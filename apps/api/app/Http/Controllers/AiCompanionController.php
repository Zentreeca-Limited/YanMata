<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AiCompanionController extends Controller
{
    /**
     * Aisha AI Health Companion - Empathetic, culturally aware educational AI.
     */
    public function chat(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'prompt' => 'required|string|max:1000',
            'language' => 'nullable|string|in:en,ha,yo,ig,pcm',
            'cycle_day' => 'nullable|integer|min:1|max:60',
            'phase' => 'nullable|string|max:50',
            'age_group' => 'nullable|string|max:50',
        ]);

        $prompt = trim($validated['prompt']);
        $lang = $validated['language'] ?? 'en';
        $cycleDay = $validated['cycle_day'] ?? null;
        $phase = $validated['phase'] ?? 'Follicular Phase';

        // Check for acute crisis keywords
        $crisisKeywords = ['suicide', 'kill myself', 'die', 'bleeding heavily', 'fainted', 'unconscious', 'severe hemorrhage', 'soaking pad in 30 minutes', 'self harm'];
        $isEmergency = false;
        foreach ($crisisKeywords as $kw) {
            if (stripos($prompt, $kw) !== false) {
                $isEmergency = true;
                break;
            }
        }

        if ($isEmergency) {
            return response()->json([
                'data' => [
                    'reply' => $this->emergencyReply($lang),
                    'is_emergency' => true,
                    'helplines' => [
                        ['name' => 'Nigeria national emergency number', 'number' => '112', 'cost' => 'Emergency service'],
                    ],
                    'suggested_actions' => [
                        'Seek emergency medical help immediately',
                        'Call a trusted loved one or local healthcare provider',
                    ],
                    'disclaimer' => 'Educational companion. If you are experiencing an acute emergency, please contact 112 or visit the nearest hospital emergency unit immediately.',
                ],
            ]);
        }

        // Generate intelligent contextual response
        $aiResponse = $this->generateEducationalResponse($prompt, $lang, $cycleDay, $phase);

        return response()->json([
            'data' => [
                'reply' => $aiResponse['reply'],
                'is_emergency' => false,
                'citations' => [
                    'WHO menstrual health fact sheet — https://www.who.int/news-room/fact-sheets/detail/menstrual-health',
                    'Nigeria Federal Ministry of Health, Family Health — https://health.gov.ng/family-health/',
                ],
                'follow_up_questions' => $aiResponse['follow_ups'],
                'suggested_actions' => $aiResponse['suggested_actions'],
                'disclaimer' => 'Aisha AI is an educational health companion, not a clinical diagnostic tool. In case of persistent pain or concern, consult a certified healthcare specialist.',
            ],
        ]);
    }

    /**
     * Generate cycle pattern insights based on tracking data.
     */
    public function cycleInsights(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'cycle_length' => 'nullable|integer|min:15|max:60',
            'period_duration' => 'nullable|integer|min:1|max:15',
            'current_day' => 'nullable|integer|min:1|max:60',
            'symptoms' => 'nullable|array',
            'language' => 'nullable|string|in:en,ha,yo,ig,pcm',
        ]);

        $cycleLength = $validated['cycle_length'] ?? 28;
        $periodDuration = $validated['period_duration'] ?? 5;
        $currentDay = $validated['current_day'] ?? 12;
        $symptoms = $validated['symptoms'] ?? [];
        $lang = $validated['language'] ?? 'en';

        // Evaluate phase
        if ($currentDay <= $periodDuration) {
            $currentPhase = 'Menstrual Phase';
            $energyOutlook = 'Gentle rest and warmth. Iron-rich foods and hydration help replenishment.';
        } elseif ($currentDay <= ($cycleLength / 2) - 2) {
            $currentPhase = 'Follicular Phase';
            $energyOutlook = 'Energy and mood can vary from person to person. Notice your own pattern without pressure.';
        } elseif ($currentDay <= ($cycleLength / 2) + 2) {
            $currentPhase = 'Ovulatory Window';
            $energyOutlook = 'This is an estimated mid-cycle window, not a fertility or contraception guarantee.';
        } else {
            $currentPhase = 'Luteal Phase';
            $energyOutlook = 'Some people notice changes before a period; rest, hydration and symptom tracking may help.';
        }

        return response()->json([
            'data' => [
                'regularity' => ($cycleLength >= 21 && $cycleLength <= 35) ? 'Within a common adult range' : 'Pattern varies',
                'phase' => $currentPhase,
                'day_of_cycle' => $currentDay,
                'total_days' => $cycleLength,
                'energy_outlook' => $energyOutlook,
                'next_period_in_days' => max(1, $cycleLength - $currentDay),
                'fertile_window' => [
                    'start_day' => max(1, (int) round(($cycleLength / 2) - 4)),
                    'end_day' => min($cycleLength, (int) round(($cycleLength / 2) + 2)),
                ],
                'tailored_tips' => [
                    'Hydrate with at least 2.5 litres of clean water daily.',
                    'Include locally available leafy vegetables (ugwu, spinach, aleho) for iron support.',
                    'Log symptoms for 3 consecutive cycles to reveal your personal biological baseline.',
                ],
            ],
        ]);
    }

    private function emergencyReply(string $lang): string
    {
        return match ($lang) {
            'ha' => 'Muna tare da ke. Don Allah ki nemi taimakon gaggawa yanzu. Ki kira 112 a Najeriya, ko ki je wurin ba da agajin gaggawa mafi kusa tare da amintaccen mutum.',
            'yo' => 'A wà pẹ̀lú rẹ. Jọ̀wọ́ wá ìrànlọ́wọ́ pàjáwìrì ní kíákíá. Pe 112 ní Nàìjíríà, tàbí lọ sí ibi ìtọ́jú pàjáwìrì tó súnmọ́ ọ pẹ̀lú ẹni tí o gbẹ́kẹ̀ lé.',
            'ig' => 'Anyị nọnyeere gị. Biko chọọ enyemaka mberede ugbu a. Kpọọ 112 na Nigeria, ma ọ bụ gaa n’ebe enyemaka mberede kacha nso gị na onye ị tụkwasịrị obi.',
            'pcm' => 'We dey with you. Abeg find emergency help now. Call 112 for Nigeria, or go the nearest emergency centre with person wey you trust.',
            default => 'You are not alone. Call 112 in Nigeria or go to the nearest emergency department with a trusted person now.',
        };
    }

    private function generateEducationalResponse(string $prompt, string $lang, ?int $cycleDay, string $phase): array
    {
        $p = strtolower($prompt);

        if (str_contains($p, 'cramp') || str_contains($p, 'pain') || str_contains($p, 'ciwon mara') || str_contains($p, 'inu run') || str_contains($p, 'mgbu afo')) {
            $reply = match ($lang) {
                'ha' => "Ciwon marar haila (dysmenorrhea) yana faruwa ne lokacin da mahaifa ke matsewa don fitar da jinin haila. \n\nAbubuwan da ke taimakawa:\n1. Sanya kwanon ruwan dumi a kan mara.\n2. Shan shayi mai dumi kamar na zanjabil (ginger) ko shayin na'a-na'a.\n3. Shan ruwa mai yawa da cin abinci mai sinadarin magnesium kamar kwayoyin gyada da ganye.\n\nIdan ciwon ya yi tsanani sosai har ya hana ki ayyukan yau da kullum, yana da kyau ki ga likita don bincike.",
                'yo' => "Inú rírun nǹkan oṣù máa ń wáyé nítorí pé ilé-ọmọ ń fúnra rẹ̀ láti tú ẹ̀jẹ̀ jáde. \n\nÀwọn nǹkan tó lè ràn ọ́ lọ́wọ́:\n1. Fi nǹkan tó lọ́wọ́rọ́ bíi omi gbígbóná sínú roba sí orí ìkùn rẹ.\n2. Mu tíì jinja tàbí omi tó lọ́wọ́rọ́ dáadáa.\n3. Jẹ oúnjẹ tó ní ewébẹ̀ púpọ̀ àti àwọn nǹkan bí ẹ̀pà.\n\nTí inú rírun náà bá pọ̀ ju bó ṣe yẹ lọ tí kò jẹ́ kí o ṣe nǹkan kan, kàn sí dọ́kítà fún àyẹ̀wò tó péye.",
                'ig' => "Mgbu afọ nsọ na-eme n'ihi na akpa nwa na-akpakọba onwe ya iji wepụ ọbara nsọ. \n\nIhe ga-enyere gị aka:\n1. Debe mmiri ọkụ na karama n'elu afọ gị.\n2. Ṅụọ tii jinja ma ọ bụ mmiri ọkụ nke ọma.\n3. Rie akwụkwọ nri na nri nwere ezigbo vitamin.\n\nỌ bụrụ na mgbu ahụ dị oke njọ nke na ị pụghị ime ihe ọ bụla, biko hụ dọkịta maka nyocha.",
                'pcm' => "Period cramp dey happen because the uterus dey squeeze to push out the period blood. \n\nWetin go help you:\n1. Press warm water bottle or hot towel on top your lower belly.\n2. Drink warm ginger tea or plenty clean warm water.\n3. Eat beta green vegetables (like ugwu, spinach) and avoid too much sugar.\n\nIf the pain too strong wey no let you stand up or work, abeg visit clinic or talk to YanMata specialist make dem check am.",
                default => "Menstrual cramps (dysmenorrhea) are caused by uterine contractions triggered by prostaglandins as the uterine lining sheds.\n\nEvidence-based comfort strategies:\n1. Apply gentle heat (a warm hot water bottle or heating pad on the lower abdomen increases blood flow).\n2. Sip warm ginger, chamomile, or peppermint tea which contain anti-inflammatory compounds.\n3. Prioritize hydration and foods rich in magnesium and omega-3 fatty acids (leafy greens, seeds, nuts).\n\nIf cramps are severe enough to disrupt daily school or work, or do not respond to simple remedies, consider an in-platform evaluation with a gynecologist.",
            };

            return [
                'reply' => $reply,
                'follow_ups' => [
                    'How can I tell if my cramps are normal or related to fibroids?',
                    'What foods help soothe period inflammation?',
                ],
                'suggested_actions' => [
                    'Log cramp severity in your daily check-in',
                    'Apply a warm compress and rest for 20 minutes',
                ],
            ];
        }

        if (str_contains($p, 'follicular') || str_contains($p, 'phase') || str_contains($p, 'cycle') || str_contains($p, 'haila') || str_contains($p, 'nso')) {
            $reply = match ($lang) {
                'ha' => 'Lokacin Follicular yana farawa ne daga ranar farko ta haila har zuwa lokacin fitar kwayar haihuwa (ovulation). A wannan lokacin, kwayoyin halittar estrogen suna karuwa, wanda ke sa mace ta ji karfin jiki, karsashi, da natsuwa a zuciya. Wannan lokaci ne mai kyau don koyon sabbin abubuwa da yin aiki mai karfi.',
                'yo' => 'Àkókò Follicular máa ń bẹ̀rẹ̀ láti ọjọ́ àkọ́kọ́ tí nǹkan oṣù bá ti bẹ̀rẹ̀ títí dé àkókò tí ẹyin yóò fi gbó. Ní àkókò yìí, homonu estrogen máa ń pọ̀ sí i nínú ara, èyí tó máa ń fún ọ ní agbára, ayọ̀ àti ìmọ́lẹ̀ ọpọlọ.',
                'ig' => "Oge Follicular na-amalite site n'ụbọchị mbụ nke nsọ ruo mgbe akwa na-agbawa. N'oge a, estrogen na-abawanye n'ahụ, nke na-enye gị ike, obi ụtọ na mmụọ dị ọcha iji rụọ ọrụ.",
                'pcm' => 'Follicular phase dey start from the first day your period show face reach when ovulation happen. As your estrogen level dey climb up, your body go get sharp energy, your face go dey glow, and your brain go sharp well well for work and study.',
                default => 'The Follicular Phase begins on the first day of menstruation and lasts until ovulation (typically Days 1–13 of a 28-day cycle). As follicle-stimulating hormone (FSH) prompts the ovaries to mature eggs, estrogen levels steadily climb, boosting energy, cognitive stamina, and mood.',
            };

            return [
                'reply' => $reply,
                'follow_ups' => [
                    'When does my fertile window occur?',
                    'What vitamins support hormone balance during this phase?',
                ],
                'suggested_actions' => [
                    'Track your energy rating today in Track tab',
                    'Plan demanding cognitive or physical tasks during this phase',
                ],
            ];
        }

        // Default supportive and informative response
        $reply = match ($lang) {
            'ha' => 'Ina jin dadin tambayarki. Jikin mace yana da tsari mai ban mamaki wanda ke canzawa a kowane mako na wata. Ki gaya mini karin bayani game da yadda kike ji a yau ko abin da kike son fahimta, kuma zan taimaka miki da shawarwari masu aminci.',
            'yo' => 'Ẹ ṣeun fún ìbéèrè rẹ. Ara obìnrin ní àgbàyanu ètò tí ó ń yípadà ní ọ̀sọ̀ọ̀sẹ̀. Sọ fún mi nípa bí ara rẹ ṣe ń ṣe ọ́ lónìí kí n lè fún ọ ní ìmọ̀ràn tó dára jùlọ.',
            'ig' => 'Daalụ maka ajụjụ gị. Ahụ nwanyị nwere usoro dị ịtụnanya na-agbanwe kwa izu. Gwa mkwu banyere otu obi dị gị taa ka m wee nye gị ezigbo ndụmọdụ ahụike.',
            'pcm' => 'Thank you for asking this question. Woman body get special rhythm wey dey change week by week. Tell me small more tori about wetin you dey experience today so I fit give you correct advice.',
            default => "Thank you for sharing your question. Women's physiological and emotional wellbeing follows a rhythmic pattern shaped by hormonal transitions across each cycle and life stage. Tell me a bit more about what symptoms or questions you'd like to explore today.",
        };

        return [
            'reply' => $reply,
            'follow_ups' => [
                'How do I calculate my cycle length accurately?',
                'What are early signs of hormonal imbalance?',
            ],
            'suggested_actions' => [
                'Check in with your daily mood and symptoms',
                'Explore verified health articles in Learn tab',
            ],
        ];
    }
}
