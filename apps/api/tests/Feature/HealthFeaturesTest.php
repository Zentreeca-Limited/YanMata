<?php

namespace Tests\Feature;

use App\Models\HealthProduct;
use App\Models\HealthService;
use App\Models\MentalHealthResource;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class HealthFeaturesTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_and_filter_health_services(): void
    {
        HealthService::create([
            'id' => (string) Str::uuid(),
            'name' => 'Cervical Cancer Screening',
            'category' => 'screening',
            'provider_name' => 'Synthetic Jos Hospital One',
            'provider_type' => 'hospital',
            'address' => 'Lamingo Road, Jos',
            'city' => 'Jos',
            'distance_km' => 2.3,
            'price_range' => '₦8,000 – ₦9,000',
            'is_verified' => true,
            'is_available' => true,
            'description' => 'Comprehensive cervical screening.',
            'opening_hours' => 'Mon - Fri, 8:00 AM - 4:00 PM',
            'verification_source' => 'Synthetic fixture; no verification claim',
        ]);

        HealthService::create([
            'id' => (string) Str::uuid(),
            'name' => 'Maternal Care',
            'category' => 'maternal',
            'provider_name' => 'Synthetic Plateau Demo Service',
            'provider_type' => 'hospital',
            'address' => 'Bank Road, Jos',
            'city' => 'Jos',
            'distance_km' => 3.1,
            'price_range' => '₦6,000 – ₦12,000',
            'is_verified' => true,
            'is_available' => true,
            'description' => 'Antenatal and delivery care.',
            'opening_hours' => '24/7 Maternity Emergency',
            'verification_source' => 'Synthetic fixture; no verification claim',
        ]);

        $res = $this->getJson('/api/v1/services');
        $res->assertOk()->assertJsonCount(2, 'data');

        $filtered = $this->getJson('/api/v1/services?category=screening');
        $filtered->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Cervical Cancer Screening');

        $searched = $this->getJson('/api/v1/services?query=Plateau');
        $searched->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.provider_name', 'Synthetic Plateau Demo Service');
    }

    public function test_can_list_products_and_place_order(): void
    {
        $product = HealthProduct::create([
            'id' => (string) Str::uuid(),
            'name' => 'Pregnancy Test Kit',
            'category' => 'womens_health',
            'pack_size' => '1 pack',
            'price_ngn' => 3500,
            'description' => 'Rapid early detection test kit.',
            'seller_name' => 'Zentreeca Community Pharmacy Jos',
            'is_verified_seller' => true,
            'stock_status' => 'in_stock',
            'safety_info' => 'For in vitro diagnostic use.',
        ]);

        $this->getJson('/api/v1/products')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Pregnancy Test Kit');

        $orderPayload = [
            'customer_name' => 'Aisha Yusuf',
            'customer_phone' => '+234 803 000 1122',
            'delivery_address' => '12 Anglo Jos Road, Jos, Plateau State',
            'total_ngn' => 3500,
            'items' => [
                [
                    'product_id' => $product->id,
                    'name' => 'Pregnancy Test Kit',
                    'quantity' => 1,
                    'price_ngn' => 3500,
                ],
            ],
        ];

        $this->postJson('/api/v1/orders', $orderPayload)->assertUnauthorized();
        Sanctum::actingAs(User::factory()->create(['role' => 'member']));
        $orderRes = $this->postJson('/api/v1/orders', $orderPayload);
        $orderRes->assertCreated()
            ->assertJsonPath('data.status', 'confirmed')
            ->assertJsonPath('data.total_ngn', 3500);

        $this->assertDatabaseHas('product_orders', [
            'customer_name' => 'Aisha Yusuf',
            'total_ngn' => 3500,
        ]);
    }

    public function test_can_get_mental_health_resources_and_helplines(): void
    {
        MentalHealthResource::create([
            'id' => (string) Str::uuid(),
            'title' => 'Anxiety & Stress Coping Strategies',
            'category' => 'anxiety',
            'summary' => 'Grounding techniques and gentle breathing.',
            'body' => 'Grounding exercises restore emotional equilibrium.',
            'coping_strategies' => ['Box breathing', '5-4-3-2-1 Grounding'],
            'emergency_helpline' => 'Nigeria national emergency number: 112',
            'source_citation' => 'WHO Guidelines',
        ]);

        $res = $this->getJson('/api/v1/mental-health/resources');
        $res->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonCount(1, 'helplines')
            ->assertJsonPath('helplines.0.phone', '112');
    }

    public function test_cycle_settings_sync_requires_consent_and_resolves_conflicts(): void
    {
        $this->getJson('/api/v1/cycle-settings')->assertUnauthorized();
        $user = User::factory()->create(['role' => 'member', 'sync_consent' => false]);
        Sanctum::actingAs($user);
        $body = ['last_period_date' => now()->subDays(10)->format('Y-m-d'), 'cycle_length' => 30, 'period_duration' => 5];
        $this->putJson('/api/v1/cycle-settings', $body)->assertForbidden();

        $user->forceFill(['sync_consent' => true])->save();
        $this->getJson('/api/v1/cycle-settings')->assertOk()->assertJsonPath('data', null);
        $this->putJson('/api/v1/cycle-settings', $body)->assertOk()->assertJsonPath('applied', true)->assertJsonPath('data.cycle_length', 30);

        $stale = array_merge($body, ['client_updated_at' => now()->subDay()->toIso8601String(), 'cycle_length' => 26]);
        $this->putJson('/api/v1/cycle-settings', $stale)->assertOk()->assertJsonPath('applied', false)->assertJsonPath('data.cycle_length', 30);
        $this->putJson('/api/v1/cycle-settings', array_merge($body, ['cycle_length' => 5]))->assertUnprocessable();
        $this->putJson('/api/v1/cycle-settings', ['last_period_date' => now()->addDay()->format('Y-m-d'), 'cycle_length' => 28, 'period_duration' => 5])->assertUnprocessable();
    }

    public function test_security_headers_are_attached(): void
    {
        $res = $this->getJson('/api/v1/services');
        $res->assertHeader('X-Content-Type-Options', 'nosniff');
        $res->assertHeader('X-Frame-Options', 'DENY');
        $res->assertHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
        $res->assertHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
    }

    public function test_can_get_dynamic_locations(): void
    {
        $res = $this->getJson('/api/v1/locations');
        $res->assertOk()
            ->assertJsonPath('default_pilot', 'jos')
            ->assertJsonStructure(['data' => [['id', 'city', 'state', 'country', 'label', 'is_pilot_hub']]]);
    }

    public function test_ai_companion_chat_and_crisis_handling(): void
    {
        // 1. Normal educational chat
        $res = $this->postJson('/api/v1/ai/companion/chat', [
            'prompt' => 'How can I ease cramps?',
            'language' => 'en',
            'cycle_day' => 1,
            'phase' => 'Menstrual Phase',
        ]);
        $res->assertOk()
            ->assertJsonPath('data.is_emergency', false)
            ->assertJsonStructure(['data' => ['reply', 'citations', 'follow_up_questions', 'suggested_actions']]);

        // 2. Crisis trigger
        $crisis = $this->postJson('/api/v1/ai/companion/chat', [
            'prompt' => 'I feel like bleeding heavily and dying',
            'language' => 'pcm',
        ]);
        $crisis->assertOk()
            ->assertJsonPath('data.is_emergency', true)
            ->assertJsonCount(1, 'data.helplines')
            ->assertJsonPath('data.helplines.0.number', '112');
    }

    public function test_ai_cycle_insights(): void
    {
        $res = $this->postJson('/api/v1/ai/cycle/insights', [
            'cycle_length' => 28,
            'period_duration' => 5,
            'current_day' => 12,
            'language' => 'en',
        ]);

        $res->assertOk()
            ->assertJsonPath('data.regularity', 'Within a common adult range')
            ->assertJsonPath('data.phase', 'Follicular Phase')
            ->assertJsonPath('data.total_days', 28);
    }
}
