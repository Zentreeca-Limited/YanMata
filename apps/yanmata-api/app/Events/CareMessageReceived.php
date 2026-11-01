<?php

namespace App\Events;

use App\Models\CareMessage;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Str;

class CareMessageReceived implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public string $eventId;

    public string $type = 'care_message';

    public string $conversationId;

    public string $messageId;

    public string $timestamp;

    public int $recipientUserId;

    public function __construct(CareMessage $message, int $recipientUserId)
    {
        $this->eventId = (string) Str::uuid();
        $this->conversationId = $message->conversation_id;
        $this->messageId = $message->id;
        $this->timestamp = $message->created_at?->toISOString() ?? now()->toISOString();
        $this->recipientUserId = $recipientUserId;
    }

    public function broadcastOn(): array
    {
        return [
            new PrivateChannel('user.'.$this->recipientUserId),
        ];
    }

    public function broadcastAs(): string
    {
        return 'care.message_received';
    }

    public function broadcastWith(): array
    {
        // STRICT INVARIANT: ZERO health text, ZERO patient names, ZERO message body.
        return [
            'event_id' => $this->eventId,
            'type' => $this->type,
            'conversation_id' => $this->conversationId,
            'message_id' => $this->messageId,
            'timestamp' => $this->timestamp,
        ];
    }
}
