<?php

namespace App\Actions;

use App\Models\JournalEntry;
use App\Models\User;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

class SyncJournal
{
    public function push(User $user, array $mutations): array
    {
        return DB::transaction(function () use ($user, $mutations) {
            $owner = User::lockForUpdate()->findOrFail($user->id);
            abort_unless($owner->sync_consent, 403, 'Cloud sync consent is required.');
            $results = [];
            foreach ($mutations as $m) {
                $fingerprint = hash('sha256', json_encode($this->canonical($m)));
                $receipt = DB::table('sync_receipts')->where('user_id', $owner->id)->where('mutation_id', $m['mutation_id'])->first();
                if ($receipt) {
                    abort_unless(hash_equals($receipt->fingerprint, $fingerprint), 409, 'Mutation ID already used for different data.');
                    $results[] = json_decode(Crypt::decryptString($receipt->result), true);

                    continue;
                }
                $entry = JournalEntry::find($m['entry_id']);
                abort_if($entry && $entry->user_id !== $owner->id, 404);
                if (($entry?->version ?? 0) !== $m['expected_version'] || $entry?->deleted) {
                    $result = ['mutation_id' => $m['mutation_id'], 'status' => 'conflict', 'server' => $entry ? $this->serialize($entry) : null];
                } else {
                    $entry ??= new JournalEntry(['id' => $m['entry_id'], 'user_id' => $owner->id]);
                    $entry->payload = $m['payload'];
                    $entry->version = ($entry->version ?? 0) + 1;
                    $entry->deleted = $m['deleted'];
                    $entry->save();
                    DB::table('journal_changes')->insert(['user_id' => $owner->id, 'entry_id' => $entry->id, 'created_at' => now(), 'updated_at' => now()]);
                    $result = ['mutation_id' => $m['mutation_id'], 'status' => 'accepted', 'server' => $this->serialize($entry)];
                }
                DB::table('sync_receipts')->insert(['user_id' => $owner->id, 'mutation_id' => $m['mutation_id'], 'fingerprint' => $fingerprint, 'result' => Crypt::encryptString(json_encode($result)), 'created_at' => now(), 'updated_at' => now()]);
                $results[] = $result;
            }

            return $results;
        }, 3);
    }

    public function serialize(JournalEntry $entry): array
    {
        return ['id' => $entry->id, 'payload' => $entry->deleted ? null : $entry->payload, 'version' => $entry->version, 'deleted' => $entry->deleted];
    }

    private function canonical(array $value): array
    {
        ksort($value);
        foreach ($value as &$item) {
            if (is_array($item)) {
                $item = $this->canonical($item);
            }
        }

        return $value;
    }
}
