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
                    'name' => 'SURPIN (Suicide Research & Prevention Initiative Nigeria)',
                    'phone' => '0800 123 4567 / 0908 021 7555',
                    'available' => '24/7 Toll-Free Support',
                ],
                [
                    'name' => 'Plateau State Emergency Response',
                    'phone' => '112',
                    'available' => '24/7 Immediate Medical & Safety Help',
                ],
                [
                    'name' => 'Asido Foundation Psychosocial Helpline',
                    'phone' => '0902 808 0416',
                    'available' => 'Mon - Sun, 8:00 AM - 8:00 PM',
                ],
            ],
        ]);
    }
}
