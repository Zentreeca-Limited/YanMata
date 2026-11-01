<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class BroadcastEvent extends Model
{
    use HasUuids;

    protected $fillable = [
        'id',
        'channel',
        'event',
        'payload',
        'dispatched',
    ];

    protected function casts(): array
    {
        return [
            'payload' => 'array',
            'dispatched' => 'boolean',
        ];
    }
}
