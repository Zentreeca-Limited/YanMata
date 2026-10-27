<?php

namespace Database\Seeders;

use App\Models\CareConversation;
use App\Models\CareMessage;
use App\Models\ContentItem;
use App\Models\SpecialistProfile;
use App\Models\SupportRequest;
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
        foreach (['author', 'reviewer', 'publisher', 'member', 'specialist'] as $role) {
            $users[$role] = User::unguarded(fn () => User::updateOrCreate(['email' => $role.'@demo.yanmata.test'], ['name' => 'Demo '.ucfirst($role), 'password' => Hash::make($password), 'role' => $role, 'sync_consent' => true]));
        }

        // Synthetic specialist profiles
        $specialistsData = [
            [
                'user_id' => $users['specialist']->id,
                'name' => 'Dr. Fatima Bello',
                'title' => 'Obstetrician & Gynaecologist',
                'credentials' => 'MBBS, FWACS (OB/GYN)',
                'specialty' => 'Reproductive health & midlife transitions',
                'bio' => 'Consultant gynaecologist based in Jos with 14 years supporting women through puberty, reproductive choices and perimenopause. Synthetic demo profile.',
                'city' => 'Jos, Plateau State',
                'verification_source' => 'Medical and Dental Council of Nigeria (MDCN) synthetic verification #94821',
                'is_verified' => true,
                'is_available' => true,
            ],
            [
                'user_id' => $users['reviewer']->id,
                'name' => 'Nurse Grace Danladi',
                'title' => 'Clinical Nurse Specialist',
                'credentials' => 'RN, RM, BNSc (Adolescent & Community Health)',
                'specialty' => 'Adolescent body literacy & menstrual health',
                'bio' => 'Nurse practitioner with over a decade in community and adolescent reproductive education across Plateau State. Synthetic demo profile.',
                'city' => 'Jos, Plateau State',
                'verification_source' => 'Nursing and Midwifery Council of Nigeria (NMCN) synthetic verification #31084',
                'is_verified' => true,
                'is_available' => true,
            ],
        ];

        $specialistModels = [];
        foreach ($specialistsData as $data) {
            $specialistModels[] = SpecialistProfile::updateOrCreate(
                ['name' => $data['name']],
                $data
            );
        }

        // Synthetic care inquiry & conversation
        $supportReq = SupportRequest::updateOrCreate(
            ['summary' => 'I would like to understand if irregular cycles during early puberty are typical, and what signals indicate I should speak with a nurse.'],
            [
                'user_id' => $users['member']->id,
                'specialist_id' => $specialistModels[1]->id,
                'topic' => 'Menstrual wellbeing',
                'stage' => 'Puberty',
                'status' => 'assigned',
                'share_journal_consent' => true,
            ]
        );

        $conv = CareConversation::updateOrCreate(
            ['support_request_id' => $supportReq->id],
            [
                'user_id' => $users['member']->id,
                'specialist_id' => $specialistModels[1]->id,
                'status' => 'open',
                'last_message_at' => now(),
            ]
        );

        CareMessage::firstOrCreate(
            ['conversation_id' => $conv->id, 'body' => $supportReq->summary],
            [
                'sender_id' => $users['member']->id,
                'sender_role' => 'member',
                'is_read' => true,
            ]
        );

        CareMessage::firstOrCreate(
            ['conversation_id' => $conv->id, 'sender_id' => $users['reviewer']->id],
            [
                'sender_role' => 'specialist',
                'body' => 'Hello. In the first one to two years after menarche (first period), the hormonal system is still maturing, so cycle lengths can naturally vary. Tracking your symptoms helps us observe whether pain or flow intensity need attention. Feel free to ask anytime.',
                'is_read' => false,
            ]
        );
        $samples = [['A little space to understand yourself', 'Body literacy', 'Puberty', 'Your questions belong here. Explore your changing body at your own pace.'], ['Your journal, your own words', 'Periods', 'Adolescence', 'A quiet place to notice patterns, without judging your experience.'], ['You are more than a busy day', 'Emotional wellbeing', 'Adulthood', 'Make room for a moment of reflection in your everyday life.'], ['A new chapter is still your chapter', 'Healthy ageing', 'Menopause', 'Discover a space designed to grow with you, through every transition.'], ['Wellbeing has no age limit', 'Healthy ageing', 'Later life', 'Comfort, dignity and connection belong in every chapter.']];
        foreach ($samples as [$title,$topic,$stage,$summary]) {
            ContentItem::updateOrCreate(['title' => $title], ['topic' => $topic, 'stage' => $stage, 'summary' => $summary, 'body' => 'This is synthetic demonstration content for the YanMata learning experience. It has not been clinically reviewed and is not health advice.

The finished library will include age-appropriate articles, clear source links and named clinical review. You will be able to learn at your own pace and speak with verified specialists within YanMata.

Your personal experience matters. You can explore without sharing a health history.', 'source_url' => 'https://www.who.int/health-topics/adolescent-health', 'status' => 'published', 'is_demo' => true, 'author_id' => $users['author']->id, 'reviewer_id' => $users['reviewer']->id, 'reviewed_at' => now(), 'review_due_at' => now()->addMonths(3), 'published_at' => now()]);
        }
    }
}
