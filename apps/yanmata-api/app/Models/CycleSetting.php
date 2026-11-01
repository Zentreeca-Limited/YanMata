<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CycleSetting extends Model
{
    protected $fillable = ['user_id', 'last_period_date', 'cycle_length', 'period_duration'];

    protected function casts(): array
    {
        return [
            'last_period_date' => 'date:Y-m-d',
            'cycle_length' => 'integer',
            'period_duration' => 'integer',
        ];
    }
}
