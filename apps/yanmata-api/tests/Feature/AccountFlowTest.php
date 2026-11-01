<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AccountFlowTest extends TestCase
{
    use RefreshDatabase;

    private function payload(array $o = []): array
    {
        return array_merge([
            'name' => 'Amina Bello', 'email' => 'amina@example.test', 'password' => 'Sturdy-pass-2026',
            'date_of_birth' => now()->subYears(34)->format('Y-m-d'), 'accept_terms' => true,
        ], $o);
    }

    public function test_register_returns_token_without_assuming_sync_consent(): void
    {
        $res = $this->postJson('/api/v1/mobile/register', $this->payload())->assertCreated();
        $res->assertJsonPath('user.name', 'Amina Bello')->assertJsonPath('user.sync_consent', false);
        $this->withToken($res->json('token'))->getJson('/api/v1/me')->assertOk();
    }

    public function test_register_validates_age_terms_duplicates_and_password(): void
    {
        $this->postJson('/api/v1/mobile/register', $this->payload(['date_of_birth' => now()->subYears(8)->format('Y-m-d')]))->assertUnprocessable();
        $this->postJson('/api/v1/mobile/register', $this->payload(['accept_terms' => false]))->assertUnprocessable();
        $this->postJson('/api/v1/mobile/register', $this->payload(['password' => 'short1']))->assertUnprocessable();
        $this->postJson('/api/v1/mobile/register', $this->payload())->assertCreated();
        $this->postJson('/api/v1/mobile/register', $this->payload(['name' => 'Other']))->assertUnprocessable();
    }

    public function test_profile_completion_unlocks_personalised_insights_without_scores(): void
    {
        $token = $this->postJson('/api/v1/mobile/register', $this->payload())->json('token');
        $h = ['Authorization' => "Bearer $token"];
        $this->getJson('/api/v1/profile', $h)->assertOk()->assertJsonPath('data.completed', false);
        $this->getJson('/api/v1/insights', $h)->assertStatus(409);

        $answers = [
            'menstrual' => ['cycle_regular' => 'irregular'],
            'reproductive' => ['pregnancy_status' => 'none'],
            'medical' => ['conditions' => ['pcos'], 'hpv_vaccinated' => 'no', 'last_cervical_screening' => 'never'],
            'lifestyle' => ['smoking' => 'current', 'activity' => 'low', 'stress' => 'high'],
            'family' => ['family_history' => ['breast']],
        ];
        $this->putJson('/api/v1/profile', ['answers' => $answers], $h)->assertOk()->assertJsonPath('data.completed', true);
        $res = $this->getJson('/api/v1/insights', $h)->assertOk();
        $ids = collect($res->json('data'))->pluck('id');
        $this->assertTrue($ids->contains('cervical_screening_due') && $ids->contains('family_history') && $ids->contains('cycle_tracking'));
        $this->assertStringNotContainsString('score', strtolower($res->getContent()));
        $this->assertNotNull($res->json('data.0.source'));
        $this->putJson('/api/v1/profile', ['answers' => ['lifestyle' => ['smoking' => 'bogus']]], $h)->assertUnprocessable();
        $this->assertStringNotContainsString('pcos', (string) \DB::table('health_profiles')->value('answers'));
    }

    public function test_minor_profile_needs_fewer_sections_and_gets_no_screening_insight(): void
    {
        $token = $this->postJson('/api/v1/mobile/register', $this->payload(['email' => 'teen@example.test', 'date_of_birth' => now()->subYears(13)->format('Y-m-d')]))->json('token');
        $h = ['Authorization' => "Bearer $token"];
        $this->putJson('/api/v1/profile', ['answers' => ['menstrual' => ['cycle_regular' => 'unsure'], 'lifestyle' => ['activity' => 'low']]], $h)
            ->assertOk()->assertJsonPath('data.completed', true)->assertJsonPath('data.is_minor', true);
        $ids = collect($this->getJson('/api/v1/insights', $h)->json('data'))->pluck('id');
        $this->assertFalse($ids->contains('cervical_screening_due'));
        $this->assertTrue($ids->contains('hpv_vaccine'));
    }

    public function test_profiles_are_isolated(): void
    {
        $a = $this->postJson('/api/v1/mobile/register', $this->payload())->json('token');
        $b = $this->postJson('/api/v1/mobile/register', $this->payload(['email' => 'b@example.test']))->json('token');
        $this->putJson('/api/v1/profile', ['answers' => ['lifestyle' => ['smoking' => 'never']]], ['Authorization' => "Bearer $a"])->assertOk();
        $this->app['auth']->forgetGuards();
        $this->getJson('/api/v1/profile', ['Authorization' => "Bearer $b"])->assertJsonPath('data.answers', []);
    }

    public function test_member_can_delete_account_only_after_password_and_explicit_confirmation(): void
    {
        $registered = $this->postJson('/api/v1/mobile/register', $this->payload())->assertCreated();
        $token = $registered->json('token');
        $headers = ['Authorization' => "Bearer $token"];

        $this->deleteJson('/api/v1/account', [
            'password' => 'wrong-password',
            'confirmation' => 'DELETE',
        ], $headers)->assertUnprocessable();
        $this->assertDatabaseHas('users', ['email' => 'amina@example.test']);

        $this->deleteJson('/api/v1/account', [
            'password' => 'Sturdy-pass-2026',
            'confirmation' => 'delete',
        ], $headers)->assertUnprocessable();

        $this->deleteJson('/api/v1/account', [
            'password' => 'Sturdy-pass-2026',
            'confirmation' => 'DELETE',
        ], $headers)->assertNoContent();

        $this->assertDatabaseMissing('users', ['email' => 'amina@example.test']);
        $this->app['auth']->forgetGuards();
        $this->getJson('/api/v1/me', $headers)->assertUnauthorized();
    }

    public function test_sync_requests_do_not_consume_the_account_deletion_limit(): void
    {
        $registered = $this->postJson('/api/v1/mobile/register', $this->payload())->assertCreated();
        $headers = ['Authorization' => 'Bearer '.$registered->json('token')];

        $this->putJson('/api/v1/consent/sync', ['enabled' => true], $headers)->assertOk();
        foreach (range(1, 6) as $_) {
            $this->getJson('/api/v1/sync/pull', $headers)->assertOk();
        }

        $this->deleteJson('/api/v1/account', [
            'password' => 'Sturdy-pass-2026',
            'confirmation' => 'DELETE',
        ], $headers)->assertNoContent();
    }
}
