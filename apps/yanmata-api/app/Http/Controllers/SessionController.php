<?php

namespace App\Http\Controllers;

use App\Models\CareConversation;
use App\Models\CareMessage;
use App\Models\CycleSetting;
use App\Models\JournalEntry;
use App\Models\NotificationPreference;
use App\Models\SpecialistProfile;
use App\Models\SupportRequest;
use App\Models\User;
use App\Models\UserDevice;
use App\Services\MemberMailService;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;
use Laravel\Sanctum\PersonalAccessToken;

class SessionController extends Controller
{
    public function __construct(private readonly MemberMailService $mailService) {}

    public function login(Request $request)
    {
        $data = $request->validate(['email' => 'required|email', 'password' => 'required|string', 'device_name' => 'sometimes|string|max:80']);
        $user = User::where('email', strtolower($data['email']))->first();
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
        $user->forceFill(['role' => 'member', 'sync_consent' => false, 'date_of_birth' => $d['date_of_birth']])->save();

        if (config('yanmata.demo')) {
            $this->seedMemberDemoExperience($user);
        }

        $verificationCode = $this->issueEmailVerificationCode($user);
        $this->mailService->sendWelcome($user, $verificationCode);

        return response()->json([
            'user' => $this->profile($user),
            'token' => $user->createToken($d['device_name'] ?? 'YanMata mobile', ['*'], now()->addDays(7))->plainTextToken,
        ], 201);
    }

    public function forgotPassword(Request $request)
    {
        $data = $request->validate([
            'email' => 'required|email:rfc|max:190',
        ]);

        $email = strtolower(trim($data['email']));
        $user = User::where('email', $email)->first();

        if ($user) {
            $code = (string) random_int(100000, 999999);
            DB::table('password_reset_tokens')->updateOrInsert(
                ['email' => $email],
                [
                    'token' => Hash::make($code),
                    'created_at' => now(),
                ]
            );
            $this->mailService->sendPasswordResetCode($user, $code);
        }

        return response()->json([
            'message' => 'If an account matches that email address, we have sent a 6-digit password reset code.',
        ]);
    }

    public function resetPassword(Request $request)
    {
        $data = $request->validate([
            'email' => 'required|email:rfc|max:190',
            'code' => 'required|string|size:6',
            'password' => ['required', 'string', Password::min(10)->letters()->numbers()],
        ]);

        $email = strtolower(trim($data['email']));
        $record = DB::table('password_reset_tokens')->where('email', $email)->first();

        if (
            ! $record ||
            ! $record->created_at ||
            Carbon::parse($record->created_at)->addMinutes(30)->isPast() ||
            ! Hash::check($data['code'], $record->token)
        ) {
            throw ValidationException::withMessages([
                'code' => 'The reset code is invalid or has expired.',
            ]);
        }

        $user = User::where('email', $email)->first();
        if (! $user) {
            throw ValidationException::withMessages([
                'code' => 'The reset code is invalid or has expired.',
            ]);
        }

        $user->forceFill([
            'password' => $data['password'],
        ])->save();

        DB::table('password_reset_tokens')->where('email', $email)->delete();
        $this->mailService->sendPasswordResetSuccess($user);

        return response()->json([
            'message' => 'Your password has been updated. You can now sign in.',
        ]);
    }

    public function sendEmailVerification(Request $request)
    {
        $user = $request->user();
        if ($user->email_verified_at !== null) {
            return response()->json([
                'message' => 'Your email address is already verified.',
                'email_verified' => true,
            ]);
        }

        $code = $this->issueEmailVerificationCode($user);
        $this->mailService->sendEmailVerificationCode($user, $code);

        return response()->json([
            'message' => 'A 6-digit confirmation code has been sent to '.$user->email.'.',
            'email_verified' => false,
        ]);
    }

