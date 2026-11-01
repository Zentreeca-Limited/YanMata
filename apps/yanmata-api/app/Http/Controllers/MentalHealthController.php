<?php

namespace App\Http\Controllers;

use App\Models\MentalHealthResource;
use Illuminate\Http\Request;

class MentalHealthController extends Controller
{
    public function resources(Request $request)
    {
        $query = MentalHealthResource::query();

        if ($request->filled('category')) {
            $query->where('category', $request->category);
        }

        return response()->json([
            'data' => $query->get(),
            'helplines' => [
                [
                    'name' => 'Nigeria national emergency number',
                    'phone' => '112',
                    'available' => 'Immediate emergency response',
                ],
            ],
        ]);
    }
}
