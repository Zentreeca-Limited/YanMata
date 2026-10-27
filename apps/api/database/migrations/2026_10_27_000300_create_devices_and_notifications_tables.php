<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_devices', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $t->string('device_id');
            $t->string('device_name')->default('Mobile Device');
            $t->string('platform'); // 'android' or 'ios'
            $t->string('push_token')->nullable();
            $t->boolean('push_enabled')->default(true);
            $t->timestamp('last_seen_at')->nullable();
            $t->timestamps();

            $t->unique(['user_id', 'device_id'], 'idx_user_devices_unique');
            $t->index('push_token', 'idx_devices_push_token');
        });

        Schema::create('notification_preferences', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->unique()->constrained('users')->cascadeOnDelete();
            $t->boolean('care_messages')->default(true);
            $t->boolean('editorial_updates')->default(false);
            $t->boolean('quiet_hours_enabled')->default(true);
            $t->string('quiet_hours_start')->default('22:00');
            $t->string('quiet_hours_end')->default('07:00');
            $t->timestamps();
        });

        Schema::create('broadcast_events', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->string('channel');
            $t->string('event');
            $t->json('payload'); // Must carry event ID, entity ID, version only; NEVER health text
            $t->boolean('dispatched')->default(false);
            $t->timestamps();

            $t->index(['dispatched', 'created_at'], 'idx_broadcast_events_queue');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('broadcast_events');
        Schema::dropIfExists('notification_preferences');
        Schema::dropIfExists('user_devices');
    }
};
