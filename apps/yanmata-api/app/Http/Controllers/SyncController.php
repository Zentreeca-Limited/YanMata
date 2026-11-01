<?php

namespace App\Http\Controllers;

use App\Actions\SyncJournal;
use App\Models\JournalEntry;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

class SyncController extends Controller
{
    public function push(Request $r, SyncJournal $sync)
    {
        $data = $r->validate([
            'mutations' => 'required|array|min:1|max:50',
            'mutations.*.mutation_id' => 'required|uuid',
            'mutations.*.entry_id' => 'required|uuid',
            'mutations.*.expected_version' => 'required|integer|min:0',
            'mutations.*.deleted' => 'required|boolean',
            'mutations.*.payload' => 'required|array',
            'mutations.*.payload.date' => 'required|date_format:Y-m-d',
            'mutations.*.payload.mood' => 'required|in:Great,Good,Okay,Low,Difficult',
            'mutations.*.payload.flow' => 'nullable|in:none,spotting,light,medium,heavy',
            'mutations.*.payload.symptoms' => 'nullable|array',
            'mutations.*.payload.symptoms.*' => 'string|max:50',
            'mutations.*.payload.energy' => 'nullable|in:high,moderate,low,exhausted',
            'mutations.*.payload.stage' => 'nullable|in:Puberty,Adolescence,Adulthood,Menopause,Later life',
            'mutations.*.payload.note' => 'present|nullable|string|max:2000',
        ]);

        foreach ($data['mutations'] as &$mutation) {
            $mutation['payload']['note'] ??= '';
            $mutation['payload']['flow'] ??= 'none';
            $mutation['payload']['symptoms'] ??= [];
            $mutation['payload']['energy'] ??= 'moderate';
            $mutation['payload']['stage'] ??= null;
        }
        unset($mutation);

        return response()->json(['results' => $sync->push($r->user(), $data['mutations'])]);
    }

    public function pull(Request $r, SyncJournal $sync)
    {
        abort_unless($r->user()->sync_consent, 403);
        $cursor = 0;
        if ($r->filled('cursor')) {
            try {
                $decoded = json_decode(Crypt::decryptString((string) $r->string('cursor')), true);
                abort_unless($decoded['user'] === $r->user()->id, 400);
                $cursor = $decoded['offset'];
            } catch (\Throwable) {
                abort(400, 'Invalid cursor.');
            }
        }
        $changes = DB::table('journal_changes')->where('user_id', $r->user()->id)->where('id', '>', $cursor)->orderBy('id')->limit(100)->get();
        $items = JournalEntry::where('user_id', $r->user()->id)->whereIn('id', $changes->pluck('entry_id')->unique())->get()->map(fn ($e) => $sync->serialize($e));

        return response()->json(['entries' => $items, 'cursor' => Crypt::encryptString(json_encode(['user' => $r->user()->id, 'offset' => $changes->last()?->id ?? $cursor])), 'has_more' => $changes->count() === 100]);
    }
}
