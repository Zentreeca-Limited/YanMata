<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class RiskAssessment extends Model
{
    use HasUuids;

    protected $fillable = [
        'id',
        'user_id',
        'age_group',
        'overall_risk_score',
        'overall_risk_label',
        'cervical_risk_score',
        'breast_risk_score',
        'hormonal_risk_score',
        'completed_sections',
        'key_factors',
        'recommendations',
        'traceable_source',
    ];

    protected function casts(): array
    {
        return [
            'overall_risk_score' => 'integer',
            'cervical_risk_score' => 'integer',
            'breast_risk_score' => 'integer',
            'hormonal_risk_score' => 'integer',
            'completed_sections' => 'array',
            'key_factors' => 'array',
            'recommendations' => 'array',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
