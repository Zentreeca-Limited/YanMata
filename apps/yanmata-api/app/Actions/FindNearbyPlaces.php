<?php

namespace App\Actions;

use App\Services\GooglePlacesClient;
use Illuminate\Support\Arr;

class FindNearbyPlaces
{
    private const array GoogleTypes = [
        'all' => ['hospital', 'general_hospital', 'medical_clinic', 'medical_center', 'pharmacy', 'drugstore'],
        'hospital' => ['hospital', 'general_hospital'],
        'clinic' => ['medical_clinic', 'medical_center', 'doctor'],
        'pharmacy' => ['pharmacy', 'drugstore'],
    ];

    public function __construct(private GooglePlacesClient $googlePlaces) {}

    public function providerName(): string
    {
        return $this->googlePlaces->providerName();
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    public function handle(
        float $latitude,
        float $longitude,
        string $category,
        int $radiusMeters,
    ): array {
        $places = $this->googlePlaces->searchNearby(
            latitude: $latitude,
            longitude: $longitude,
            includedTypes: self::GoogleTypes[$category],
            radiusMeters: $radiusMeters,
        );

        return collect($places)
            ->map(fn (array $place): array => $this->normalizePlace($place, $latitude, $longitude))
            ->filter(fn (array $place): bool => $place['id'] !== '' && $place['name'] !== '')
            ->sortBy('distance_km')
            ->values()
            ->all();
    }

    /**
     * @param  array<string, mixed>  $place
     * @return array<string, mixed>
     */
    private function normalizePlace(array $place, float $originLatitude, float $originLongitude): array
    {
        $latitude = (float) Arr::get($place, 'location.latitude', 0);
        $longitude = (float) Arr::get($place, 'location.longitude', 0);

        return [
            'id' => (string) Arr::get($place, 'id', ''),
            'name' => (string) Arr::get($place, 'displayName.text', ''),
            'category' => (string) Arr::get($place, 'primaryType', 'health_service'),
            'category_label' => (string) Arr::get($place, 'primaryTypeDisplayName.text', 'Health service'),
            'address' => (string) Arr::get($place, 'formattedAddress', ''),
            'distance_km' => round($this->distanceKilometres(
                $originLatitude,
                $originLongitude,
                $latitude,
                $longitude,
            ), 1),
            'business_status' => (string) Arr::get($place, 'businessStatus', 'BUSINESS_STATUS_UNSPECIFIED'),
            'directions_uri' => (string) Arr::get($place, 'googleMapsLinks.directionsUri', ''),
            'place_uri' => (string) Arr::get($place, 'googleMapsLinks.placeUri', ''),
            'attributions' => collect(Arr::get($place, 'attributions', []))
                ->map(fn (array $attribution): array => [
                    'provider' => (string) Arr::get($attribution, 'provider', ''),
                    'provider_uri' => (string) Arr::get($attribution, 'providerUri', ''),
                ])
                ->filter(fn (array $attribution): bool => $attribution['provider'] !== '')
                ->values()
                ->all(),
        ];
    }

    private function distanceKilometres(
        float $fromLatitude,
        float $fromLongitude,
        float $toLatitude,
        float $toLongitude,
    ): float {
        $earthRadiusKilometres = 6371;
        $latitudeDelta = deg2rad($toLatitude - $fromLatitude);
        $longitudeDelta = deg2rad($toLongitude - $fromLongitude);
        $fromLatitudeRadians = deg2rad($fromLatitude);
        $toLatitudeRadians = deg2rad($toLatitude);

        $haversine = sin($latitudeDelta / 2) ** 2
            + cos($fromLatitudeRadians) * cos($toLatitudeRadians) * sin($longitudeDelta / 2) ** 2;

        return $earthRadiusKilometres * 2 * atan2(sqrt($haversine), sqrt(1 - $haversine));
    }
}
