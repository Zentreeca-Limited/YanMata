<?php

use App\Http\Controllers\ContentController;
use App\Http\Controllers\SessionController;
use App\Http\Controllers\SyncController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/health', fn () => ['service' => 'YanMata API', 'version' => '0.1.0', 'demo' => (bool) config('yanmata.demo')]);
    Route::get('/content', [ContentController::class, 'index'])->middleware('throttle:60,1');
    Route::post('/mobile/login', [SessionController::class, 'login'])->middleware('throttle:login');
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/me', [SessionController::class, 'me']);
        Route::post('/logout', [SessionController::class, 'logout']);
        Route::put('/consent/sync', [SessionController::class, 'consent']);
        Route::post('/sync/push', [SyncController::class, 'push'])->middleware('throttle:60,1');
        Route::get('/sync/pull', [SyncController::class, 'pull'])->middleware('throttle:60,1');
        Route::get('/studio/content', [ContentController::class, 'studio']);
        Route::post('/studio/content', [ContentController::class, 'store']);
        Route::put('/studio/content/{id}', [ContentController::class, 'update']);
        Route::post('/studio/content/{id}/transition', [ContentController::class, 'transition']);
    });
});
