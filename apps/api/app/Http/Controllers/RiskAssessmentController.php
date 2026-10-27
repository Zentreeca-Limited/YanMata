<?php

namespace App\Http\Controllers;

use App\Models\RiskAssessment;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class RiskAssessmentController extends Controller
{
    public function getLatest(Request $request)
    {
        $assessment = null;
        if ($request->user()) {
            $assessment = RiskAssessment::where('user_id', $request->user()->id)->latest()->first();
        }

        if (! $assessment) {
            $assessment = RiskAssessment::latest()->first();
        }

        return response()->json(['data' => $assessment]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'age_group' => 'nullable|string',
            'overall_risk_score' => 'required|integer|min:0|max:100',
            'overall_risk_label' => 'required|string',
            'cervical_risk_score' => 'required|integer|min:0|max:100',
            'breast_risk_score' => 'required|integer|min:0|max:100',
            'hormonal_risk_score' => 'required|integer|min:0|max:100',
            'completed_sections' => 'required|array',
            'key_factors' => 'required|array',
            'recommendations' => 'required|array',
        ]);

        $assessment = RiskAssessment::create([
            'id' => (string) Str::uuid(),
            'user_id' => $request->user()?->id,
            'age_group' => $data['age_group'] ?? 'Adolescence (15–19)',
            'overall_risk_score' => $data['overall_risk_score'],
            'overall_risk_label' => $data['overall_risk_label'],
            'cervical_risk_score' => $data['cervical_risk_score'],
            'breast_risk_score' => $data['breast_risk_score'],
            'hormonal_risk_score' => $data['hormonal_risk_score'],
            'completed_sections' => $data['completed_sections'],
            'key_factors' => $data['key_factors'],
            'recommendations' => $data['recommendations'],
            'traceable_source' => 'WHO Cervical Cancer Elimination Initiative & FMOH National Guidelines',
        ]);

        return response()->json(['data' => $assessment], 201);
    }
}
