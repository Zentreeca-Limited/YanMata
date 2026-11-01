<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ContentResource extends JsonResource
{
    public function toArray($request): array
    {
        return ['id' => $this->id, 'title' => $this->title, 'topic' => $this->topic, 'stage' => $this->stage, 'summary' => $this->summary, 'body' => $this->body, 'source_url' => $this->source_url, 'status' => $this->status, 'is_demo' => $this->is_demo, 'version' => $this->version, 'reviewed_at' => $this->reviewed_at?->toIso8601String(), 'review_due_at' => $this->review_due_at?->toIso8601String(), 'published_at' => $this->published_at?->toIso8601String()];
    }
}
