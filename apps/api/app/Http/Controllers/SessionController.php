<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
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

    public function me(Request $request)
    {
        return response()->json(['user' => $this->profile($request->user())]);
    }

    public function logout(Request $request)
    {
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
        return ['id' => $u->id, 'name' => $u->name, 'role' => $u->role, 'sync_consent' => (bool) $u->sync_consent];
    }
}
