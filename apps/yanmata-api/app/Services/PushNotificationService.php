<?php

namespace App\Services;

use App\Models\BroadcastEvent;
use App\Models\NotificationPreference;
use App\Models\User;
use App\Models\UserDevice;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class PushNotificationService
{
    public const DISCREET_TITLE = 'A quiet moment';

    public const DISCREET_CARE_BODY = 'You have a new update waiting in your private YanMata space.';

    /**
     * Record a BroadcastEvent and dispatch discreet push notifications to active user devices.
     * STRICT INVARIANT: Never include clinical body, journal data, or health text in push payloads.
     *
     * @param  array<string, mixed>  $dataPayload
     */
    public function notifyUser(
        User $recipient,
        string $eventName,
        array $dataPayload,
        ?string $eventId = null,
        string $category = 'care_messages',
    ): BroadcastEvent {
        $id = $eventId ?? (string) Str::uuid();

        $broadcastRecord = BroadcastEvent::create([
            'id' => $id,
            'channel' => 'private-user.'.$recipient->id,
            'event' => $eventName,
            'payload' => $dataPayload,
            'dispatched' => true,
        ]);

        if (! $this->shouldSendPush($recipient, $category)) {
            return $broadcastRecord;
        }

        $devices = UserDevice::where('user_id', $recipient->id)
            ->where('push_enabled', true)
            ->whereNotNull('push_token')
            ->get();

        foreach ($devices as $device) {
            if (! $device->push_token) {
                continue;
            }
            $this->dispatchToFcm($device, $dataPayload);
        }

        return $broadcastRecord;
    }

    public function shouldSendPush(User $user, string $category = 'care_messages', ?Carbon $now = null): bool
    {
        $prefs = NotificationPreference::where('user_id', $user->id)->first();
        if (! $prefs) {
            // Default: care_messages=true, quiet_hours=true (22:00-07:00)
            $careAllowed = true;
            $editorialAllowed = false;
            $quietEnabled = true;
            $quietStart = '22:00';
            $quietEnd = '07:00';
        } else {
            $careAllowed = (bool) $prefs->care_messages;
            $editorialAllowed = (bool) $prefs->editorial_updates;
            $quietEnabled = (bool) $prefs->quiet_hours_enabled;
            $quietStart = (string) ($prefs->quiet_hours_start ?? '22:00');
            $quietEnd = (string) ($prefs->quiet_hours_end ?? '07:00');
        }

        if ($category === 'care_messages' && ! $careAllowed) {
            return false;
        }
        if ($category === 'editorial_updates' && ! $editorialAllowed) {
            return false;
        }

        if ($quietEnabled && $this->isWithinQuietHours($quietStart, $quietEnd, $now ?? now())) {
            return false;
        }

        return true;
    }

    public function isWithinQuietHours(string $start, string $end, Carbon $time): bool
    {
        $startParts = explode(':', $start);
        $endParts = explode(':', $end);
        if (count($startParts) !== 2 || count($endParts) !== 2) {
            return false;
        }

        $currentMinutes = ((int) $time->format('H')) * 60 + ((int) $time->format('i'));
        $startMinutes = ((int) $startParts[0]) * 60 + ((int) $startParts[1]);
        $endMinutes = ((int) $endParts[0]) * 60 + ((int) $endParts[1]);

        if ($startMinutes > $endMinutes) {
            return $currentMinutes >= $startMinutes || $currentMinutes < $endMinutes;
        }

        return $currentMinutes >= $startMinutes && $currentMinutes < $endMinutes;
    }

    /**
     * @param  array<string, mixed>  $dataPayload
     */
    private function dispatchToFcm(UserDevice $device, array $dataPayload): void
    {
        $fcmServerKey = config('services.fcm.server_key');
        $fcmEndpoint = config('services.fcm.endpoint', 'https://fcm.googleapis.com/fcm/send');

        if (! $fcmServerKey) {
            return;
        }

        $stringData = [];
        foreach ($dataPayload as $k => $v) {
            if (is_scalar($v)) {
                $stringData[(string) $k] = (string) $v;
            }
        }

        try {
            Http::withHeaders([
                'Authorization' => 'key='.$fcmServerKey,
                'Content-Type' => 'application/json',
            ])->timeout(5)->post($fcmEndpoint, [
                'to' => $device->push_token,
                'notification' => [
                    'title' => self::DISCREET_TITLE,
                    'body' => self::DISCREET_CARE_BODY,
                ],
                'data' => $stringData,
            ]);
        } catch (\Throwable $e) {
            Log::warning('FCM push notification dispatch failed', [
                'device_id' => $device->id,
                'platform' => $device->platform,
                'error' => $e->getMessage(),
            ]);
        }
    }
}
