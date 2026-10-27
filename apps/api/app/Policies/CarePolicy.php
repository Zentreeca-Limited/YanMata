<?php

namespace App\Policies;

use App\Models\CareConversation;
use App\Models\SupportRequest;
use App\Models\User;

class CarePolicy
{
    public function viewSupportRequest(User $user, SupportRequest $request): bool
    {
        if ($user->id === $request->user_id) {
            return true;
        }

        if ($request->specialist && $request->specialist->user_id === $user->id) {
            return true;
        }

        return in_array($user->role, ['publisher', 'reviewer', 'support_operator', 'admin'], true);
    }

    public function viewConversation(User $user, CareConversation $conversation): bool
    {
        if ($user->id === $conversation->user_id) {
            return true;
        }

        if ($conversation->specialist && $conversation->specialist->user_id === $user->id) {
            return true;
        }

        return in_array($user->role, ['support_operator', 'admin'], true);
    }

    public function sendMessage(User $user, CareConversation $conversation): bool
    {
        if ($conversation->status !== 'open') {
            return false;
        }

        if ($user->id === $conversation->user_id) {
            return true;
        }

        return $conversation->specialist && $conversation->specialist->user_id === $user->id;
    }

    public function assignSupportRequest(User $user, SupportRequest $request): bool
    {
        return in_array($user->role, ['publisher', 'reviewer', 'specialist', 'support_operator', 'admin'], true);
    }
}
