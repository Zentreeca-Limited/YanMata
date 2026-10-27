<?php

namespace App\Http\Controllers;

use App\Events\CareMessageReceived;
use App\Http\Resources\CareConversationResource;
use App\Http\Resources\CareMessageResource;
use App\Http\Resources\SpecialistResource;
use App\Http\Resources\SupportRequestResource;
use App\Models\BroadcastEvent;
use App\Models\CareConversation;
use App\Models\CareMessage;
use App\Models\SpecialistProfile;
use App\Models\SupportRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Gate;

class CareController extends Controller
{
    public function specialists()
    {
        $specialists = SpecialistProfile::where('is_verified', true)
            ->where('is_available', true)
            ->orderBy('name')
            ->get();

        return SpecialistResource::collection($specialists);
    }

    public function memberRequests(Request $r)
    {
        $requests = SupportRequest::with(['specialist', 'conversation'])
            ->where('user_id', $r->user()->id)
            ->latest('created_at')
            ->get();

        return SupportRequestResource::collection($requests);
    }

    public function createRequest(Request $r)
    {
        $data = $r->validate([
            'topic' => 'required|string|max:120',
            'stage' => 'required|in:All chapters,Puberty,Adolescence,Adulthood,Menopause,Later life',
            'summary' => 'required|string|max:2000',
            'share_journal_consent' => 'required|boolean',
            'specialist_id' => 'nullable|uuid|exists:specialist_profiles,id',
        ]);

        $request = DB::transaction(function () use ($r, $data) {
            $req = SupportRequest::create([
                'user_id' => $r->user()->id,
                'specialist_id' => $data['specialist_id'] ?? null,
                'topic' => $data['topic'],
                'stage' => $data['stage'],
                'summary' => $data['summary'],
                'status' => ! empty($data['specialist_id']) ? 'assigned' : 'pending',
                'share_journal_consent' => $data['share_journal_consent'],
            ]);

            // If a specific specialist was chosen, immediately start the conversation
            if (! empty($data['specialist_id'])) {
                $conv = CareConversation::create([
                    'support_request_id' => $req->id,
                    'user_id' => $r->user()->id,
                    'specialist_id' => $data['specialist_id'],
                    'status' => 'open',
                    'last_message_at' => now(),
                ]);

                // Create initial question as first message
                CareMessage::create([
                    'conversation_id' => $conv->id,
                    'sender_id' => $r->user()->id,
                    'sender_role' => 'member',
                    'body' => $data['summary'],
                    'is_read' => false,
                ]);
            }

            return $req;
        });

        $request->load(['specialist', 'conversation']);

        return new SupportRequestResource($request);
    }

    public function getConversation(Request $r, string $id)
    {
        $conv = CareConversation::with(['specialist', 'supportRequest', 'messages.sender'])
            ->findOrFail($id);

        Gate::authorize('viewConversation', $conv);

        return new CareConversationResource($conv);
    }

    public function sendMessage(Request $r, string $id)
    {
        $data = $r->validate([
            'body' => 'required|string|max:4000',
        ]);

        $conv = CareConversation::with(['specialist'])->findOrFail($id);

        Gate::authorize('sendMessage', $conv);

        $senderRole = ($conv->user_id === $r->user()->id) ? 'member' : 'specialist';

        $msg = DB::transaction(function () use ($r, $conv, $data, $senderRole) {
            $message = CareMessage::create([
                'conversation_id' => $conv->id,
                'sender_id' => $r->user()->id,
                'sender_role' => $senderRole,
                'body' => $data['body'],
                'is_read' => false,
            ]);

            $conv->update(['last_message_at' => now()]);

            return $message;
        });

        // Realtime hint dispatch with strict privacy guarantee:
        // NEVER include clinical body, journal data, or health text.
        $recipientUserId = ($senderRole === 'member')
            ? ($conv->specialist?->user_id)
            : $conv->user_id;

        if ($recipientUserId) {
            $event = new CareMessageReceived($msg, $recipientUserId);

            BroadcastEvent::create([
                'id' => $event->eventId,
                'channel' => 'private-user.'.$recipientUserId,
                'event' => 'care.message_received',
                'payload' => $event->broadcastWith(),
                'dispatched' => true,
            ]);

            try {
                broadcast($event);
            } catch (\Throwable) {
                // Non-fatal if broadcast driver / network socket is offline
            }
        }

        return new CareMessageResource($msg);
    }

    // Studio / Specialist operator endpoints
    public function studioRequests(Request $r)
    {
        abort_unless(in_array($r->user()->role, ['publisher', 'reviewer', 'specialist', 'support_operator', 'admin'], true), 403);

        $requests = SupportRequest::with(['user', 'specialist', 'conversation'])
            ->latest('created_at')
            ->limit(100)
            ->get();

        return SupportRequestResource::collection($requests);
    }

    public function studioAssign(Request $r, string $id)
    {
        abort_unless(in_array($r->user()->role, ['publisher', 'reviewer', 'specialist', 'support_operator', 'admin'], true), 403);

        $data = $r->validate([
            'specialist_id' => 'required|uuid|exists:specialist_profiles,id',
        ]);

        $request = DB::transaction(function () use ($id, $data) {
            $req = SupportRequest::findOrFail($id);
            $req->specialist_id = $data['specialist_id'];
            $req->status = 'assigned';
            $req->save();

            $conv = CareConversation::firstOrCreate(
                ['support_request_id' => $req->id],
                [
                    'user_id' => $req->user_id,
                    'specialist_id' => $data['specialist_id'],
                    'status' => 'open',
                    'last_message_at' => now(),
                ]
            );

            return $req;
        });

        $request->load(['specialist', 'conversation']);

        return new SupportRequestResource($request);
    }
}
