<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Performance indexes for existing tables
        Schema::table('content_items', function (Blueprint $t) {
            $t->index(['status', 'review_due_at', 'published_at'], 'idx_content_published_lookup');
        });

        Schema::table('journal_changes', function (Blueprint $t) {
            $t->index(['user_id', 'id'], 'idx_journal_changes_user_offset');
        });

        Schema::create('specialist_profiles', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->unique()->constrained('users')->cascadeOnDelete();
            $t->string('name');
            $t->string('title');
            $t->string('credentials');
            $t->string('specialty');
            $t->text('bio');
            $t->string('city')->default('Jos, Plateau State');
            $t->string('verification_source');
            $t->boolean('is_verified')->default(false);
            $t->boolean('is_available')->default(true);
            $t->timestamps();

            $t->index(['is_verified', 'is_available'], 'idx_specialists_verified_avail');
        });

        Schema::create('support_requests', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $t->foreignUuid('specialist_id')->nullable()->constrained('specialist_profiles')->nullOnDelete();
            $t->string('topic');
            $t->string('stage');
            $t->text('summary');
            $t->string('status')->default('pending');
            $t->boolean('share_journal_consent')->default(false);
            $t->timestamps();

            $t->index(['user_id', 'created_at'], 'idx_support_requests_user');
            $t->index(['status', 'created_at'], 'idx_support_requests_status');
        });

        Schema::create('care_conversations', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignUuid('support_request_id')->unique()->constrained('support_requests')->cascadeOnDelete();
            $t->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $t->foreignUuid('specialist_id')->constrained('specialist_profiles')->cascadeOnDelete();
            $t->string('status')->default('open');
            $t->timestamp('last_message_at')->nullable();
            $t->timestamps();

            $t->index(['user_id', 'status'], 'idx_conversations_user');
            $t->index(['specialist_id', 'status'], 'idx_conversations_specialist');
        });

        Schema::create('care_messages', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignUuid('conversation_id')->constrained('care_conversations')->cascadeOnDelete();
            $t->foreignId('sender_id')->constrained('users')->cascadeOnDelete();
            $t->string('sender_role'); // 'member' or 'specialist'
            $t->text('body');
            $t->boolean('is_read')->default(false);
            $t->timestamps();

            $t->index(['conversation_id', 'created_at'], 'idx_messages_conversation_date');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('care_messages');
        Schema::dropIfExists('care_conversations');
        Schema::dropIfExists('support_requests');
        Schema::dropIfExists('specialist_profiles');

        Schema::table('journal_changes', function (Blueprint $t) {
            $t->dropIndex('idx_journal_changes_user_offset');
        });

        Schema::table('content_items', function (Blueprint $t) {
            $t->dropIndex('idx_content_published_lookup');
        });
    }
};
