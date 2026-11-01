<?php

namespace App\Policies;

use App\Models\ContentItem;
use App\Models\User;

class ContentItemPolicy
{
    public function viewAny(User $u): bool
    {
        return in_array($u->role, ['author', 'reviewer', 'publisher']);
    }

    public function create(User $u): bool
    {
        return $u->role === 'author';
    }

    public function update(User $u, ContentItem $c): bool
    {
        return $u->role === 'author' && $c->author_id === $u->id && $c->status !== 'published';
    }

    public function submit(User $u, ContentItem $c): bool
    {
        return $this->update($u, $c) && $c->status === 'draft';
    }

    public function review(User $u, ContentItem $c): bool
    {
        return $u->role === 'reviewer' && $c->author_id !== $u->id && $c->status === 'in_review';
    }

    public function publish(User $u, ContentItem $c): bool
    {
        return $u->role === 'publisher' && $c->status === 'approved' && $c->review_due_at?->isFuture();
    }

    public function withdraw(User $u, ContentItem $c): bool
    {
        return $u->role === 'publisher' && $c->status === 'published';
    }
}