    public function verifyEmail(Request $request)
    {
        $data = $request->validate([
            'code' => 'required|string|size:6',
        ]);

        $user = $request->user();
        if ($user->email_verified_at !== null) {
            return response()->json([
                'message' => 'Your email address is already verified.',
                'user' => $this->profile($user),
            ]);
        }

        $cacheKey = 'email_verify_code:'.$user->id;
        $storedHash = Cache::get($cacheKey);

        if (! is_string($storedHash) || ! Hash::check($data['code'], $storedHash)) {
            throw ValidationException::withMessages([
                'code' => 'The confirmation code is invalid or has expired.',
            ]);
        }

        Cache::forget($cacheKey);
        $user->forceFill(['email_verified_at' => now()])->save();
        $this->mailService->sendEmailVerifiedConfirmation($user);

        return response()->json([
            'message' => 'Your email address has been confirmed.',
            'user' => $this->profile($user->fresh()),
        ]);
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

    /** Permanently delete a member account after explicit re-authentication. */
    public function destroy(Request $request)
    {
        $data = $request->validate([
            'password' => 'required|string',
            'confirmation' => 'required|in:DELETE',
        ]);
        $user = $request->user();

        if ($user->role !== 'member') {
            return response()->json([
                'message' => 'Staff and specialist accounts require an administrator-managed offboarding process.',
            ], 403);
        }
        if (! Hash::check($data['password'], $user->password)) {
            throw ValidationException::withMessages([
                'password' => 'The password is incorrect.',
            ]);
        }

        $deletedEmail = $user->email;
        $deletedName = $user->name;

        DB::transaction(function () use ($user): void {
            $user->tokens()->delete();
            $user->delete();
        });

        $this->mailService->sendAccountDeleted($deletedEmail, $deletedName);

        return response()->noContent();
    }

    private function issueEmailVerificationCode(User $user): string
    {
        $code = (string) random_int(100000, 999999);
        Cache::put('email_verify_code:'.$user->id, Hash::make($code), now()->addMinutes(30));

        return $code;
    }

    /**
     * When YANMATA_DEMO=true, populate initial synthetic demo records for newly
     * registered members so every section (Care, Cycle Settings, Synced Journal,
     * Notification Preferences) has illustrative data immediately upon sign-in.
     */
    private function seedMemberDemoExperience(User $user): void
    {
        try {
            CycleSetting::firstOrCreate(
                ['user_id' => $user->id],
                [
                    'last_period_date' => now()->subDays(11)->format('Y-m-d'),
                    'cycle_length' => 28,
                    'period_duration' => 5,
                ]
            );

            NotificationPreference::firstOrCreate(
                ['user_id' => $user->id],
                [
                    'check_in_reminder_enabled' => true,
                    'check_in_reminder_time' => '20:00',
                    'care_messages' => true,
                    'content_updates' => true,
                    'quiet_hours_enabled' => true,
                    'quiet_hours_start' => '22:00',
                    'quiet_hours_end' => '07:00',
                ]
            );

            $specialist = SpecialistProfile::where('is_verified', true)->first();
            if ($specialist && ! SupportRequest::where('user_id', $user->id)->exists()) {
                $req = SupportRequest::create([
                    'user_id' => $user->id,
                    'specialist_id' => $specialist->id,
                    'topic' => 'Menstrual wellbeing',
                    'stage' => 'Adulthood',
                    'summary' => 'Synthetic demo inquiry: What cycle signals or energy shifts are helpful to log each week for my check-ins?',
                    'status' => 'assigned',
                    'share_journal_consent' => true,
                ]);

                $conv = CareConversation::create([
                    'support_request_id' => $req->id,
                    'user_id' => $user->id,
                    'specialist_id' => $specialist->id,
                    'status' => 'open',
                    'last_message_at' => now(),
                ]);

                CareMessage::create([
                    'conversation_id' => $conv->id,
                    'sender_id' => $user->id,
                    'sender_role' => 'member',
                    'body' => $req->summary,
                    'is_read' => true,
                ]);

                CareMessage::create([
                    'conversation_id' => $conv->id,
                    'sender_id' => $specialist->user_id ?? $user->id,
                    'sender_role' => 'specialist',
                    'body' => 'Welcome to YanMata Care (Synthetic Demo Thread). Logging your daily mood, energy level, and any physical symptoms like cramps or fatigue over 2–3 cycles gives a clear picture of your personal rhythm. Feel free to send a message here anytime to test live specialist chat.',
                    'is_read' => false,
                ]);
            }

            if (! JournalEntry::where('user_id', $user->id)->exists()) {
                $demoLogs = [
                    [
                        'date' => now()->subDays(3)->format('Y-m-d'),
                        'mood' => 'Good',
                        'flow' => 'none',
                        'symptoms' => ['Fatigue'],
                        'energy' => 'moderate',
                        'stage' => 'Adulthood',
                        'note' => 'Synthetic demo entry: Rested well and took an evening walk.',
                    ],
                    [
                        'date' => now()->subDays(1)->format('Y-m-d'),
                        'mood' => 'Great',
                        'flow' => 'none',
                        'symptoms' => [],
                        'energy' => 'high',
                        'stage' => 'Adulthood',
                        'note' => 'Synthetic demo entry: Feeling steady energy during the follicular phase.',
                    ],
                ];

                foreach ($demoLogs as $payload) {
                    $entryId = (string) Str::uuid();
                    JournalEntry::create([
                        'id' => $entryId,
                        'user_id' => $user->id,
                        'payload' => $payload,
                        'version' => 1,
                        'deleted' => false,
                    ]);

                    DB::table('journal_changes')->insert([
                        'user_id' => $user->id,
                        'entry_id' => $entryId,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }
        } catch (\Throwable) {
            // Non-blocking demo fixture generation
        }
    }

    private function profile(User $u): array
    {
        return [
            'id' => $u->id,
            'name' => $u->name,
            'email' => $u->email,
            'email_verified' => $u->email_verified_at !== null,
            'email_verified_at' => $u->email_verified_at?->toIso8601String(),
            'role' => $u->role,
            'sync_consent' => (bool) $u->sync_consent,
            'date_of_birth' => $u->date_of_birth ? Carbon::parse($u->date_of_birth)->format('Y-m-d') : null,
        ];
    }
}
