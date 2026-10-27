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
            'provider_name' => 'Jos University Teaching Hospital (JUTH)',
            'provider_type' => 'hospital',
            'address' => 'Lamingo Road, Jos',
            'city' => 'Jos',
            'distance_km' => 2.3,
            'price_range' => '₦8,000 – ₦9,000',
            'is_verified' => true,
            'is_available' => true,
            'description' => 'Comprehensive cervical screening.',
            'opening_hours' => 'Mon - Fri, 8:00 AM - 4:00 PM',
            'verification_source' => 'Plateau State Ministry of Health Facility Registry #PL-HOSP-014',
        ]);

        HealthService::create([
            'id' => (string) Str::uuid(),
            'name' => 'Maternal Care',
            'category' => 'maternal',
            'provider_name' => 'Plateau Specialist Hospital',
            'provider_type' => 'hospital',
            'address' => 'Bank Road, Jos',
            'city' => 'Jos',
            'distance_km' => 3.1,
            'price_range' => '₦6,000 – ₦12,000',
            'is_verified' => true,
            'is_available' => true,
            'description' => 'Antenatal and delivery care.',
            'opening_hours' => '24/7 Maternity Emergency',
            'verification_source' => 'Plateau State Ministry of Health Facility Registry #PL-HOSP-002',
        ]);

        $res = $this->getJson('/api/v1/services');
        $res->assertOk()->assertJsonCount(2, 'data');

        $filtered = $this->getJson('/api/v1/services?category=screening');
        $filtered->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Cervical Cancer Screening');

        $searched = $this->getJson('/api/v1/services?query=Plateau');
        $searched->assertOk()->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.provider_name', 'Plateau Specialist Hospital');
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
            'emergency_helpline' => 'SURPIN Nigeria: 0800 123 4567',
            'source_citation' => 'WHO Guidelines',
        ]);

        $res = $this->getJson('/api/v1/mental-health/resources');
        $res->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonCount(3, 'helplines');
    }

    public function test_can_get_and_store_risk_assessment(): void
    {
        $user = User::factory()->create(['role' => 'member']);
        Sanctum::actingAs($user);

        $payload = [
            'age_group' => 'Adolescence (15–19)',
            'overall_risk_score' => 38,
            'overall_risk_label' => 'Moderate',
            'cervical_risk_score' => 38,
            'breast_risk_score' => 22,
            'hormonal_risk_score' => 41,
            'completed_sections' => ['age' => 'completed', 'menstrual' => 'completed'],
            'key_factors' => ['cervical' => ['Last screening 2 years ago']],
            'recommendations' => ['Get screened regularly'],
        ];

        $this->postJson('/api/v1/risk-profile', $payload)
            ->assertCreated()
            ->assertJsonPath('data.overall_risk_score', 38);

        $getRes = $this->getJson('/api/v1/risk-profile');
        $getRes->assertOk()
            ->assertJsonPath('data.overall_risk_score', 38)
            ->assertJsonPath('data.cervical_risk_score', 38);
    }

    public function test_security_headers_are_attached(): void
    {
        $res = $this->getJson('/api/v1/services');
        $res->assertHeader('X-Content-Type-Options', 'nosniff');
        $res->assertHeader('X-Frame-Options', 'DENY');
        $res->assertHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
        $res->assertHeader('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
    }
}
