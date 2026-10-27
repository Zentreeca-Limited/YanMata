<?php

namespace App\Http\Controllers;

use App\Models\BroadcastEvent;
use App\Models\NotificationPreference;
use App\Models\UserDevice;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class DeviceController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'device_id' => 'required|string|max:128',
            'device_name' => 'nullable|string|max:100',
            'platform' => 'required|string|in:android,ios,web',
            'push_token' => 'nullable|string|max:512',
            'push_enabled' => 'nullable|boolean',
        ]);

        $device = UserDevice::updateOrCreate(
            [
                'user_id' => $request->user()->id,
                'device_id' => $data['device_id'],
            ],
            [
                'device_name' => $data['device_name'] ?? 'Mobile Device',
                'platform' => $data['platform'],
                'push_token' => $data['push_token'] ?? null,
                'push_enabled' => $data['push_enabled'] ?? true,
                'last_seen_at' => now(),
            ]
        );

        return response()->json([
            'data' => [
                'id' => $device->id,
                'device_id' => $device->device_id,
                'device_name' => $device->device_name,
                'platform' => $device->platform,
                'push_token' => $device->push_token ? substr($device->push_token, 0, 8).'...' : null,
                'push_enabled' => (bool) $device->push_enabled,
                'last_seen_at' => $device->last_seen_at?->toISOString(),
            ],
        ]);
    }

    public function destroy(Request $request, string $deviceId): Response
    {
        UserDevice::where('user_id', $request->user()->id)
            ->where('device_id', $deviceId)
            ->delete();

        return response()->noContent();
    }

    public function getPreferences(Request $request): JsonResponse
    {
        $prefs = NotificationPreference::firstOrCreate(
            ['user_id' => $request->user()->id],
            [
                'care_messages' => true,
                'editorial_updates' => false,
                'quiet_hours_enabled' => true,
                'quiet_hours_start' => '22:00',
                'quiet_hours_end' => '07:00',
            ]
        );

        return response()->json([
            'data' => [
                'care_messages' => (bool) $prefs->care_messages,
                'editorial_updates' => (bool) $prefs->editorial_updates,
                'quiet_hours_enabled' => (bool) $prefs->quiet_hours_enabled,
                'quiet_hours_start' => $prefs->quiet_hours_start,
                'quiet_hours_end' => $prefs->quiet_hours_end,
            ],
        ]);
    }

    public function updatePreferences(Request $request): JsonResponse
    {
        $data = $request->validate([
            'care_messages' => 'nullable|boolean',
            'editorial_updates' => 'nullable|boolean',
            'quiet_hours_enabled' => 'nullable|boolean',
            'quiet_hours_start' => ['nullable', 'string', 'regex:/^([01]\d|2[0-3]):[0-5]\d$/'],
            'quiet_hours_end' => ['nullable', 'string', 'regex:/^([01]\d|2[0-3]):[0-5]\d$/'],
        ]);

        $prefs = NotificationPreference::firstOrCreate(['user_id' => $request->user()->id]);
        $prefs->update(array_filter($data, fn ($v) => $v !== null));

        return response()->json([
            'data' => [
                'care_messages' => (bool) $prefs->care_messages,
                'editorial_updates' => (bool) $prefs->editorial_updates,
                'quiet_hours_enabled' => (bool) $prefs->quiet_hours_enabled,
                'quiet_hours_start' => $prefs->quiet_hours_start,
                'quiet_hours_end' => $prefs->quiet_hours_end,
            ],
        ]);
    }

    public function pollEvents(Request $request): JsonResponse
    {
        $channel = 'private-user.'.$request->user()->id;

        $query = BroadcastEvent::where('channel', $channel);

        if ($since = $request->query('since')) {
            try {
                $sinceDate = Carbon::parse($since);
                $query->where('created_at', '>', $sinceDate);
            } catch (\Throwable) {
                // If invalid date format, ignore since filter
            }
        }

        $events = $query->oldest('created_at')->limit(50)->get();

        return response()->json([
            'data' => $events->map(fn ($e) => [
                'id' => $e->id,
                'channel' => $e->channel,
                'event' => $e->event,
                'payload' => $e->payload,
                'created_at' => $e->created_at?->toISOString(),
            ]),
        ]);
    }
}
