<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class SupportRequestResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'specialist_id' => $this->specialist_id,
            'topic' => $this->topic,
            'stage' => $this->stage,
            'summary' => $this->summary,
            'status' => $this->status,
            'share_journal_consent' => $this->share_journal_consent,
            'specialist' => new SpecialistResource($this->whenLoaded('specialist')),
            'conversation_id' => $this->whenLoaded('conversation', fn () => $this->conversation?->id),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
