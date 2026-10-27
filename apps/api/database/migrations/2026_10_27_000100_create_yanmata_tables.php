<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $t) {
            $t->string('role')->default('member');
            $t->boolean('sync_consent')->default(false);
        });
        Schema::create('content_items', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->string('title');
            $t->string('topic');
            $t->string('stage');
            $t->text('summary');
            $t->text('body');
            $t->string('source_url');
            $t->string('status')->default('draft');
            $t->boolean('is_demo')->default(false);
            $t->unsignedInteger('version')->default(1);
            $t->foreignId('author_id')->constrained('users');
            $t->foreignId('reviewer_id')->nullable()->constrained('users');
            $t->timestamp('reviewed_at')->nullable();
            $t->timestamp('review_due_at')->nullable();
            $t->timestamp('published_at')->nullable();
            $t->timestamps();
        });
        Schema::create('editorial_events', function (Blueprint $t) {
            $t->id();
            $t->foreignUuid('content_id')->constrained('content_items');
            $t->foreignId('actor_id')->constrained('users');
            $t->string('action');
            $t->unsignedInteger('version');
            $t->timestamps();
        });
        Schema::create('journal_entries', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->text('payload');
            $t->unsignedInteger('version');
            $t->boolean('deleted')->default(false);
            $t->timestamps();
        });
        Schema::create('sync_receipts', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->uuid('mutation_id');
            $t->string('fingerprint');
            $t->text('result');
            $t->unique(['user_id', 'mutation_id']);
            $t->timestamps();
        });
        Schema::create('journal_changes', function (Blueprint $t) {
            $t->id();
            $t->foreignId('user_id')->constrained()->cascadeOnDelete();
            $t->uuid('entry_id');
            $t->timestamps();
        });
    }

    public function down(): void
    {
        foreach (['journal_changes', 'sync_receipts', 'journal_entries', 'editorial_events', 'content_items'] as $table) {
            Schema::dropIfExists($table);
        }Schema::table('users', function (Blueprint $t) {
            $t->dropColumn(['role', 'sync_consent']);
        });
    }
};
