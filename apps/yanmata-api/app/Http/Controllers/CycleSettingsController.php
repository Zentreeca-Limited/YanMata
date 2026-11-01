<?php

namespace App\Http\Controllers;

use App\Models\CycleSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class CycleSettingsController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        abort_unless($request->user()->sync_consent, 403, 'Cloud sync consent is required.');

        return response()->json(['data' => $this->present(CycleSetting::where('user_id', $request->user()->id)->first())]);
    }

    /**
     * Last-write-wins on the client's edit time. A stale write is not applied and the
     * stored value is returned so the device can converge.
     */
    public function update(Request $request): JsonResponse
    {
        abort_unless($request->user()->sync_consent, 403, 'Cloud sync consent is required.');
        $d = $request->validate([
            'last_period_date' => 'required|date_format:Y-m-d|before_or_equal:today',
            'cycle_length' => 'required|integer|between:15,60',
            'period_duration' => 'required|integer|between:1,15|lte:cycle_length',
            'client_updated_at' => 'nullable|date',
        ]);
        $existing = CycleSetting::where('user_id', $request->user()->id)->first();
        $clientAt = isset($d['client_updated_at']) ? Carbon::parse($d['client_updated_at']) : now();
        if ($existing && $existing->updated_at && $clientAt->lt($existing->updated_at)) {
            return response()->json(['applied' => false, 'data' => $this->present($existing)]);
        }
        $row = CycleSetting::updateOrCreate(
            ['user_id' => $request->user()->id],
            collect($d)->only(['last_period_date', 'cycle_length', 'period_duration'])->all(),
        );

        return response()->json(['applied' => true, 'data' => $this->present($row)]);
    }

    private function present(?CycleSetting $s): ?array
    {
        return $s ? [
            'last_period_date' => $s->last_period_date->format('Y-m-d'),
            'cycle_length' => $s->cycle_length,
            'period_duration' => $s->period_duration,
            'updated_at' => $s->updated_at?->toIso8601String(),
        ] : null;
    }
}
