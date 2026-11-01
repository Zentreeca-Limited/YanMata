<?php

namespace App\Providers;

use App\Models\CareConversation;
use App\Models\SupportRequest;
use App\Policies\CarePolicy;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Model::preventLazyLoading(! $this->app->isProduction());
        Model::preventSilentlyDiscardingAttributes(! $this->app->isProduction());

        Gate::policy(CareConversation::class, CarePolicy::class);
        Gate::policy(SupportRequest::class, CarePolicy::class);

        RateLimiter::for('login', fn (Request $request) => [Limit::perMinute(5)->by('login-account:'.hash('sha256', strtolower((string) $request->input('email')).'|'.$request->ip())), Limit::perMinute(30)->by('login-ip:'.$request->ip())]);
        RateLimiter::for('account-deletion', fn (Request $request) => Limit::perMinute(5)->by('account-deletion:'.($request->user()?->getAuthIdentifier() ?? $request->ip())));
    }
}
