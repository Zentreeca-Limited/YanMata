<?php

namespace Tests\Feature;

use App\Models\BroadcastEvent;
use App\Models\ContentItem;
use App\Models\SpecialistProfile;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class YanMataTest extends TestCase
{
    use RefreshDatabase;

    private function actor(string $role = 'member', bool $consent = false): User
    {
        return User::factory()->create(['role' => $role, 'sync_consent' => $consent]);
    }

    private function draft(User $u, array $extra = []): ContentItem
    {
        return ContentItem::create([...['title' => 'Sample', 'topic' => 'Body literacy', 'stage' => 'Puberty', 'summary' => 'Demo summary', 'body' => 'Demo only', 'source_url' => 'https://www.who.int/health-topics/adolescent-health', 'author_id' => $u->id], ...$extra]);
    }

    private function mutation(?string $entry = null, int $version = 0): array
    {
        return ['mutation_id' => (string) Str::uuid(), 'entry_id' => $entry ?? (string) Str::uuid(), 'expected_version' => $version, 'deleted' => false, 'payload' => ['date' => '2026-10-27', 'mood' => 'Okay', 'note' => 'Private sample note']];
    }

    public function test_learning_hides_unpublished_expired_and_demo_records_by_default(): void
    {
        $u = $this->actor('author');
        $this->draft($u);
        $this->draft($u, ['status' => 'published', 'review_due_at' => now()->subDay()]);
        $this->draft($u, ['status' => 'published', 'review_due_at' => now()->addDay(), 'is_demo' => true]);
        $this->getJson('/api/v1/content')->assertOk()->assertJsonCount(0, 'data');
        config(['yanmata.demo' => true]);
        $this->getJson('/api/v1/content')->assertJsonCount(1, 'data');
    }

    public function test_member_cannot_enter_studio_or_read_another_journal(): void
    {
        Sanctum::actingAs($this->actor());
        $this->getJson('/api/v1/studio/content')->assertForbidden();
        $this->getJson('/api/v1/sync/pull')->assertForbidden();
    }

    public function test_publication_requires_separate_roles_and_current_version(): void
    {
        $author = $this->actor('author');
        $item = $this->draft($author);
        Sanctum::actingAs($author);
        $url = "/api/v1/studio/content/{$item->id}/transition";
        $this->postJson($url, ['action' => 'publish', 'version' => 1])->assertForbidden();
        $this->postJson($url, ['action' => 'submit', 'version' => 1])->assertOk()->assertJsonPath('data.status', 'in_review');
        $this->postJson($url, ['action' => 'review', 'version' => 2])->assertForbidden();
        Sanctum::actingAs($this->actor('reviewer'));
        $this->postJson($url, ['action' => 'review', 'version' => 1])->assertConflict();
        $this->postJson($url, ['action' => 'review', 'version' => 2])->assertOk()->assertJsonPath('data.status', 'approved');
        Sanctum::actingAs($this->actor('publisher'));
        $this->postJson($url, ['action' => 'publish', 'version' => 3])->assertOk();
        $this->getJson('/api/v1/content')->assertJsonCount(1, 'data');
        $this->postJson($url, ['action' => 'withdraw', 'version' => 4])->assertOk();
        $this->getJson('/api/v1/content')->assertJsonCount(0, 'data');
    }

    public function test_editing_approved_content_resets_clinical_approval(): void
    {
        $author = $this->actor('author');
        $item = $this->draft($author, ['status' => 'approved', 'reviewer_id' => $this->actor('reviewer')->id, 'reviewed_at' => now(), 'review_due_at' => now()->addMonth()]);
        Sanctum::actingAs($author);
        $this->putJson("/api/v1/studio/content/{$item->id}", ['title' => 'Revised', 'topic' => 'Periods', 'stage' => 'Adolescence', 'summary' => 'Changed', 'body' => 'New content', 'source_url' => 'https://www.who.int', 'version' => 1])->assertOk()->assertJsonPath('data.status', 'draft')->assertJsonPath('data.reviewed_at', null);
    }

    public function test_author_cannot_edit_another_authors_content(): void
    {
        $item = $this->draft($this->actor('author'));
        Sanctum::actingAs($this->actor('author'));
        $this->putJson("/api/v1/studio/content/{$item->id}", ['title' => 'Revised', 'topic' => 'Periods', 'stage' => 'Adolescence', 'summary' => 'Changed', 'body' => 'New', 'source_url' => 'https://www.who.int', 'version' => 1])->assertForbidden();
    }

    public function test_sync_is_encrypted_idempotent_and_reports_stale_writes(): void
    {
        $u = $this->actor('member', true);
        Sanctum::actingAs($u);
        $m = $this->mutation();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertOk()->assertJsonPath('results.0.status', 'accepted');
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertOk();
        $this->assertDatabaseCount('journal_entries', 1);
        $this->assertDatabaseCount('journal_changes', 1);
        $this->assertStringNotContainsString('Private sample note', DB::table('journal_entries')->first()->payload);
        $this->assertStringNotContainsString('Private sample note', DB::table('sync_receipts')->first()->result);
        $stale = $this->mutation($m['entry_id']);
        $this->postJson('/api/v1/sync/push', ['mutations' => [$stale]])->assertOk()->assertJsonPath('results.0.status', 'conflict');
        $m['payload']['note'] = 'Different';
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertConflict();
    }

    public function test_sync_delete_cannot_be_resurrected_and_cursor_is_scoped(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $m = $this->mutation();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertOk();
        $deleted = $this->mutation($m['entry_id'], 1);
        $deleted['deleted'] = true;
        $this->postJson('/api/v1/sync/push', ['mutations' => [$deleted]])->assertOk();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$this->mutation($m['entry_id'], 2)]])->assertJsonPath('results.0.status', 'conflict');
        $pull = $this->getJson('/api/v1/sync/pull')->assertOk()->assertJsonPath('entries.0.deleted', true)->assertJsonPath('entries.0.payload', null);
        $cursor = $pull->json('cursor');
        Sanctum::actingAs($this->actor('member', true));
        $this->getJson('/api/v1/sync/pull?cursor='.urlencode($cursor))->assertBadRequest();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$this->mutation($m['entry_id'], 2)]])->assertNotFound();
    }

    public function test_revoked_consent_blocks_future_sync(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $this->putJson('/api/v1/consent/sync', ['enabled' => false])->assertOk();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$this->mutation()]])->assertForbidden();
    }

    public function test_mobile_login_issues_expiring_token_and_logout_revokes_it(): void
    {
        $u = $this->actor();
        $u->forceFill(['password' => Hash::make('a-test-only-password')])->save();
        $result = $this->postJson('/api/v1/mobile/login', ['email' => $u->email, 'password' => 'a-test-only-password'])->assertOk();
        $this->assertNotNull($u->tokens()->first()->expires_at);
        $token = $result->json('token');
        $this->withToken($token)->postJson('/api/v1/logout')->assertNoContent();
        $this->assertDatabaseCount('personal_access_tokens', 0);
    }

    public function test_valid_cursor_can_be_reused_by_its_owner(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $cursor = $this->getJson('/api/v1/sync/pull')->assertOk()->json('cursor');
        $this->getJson('/api/v1/sync/pull?cursor='.urlencode($cursor))->assertOk()->assertJsonCount(0, 'entries');
    }

    public function test_check_in_can_sync_without_an_optional_note(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $mutation = $this->mutation();
        $mutation['payload']['note'] = '';
        $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])->assertOk()->assertJsonPath('results.0.server.payload.note', '');
    }

    public function test_idempotency_ignores_json_key_order(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $mutation = $this->mutation();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])->assertOk();
        $mutation = array_reverse($mutation, true);
        $mutation['payload'] = array_reverse($mutation['payload'], true);
        $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])->assertOk();
        $this->assertDatabaseCount('journal_changes', 1);
    }

    public function test_tracking_sync_accepts_cycle_symptoms_and_flow_payload(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $mutation = $this->mutation();
        $mutation['payload'] = [
            'date' => '2026-10-27',
            'mood' => 'Difficult',
            'flow' => 'medium',
            'symptoms' => ['cramps', 'fatigue', 'headache'],
            'energy' => 'low',
            'stage' => 'Puberty',
            'note' => 'First day of bleeding, feeling low energy.',
        ];

        $res = $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])
            ->assertOk()
            ->assertJsonPath('results.0.status', 'accepted')
            ->assertJsonPath('results.0.server.payload.flow', 'medium')
            ->assertJsonPath('results.0.server.payload.symptoms.0', 'cramps')
            ->assertJsonPath('results.0.server.payload.energy', 'low');

        $pull = $this->getJson('/api/v1/sync/pull')->assertOk();
        $this->assertEquals('medium', $pull->json('entries.0.payload.flow'));
        $this->assertEquals(['cramps', 'fatigue', 'headache'], $pull->json('entries.0.payload.symptoms'));
    }

    public function test_specialists_endpoint_returns_verified_professionals_only(): void
    {
        $u1 = $this->actor('specialist');
        $u2 = $this->actor('specialist');

        SpecialistProfile::create([
            'user_id' => $u1->id,
            'name' => 'Dr. Fatima Bello',
            'title' => 'Obstetrician & Gynaecologist',
            'credentials' => 'MBBS, FWACS (OB/GYN)',
            'specialty' => 'Reproductive health',
            'bio' => 'Consultant in Jos',
            'city' => 'Jos, Plateau State',
            'verification_source' => 'MDCN #12345',
            'is_verified' => true,
            'is_available' => true,
        ]);

        SpecialistProfile::create([
            'user_id' => $u2->id,
            'name' => 'Unverified Person',
            'title' => 'Consultant',
            'credentials' => 'None',
            'specialty' => 'General',
            'bio' => 'Not verified',
            'city' => 'Jos',
            'verification_source' => 'None',
            'is_verified' => false,
            'is_available' => true,
        ]);

        $res = $this->getJson('/api/v1/specialists')->assertOk()->assertJsonCount(1, 'data');
        $this->assertEquals('Dr. Fatima Bello', $res->json('data.0.name'));
        $this->assertTrue($res->json('data.0.is_verified'));
    }

    public function test_member_can_create_support_request_and_message_assigned_specialist(): void
    {
        $member = $this->actor('member');
        $specialistUser = $this->actor('specialist');
        $stranger = $this->actor('member');

        $profile = SpecialistProfile::create([
            'user_id' => $specialistUser->id,
            'name' => 'Nurse Grace Danladi',
            'title' => 'Nurse Specialist',
            'credentials' => 'RN, RM',
            'specialty' => 'Adolescent health',
            'bio' => 'Adolescent health nurse in Jos',
            'city' => 'Jos, Plateau State',
            'verification_source' => 'NMCN #67890',
            'is_verified' => true,
            'is_available' => true,
        ]);

        Sanctum::actingAs($member);

        // Member creates support request directly to Nurse Grace
        $reqRes = $this->postJson('/api/v1/care/requests', [
            'topic' => 'Menstrual wellbeing',
            'stage' => 'Puberty',
            'summary' => 'I have a question about cramping during my first period.',
            'share_journal_consent' => true,
            'specialist_id' => $profile->id,
        ])->assertCreated();

        $convId = $reqRes->json('data.conversation_id');
        $this->assertNotNull($convId);

        // Member can view conversation
        $convRes = $this->getJson("/api/v1/care/conversations/{$convId}")
            ->assertOk()
            ->assertJsonPath('data.specialist.name', 'Nurse Grace Danladi')
            ->assertJsonCount(1, 'data.messages');

        // Member sends a follow-up message
        $this->postJson("/api/v1/care/conversations/{$convId}/messages", [
            'body' => 'Also, is hot water bottle safe for cramps?',
        ])->assertCreated()->assertJsonPath('data.sender_role', 'member');

        // Stranger cannot view conversation
        Sanctum::actingAs($stranger);
        $this->getJson("/api/v1/care/conversations/{$convId}")->assertForbidden();
        $this->postJson("/api/v1/care/conversations/{$convId}/messages", [
            'body' => 'Intruder message',
        ])->assertForbidden();

        // Specialist can view conversation and reply
        Sanctum::actingAs($specialistUser);
        $this->getJson("/api/v1/care/conversations/{$convId}")
            ->assertOk()
            ->assertJsonCount(2, 'data.messages');

        $this->postJson("/api/v1/care/conversations/{$convId}/messages", [
            'body' => 'Yes, a warm compress or hot water bottle wrapped in a towel is a very gentle, safe way to soothe cramps.',
        ])->assertCreated()->assertJsonPath('data.sender_role', 'specialist');
    }

    public function test_device_registration_token_rotation_and_revocation(): void
    {
        $member = $this->actor('member');
        Sanctum::actingAs($member);

        // Register initial device
        $res = $this->postJson('/api/v1/devices', [
            'device_id' => 'device-android-001',
            'device_name' => 'Tecno Camon 20',
            'platform' => 'android',
            'push_token' => 'fcm-token-alpha-1234567890',
        ])->assertOk();

        $res->assertJsonPath('data.device_id', 'device-android-001')
            ->assertJsonPath('data.platform', 'android')
            ->assertJsonPath('data.device_name', 'Tecno Camon 20')
            ->assertJsonPath('data.push_token', 'fcm-toke...');

        $this->assertDatabaseHas('user_devices', [
            'user_id' => $member->id,
            'device_id' => 'device-android-001',
            'push_token' => 'fcm-token-alpha-1234567890',
        ]);

        // Rotate token
        $this->postJson('/api/v1/devices', [
            'device_id' => 'device-android-001',
            'platform' => 'android',
            'push_token' => 'fcm-token-beta-9876543210',
        ])->assertOk();

        $this->assertDatabaseHas('user_devices', [
            'user_id' => $member->id,
            'device_id' => 'device-android-001',
            'push_token' => 'fcm-token-beta-9876543210',
        ]);

        // Unregister device
        $this->deleteJson('/api/v1/devices/device-android-001')->assertNoContent();
        $this->assertDatabaseMissing('user_devices', ['device_id' => 'device-android-001']);
    }

    public function test_logout_revokes_device_push_token_when_device_id_provided(): void
    {
        $member = $this->actor('member');
        Sanctum::actingAs($member);

        $this->postJson('/api/v1/devices', [
            'device_id' => 'device-ios-002',
            'platform' => 'ios',
            'push_token' => 'apns-token-123',
        ])->assertOk();

        $this->assertDatabaseHas('user_devices', ['device_id' => 'device-ios-002']);

        // Logout with device_id
        $this->postJson('/api/v1/logout', ['device_id' => 'device-ios-002'])->assertNoContent();
        $this->assertDatabaseMissing('user_devices', ['device_id' => 'device-ios-002']);
    }

    public function test_notification_preferences_get_and_update(): void
    {
        $member = $this->actor('member');
        Sanctum::actingAs($member);

        // Get defaults
        $this->getJson('/api/v1/notification-preferences')
            ->assertOk()
            ->assertJsonPath('data.care_messages', true)
            ->assertJsonPath('data.quiet_hours_enabled', true)
            ->assertJsonPath('data.quiet_hours_start', '22:00')
            ->assertJsonPath('data.quiet_hours_end', '07:00');

        // Update preferences
        $this->putJson('/api/v1/notification-preferences', [
            'care_messages' => true,
            'quiet_hours_start' => '21:30',
            'quiet_hours_end' => '06:30',
        ])->assertOk()
            ->assertJsonPath('data.quiet_hours_start', '21:30')
            ->assertJsonPath('data.quiet_hours_end', '06:30');

        $this->assertDatabaseHas('notification_preferences', [
            'user_id' => $member->id,
            'quiet_hours_start' => '21:30',
        ]);
    }

    public function test_care_message_creates_privacy_preserving_event_and_allows_polling(): void
    {
        $member = $this->actor('member');
        $specialistUser = $this->actor('specialist');
        $profile = SpecialistProfile::create([
            'user_id' => $specialistUser->id,
            'name' => 'Dr. Fatima Bello',
            'title' => 'Obstetrician & Gynaecologist',
            'credentials' => 'MBBS, FWACS (OB/GYN)',
            'specialty' => 'Obstetrics & Gynaecology',
            'bio' => 'Consultant in Jos',
            'city' => 'Jos, Plateau State',
            'verification_source' => 'MDCN #94821',
            'is_verified' => true,
            'is_available' => true,
        ]);

        Sanctum::actingAs($member);
        $reqRes = $this->postJson('/api/v1/care/requests', [
            'topic' => 'Menstrual wellbeing',
            'stage' => 'Adulthood',
            'summary' => 'Severe pelvic discomfort',
            'share_journal_consent' => true,
            'specialist_id' => $profile->id,
        ])->assertCreated();

        $convId = $reqRes->json('data.conversation_id');

        // Member sends message
        $this->postJson("/api/v1/care/conversations/{$convId}/messages", [
            'body' => 'Noticeable sharp ache on right side.',
        ])->assertCreated();

        // Verify broadcast event in outbox
        $event = BroadcastEvent::where('channel', 'private-user.'.$specialistUser->id)->first();
        $this->assertNotNull($event, 'Broadcast event must be created in outbox');
        $this->assertSame('care.message_received', $event->event);
        $this->assertSame('care_message', $event->payload['type']);
        $this->assertSame($convId, $event->payload['conversation_id']);

        // CRITICAL INVARIANT: Zero health text, zero message body in broadcast payload
        $this->assertArrayNotHasKey('body', $event->payload);
        $this->assertStringNotContainsString('ache', json_encode($event->payload));
        $this->assertStringNotContainsString('pelvic', json_encode($event->payload));

        // Specialist polls events
        Sanctum::actingAs($specialistUser);
        $pollRes = $this->getJson('/api/v1/events/poll')
            ->assertOk()
            ->assertJsonCount(1, 'data');

        $this->assertSame($convId, $pollRes->json('data.0.payload.conversation_id'));
    }
}
