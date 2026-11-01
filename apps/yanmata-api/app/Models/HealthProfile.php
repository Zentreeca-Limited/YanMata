<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HealthProfile extends Model
{
    protected $fillable = ['user_id', 'answers', 'completed_at'];

    protected function casts(): array
    {
        return ['answers' => 'encrypted:array', 'completed_at' => 'datetime'];
    }
}
