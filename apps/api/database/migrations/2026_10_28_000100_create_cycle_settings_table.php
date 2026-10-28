<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cycle_settings', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->unique()->constrained()->cascadeOnDelete();
            $t->date('last_period_date');
            $t->unsignedTinyInteger('cycle_length')->default(28);
            $t->unsignedTinyInteger('period_duration')->default(5);
            $t->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cycle_settings');
    }
};
