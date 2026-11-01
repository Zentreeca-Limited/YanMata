<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CareConversationResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'support_request_id' => $this->support_request_id,
            'user_id' => $this->user_id,
            'specialist_id' => $this->specialist_id,
            'status' => $this->status,
            'last_message_at' => $this->last_message_at?->toIso8601String(),
            'specialist' => new SpecialistResource($this->whenLoaded('specialist')),
            'support_request' => new SupportRequestResource($this->whenLoaded('supportRequest')),
            'messages' => CareMessageResource::collection($this->whenLoaded('messages')),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
