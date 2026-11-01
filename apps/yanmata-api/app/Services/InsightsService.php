<?php

namespace App\Services;

/**
 * Rule-based, non-numeric personalised guidance. No risk scores are produced.
 * Every item carries a source and an explicit clinical-review status; copy stays
 * pending_clinical_review until named reviewers sign it off (GOV-01).
 */
class InsightsService
{
    public const ADULT = 18;

    /** @return list<string> */
    public static function requiredSections(int $age): array
    {
        return $age >= self::ADULT
            ? ['menstrual', 'reproductive', 'medical', 'lifestyle', 'family']
            : ['menstrual', 'lifestyle'];
    }

    /** @return list<array<string,mixed>> */
    public function build(int $age, array $a): array
    {
        $out = [];
        $add = function (string $id, string $cat, string $priority, string $title, string $body, string $source) use (&$out) {
            $out[] = ['id' => $id, 'category' => $cat, 'priority' => $priority, 'title' => $title, 'body' => $body,
                'source' => $source, 'review_status' => 'pending_clinical_review'];
        };
        $med = $a['medical'] ?? [];
        $conditions = $med['conditions'] ?? [];
        $screen = $med['last_cervical_screening'] ?? null;
        $family = $a['family']['family_history'] ?? [];
        $cycle = $a['menstrual']['cycle_regular'] ?? null;
        $life = $a['lifestyle'] ?? [];
        $preg = $a['reproductive']['pregnancy_status'] ?? 'none';
        $hiv = in_array('hiv', $conditions, true);

        if ($age >= 30 || ($hiv && $age >= 25)) {
            if (in_array($screen, ['never', 'over_5y'], true)) {
                $add('cervical_screening_due', 'cervical', 'soon', 'Cervical screening may be due',
                    'You told us you have never been screened or it was over five years ago. HPV-based screening is recommended for women from age 30 (from 25 if living with HIV). Ask a clinician about screening.',
                    'WHO guideline for screening and treatment of cervical pre-cancer lesions, 2021');
            } elseif ($screen === 'unsure') {
                $add('cervical_screening_check', 'cervical', 'discuss', 'Check your last screening date',
                    'If you are not sure when you were last screened, a clinician can help confirm whether you are due.',
                    'WHO guideline for screening and treatment of cervical pre-cancer lesions, 2021');
            }
        }
        if ($age >= 9 && $age <= 26 && in_array($med['hpv_vaccinated'] ?? 'unsure', ['no', 'unsure'], true)) {
            $add('hpv_vaccine', 'cervical', 'discuss', 'Ask about HPV vaccination',
                $age <= 14 ? 'HPV vaccination works best between ages 9 and 14. A parent or guardian can ask a clinic about it.' : 'HPV vaccination may still help. Ask a clinician whether you are eligible.',
                'WHO position paper on HPV vaccines, 2022');
        }
        if (array_intersect($family, ['cervical', 'breast', 'ovarian'])) {
            $add('family_history', 'family', 'discuss', 'Share your family history with a clinician',
                'A family history of cervical, breast or ovarian cancer can change what screening is advised for you. Our specialists can help you prepare questions.',
                'WHO breast cancer fact sheet; ACOG guidance on hereditary cancer');
        }
        if ($cycle === 'irregular' || array_intersect($conditions, ['pcos', 'endometriosis'])) {
            $add('cycle_tracking', 'cycle', 'routine', 'Track your cycle for three months',
                'Irregular cycles or PCOS/endometriosis are easier to assess with a few months of tracking. Seek advice if cycles are shorter than 21 or longer than 35 days, or bleeding is very heavy.',
                'ACOG Committee Opinion 651: menstruation as a vital sign');
        }
        if ($age >= self::ADULT) {
            $add('breast_awareness', 'breast', 'routine', 'Know how your breasts normally look and feel',
                'Being familiar with your normal helps you notice changes early. Tell a clinician about any lump, skin change or nipple discharge.',
                'WHO: Breast cancer early detection and awareness');
        }
        if (($life['smoking'] ?? 'never') === 'current') {
            $add('smoking', 'lifestyle', 'discuss', 'Support to stop smoking',
                'Tobacco use raises the risk of cervical and other cancers. Quitting helps at any age.',
                'WHO tobacco fact sheet');
        }
        if (($life['activity'] ?? null) === 'low') {
            $add('activity', 'lifestyle', 'routine', 'Add gentle movement',
                $age >= self::ADULT ? 'Aim for about 150 minutes of moderate activity a week, building up slowly.' : 'Children and teens benefit from about 60 minutes of activity a day.',
                'WHO guidelines on physical activity and sedentary behaviour, 2020');
        }
        if (($life['stress'] ?? null) === 'high') {
            $add('stress', 'mental', 'routine', 'Make space for rest and support',
                'High stress affects sleep, cycles and mood. Our mental wellbeing resources and specialists are available inside YanMata.',
                'WHO mental health fact sheet');
        }
        if ($preg === 'pregnant') {
            $add('antenatal', 'pregnancy', 'soon', 'Keep up antenatal care',
                'Regular antenatal contacts with a qualified provider help protect you and your baby.',
                'WHO recommendations on antenatal care, 2016');
        }

        return $out;
    }
}
