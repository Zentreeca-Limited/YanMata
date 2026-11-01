<?php

namespace Tests\Feature;

use App\Mail\TransactionalNotificationMail;
use App\Models\HealthProduct;
use App\Models\NotificationPreference;
use App\Models\SpecialistProfile;
use App\Models\User;
use App\Models\UserDevice;
use App\Services\PushNotificationService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class TransactionalEmailAndPushTest extends TestCase
{
    use RefreshDatabase;

    public function test_onboarding_profile_completion_and_account_deletion_send_discreet_emails(): void
    {
        Mail::fake();

        $registerRes = $this->postJson('/api/v1/mobile/register', [
            'name' => 'Zainab Musa',
            'email' => 'zainab@example.test',
            'password' => 'Sturdy-pass-2026',
            'date_of_birth' => now()->subYears(26)->format('Y-m-d'),
            'accept_terms' => true,
        ])->assertCreated();

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            return $mail->hasTo('zainab@example.test')
                && str_contains($mail->subjectLine, 'Welcome to YanMata');
        });

        $token = $registerRes->json('token');
        $headers = ['Authorization' => "Bearer $token"];

        // Complete health profile
        $answers = [
            'menstrual' => ['cycle_regular' => 'irregular'],
            'reproductive' => ['pregnancy_status' => 'none'],
            'medical' => ['conditions' => ['endometriosis'], 'hpv_vaccinated' => 'no', 'last_cervical_screening' => 'never'],
            'lifestyle' => ['smoking' => 'never', 'activity' => 'moderate', 'stress' => 'high'],
            'family' => ['family_history' => ['cervical']],
        ];

        $this->putJson('/api/v1/profile', ['answers' => $answers], $headers)
            ->assertOk()
            ->assertJsonPath('data.completed', true);

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            $rendered = $mail->render();

            return $mail->hasTo('zainab@example.test')
                && str_contains($mail->subjectLine, 'Personalised Health Space')
                && ! str_contains(strtolower($rendered), 'endometriosis')
                && ! str_contains(strtolower($rendered), 'cervical');
        });

        // Delete account
        $this->deleteJson('/api/v1/account', [
            'password' => 'Sturdy-pass-2026',
            'confirmation' => 'DELETE',
        ], $headers)->assertNoContent();

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            return $mail->hasTo('zainab@example.test')
                && str_contains($mail->subjectLine, 'Permanently Deleted');
        });
    }

    public function test_care_workflow_and_orders_send_discreet_emails_and_fcm_push_without_sensitive_text(): void
    {
        Mail::fake();
        Http::fake([
            'https://fcm.googleapis.com/*' => Http::response(['success' => 1], 200),
        ]);
        config(['services.fcm.server_key' => 'test-fcm-server-key']);

        // Set deterministic daytime outside quiet hours (e.g. 14:00)
        Carbon::setTestNow(Carbon::parse('2026-10-28 14:00:00'));

        $member = User::factory()->create([
            'name' => 'Halima Abdullahi',
            'email' => 'halima@example.test',
            'role' => 'member',
        ]);
        $specialistUser = User::factory()->create([
            'name' => 'Dr. Amara Obi',
            'email' => 'amara@example.test',
            'role' => 'specialist',
        ]);

        $specialistProfile = SpecialistProfile::create([
            'user_id' => $specialistUser->id,
            'name' => 'Dr. Amara Obi',
            'title' => 'Gynaecologist',
            'credentials' => 'MBBS, FWACS',
            'specialty' => 'Reproductive Health',
            'bio' => 'Verified specialist',
            'city' => 'Abuja',
            'verification_source' => 'MDCN #55112',
            'is_verified' => true,
            'is_available' => true,
        ]);

        // Register member device for push
        UserDevice::create([
            'user_id' => $member->id,
            'device_id' => 'ios-sim-01',
            'device_name' => 'iPhone 16 Pro',
            'platform' => 'ios',
            'push_token' => 'fcm-member-device-token-12345',
            'push_enabled' => true,
            'last_seen_at' => now(),
        ]);

        Sanctum::actingAs($member);

        // 1. Member creates unassigned care request
        $reqRes = $this->postJson('/api/v1/care/requests', [
            'topic' => 'Cycle questions',
            'stage' => 'Adulthood',
            'summary' => 'Private clinical symptom summary that must never leak in email.',
            'share_journal_consent' => false,
        ])->assertCreated();

        $reqId = $reqRes->json('data.id');

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            $rendered = $mail->render();

            return $mail->hasTo('halima@example.test')
                && str_contains($mail->subjectLine, 'We Received Your Specialist Support Request')
                && ! str_contains($rendered, 'Private clinical symptom summary');
        });

        // 2. Specialist assigns request
        Sanctum::actingAs($specialistUser);
        $assignRes = $this->postJson("/api/v1/studio/care/requests/{$reqId}/assign", [
            'specialist_id' => $specialistProfile->id,
        ])->assertOk();

        $convId = $assignRes->json('data.conversation_id');

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            return $mail->hasTo('halima@example.test')
                && str_contains($mail->subjectLine, 'A Specialist Is Connected');
        });

        // 3. Specialist replies to member -> triggers discreet email + FCM push
        $this->postJson("/api/v1/care/conversations/{$convId}/messages", [
            'body' => 'Confidential clinical advice from Dr. Amara.',
        ])->assertCreated();

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            $rendered = $mail->render();

            return $mail->hasTo('halima@example.test')
                && str_contains($mail->subjectLine, 'New Update in Your Private Space')
                && ! str_contains($rendered, 'Confidential clinical advice');
        });

        Http::assertSent(function ($request) {
            $body = $request->data();

            return str_contains($request->url(), 'fcm.googleapis.com')
                && ($body['to'] ?? '') === 'fcm-member-device-token-12345'
                && ($body['notification']['title'] ?? '') === PushNotificationService::DISCREET_TITLE
                && ! str_contains(json_encode($body), 'Confidential clinical advice');
        });

        // 4. Member places an order -> triggers discreet order email
        $product = HealthProduct::create([
            'id' => (string) Str::uuid(),
            'name' => 'Sensitive Product Name',
            'category' => 'womens_health',
            'pack_size' => '1 pack',
            'price_ngn' => 4500,
            'description' => 'Essential health item',
            'seller_name' => 'Verified Pharmacy',
            'is_verified_seller' => true,
            'stock_status' => 'in_stock',
            'safety_info' => 'Follow package instructions',
        ]);

        Sanctum::actingAs($member);
        $this->postJson('/api/v1/orders', [
            'customer_name' => 'Halima Abdullahi',
            'customer_phone' => '+2348031234567',
            'delivery_address' => '10 Independence Way',
            'total_ngn' => 4500,
            'items' => [
                [
                    'product_id' => $product->id,
                    'name' => 'Sensitive Product Name',
                    'quantity' => 1,
                    'price_ngn' => 4500,
                ],
            ],
        ])->assertCreated();

        Mail::assertSent(TransactionalNotificationMail::class, function (TransactionalNotificationMail $mail) {
            $rendered = $mail->render();

            return $mail->hasTo('halima@example.test')
                && str_contains($mail->subjectLine, 'Your Essential Order Is Confirmed')
                && ! str_contains($rendered, 'Sensitive Product Name');
        });

        Carbon::setTestNow();
    }

    public function test_push_notification_respects_quiet_hours_while_still_recording_outbox_event(): void
    {
        Http::fake();
        config(['services.fcm.server_key' => 'test-fcm-server-key']);

        // 23:15 is inside default quiet hours (22:00 - 07:00)
        Carbon::setTestNow(Carbon::parse('2026-10-28 23:15:00'));

        $member = User::factory()->create(['role' => 'member']);
        UserDevice::create([
            'user_id' => $member->id,
            'device_id' => 'android-01',
            'platform' => 'android',
            'push_token' => 'fcm-quiet-token',
            'push_enabled' => true,
        ]);
        NotificationPreference::create([
            'user_id' => $member->id,
            'care_messages' => true,
            'quiet_hours_enabled' => true,
            'quiet_hours_start' => '22:00',
            'quiet_hours_end' => '07:00',
        ]);

        $service = app(PushNotificationService::class);
        $event = $service->notifyUser(
            recipient: $member,
            eventName: 'care.message_received',
            dataPayload: ['type' => 'care_message', 'conversation_id' => 'conv-123'],
        );

        $this->assertDatabaseHas('broadcast_events', ['id' => $event->id]);
        Http::assertNothingSent();

        Carbon::setTestNow();
    }
}
