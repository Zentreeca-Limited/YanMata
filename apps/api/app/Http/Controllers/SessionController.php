<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserDevice;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;
use Laravel\Sanctum\PersonalAccessToken;

class SessionController extends Controller
{
    public function login(Request $request)
    {
        $data = $request->validate(['email' => 'required|email', 'password' => 'required|string', 'device_name' => 'sometimes|string|max:80']);
        $user = User::where('email', $data['email'])->first();
        if (! $user || ! Hash::check($data['password'], $user->password)) {
            throw ValidationException::withMessages(['email' => 'The sign-in details are incorrect.']);
        }
        if ($request->is('api/v1/mobile/login')) {
            return response()->json(['user' => $this->profile($user), 'token' => $user->createToken($data['device_name'] ?? 'YanMata mobile', ['*'], now()->addDays(7))->plainTextToken]);
        }
        Auth::guard('web')->login($user);
        $request->session()->regenerate();

        return response()->json(['user' => $this->profile($user)]);
    }

    /** Mobile self-service sign-up. Email only; third-party identity is not enabled. */
    public function register(Request $request)
    {
        $d = $request->validate([
            'name' => 'required|string|min:2|max:80',
            'email' => 'required|email:rfc|max:190|unique:users,email',
            'password' => ['required', 'string', Password::min(10)->letters()->numbers()],
            'date_of_birth' => 'required|date_format:Y-m-d|before:today|after:1900-01-01',
            'accept_terms' => 'accepted',
            'device_name' => 'sometimes|string|max:80',
        ]);
        if (Carbon::parse($d['date_of_birth'])->age < 9) {
            throw ValidationException::withMessages(['date_of_birth' => 'YanMata is for ages 9 and over.']);
        }
        $user = new User(['name' => trim($d['name']), 'email' => strtolower($d['email']), 'password' => $d['password']]);
        $user->forceFill(['role' => 'member', 'sync_consent' => true, 'date_of_birth' => $d['date_of_birth']])->save();

        return response()->json([
            'user' => $this->profile($user),
            'token' => $user->createToken($d['device_name'] ?? 'YanMata mobile', ['*'], now()->addDays(7))->plainTextToken,
        ], 201);
    }

    public function me(Request $request)
    {
        return response()->json(['user' => $this->profile($request->user())]);
    }

    public function logout(Request $request)
    {
        if ($deviceId = $request->input('device_id')) {
            UserDevice::where('user_id', $request->user()->id)
                ->where('device_id', $deviceId)
                ->delete();
        }

        if ($request->user()->currentAccessToken() instanceof PersonalAccessToken) {
            $request->user()->currentAccessToken()->delete();
        } else {
            Auth::guard('web')->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();
        }

        return response()->noContent();
    }

    public function consent(Request $request)
    {
        $data = $request->validate(['enabled' => 'required|boolean']);
        $request->user()->forceFill(['sync_consent' => $data['enabled']])->save();

        return response()->json(['enabled' => $data['enabled']]);
    }

    private function profile(User $u): array
    {
        return ['id' => $u->id, 'name' => $u->name, 'role' => $u->role, 'sync_consent' => (bool) $u->sync_consent, 'date_of_birth' => $u->date_of_birth ? Carbon::parse($u->date_of_birth)->format('Y-m-d') : null];
    }
}
