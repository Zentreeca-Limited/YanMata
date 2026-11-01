<?php

namespace App\Http\Controllers;

use App\Actions\TransitionContent;
use App\Http\Resources\ContentResource;
use App\Models\ContentItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Gate;

class ContentController extends Controller
{
    public function index()
    {
        return ContentResource::collection(ContentItem::where('status', 'published')->where('review_due_at', '>', now())->when(! config('yanmata.demo'), fn ($q) => $q->where('is_demo', false))->latest('published_at')->limit(100)->get());
    }

    public function studio()
    {
        Gate::authorize('viewAny', ContentItem::class);

        return ContentResource::collection(ContentItem::latest()->limit(100)->get());
    }

    public function store(Request $r)
    {
        Gate::authorize('create', ContentItem::class);
        $data = $r->validate($this->rules());
        $item = ContentItem::create([...$data, 'author_id' => $r->user()->id, 'is_demo' => config('yanmata.demo')]);

        return new ContentResource($item);
    }

    public function update(Request $r, string $id)
    {
        $data = $r->validate([...$this->rules(), 'version' => 'required|integer|min:1']);

        return DB::transaction(function () use ($id, $data) {
            $item = ContentItem::lockForUpdate()->findOrFail($id);
            Gate::authorize('update', $item);
            abort_if($item->version !== $data['version'], 409, 'This draft changed. Refresh before saving.');
            unset($data['version']);
            $item->fill([...$data, 'status' => 'draft', 'reviewer_id' => null, 'reviewed_at' => null, 'review_due_at' => null, 'version' => $item->version + 1])->save();

            return new ContentResource($item);
        });
    }

    public function transition(Request $r, string $id, TransitionContent $action)
    {
        $data = $r->validate(['action' => 'required|in:submit,review,publish,withdraw', 'version' => 'required|integer|min:1']);

        return new ContentResource($action->execute($id, $data['action'], $data['version'], $r->user()->id));
    }

    private function rules(): array
    {
        return ['title' => 'required|string|max:160', 'topic' => 'required|in:Body literacy,Periods,Emotional wellbeing,Healthy ageing', 'stage' => 'required|in:All chapters,Puberty,Adolescence,Adulthood,Menopause,Later life', 'summary' => 'required|string|max:400', 'body' => 'required|string|max:20000', 'source_url' => 'required|url:https|max:2048'];
    }
}
