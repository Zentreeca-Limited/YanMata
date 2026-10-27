<?php

namespace Database\Seeders;

use App\Models\ContentItem;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DemoSeeder extends Seeder
{
    public function run(): void
    {
        if (! app()->environment(['local', 'testing']) || ! config('yanmata.demo')) {
            throw new \RuntimeException('Demo seeding requires local/testing environment and YANMATA_DEMO=true.');
        }
        $password = getenv('YANMATA_DEMO_PASSWORD');
        if (! $password || strlen($password) < 12) {
            throw new \RuntimeException('Set YANMATA_DEMO_PASSWORD to at least 12 characters.');
        }
        $users = [];
        foreach (['author', 'reviewer', 'publisher', 'member'] as $role) {
            $users[$role] = User::unguarded(fn () => User::updateOrCreate(['email' => $role.'@demo.yanmata.test'], ['name' => 'Demo '.ucfirst($role), 'password' => Hash::make($password), 'role' => $role, 'sync_consent' => false]));
        }
        $samples = [['A little space to understand yourself', 'Body literacy', 'Puberty', 'Your questions belong here. Explore your changing body at your own pace.'], ['Your journal, your own words', 'Periods', 'Adolescence', 'A quiet place to notice patterns, without judging your experience.'], ['You are more than a busy day', 'Emotional wellbeing', 'Adulthood', 'Make room for a moment of reflection in your everyday life.'], ['A new chapter is still your chapter', 'Healthy ageing', 'Menopause', 'Discover a space designed to grow with you, through every transition.'], ['Wellbeing has no age limit', 'Healthy ageing', 'Later life', 'Comfort, dignity and connection belong in every chapter.']];
        foreach ($samples as [$title,$topic,$stage,$summary]) {
            ContentItem::updateOrCreate(['title' => $title], ['topic' => $topic, 'stage' => $stage, 'summary' => $summary, 'body' => 'This is synthetic demonstration content for the YanMata learning experience. It has not been clinically reviewed and is not health advice.

The finished library will include age-appropriate articles, clear source links and named clinical review. You will be able to learn at your own pace and speak with verified specialists within YanMata.

Your personal experience matters. You can explore without sharing a health history.', 'source_url' => 'https://www.who.int/health-topics/adolescent-health', 'status' => 'published', 'is_demo' => true, 'author_id' => $users['author']->id, 'reviewer_id' => $users['reviewer']->id, 'reviewed_at' => now(), 'review_due_at' => now()->addMonths(3), 'published_at' => now()]);
        }
    }
}
