<?php

namespace App\Services;

use App\Exceptions\NearbyPlacesUnavailableException;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\RequestException;
use Illuminate\Support\Facades\Http;

class GooglePlacesClient
{
    private const string FieldMask = 'places.id,places.displayName,places.formattedAddress,places.location,places.primaryType,places.primaryTypeDisplayName,places.businessStatus,places.googleMapsLinks,places.attributions';

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
}
