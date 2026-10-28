<?php

namespace App\Http\Controllers;

use App\Models\HealthProfile;
use App\Services\InsightsService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class ProfileController extends Controller
{
    private function age($user): int
    {
        return $user->date_of_birth ? Carbon::parse($user->date_of_birth)->age : 18;
    }

    public function show(Request $r): JsonResponse
    {
        return response()->json(['data' => $this->present($r)]);
    }

    public function update(Request $r): JsonResponse
    {
        $d = $r->validate([
            'answers' => 'required|array',
            'answers.menstrual.menarche_age' => 'nullable|integer|between:7,20',
            'answers.menstrual.cycle_regular' => 'nullable|in:regular,irregular,unsure',
            'answers.reproductive.pregnancies' => 'nullable|integer|between:0,20',
            'answers.reproductive.pregnancy_status' => 'nullable|in:none,pregnant,postpartum,breastfeeding',
            'answers.reproductive.contraception' => 'nullable|in:none,pill,injectable,implant,iud,condom,other',
            'answers.medical.conditions' => 'nullable|array|max:10',
            'answers.medical.conditions.*' => 'in:pcos,endometriosis,fibroids,diabetes,hypertension,anaemia,hiv,none',
            'answers.medical.hpv_vaccinated' => 'nullable|in:yes,no,unsure',
            'answers.medical.last_cervical_screening' => 'nullable|in:never,under_3y,3_to_5y,over_5y,unsure',
            'answers.lifestyle.smoking' => 'nullable|in:never,former,current',
            'answers.lifestyle.activity' => 'nullable|in:low,moderate,high',
            'answers.lifestyle.stress' => 'nullable|in:low,moderate,high',
            'answers.family.family_history' => 'nullable|array|max:5',
            'answers.family.family_history.*' => 'in:cervical,breast,ovarian,none',
        ]);
        $allowed = ['menstrual', 'reproductive', 'medical', 'lifestyle', 'family'];
        $incoming = array_intersect_key($d['answers'], array_flip($allowed));
        $profile = HealthProfile::firstOrNew(['user_id' => $r->user()->id]);
        $merged = array_replace($profile->answers ?? [], $incoming);
        $required = InsightsService::requiredSections($this->age($r->user()));
        $profile->answers = $merged;
        $profile->completed_at = count(array_diff($required, array_keys($merged))) === 0 ? ($profile->completed_at ?? now()) : null;
        $profile->save();

        return response()->json(['data' => $this->present($r)]);
    }

    public function insights(Request $r): JsonResponse
    {
        $profile = HealthProfile::where('user_id', $r->user()->id)->first();
        abort_unless($profile?->completed_at, 409, 'Complete your profile to get personalised insights.');

        return response()->json(['data' => (new InsightsService)->build($this->age($r->user()), $profile->answers)]);
    }

    private function present(Request $r): array
    {
        $u = $r->user();
        $p = HealthProfile::where('user_id', $u->id)->first();
        $age = $this->age($u);

        return [
            'age' => $age,
            'is_minor' => $age < InsightsService::ADULT,
            'required_sections' => InsightsService::requiredSections($age),
            'answers' => $p?->answers ?? new \stdClass,
            'completed' => (bool) $p?->completed_at,
        ];
    }
}
