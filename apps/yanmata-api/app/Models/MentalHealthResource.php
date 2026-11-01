<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class MentalHealthResource extends Model
{
    use HasUuids;

    protected $fillable = [
        'id',
        'title',
        'category',
        'summary',
        'body',
        'coping_strategies',
        'emergency_helpline',
        'source_citation',
    ];

    protected function casts(): array
    {
        return [
            'coping_strategies' => 'array',
        ];
    }
}
