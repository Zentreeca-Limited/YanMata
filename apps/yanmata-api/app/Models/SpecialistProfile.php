<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SpecialistProfile extends Model
{
    use HasUuids;

    protected $guarded = ['id'];

    protected function casts(): array
    {
        return [
            'is_verified' => 'boolean',
            'is_available' => 'boolean',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function supportRequests(): HasMany
    {
        return $this->hasMany(SupportRequest::class, 'specialist_id');
    }

    public function conversations(): HasMany
    {
        return $this->hasMany(CareConversation::class, 'specialist_id');
    }
}
