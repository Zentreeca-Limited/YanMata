<?php

namespace Database\Seeders;

use App\Models\CareConversation;
use App\Models\CareMessage;
use App\Models\ContentItem;
use App\Models\HealthProduct;
use App\Models\HealthService;
use App\Models\MentalHealthResource;
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
                'name' => 'Demo Specialist One',
                'title' => 'Specialist workflow persona',
                'credentials' => 'Synthetic fixture — no credential claim',
                'specialty' => 'Reproductive health & midlife transitions',
                'bio' => 'Synthetic profile used to demonstrate the in-platform support workflow. No real professional is represented.',
                'city' => 'Jos, Plateau State',
                'verification_source' => 'Synthetic fixture for local demonstration only',
                'is_verified' => true,
                'is_available' => true,
            ],
            [
                'user_id' => $users['reviewer']->id,
                'name' => 'Demo Specialist Two',
                'title' => 'Specialist workflow persona',
                'credentials' => 'Synthetic fixture — no credential claim',
                'specialty' => 'Adolescent body literacy & menstrual health',
                'bio' => 'Synthetic profile used to demonstrate the in-platform support workflow. No real professional is represented.',
                'city' => 'Jos, Plateau State',
                'verification_source' => 'Synthetic fixture for local demonstration only',
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

        // Synthetic Health Services (Jos, Plateau State)
        $services = [
            [
                'name' => 'Cervical Cancer Screening',
                'category' => 'screening',
                'provider_name' => 'Synthetic Jos Hospital One',
                'provider_type' => 'hospital',
                'address' => 'Lamingo Road, Jos, Plateau State',
                'city' => 'Jos',
                'distance_km' => 2.3,
                'price_range' => '₦8,000 – ₦9,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Comprehensive cervical screening (Pap smear, HPV DNA testing, and visual inspection) with clinical follow-up by consultant gynaecologists.',
                'opening_hours' => 'Mon - Fri, 8:00 AM - 4:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Maternal Care',
                'category' => 'maternal',
                'provider_name' => 'Synthetic Jos Hospital Two',
                'provider_type' => 'hospital',
                'address' => 'Bank Road, Jos, Plateau State',
                'city' => 'Jos',
                'distance_km' => 3.1,
                'price_range' => '₦6,000 – ₦12,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Comprehensive antenatal, obstetric assessment and maternal health services staffed by licensed midwives and specialists.',
                'opening_hours' => '24/7 Maternity Emergency; Clinics: Mon - Thu 9:00 AM - 3:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Mental Health Support',
                'category' => 'mental_health',
                'provider_name' => 'Synthetic Jos Clinic Three',
                'provider_type' => 'clinic',
                'address' => 'Rayfield, Jos, Plateau State',
                'city' => 'Jos',
                'distance_km' => 4.8,
                'price_range' => '₦3,000 – ₦10,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Compassionate psychological counseling, anxiety & stress management, and postpartum emotional support in a peaceful setting.',
                'opening_hours' => 'Mon - Sat, 9:00 AM - 6:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Family Planning',
                'category' => 'family_planning',
                'provider_name' => 'Synthetic Jos Clinic Four',
                'provider_type' => 'clinic',
                'address' => 'Tudun Wada, Jos North, Plateau State',
                'city' => 'Jos',
                'distance_km' => 5.2,
                'price_range' => '₦1,000 – ₦5,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Confidential reproductive health education, family planning consultations, and maternal wellness guidance.',
                'opening_hours' => 'Mon - Fri, 8:30 AM - 3:30 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Specialist Clinical Consultation',
                'category' => 'specialist',
                'provider_name' => 'Synthetic In-App Support Service',
                'provider_type' => 'specialist',
                'address' => 'Nationwide & Global Telehealth Network',
                'city' => 'Nationwide',
                'distance_km' => 0.0,
                'price_range' => '₦4,000 – ₦8,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Direct, confidential inquiry and structured follow-up with accredited Nigerian gynaecologists and adolescent health nurses inside YanMata.',
                'opening_hours' => 'Mon - Sat, 8:00 AM - 8:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Adolescent & Maternal Gynecology',
                'category' => 'specialist',
                'provider_name' => 'Synthetic Abuja Hospital One',
                'provider_type' => 'hospital',
                'address' => 'Plot 132 Central District, Garki, Abuja',
                'city' => 'Abuja',
                'distance_km' => 4.2,
                'price_range' => '₦7,000 – ₦15,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Tertiary reproductive health consultations, cervical screening, and adolescent transition clinic.',
                'opening_hours' => 'Mon - Fri, 8:00 AM - 4:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Women\'s Diagnostic & Ultrasound Clinic',
                'category' => 'screening',
                'provider_name' => 'Synthetic Abuja Hospital Two',
                'provider_type' => 'hospital',
                'address' => 'Sam Mbakwe Avenue, Apo District, Abuja',
                'city' => 'Abuja',
                'distance_km' => 6.5,
                'price_range' => '₦10,000 – ₦25,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Pelvic ultrasound, digital mammography, and clinical breast examinations.',
                'opening_hours' => '24/7 Diagnostics & Emergency',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Cervical Cancer Screening & HPV Care',
                'category' => 'screening',
                'provider_name' => 'Synthetic Lagos Hospital One',
                'provider_type' => 'hospital',
                'address' => 'Ishaga Road, Idi-Araba, Surulere, Lagos',
                'city' => 'Lagos',
                'distance_km' => 5.1,
                'price_range' => '₦8,000 – ₦18,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Colposcopy, high-precision HPV DNA testing, and preventive cervical screening.',
                'opening_hours' => 'Mon - Fri, 8:00 AM - 5:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
            [
                'name' => 'Comprehensive Reproductive Health Clinic',
                'category' => 'maternal',
                'provider_name' => 'Synthetic Kano Hospital One',
                'provider_type' => 'hospital',
                'address' => 'Zaria Road, Kano',
                'city' => 'Kano',
                'distance_km' => 3.8,
                'price_range' => '₦5,000 – ₦12,000',
                'is_verified' => true,
                'is_available' => true,
                'description' => 'Antenatal care, postpartum counselling, and maternal health education in English and Hausa.',
                'opening_hours' => 'Mon - Fri, 8:00 AM - 4:00 PM',
                'verification_source' => 'Synthetic fixture; no provider verification claim',
                'phone' => null,
            ],
        ];

        foreach ($services as $index => $srv) {
            $srv['provider_name'] = 'Synthetic '.$srv['city'].' '.ucfirst($srv['provider_type']).' '.($index + 1);
            $srv['address'] = 'Synthetic demo location, '.$srv['city'];
            $srv['price_range'] = 'Demo estimate only';
            $srv['is_verified'] = false;
            $srv['is_available'] = false;
            $srv['opening_hours'] = 'Demo availability only';
            $srv['verification_source'] = 'Synthetic fixture; no provider verification claim';
            $srv['phone'] = null;
            HealthService::updateOrCreate(
                ['name' => $srv['name'], 'provider_name' => $srv['provider_name']],
                $srv
            );
        }

        // Synthetic Health Products (Jos, Plateau State)
        $products = [
            [
                'name' => 'Pregnancy Test Kit',
                'category' => 'womens_health',
                'pack_size' => '1 pack (2 test sticks)',
                'price_ngn' => 3500,
                'description' => 'Over 99% accurate early pregnancy detection test. Rapid results within 3-5 minutes with clear line indicators.',
                'seller_name' => 'Zentreeca Community Pharmacy Jos',
                'is_verified_seller' => true,
                'stock_status' => 'in_stock',
                'safety_info' => 'For in vitro diagnostic use. Read instruction leaflet before use. If you have questions about your result, contact YanMata care specialists.',
            ],
            [
                'name' => 'Folic Acid 400mcg',
                'category' => 'vitamins',
                'pack_size' => '30 tablets',
                'price_ngn' => 2800,
                'description' => 'Essential daily vitamin B9 supplement supporting cell division, reproductive wellness, and maternal development.',
                'seller_name' => 'Zentreeca Community Pharmacy Jos',
                'is_verified_seller' => true,
                'stock_status' => 'in_stock',
                'safety_info' => 'Dietary supplement. Not a replacement for a balanced diet. Consult a healthcare provider before taking with prescription medications.',
            ],
            [
                'name' => 'Iron Supplement',
                'category' => 'vitamins',
                'pack_size' => '30 tablets',
                'price_ngn' => 3000,
                'description' => 'Gentle iron bisglycinate with Vitamin C for optimal absorption to support healthy energy levels and red blood cells during heavy flow.',
                'seller_name' => 'Plateau Health Mart Jos',
                'is_verified_seller' => true,
                'stock_status' => 'in_stock',
                'safety_info' => 'Keep out of reach of children. Take with food or water to minimise stomach sensitivity.',
            ],
            [
                'name' => 'Menstrual Pain Relief',
                'category' => 'womens_health',
                'pack_size' => '20 tablets',
                'price_ngn' => 2500,
                'description' => 'Targeted relief for menstrual cramps, lower back ache, and period discomfort.',
                'seller_name' => 'Zentreeca Community Pharmacy Jos',
                'is_verified_seller' => true,
                'stock_status' => 'in_stock',
                'safety_info' => 'Use strictly as directed on the packaging. Do not exceed stated dose. Avoid use if sensitive to NSAIDs.',
            ],
            [
                'name' => 'Organic Cotton Sanitary Pads',
                'category' => 'personal_care',
                'pack_size' => '10 pads',
                'price_ngn' => 1800,
                'description' => 'Breathable 100% organic cotton top sheet, chlorine-free and fragrance-free pads designed for sensitive skin.',
                'seller_name' => 'Plateau Health Mart Jos',
                'is_verified_seller' => true,
                'stock_status' => 'in_stock',
                'safety_info' => 'Change pads every 4-6 hours for comfort and hygiene.',
            ],
        ];

        foreach ($products as $prod) {
            HealthProduct::updateOrCreate(
                ['name' => $prod['name']],
                $prod
            );
        }

        // Synthetic Mental Health Resources
        $mentalHealth = [
            [
                'title' => 'Anxiety & Stress Coping Strategies',
                'category' => 'anxiety',
                'summary' => 'Grounding techniques and gentle breathing for moments when everyday stress feels high.',
                'body' => 'Anxiety often presents as rapid breathing, chest tightness, or racing thoughts. Practicing structured nervous system calming allows you to restore emotional equilibrium.',
                'coping_strategies' => [
                    '5-4-3-2-1 Grounding: Notice 5 things you see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste.',
                    'Box Breathing: Breathe in for 4 seconds, hold for 4 seconds, breathe out for 4 seconds, pause for 4 seconds.',
                    'Gentle movement: A 10-minute quiet walk or stretching release.',
                ],
                'emergency_helpline' => 'Nigeria national emergency number: 112',
                'source_citation' => 'WHO Mental Health Guidelines & Asido Foundation Nigeria',
            ],
            [
                'title' => 'Understanding Cyclical Mood Shifts',
                'category' => 'mood',
                'summary' => 'Why emotional changes occur during different cycle phases and how to navigate them.',
                'body' => 'Fluctuations in estrogen and progesterone during the luteal phase naturally affect neurotransmitters like serotonin. Tracking patterns helps you differentiate normal variations from persistent low mood.',
                'coping_strategies' => [
                    'Track mood daily alongside physical symptoms in your YanMata journal.',
                    'Prioritise restful sleep and hydration during the premenstrual week.',
                    'Share your feelings with a trusted friend or accredited care provider.',
                ],
                'emergency_helpline' => 'Nigeria national emergency number: 112',
                'source_citation' => 'ACOG Clinical Guidelines & WHO Adolescent Mental Health Atlas',
            ],
            [
                'title' => 'Postpartum Depression & Emotional Care',
                'category' => 'postpartum',
                'summary' => 'Recognising maternal blues versus clinical depression and finding gentle support.',
                'body' => 'Maternal adjustment brings intense physical and hormonal shifts. While the "baby blues" typically resolve within 14 days, postpartum depression causes sustained fatigue, feelings of inadequacy, or emotional detachment that require compassionate professional care.',
                'coping_strategies' => [
                    'Ask for and accept practical support from family and community.',
                    'Speak without judgment to your midwife or gynaecologist.',
                    'Remember that seeking mental health support is an act of love for yourself and your baby.',
                ],
                'emergency_helpline' => 'Nigeria national emergency number: 112',
                'source_citation' => 'WHO Maternal Mental Health Guidelines',
            ],
        ];

        foreach ($mentalHealth as $mh) {
            MentalHealthResource::updateOrCreate(
                ['title' => $mh['title']],
                $mh
            );
        }

        $samples = [['A little space to understand yourself', 'Body literacy', 'Puberty', 'Your questions belong here. Explore your changing body at your own pace.'], ['Your journal, your own words', 'Periods', 'Adolescence', 'A quiet place to notice patterns, without judging your experience.'], ['You are more than a busy day', 'Emotional wellbeing', 'Adulthood', 'Make room for a moment of reflection in your everyday life.'], ['A new chapter is still your chapter', 'Healthy ageing', 'Menopause', 'Discover a space designed to grow with you, through every transition.'], ['Wellbeing has no age limit', 'Healthy ageing', 'Later life', 'Comfort, dignity and connection belong in every chapter.']];
        foreach ($samples as [$title,$topic,$stage,$summary]) {
            ContentItem::updateOrCreate(['title' => $title], ['topic' => $topic, 'stage' => $stage, 'summary' => $summary, 'body' => 'This is synthetic demonstration content for the YanMata learning experience. It has not been clinically reviewed and is not health advice.

The finished library will include age-appropriate articles, clear source links and named clinical review. You will be able to learn at your own pace and speak with verified specialists within YanMata.

Your personal experience matters. You can explore without sharing a health history.', 'source_url' => 'https://www.who.int/health-topics/adolescent-health', 'status' => 'published', 'is_demo' => true, 'author_id' => $users['author']->id, 'reviewer_id' => $users['reviewer']->id, 'reviewed_at' => now(), 'review_due_at' => now()->addMonths(3), 'published_at' => now()]);
        }
    }
}
