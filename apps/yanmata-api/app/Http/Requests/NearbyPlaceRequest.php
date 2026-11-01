<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class NearbyPlaceRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'latitude' => ['required', 'numeric', 'between:-90,90'],
            'longitude' => ['required', 'numeric', 'between:-180,180'],
            'category' => ['required', 'string', Rule::in(['all', 'hospital', 'clinic', 'pharmacy'])],
            'radius_meters' => ['sometimes', 'integer', 'between:500,20000'],
        ];
    }

    public function messages(): array
    {
        return [
            'latitude.between' => 'The location latitude is outside the supported range.',
            'longitude.between' => 'The location longitude is outside the supported range.',
            'category.in' => 'Choose hospitals, clinics, pharmacies, or all nearby care.',
            'radius_meters.between' => 'The search radius must be between 500 metres and 20 kilometres.',
        ];
    }
}
