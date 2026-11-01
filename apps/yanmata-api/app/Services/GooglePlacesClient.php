<?php

namespace App\Services;

use App\Exceptions\NearbyPlacesUnavailableException;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\RequestException;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Http;

class GooglePlacesClient
{
    private const string FieldMask = 'places.id,places.displayName,places.formattedAddress,places.location,places.primaryType,places.primaryTypeDisplayName,places.businessStatus,places.googleMapsLinks,places.attributions';

    private const array GeoapifyCategoryMap = [
        'hospital' => 'healthcare.hospital',
        'general_hospital' => 'healthcare.hospital',
        'medical_clinic' => 'healthcare.clinic_or_praxis',
        'medical_center' => 'healthcare.clinic_or_praxis',
        'doctor' => 'healthcare.clinic_or_praxis',
        'pharmacy' => 'healthcare.pharmacy',
        'drugstore' => 'healthcare.pharmacy',
    ];

    public function providerName(): string
    {
        $geoapifyKey = config('services.geoapify.api_key');
        if (is_string($geoapifyKey) && $geoapifyKey !== '') {
            return 'Geoapify · OpenStreetMap';
        }

        return 'Google Maps';
    }

    /**
     * @param  array<int, string>  $includedTypes
     * @return array<int, array<string, mixed>>
     */
    public function searchNearby(
        float $latitude,
        float $longitude,
        array $includedTypes,
        int $radiusMeters,
    ): array {
        $geoapifyKey = config('services.geoapify.api_key');

        if (is_string($geoapifyKey) && $geoapifyKey !== '') {
            return $this->searchGeoapify(
                apiKey: $geoapifyKey,
                latitude: $latitude,
                longitude: $longitude,
                includedTypes: $includedTypes,
                radiusMeters: $radiusMeters,
            );
        }

        $apiKey = config('services.google_places.api_key');

        if (! is_string($apiKey) || $apiKey === '') {
            throw NearbyPlacesUnavailableException::notConfigured();
        }

        try {
            $response = Http::withHeaders([
                'X-Goog-Api-Key' => $apiKey,
                'X-Goog-FieldMask' => self::FieldMask,
            ])
                ->acceptJson()
                ->connectTimeout(3)
                ->timeout(8)
                ->post(config('services.google_places.nearby_search_url'), [
                    'includedTypes' => $includedTypes,
                    'maxResultCount' => 20,
                    'rankPreference' => 'DISTANCE',
                    'regionCode' => 'NG',
                    'locationRestriction' => [
                        'circle' => [
                            'center' => [
                                'latitude' => $latitude,
                                'longitude' => $longitude,
                            ],
                            'radius' => $radiusMeters,
                        ],
                    ],
                ])
                ->throw();
        } catch (ConnectionException|RequestException $exception) {
            throw NearbyPlacesUnavailableException::upstreamFailure($exception);
        }

        $places = $response->json('places', []);

        return is_array($places) ? $places : [];
    }

    /**
     * @param  array<int, string>  $includedTypes
     * @return array<int, array<string, mixed>>
     */
    private function searchGeoapify(
        string $apiKey,
        float $latitude,
        float $longitude,
        array $includedTypes,
        int $radiusMeters,
    ): array {
        $categories = collect($includedTypes)
            ->map(fn (string $type): string => self::GeoapifyCategoryMap[$type] ?? 'healthcare')
            ->unique()
            ->values()
            ->implode(',');

        try {
            $response = Http::acceptJson()
                ->connectTimeout(4)
                ->timeout(10)
                ->get(config('services.geoapify.places_url'), [
                    'categories' => $categories,
                    'filter' => sprintf('circle:%s,%s,%d', $longitude, $latitude, $radiusMeters),
                    'bias' => sprintf('proximity:%s,%s', $longitude, $latitude),
                    'limit' => 20,
                    'apiKey' => $apiKey,
                ])
                ->throw();
        } catch (ConnectionException|RequestException $exception) {
            throw NearbyPlacesUnavailableException::upstreamFailure($exception);
        }

        $features = $response->json('features', []);
        if (! is_array($features)) {
            return [];
        }

        return collect($features)
            ->map(function (mixed $feature): array {
                $props = is_array($feature) ? (array) Arr::get($feature, 'properties', []) : [];
                $lat = (float) ($props['lat'] ?? Arr::get($feature, 'geometry.coordinates.1', 0));
                $lon = (float) ($props['lon'] ?? Arr::get($feature, 'geometry.coordinates.0', 0));
                $cats = (array) ($props['categories'] ?? []);

                [$primaryType, $primaryLabel] = $this->resolveGeoapifyCategory($cats);

                $name = trim((string) ($props['name'] ?? $props['address_line1'] ?? ''));
                $formattedAddress = trim((string) ($props['formatted'] ?? $props['address_line2'] ?? ''));
                $placeId = (string) ($props['place_id'] ?? ($name !== '' ? md5($name.$lat.$lon) : ''));

                $directionsUri = ($lat !== 0.0 || $lon !== 0.0)
                    ? sprintf('https://www.google.com/maps/dir/?api=1&destination=%s,%s', $lat, $lon)
                    : '';
                $placeUri = ($lat !== 0.0 || $lon !== 0.0)
                    ? sprintf('https://www.openstreetmap.org/?mlat=%s&mlon=%s#map=17/%s/%s', $lat, $lon, $lat, $lon)
                    : '';

                $attribution = (string) Arr::get($props, 'datasource.attribution', '© OpenStreetMap contributors');
                $attributionUrl = (string) Arr::get($props, 'datasource.url', 'https://www.openstreetmap.org/copyright');

                return [
                    'id' => $placeId,
                    'displayName' => ['text' => $name],
                    'formattedAddress' => $formattedAddress,
                    'location' => [
                        'latitude' => $lat,
                        'longitude' => $lon,
                    ],
                    'primaryType' => $primaryType,
                    'primaryTypeDisplayName' => ['text' => $primaryLabel],
                    'businessStatus' => 'OPERATIONAL',
                    'googleMapsLinks' => [
                        'directionsUri' => $directionsUri,
                        'placeUri' => $placeUri,
                    ],
                    'attributions' => [
                        [
                            'provider' => $attribution,
                            'providerUri' => $attributionUrl,
                        ],
                    ],
                ];
            })
            ->all();
    }

    /**
     * @param  array<int, mixed>  $categories
     * @return array{0: string, 1: string}
     */
    private function resolveGeoapifyCategory(array $categories): array
    {
        $joined = implode(' ', array_map('strval', $categories));
        if (str_contains($joined, 'pharmacy')) {
            return ['pharmacy', 'Pharmacy'];
        }
        if (str_contains($joined, 'clinic') || str_contains($joined, 'praxis') || str_contains($joined, 'doctor')) {
            return ['medical_clinic', 'Medical clinic'];
        }
        if (str_contains($joined, 'hospital')) {
            return ['hospital', 'Hospital'];
        }

        return ['health_service', 'Health service'];
    }
}
