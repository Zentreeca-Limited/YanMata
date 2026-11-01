<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LocationController extends Controller
{
    /**
     * Return available locations, hubs, and coverage areas.
     */
    public function index(Request $request): JsonResponse
    {
        $locations = [
            [
                'id' => 'all',
                'city' => 'All Locations',
                'state' => 'Nationwide & Global',
                'country' => 'Nigeria',
                'label' => 'All Locations (Nationwide & Telehealth)',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'jos',
                'city' => 'Jos',
                'state' => 'Plateau State',
                'country' => 'Nigeria',
                'label' => 'Jos, Plateau State (Pilot Launch Hub)',
                'is_pilot_hub' => true,
            ],
            [
                'id' => 'abuja',
                'city' => 'Abuja',
                'state' => 'Federal Capital Territory',
                'country' => 'Nigeria',
                'label' => 'Abuja, FCT',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'lagos',
                'city' => 'Lagos',
                'state' => 'Lagos State',
                'country' => 'Nigeria',
                'label' => 'Lagos, Lagos State',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'kano',
                'city' => 'Kano',
                'state' => 'Kano State',
                'country' => 'Nigeria',
                'label' => 'Kano, Kano State',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'ibadan',
                'city' => 'Ibadan',
                'state' => 'Oyo State',
                'country' => 'Nigeria',
                'label' => 'Ibadan, Oyo State',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'port_harcourt',
                'city' => 'Port Harcourt',
                'state' => 'Rivers State',
                'country' => 'Nigeria',
                'label' => 'Port Harcourt, Rivers State',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'enugu',
                'city' => 'Enugu',
                'state' => 'Enugu State',
                'country' => 'Nigeria',
                'label' => 'Enugu, Enugu State',
                'is_pilot_hub' => false,
            ],
            [
                'id' => 'kaduna',
                'city' => 'Kaduna',
                'state' => 'Kaduna State',
                'country' => 'Nigeria',
                'label' => 'Kaduna, Kaduna State',
                'is_pilot_hub' => false,
            ],
        ];

        return response()->json([
            'data' => $locations,
            'default_pilot' => 'jos',
        ]);
    }
}
