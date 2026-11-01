<?php

namespace App\Exceptions;

use Exception;
use Illuminate\Contracts\Debug\ShouldntReport;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\RequestException;
use Illuminate\Http\JsonResponse;

class NearbyPlacesUnavailableException extends Exception implements ShouldntReport
{
    public static function notConfigured(): self
    {
        return new self('Nearby care search is not configured yet.');
    }

    public static function upstreamFailure(ConnectionException|RequestException $previous): self
    {
        return new self(
            'Nearby care search is temporarily unavailable. Please try again.',
            previous: $previous,
        );
    }

    public function render(): JsonResponse
    {
        return response()->json(['message' => $this->getMessage()], 503, [
            'Cache-Control' => 'no-store, private',
            'Pragma' => 'no-cache',
        ]);
    }
}
