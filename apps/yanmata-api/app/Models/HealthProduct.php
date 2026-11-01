<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class HealthProduct extends Model
{
    use HasUuids;

    protected $fillable = [
        'id',
        'name',
        'category',
        'pack_size',
        'price_ngn',
        'description',
        'seller_name',
        'is_verified_seller',
        'stock_status',
        'safety_info',
    ];

    protected function casts(): array
    {
        return [
            'price_ngn' => 'integer',
            'is_verified_seller' => 'boolean',
        ];
    }
}
