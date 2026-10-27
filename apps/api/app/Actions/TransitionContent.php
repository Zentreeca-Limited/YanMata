<?php

namespace App\Actions;

use App\Models\ContentItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Gate;

class TransitionContent
{
    public function execute(string $id, string $action, int $version, int $actorId): ContentItem
    {
        return DB::transaction(function () use ($id, $action, $version, $actorId) {
            $item = ContentItem::lockForUpdate()->findOrFail($id);
            abort_if($item->version !== $version, 409, 'This draft changed. Refresh before continuing.');
            Gate::authorize($action, $item);
            $item->status = match ($action) {
                'submit' => 'in_review','review' => 'approved','publish' => 'published','withdraw' => 'withdrawn'
            };
            if ($action === 'review') {
                $item->reviewer_id = $actorId;
                $item->reviewed_at = now();
                $item->review_due_at = now()->addMonths(3);
            }
            if ($action === 'publish') {
                $item->published_at = now();
            }
            $item->version++;
            $item->save();
            DB::table('editorial_events')->insert(['content_id' => $item->id, 'actor_id' => $actorId, 'action' => $action, 'version' => $item->version, 'created_at' => now(), 'updated_at' => now()]);

            return $item;
        });
    }
}
