<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CareMessageResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'conversation_id' => $this->conversation_id,
            'sender_id' => $this->sender_id,
            'sender_role' => $this->sender_role,
            'body' => $this->body,
            'is_read' => $this->is_read,
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
