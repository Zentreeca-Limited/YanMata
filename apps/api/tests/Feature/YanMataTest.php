<?php

namespace Tests\Feature;

use App\Models\ContentItem;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class YanMataTest extends TestCase
{
    use RefreshDatabase;

    private function actor(string $role = 'member', bool $consent = false): User
    {
        return User::factory()->create(['role' => $role, 'sync_consent' => $consent]);
    }

    private function draft(User $u, array $extra = []): ContentItem
    {
        return ContentItem::create([...['title' => 'Sample', 'topic' => 'Body literacy', 'stage' => 'Puberty', 'summary' => 'Demo summary', 'body' => 'Demo only', 'source_url' => 'https://www.who.int/health-topics/adolescent-health', 'author_id' => $u->id], ...$extra]);
    }

    private function mutation(?string $entry = null, int $version = 0): array
    {
        return ['mutation_id' => (string) Str::uuid(), 'entry_id' => $entry ?? (string) Str::uuid(), 'expected_version' => $version, 'deleted' => false, 'payload' => ['date' => '2026-10-27', 'mood' => 'Okay', 'note' => 'Private sample note']];
    }

    public function test_learning_hides_unpublished_expired_and_demo_records_by_default(): void
    {
        $u = $this->actor('author');
        $this->draft($u);
        $this->draft($u, ['status' => 'published', 'review_due_at' => now()->subDay()]);
        $this->draft($u, ['status' => 'published', 'review_due_at' => now()->addDay(), 'is_demo' => true]);
        $this->getJson('/api/v1/content')->assertOk()->assertJsonCount(0, 'data');
        config(['yanmata.demo' => true]);
        $this->getJson('/api/v1/content')->assertJsonCount(1, 'data');
    }

    public function test_member_cannot_enter_studio_or_read_another_journal(): void
    {
        Sanctum::actingAs($this->actor());
        $this->getJson('/api/v1/studio/content')->assertForbidden();
        $this->getJson('/api/v1/sync/pull')->assertForbidden();
    }

    public function test_publication_requires_separate_roles_and_current_version(): void
    {
        $author = $this->actor('author');
        $item = $this->draft($author);
        Sanctum::actingAs($author);
        $url = "/api/v1/studio/content/{$item->id}/transition";
        $this->postJson($url, ['action' => 'publish', 'version' => 1])->assertForbidden();
        $this->postJson($url, ['action' => 'submit', 'version' => 1])->assertOk()->assertJsonPath('data.status', 'in_review');
        $this->postJson($url, ['action' => 'review', 'version' => 2])->assertForbidden();
        Sanctum::actingAs($this->actor('reviewer'));
        $this->postJson($url, ['action' => 'review', 'version' => 1])->assertConflict();
        $this->postJson($url, ['action' => 'review', 'version' => 2])->assertOk()->assertJsonPath('data.status', 'approved');
        Sanctum::actingAs($this->actor('publisher'));
        $this->postJson($url, ['action' => 'publish', 'version' => 3])->assertOk();
        $this->getJson('/api/v1/content')->assertJsonCount(1, 'data');
        $this->postJson($url, ['action' => 'withdraw', 'version' => 4])->assertOk();
        $this->getJson('/api/v1/content')->assertJsonCount(0, 'data');
    }

    public function test_editing_approved_content_resets_clinical_approval(): void
    {
        $author = $this->actor('author');
        $item = $this->draft($author, ['status' => 'approved', 'reviewer_id' => $this->actor('reviewer')->id, 'reviewed_at' => now(), 'review_due_at' => now()->addMonth()]);
        Sanctum::actingAs($author);
        $this->putJson("/api/v1/studio/content/{$item->id}", ['title' => 'Revised', 'topic' => 'Periods', 'stage' => 'Adolescence', 'summary' => 'Changed', 'body' => 'New content', 'source_url' => 'https://www.who.int', 'version' => 1])->assertOk()->assertJsonPath('data.status', 'draft')->assertJsonPath('data.reviewed_at', null);
    }

    public function test_author_cannot_edit_another_authors_content(): void
    {
        $item = $this->draft($this->actor('author'));
        Sanctum::actingAs($this->actor('author'));
        $this->putJson("/api/v1/studio/content/{$item->id}", ['title' => 'Revised', 'topic' => 'Periods', 'stage' => 'Adolescence', 'summary' => 'Changed', 'body' => 'New', 'source_url' => 'https://www.who.int', 'version' => 1])->assertForbidden();
    }

    public function test_sync_is_encrypted_idempotent_and_reports_stale_writes(): void
    {
        $u = $this->actor('member', true);
        Sanctum::actingAs($u);
        $m = $this->mutation();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertOk()->assertJsonPath('results.0.status', 'accepted');
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertOk();
        $this->assertDatabaseCount('journal_entries', 1);
        $this->assertDatabaseCount('journal_changes', 1);
        $this->assertStringNotContainsString('Private sample note', DB::table('journal_entries')->first()->payload);
        $this->assertStringNotContainsString('Private sample note', DB::table('sync_receipts')->first()->result);
        $stale = $this->mutation($m['entry_id']);
        $this->postJson('/api/v1/sync/push', ['mutations' => [$stale]])->assertOk()->assertJsonPath('results.0.status', 'conflict');
        $m['payload']['note'] = 'Different';
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertConflict();
    }

    public function test_sync_delete_cannot_be_resurrected_and_cursor_is_scoped(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $m = $this->mutation();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$m]])->assertOk();
        $deleted = $this->mutation($m['entry_id'], 1);
        $deleted['deleted'] = true;
        $this->postJson('/api/v1/sync/push', ['mutations' => [$deleted]])->assertOk();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$this->mutation($m['entry_id'], 2)]])->assertJsonPath('results.0.status', 'conflict');
        $pull = $this->getJson('/api/v1/sync/pull')->assertOk()->assertJsonPath('entries.0.deleted', true)->assertJsonPath('entries.0.payload', null);
        $cursor = $pull->json('cursor');
        Sanctum::actingAs($this->actor('member', true));
        $this->getJson('/api/v1/sync/pull?cursor='.urlencode($cursor))->assertBadRequest();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$this->mutation($m['entry_id'], 2)]])->assertNotFound();
    }

    public function test_revoked_consent_blocks_future_sync(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $this->putJson('/api/v1/consent/sync', ['enabled' => false])->assertOk();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$this->mutation()]])->assertForbidden();
    }

    public function test_mobile_login_issues_expiring_token_and_logout_revokes_it(): void
    {
        $u = $this->actor();
        $u->forceFill(['password' => Hash::make('a-test-only-password')])->save();
        $result = $this->postJson('/api/v1/mobile/login', ['email' => $u->email, 'password' => 'a-test-only-password'])->assertOk();
        $this->assertNotNull($u->tokens()->first()->expires_at);
        $token = $result->json('token');
        $this->withToken($token)->postJson('/api/v1/logout')->assertNoContent();
        $this->assertDatabaseCount('personal_access_tokens', 0);
    }

    public function test_valid_cursor_can_be_reused_by_its_owner(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $cursor = $this->getJson('/api/v1/sync/pull')->assertOk()->json('cursor');
        $this->getJson('/api/v1/sync/pull?cursor='.urlencode($cursor))->assertOk()->assertJsonCount(0, 'entries');
    }

    public function test_check_in_can_sync_without_an_optional_note(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $mutation = $this->mutation();
        $mutation['payload']['note'] = '';
        $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])->assertOk()->assertJsonPath('results.0.server.payload.note', '');
    }

    public function test_idempotency_ignores_json_key_order(): void
    {
        Sanctum::actingAs($this->actor('member', true));
        $mutation = $this->mutation();
        $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])->assertOk();
        $mutation = array_reverse($mutation, true);
        $mutation['payload'] = array_reverse($mutation['payload'], true);
        $this->postJson('/api/v1/sync/push', ['mutations' => [$mutation]])->assertOk();
        $this->assertDatabaseCount('journal_changes', 1);
    }
}
