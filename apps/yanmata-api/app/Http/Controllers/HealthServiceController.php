<?php

namespace App\Http\Controllers;

use App\Models\HealthService;
use Illuminate\Http\Request;

class HealthServiceController extends Controller
{
    public function index(Request $request)
    {
        $query = HealthService::query();

        if ($request->filled('category') && $request->category !== 'all') {
            $query->where('category', $request->category);
        }

        if ($request->filled('type') && $request->type !== 'all') {
            $query->where('provider_type', $request->type);
        }

        if ($request->filled('city') && strtolower((string) $request->city) !== 'all') {
            $city = $request->query('city');
            $query->where(function ($sub) use ($city) {
                $sub->where('city', 'like', "%{$city}%")
                    ->orWhere('city', 'Nationwide')
                    ->orWhere('city', 'Telehealth');
            });
        }

        if ($request->filled('query')) {
            $q = $request->query('query');
            $query->where(function ($sub) use ($q) {
                $sub->where('name', 'like', "%{$q}%")
                    ->orWhere('provider_name', 'like', "%{$q}%")
                    ->orWhere('description', 'like', "%{$q}%");
            });
        }

        return response()->json([
            'data' => $query->orderBy('distance_km')->get(),
        ]);
    }

    public function show(string $id)
    {
        $service = HealthService::findOrFail($id);

        return response()->json(['data' => $service]);
    }
}
