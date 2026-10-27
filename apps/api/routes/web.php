<?php

use App\Http\Controllers\SessionController;
use Illuminate\Support\Facades\Route;

Route::post('/api/v1/session', [SessionController::class, 'login'])->middleware('throttle:login');
Route::get('/', fn () => response()->json(['service' => 'YanMata API', 'website' => 'http://127.0.0.1:5173']));
