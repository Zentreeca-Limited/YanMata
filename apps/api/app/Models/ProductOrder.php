<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProductOrder extends Model
{
    use HasUuids;

    protected $fillable = [
        'id',
        'user_id',
        'customer_name',
        'customer_phone',
        'delivery_address',
        'total_ngn',
        'status',
        'items',
    ];

    protected function casts(): array
    {
        return [
            'total_ngn' => 'integer',
            'items' => 'array',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
