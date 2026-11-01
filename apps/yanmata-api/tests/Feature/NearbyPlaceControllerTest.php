<?php

namespace Tests\Feature;

use Illuminate\Http\Client\Request as ClientRequest;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class NearbyPlaceControllerTest extends TestCase
{
    public function test_returns_distance_ranked_google_places_without_caching_or_storing_location(): void
    {
        config()->set('services.geoapify.api_key', null);
        config()->set('services.google_places.api_key', 'test-server-key');
        Http::preventStrayRequests();
        Http::fake([
            'https://places.googleapis.com/v1/places:searchNearby' => Http::response([
                'places' => [
                    [
                        'id' => 'far-clinic',
                        'displayName' => ['text' => 'Jos Community Clinic'],
                        'formattedAddress' => 'Rayfield Road, Jos',
                        'location' => ['latitude' => 9.91, 'longitude' => 8.89],
                        'primaryType' => 'medical_clinic',
                        'primaryTypeDisplayName' => ['text' => 'Medical clinic'],
                        'businessStatus' => 'OPERATIONAL',
                        'googleMapsLinks' => [
                            'directionsUri' => 'https://www.google.com/maps/dir/?api=1&destination=clinic',
                            'placeUri' => 'https://maps.google.com/?cid=clinic',
                        ],
                        'attributions' => [
                            ['provider' => 'Example local data provider', 'providerUri' => 'https://example.test/provider'],
                        ],
                    ],
                    [
                        'id' => 'near-pharmacy',
                        'displayName' => ['text' => 'Nearby Pharmacy'],
                        'formattedAddress' => 'Terminus, Jos',
                        'location' => ['latitude' => 9.9004, 'longitude' => 8.9004],
                        'primaryType' => 'pharmacy',
                        'primaryTypeDisplayName' => ['text' => 'Pharmacy'],
                        'businessStatus' => 'OPERATIONAL',
                        'googleMapsLinks' => [
                            'directionsUri' => 'https://www.google.com/maps/dir/?api=1&destination=pharmacy',
                            'placeUri' => 'https://maps.google.com/?cid=pharmacy',
                        ],
                    ],
                ],
            ]),
        ]);

        $response = $this->postJson('/api/v1/nearby-places/search', [
            'latitude' => 9.9,
            'longitude' => 8.9,
            'category' => 'all',
            'radius_meters' => 10000,
        ]);

        $response->assertOk()
            ->assertHeader('Cache-Control', 'no-store, private')
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('data.0.id', 'near-pharmacy')
            ->assertJsonPath('data.0.category_label', 'Pharmacy')
            ->assertJsonPath('data.1.attributions.0.provider', 'Example local data provider')
            ->assertJsonPath('meta.provider', 'Google Maps')
            ->assertJsonPath('meta.stored', false);

        Http::assertSent(function (ClientRequest $request): bool {
            $body = $request->data();

            return $request->url() === 'https://places.googleapis.com/v1/places:searchNearby'
                && $request->hasHeader('X-Goog-Api-Key', 'test-server-key')
                && $request->hasHeader('X-Goog-FieldMask')
                && $body['includedTypes'] === [
                    'hospital',
                    'general_hospital',
                    'medical_clinic',
                    'medical_center',
                    'pharmacy',
                    'drugstore',
                ]
                && $body['locationRestriction']['circle']['center'] === [
                    'latitude' => 9.9,
                    'longitude' => 8.9,
                ];
        });
    }

    public function test_returns_422_for_invalid_location_category_and_radius(): void
    {
        Http::preventStrayRequests();

        $response = $this->postJson('/api/v1/nearby-places/search', [
            'latitude' => 91,
            'longitude' => -181,
            'category' => 'medicine-shop',
            'radius_meters' => 100,
        ]);

        $response->assertUnprocessable()
            ->assertJsonValidationErrors([
                'latitude',
                'longitude',
                'category',
                'radius_meters',
            ]);

        Http::assertNothingSent();
    }

    public function test_returns_503_when_google_places_is_not_configured(): void
    {
        config()->set('services.geoapify.api_key', null);
        config()->set('services.google_places.api_key', null);
        Http::preventStrayRequests();

        $response = $this->postJson('/api/v1/nearby-places/search', [
            'latitude' => 9.9,
            'longitude' => 8.9,
            'category' => 'pharmacy',
        ]);

        $response->assertServiceUnavailable()
            ->assertHeader('Cache-Control', 'no-store, private')
            ->assertJsonPath('message', 'Nearby care search is not configured yet.');

        Http::assertNothingSent();
    }

    public function test_returns_503_without_exposing_google_error_details(): void
    {
        config()->set('services.geoapify.api_key', null);
        config()->set('services.google_places.api_key', 'test-server-key');
        Http::preventStrayRequests();
        Http::fake([
            'https://places.googleapis.com/v1/places:searchNearby' => Http::response([
                'error' => ['message' => 'Sensitive upstream diagnostic'],
            ], 500),
        ]);

        $response = $this->postJson('/api/v1/nearby-places/search', [
            'latitude' => 9.9,
            'longitude' => 8.9,
            'category' => 'hospital',
        ]);

        $response->assertServiceUnavailable()
            ->assertJsonMissing(['message' => 'Sensitive upstream diagnostic'])
            ->assertJsonPath('message', 'Nearby care search is temporarily unavailable. Please try again.');

        Http::assertSentCount(1);
    }

    public function test_returns_distance_ranked_geoapify_places_when_configured(): void
    {
        config()->set('services.geoapify.api_key', 'test-geoapify-key');
        config()->set('services.google_places.api_key', null);
        Http::preventStrayRequests();
        Http::fake([
            'https://api.geoapify.com/v2/places*' => Http::response([
                'type' => 'FeatureCollection',
                'features' => [
                    [
                        'type' => 'Feature',
                        'properties' => [
                            'place_id' => 'geoapify-hospital-1',
                            'name' => 'Plateau Specialist Hospital',
                            'formatted' => 'Old Bukuru Road, Jos, Plateau State, Nigeria',
                            'lat' => 9.905,
                            'lon' => 8.895,
                            'categories' => ['healthcare.hospital'],
                            'datasource' => [
                                'attribution' => '© OpenStreetMap contributors',
                                'url' => 'https://www.openstreetmap.org/copyright',
                            ],
                        ],
                        'geometry' => [
                            'type' => 'Point',
                            'coordinates' => [8.895, 9.905],
                        ],
                    ],
                ],
            ]),
        ]);

        $response = $this->postJson('/api/v1/nearby-places/search', [
            'latitude' => 9.9,
            'longitude' => 8.9,
            'category' => 'hospital',
            'radius_meters' => 10000,
        ]);

        $response->assertOk()
            ->assertHeader('Cache-Control', 'no-store, private')
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.id', 'geoapify-hospital-1')
            ->assertJsonPath('data.0.name', 'Plateau Specialist Hospital')
            ->assertJsonPath('data.0.category_label', 'Hospital')
            ->assertJsonPath('meta.provider', 'Geoapify · OpenStreetMap')
            ->assertJsonPath('meta.stored', false);
    }
}
