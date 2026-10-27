<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class SpecialistResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'title' => $this->title,
            'credentials' => $this->credentials,
            'specialty' => $this->specialty,
            'bio' => $this->bio,
            'city' => $this->city,
            'verification_source' => $this->verification_source,
            'is_verified' => $this->is_verified,
            'is_available' => $this->is_available,
        ];
    }
}
