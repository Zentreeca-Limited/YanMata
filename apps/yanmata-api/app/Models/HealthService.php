<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class HealthService extends Model
{
    use HasUuids;

    protected $fillable = [
        'id',
        'name',
        'category',
        'provider_name',
        'provider_type',
        'address',
        'city',
        'distance_km',
        'price_range',
        'is_verified',
        'is_available',
        'description',
        'opening_hours',
        'verification_source',
        'phone',
    ];

    protected function casts(): array
    {
        return [
            'is_verified' => 'boolean',
            'is_available' => 'boolean',
            'distance_km' => 'float',
        ];
    }
}
