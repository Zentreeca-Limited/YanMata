<?php

use App\Http\Controllers\CareController;
use App\Http\Controllers\ContentController;
use App\Http\Controllers\DeviceController;
use App\Http\Controllers\HealthProductController;
use App\Http\Controllers\HealthServiceController;
use App\Http\Controllers\MentalHealthController;
use App\Http\Controllers\RiskAssessmentController;
use App\Http\Controllers\SessionController;
use App\Http\Controllers\SyncController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::get('/health', fn () => ['service' => 'YanMata API', 'version' => '0.1.0', 'demo' => (bool) config('yanmata.demo')]);
    Route::get('/content', [ContentController::class, 'index'])->middleware('throttle:60,1');
    Route::get('/specialists', [CareController::class, 'specialists'])->middleware('throttle:60,1');
    Route::post('/mobile/login', [SessionController::class, 'login'])->middleware('throttle:login');

    // Health Services (Hospitals, Clinics, Specialists in Jos)
    Route::get('/services', [HealthServiceController::class, 'index'])->middleware('throttle:60,1');
    Route::get('/services/{id}', [HealthServiceController::class, 'show'])->middleware('throttle:60,1');

    // Health Products & Ordering
    Route::get('/products', [HealthProductController::class, 'index'])->middleware('throttle:60,1');
    Route::get('/products/{id}', [HealthProductController::class, 'show'])->middleware('throttle:60,1');
    Route::post('/orders', [HealthProductController::class, 'order'])->middleware('throttle:60,1');

    // Mental Health Resources & Helplines
    Route::get('/mental-health/resources', [MentalHealthController::class, 'resources'])->middleware('throttle:60,1');

    // Risk Assessment & Health Profiling
    Route::get('/risk-profile', [RiskAssessmentController::class, 'getLatest'])->middleware('throttle:60,1');
    Route::post('/risk-profile', [RiskAssessmentController::class, 'store'])->middleware('throttle:60,1');

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/me', [SessionController::class, 'me']);
        Route::post('/logout', [SessionController::class, 'logout']);
        Route::put('/consent/sync', [SessionController::class, 'consent']);
        Route::post('/sync/push', [SyncController::class, 'push'])->middleware('throttle:60,1');
        Route::get('/sync/pull', [SyncController::class, 'pull'])->middleware('throttle:60,1');
        Route::get('/orders/my', [HealthProductController::class, 'myOrders']);
        Route::get('/studio/content', [ContentController::class, 'studio']);
        Route::post('/studio/content', [ContentController::class, 'store']);
        Route::put('/studio/content/{id}', [ContentController::class, 'update']);
        Route::post('/studio/content/{id}/transition', [ContentController::class, 'transition']);

        // Care & In-Platform Specialists
        Route::get('/care/specialists', [CareController::class, 'specialists']);
        Route::get('/care/requests', [CareController::class, 'memberRequests']);
        Route::post('/care/requests', [CareController::class, 'createRequest']);
        Route::get('/care/conversations/{id}', [CareController::class, 'getConversation']);
        Route::post('/care/conversations/{id}/messages', [CareController::class, 'sendMessage'])->middleware('throttle:60,1');
        Route::get('/studio/care/requests', [CareController::class, 'studioRequests']);
        Route::post('/studio/care/requests/{id}/assign', [CareController::class, 'studioAssign']);

        // Devices, Notifications & Events
        Route::post('/devices', [DeviceController::class, 'register']);
        Route::delete('/devices/{device_id}', [DeviceController::class, 'destroy']);
        Route::get('/notification-preferences', [DeviceController::class, 'getPreferences']);
        Route::put('/notification-preferences', [DeviceController::class, 'updatePreferences']);
        Route::get('/events/poll', [DeviceController::class, 'pollEvents']);
    });
});
