<?php

namespace App\Http\Controllers;

use App\Actions\FindNearbyPlaces;
use App\Http\Requests\NearbyPlaceRequest;
use Illuminate\Http\JsonResponse;

class NearbyPlaceController extends Controller
{
    public function store(
        NearbyPlaceRequest $request,
        FindNearbyPlaces $findNearbyPlaces,
    ): JsonResponse {
        $data = $request->validated();

        return response()->json([
            'data' => $findNearbyPlaces->handle(
                latitude: (float) $data['latitude'],
                longitude: (float) $data['longitude'],
                category: $data['category'],
                radiusMeters: $data['radius_meters'] ?? 10000,
            ),
            'meta' => [
                'category' => $data['category'],
                'radius_meters' => $data['radius_meters'] ?? 10000,
                'ranked_by' => 'distance',
                'provider' => $findNearbyPlaces->providerName(),
                'stored' => false,
            ],
        ])->withHeaders([
            'Cache-Control' => 'no-store, private',
            'Pragma' => 'no-cache',
        ]);
    }
}
