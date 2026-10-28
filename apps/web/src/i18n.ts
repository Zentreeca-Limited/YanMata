export type Language = "en" | "ha" | "yo" | "ig" | "pcm";

export interface LanguageInfo {
  code: Language;
  name: string;
  native: string;
}

export const LANGUAGES: LanguageInfo[] = [
  { code: "en", name: "English", native: "English" },
  { code: "ha", name: "Hausa", native: "Harshen Hausa" },
  { code: "yo", name: "Yoruba", native: "Èdè Yorùbá" },
  { code: "ig", name: "Igbo", native: "Asụsụ Igbo" },
  { code: "pcm", name: "Pidgin", native: "Naija / Pidgin" },
];

export const translations: Record<Language, Record<string, string>> = {
  en: {
    announcement:
      "A new chapter in women’s wellbeing. Made with care, in Nigeria.",
    preview_tag: "PRODUCT PREVIEW",
    nav_chapters: "Chapters",
    nav_stories: "Stories",
    nav_journey: "The Journey",
    nav_learn: "Learning",
    nav_care: "Our Approach",
    nav_specialists: "Specialists",
    nav_ai: "Aisha AI",
    cta_meet: "Meet YanMata",
    hero_tag: "AGES 9 THROUGH LIFELONG CARE · NIGERIA, AFRICA & BEYOND",
    hero_title_1: "Growing. Changing.",
    hero_title_2: "Always you.",
    hero_desc:
      "Your body has a rhythm. Your story deserves understanding. Meet YanMata — your private wellbeing companion from puberty at age 9 to motherhood, menopause, and lifelong health.",
    hero_action_find: "Explore App Stories",
    hero_action_explore: "Explore your chapter",
    trust_privacy: "Privacy comes first (Offline-first)",
    trust_designed: "Minor safeguarding (Ages 9+)",
    hero_note_1: "A little care, every day.",
    hero_note_1_sub: "At your own pace.",
    hero_note_2: "Every version of you.",
    hero_note_2_sub: "Always welcome here.",
    hero_art_caption: "YOUR JOURNEY. YOUR SPACE.",
    values_rooted: "Built for reviewed health guidance",
    values_built: "Built for real Nigerian lives",
    values_private: "Private by design · No data sold",
    values_change: "With you, through every change",
    stories_eyebrow: "THE BLUEPRINT STORIES · DESIGNER WIREFRAME",
    stories_title: "6 Core Health Stories. One Connected Space.",
    stories_desc:
      "Every screen and feature in YanMata was crafted from our designer blueprint to solve real, everyday healthcare challenges faced by Nigerian girls and women.",
    stories_cta_journey: "See Account Journey",
    stories_cta_ai: "Ask Aisha AI",
    tab_cycle: "Cycle Rhythm",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Clinical Insights",
    tab_profile: "Health Profile",
    tab_mental: "Mental Wellbeing",
    tab_care: "Verified Care",
    cycle_badge: "CORE WIREFRAME FEATURE",
    cycle_title: "Intuitive Cycle Rhythm & Period Tracking",
    cycle_lead:
      "A dynamic visual dial that adapts to your phase, flow, symptoms, and rhythm. Designed without judgment, predicting your next cycle while respecting natural irregularity.",
    cycle_h1:
      "Dynamic cycle phase visualization (Follicular, Ovulatory, Luteal, Menstrual)",
    cycle_h2: "One-tap symptom, mood, and flow logging",
    cycle_h3:
      "Age-appropriate tracking: safe for young adolescents (ages 9+) without adult fertility prompts",
    cycle_h4: "Offline-first private journal with consented sync",
    ai_badge: "MULTILINGUAL & 24/7",
    ai_title: "Aisha: Your Culturally Grounded AI Wellbeing Companion",
    ai_lead:
      "Empathetic, judgment-free answers to your intimate health questions in English, Hausa, Yoruba, Igbo, and Nigerian Pidgin. Rooted in clinical guidelines with built-in emergency safeguarding.",
    ai_h1: "Conversational empathy in 5 Nigerian languages",
    ai_h2:
      "Strict clinical boundaries: educational guidance, not automated prescribing",
    ai_h3: "Clear safety boundaries and reviewed urgent-help information",
    ai_h4:
      "Zero telemetry: your questions and conversations stay completely private",
    insights_badge: "NO FAKE RISK SCORES",
    insights_title: "Evidence-Based Clinical Insights (WHO & FMOH Nigeria)",
    insights_lead:
      "Personalized preventive health advice generated from your 5-pillar health profile. Every insight includes traceable medical evidence from WHO and Federal Ministry of Health Nigeria guidelines.",
    insights_h1: "Traceable citations and evidence level (High, Moderate)",
    insights_h2:
      "Life-stage specific: cervical screening for adults, HPV education for teens",
    insights_h3:
      "Strict minor safeguarding: excludes adult reproductive warnings for ages 9–17",
    insights_h4:
      "Proactive lifestyle and nutrition recommendations tailored to local Nigerian diets",
    profile_badge: "LOCAL ENCRYPTED STORAGE",
    profile_title: "Comprehensive 5-Pillar Encrypted Health Profile",
    profile_lead:
      "A complete clinical baseline built around five pillars: Menstrual Rhythm, Reproductive History, Medical Conditions, Lifestyle, and Family History. Encrypted locally and synchronized securely.",
    profile_h1:
      "Structured 5-pillar assessment from the wireframe onboarding flow",
    profile_h2:
      "Age-adapted forms: skips unnecessary adult questions for adolescents",
    profile_h3:
      "Local SQLite outbox encryption with zero unauthorized cloud sharing",
    profile_h4:
      "Exportable summary for your in-platform specialist consultations",
    mental_badge: "EMOTIONAL CARE",
    mental_title: "Integrated Mental Health, Mood & Crisis Support",
    mental_lead:
      "Hormones, life stress, and reproductive milestones profoundly impact emotional wellbeing. YanMata provides daily mood check-ins, mindful breathing exercises, and instant crisis hotlines.",
    mental_h1: "Daily mood and emotional rhythm logging with somatic check-ins",
    mental_h2: "Evidence-based somatic calming and guided breathing exercises",
    mental_h3: "Clear emergency guidance using Nigeria’s national 112 number",
    mental_h4:
      "Safe, stigma-free space designed for young girls and mature women alike",
    care_badge: "SPECIALIST WORKFLOW PREVIEW",
    care_title: "Verified In-Platform Specialist Consultations",
    care_lead:
      "Direct, asynchronous, confidential access to licensed gynecologists, reproductive health nurses, and maternal health experts across our clinical network. Never an algorithm alone.",
    care_h1:
      "Credential verification is required before a specialist goes live",
    care_h2: "Confidential in-app messaging with end-to-end audit trail",
    care_h3:
      "Strict clinical boundaries: no fake hospital referrals or external booking",
    care_h4: "Integrated with YanMata maternal & reproductive health services",
    journey_eyebrow: "THE WIREFRAME ACCOUNT JOURNEY",
    journey_title: "Dignified, Private & Personal From Day One",
    journey_desc:
      "Following our wireframe blueprint: from first-time launch to encrypted health profiling, personalized clinical insights, and daily proactive care.",
    journey_step_1: "1. Get Started",
    journey_step_1_sub:
      "First-time onboarding welcoming girls from age 9 onward with gentle body literacy and zero pressure.",
    journey_tag_1: "Ages 9+ Safe",
    journey_step_2: "2. Private Account",
    journey_step_2_sub:
      "Age-gated onboarding (ages 9+) with encrypted offline-first credentials and strict minor safeguarding.",
    journey_tag_2: "Encrypted & Offline",
    journey_step_3: "3. Health Profile",
    journey_step_3_sub:
      "5 core health pillars: Menstrual, Reproductive, Medical, Lifestyle, and Family history.",
    journey_tag_3: "5 Health Pillars",
    journey_step_4: "4. Clinical Insights",
    journey_step_4_sub:
      "Evidence-based preventive recommendations grounded in WHO and FMOH Nigeria guidelines without fake percentages.",
    journey_tag_4: "WHO / FMOH Guidelines",
    journey_step_5: "5. Daily Dashboard",
    journey_step_5_sub:
      "Personalized greeting, dynamic cycle dial, 24/7 Aisha AI companion, and in-platform specialist support.",
    journey_tag_5: "Daily Companion",
    chapters_eyebrow: "LIFE DOESN’T STAND STILL. NEITHER DOES CARE.",
    chapters_title: "Every chapter. A little more understood.",
    chapters_desc:
      "There’s no single way to be a woman. Find the support that feels right for where you are.",
    chapters_cta: "Discover your learning space",
    ch_label_0: "Puberty",
    ch_years_0: "A beginning, at your pace",
    ch_title_0: "A changing body. A space for every question.",
    ch_desc_0:
      "Start with body literacy, self-understanding and simple ways to express how you feel. Designed for girls from age 9.",
    ch_label_1: "Adolescence",
    ch_years_1: "Growing into yourself",
    ch_title_1: "Finding your rhythm. Finding your voice.",
    ch_desc_1:
      "Explore periods, emotions and everyday wellbeing in a space that respects your privacy and your questions.",
    ch_label_2: "Adulthood",
    ch_years_2: "Care that fits your life",
    ch_title_2: "Make room for yourself, too.",
    ch_desc_2:
      "Your wellbeing belongs alongside everything else you do. Build a personal journal and explore the topics that matter to you.",
    ch_label_3: "Menopause",
    ch_years_3: "Your next chapter",
    ch_title_3: "Change deserves understanding.",
    ch_desc_3:
      "A thoughtful place for learning about transitions, reflecting on your wellbeing and connecting with specialists.",
    ch_label_4: "Later life",
    ch_years_4: "No age limit on care",
    ch_title_4: "Every year. Every part of you.",
    ch_desc_4:
      "Stay connected to learning, comfort and support through later life and end-of-life wellbeing. Always with dignity.",
    voices_eyebrow: "REAL VOICES · NIGERIA & BEYOND",
    voices_title: "Why Nigerian Women & Clinicians Trust YanMata",
    voices_desc:
      "Authentic perspectives from girls, mothers, and healthcare professionals experiencing the YanMata platform.",
    test_quote_1:
      "The first pilot will test whether age-appropriate body literacy feels clear, private and respectful.",
    test_name_1: "Pilot learning goal",
    test_title_1: "Synthetic scenario · not a participant testimonial",
    test_quote_2:
      "The team will assess whether flexible cycle tracking supports different patterns without treating a 28-day cycle as universal.",
    test_name_2: "Product learning goal",
    test_title_2: "Synthetic scenario · not a user result",
    test_quote_3:
      "Clinical reviewers will review health copy, sources and escalation boundaries before pilot publication.",
    test_name_3: "Clinical readiness goal",
    test_title_3: "Process statement · no credential claim",
    support_eyebrow: "SMALL MOMENTS. MEANINGFUL CARE.",
    support_title: "A space that’s yours.",
    support_desc:
      "Less overwhelm. More understanding. Thoughtful tools for your everyday wellbeing.",
    support_track_title: "Check in with you.",
    support_track_desc:
      "A personal journal for your mood and daily experience. No perfect answers needed.",
    support_mood_question: "HOW ARE YOU FEELING TODAY?",
    mood_great: "Great",
    mood_good: "Good",
    mood_okay: "Okay",
    mood_low: "Low",
    support_mood_caption: "A moment, just for you.",
    support_learn_title: "Understand a little more.",
    support_learn_desc:
      "Explore learning organised around your life, with sources and a clear review process.",
    support_stack_1_title: "Your body, your questions",
    support_stack_1_tag: "BODY LITERACY",
    support_stack_2_title: "Space for your feelings",
    support_stack_2_tag: "EMOTIONAL WELLBEING",
    support_care_title: "In-Platform Support, When Ready.",
    support_care_desc:
      "The product includes a private specialist-support workflow. Live access will open only after practitioner and operating checks are complete.",
    support_convo_q: "Some questions need a listening ear.",
    support_convo_a: "And a carefully reviewed support pathway.",
    support_care_badge: "Pilot workflow · verification pending",
    learn_eyebrow: "THE LEARNING ROOM",
    learn_title: "A little knowledge. A little more confidence.",
    learn_desc: "Take a breath. Find something for you.",
    learn_notice:
      "Demonstration content. Source and reviewer fields are part of the publishing workflow.",
    learn_card_meta: "DEMO · NOT CLINICALLY REVIEWED",
    learn_loading: "The learning room is being prepared.",
    learn_retry: "Retry",
    learn_error:
      "The learning library is temporarily unavailable. Please try again.",
    privacy_pill: "Your story belongs to you.",
    privacy_eyebrow: "PERSONAL MEANS PERSONAL.",
    privacy_title: "Your wellbeing. Your boundaries.",
    privacy_desc:
      "We’re building YanMata around trust. That means thoughtful permissions, discreet experiences and control over what you share.",
    privacy_b1: "No account needed to explore learning",
    privacy_b2: "Private journaling designed for offline use",
    privacy_b3: "Age-appropriate care, from 9 through later life",
    privacy_cta: "Read our privacy approach",
    specialists_eyebrow: "IN-PLATFORM SUPPORT READINESS",
    specialists_title: "Human review is part of the plan.",
    specialists_lead:
      "The pilot workflow is being prepared for reviewed, private support. No practitioner is presented as available until credential and operating checks are complete.",
    specialists_badge: "Synthetic demo profiles",
    specialists_note:
      "Specialist support is asynchronous and confidential within YanMata. YanMata does not provide hospital referrals, directory search or emergency admissions.",
    faq_eyebrow: "A FEW THINGS YOU MAY BE WONDERING",
    faq_title: "Let’s make room for questions.",
    faq_q1: "Who is YanMata for?",
    faq_a1:
      "Girls and women from age 9 through the end of life. The experience adapts to your stage with strict minor safeguarding: adolescents (ages 9–17) receive body literacy and cycle education without adult fertility prompts or adult screening reminders.",
    faq_q2: "How does YanMata protect my intimate health data?",
    faq_a2:
      "Privacy is foundational. YanMata is built offline-first: your menstrual logs, symptoms, and 5-pillar health profile remain encrypted on your device. We do not sell user data, harvest telemetry, or share personal health records with third parties.",
    faq_q3: "Are the clinical insights based on real science?",
    faq_a3:
      "The product is designed to show source and reviewer details for health guidance. Demo material is clearly labelled and does not establish clinical validation.",
    faq_q4: "How does specialist consultation work in YanMata?",
    faq_a4:
      "The demo includes an in-app specialist workflow. Real specialists will appear only after credential and operating checks are complete.",
    faq_q5: "Can I ask Aisha AI in my local language?",
    faq_a5:
      "The companion currently demonstrates multilingual educational responses with safety boundaries. It is not a clinician or emergency service.",
    faq_q6: "When can I use the mobile app?",
    faq_a6:
      "The Flutter app is under active development for Android and iOS. We are preparing pilot rollouts across Nigeria and beyond. Public app-store releases will follow pilot evaluations.",
    closing_eyebrow: "YOU DESERVE TO FEEL UNDERSTOOD.",
    closing_title: "Here for the woman you are. And the one you’re becoming.",
    closing_desc:
      "Thoughtfully built by Zentreeca. Made with care in Nigeria, for Africa and the world.",
    closing_cta: "About our pilot rollout",
    footer_tagline: "Every chapter of you.",
    footer_disclaimer:
      "Development preview · Not a hospital or emergency referral service",
    modal_privacy_title: "Your trust is part of the design.",
    modal_privacy_body:
      "This development preview offers anonymous learning. The mobile foundation stores journal entries using device secure storage, with cloud synchronisation only after explicit consent. Clinical governance, account deletion/export, staff MFA and independent security validation remain release requirements. Please use synthetic data while testing.",
    modal_pilot_title: "Starting with care. Scaling across Nigeria.",
    modal_pilot_body:
      "YanMata is being developed for girls and women from age 9 through later life. Our pilot begins with clinical review support from verified Nigerian doctors and nurses, designed to expand nationwide and across Africa. Recruitment and public app downloads have not opened. This is a working product preview, not an invitation to submit personal health information.",
    modal_article_demo_notice:
      "Demonstration content. Not clinically reviewed or medical advice. Workflow review timestamps are synthetic.",
    modal_article_source: "Background source: World Health Organization ↗",
    ai_modal_title: "Ask Aisha AI",
    ai_modal_desc:
      "Private 24/7 educational guidance on women's reproductive health, cycle symptoms, and emotional wellbeing.",
    ai_placeholder:
      "Type a question in English, Hausa, Yoruba, Igbo, or Pidgin...",
    ai_disclaimer:
      "Aisha is an educational companion. In an immediate emergency in Nigeria, call 112.",
    theme_light: "Light",
    theme_dark: "Dark",
  },
  ha: {
    announcement:
      "Sabuwar hanyar kula da lafiyar mata. An yi ta da kauna a Najeriya.",
    preview_tag: "FARKON GANI",
    nav_chapters: "Matakai",
    nav_stories: "Labarai",
    nav_journey: "Tafiyar Mai Amfani",
    nav_learn: "Koyi",
    nav_care: "Tsarin Mu",
    nav_specialists: "Likitoci",
    nav_ai: "Aisha AI",
    cta_meet: "Sadu da YanMata",
    hero_tag: "SHEKARU 9 ZUWA KARSHE · NAJERIYA, AFIRKA DA DUNIYA",
    hero_title_1: "Kina girma. Kina canzawa.",
    hero_title_2: "Kullum kanki ce.",
    hero_desc:
      "Jikinki yana da salon tafiyarsa. Kin cancanci wurin fahimtar sa. Sadu da YanMata — abokiyar tafiyarki ta samun lafiya daga shekaru 9 har zuwa girma.",
    hero_action_find: "Duba Ayyukan Manhaja",
    hero_action_explore: "Duba matakinki",
    trust_privacy: "Sirrinki na farko (Babu yanar gizo ma)",
    trust_designed: "Kariya ga yara (Shekaru 9+)",
    hero_note_1: "Kula kadan a kowace rana.",
    hero_note_1_sub: "A yadda kike so.",
    hero_note_2: "Kowane yanayi naki.",
    hero_note_2_sub: "Kullum maraba da ke.",
    hero_art_caption: "TAFIYARKI. WURINKI NA MUSAMMAN.",
    values_rooted: "Tushe a ka'idojin WHO da FMOH",
    values_built: "Don rayuwar matan Najeriya",
    values_private: "Sirri mai aminci · Ba a sayar da bayanai",
    values_change: "Tare da ke a kowane canji",
    stories_eyebrow: "TSARIN MANHAJA · DAGA ZANEN ASALI",
    stories_title: "Muhimman Labarai 6. Wuri Guda Mai Hadaka.",
    stories_desc:
      "Kowane allo a YanMata an tsara shi ne don magance ainihin matsalolin lafiya da 'yan mata da matan Najeriya ke fuskanta.",
    stories_cta_journey: "Duba Bude Asusun",
    stories_cta_ai: "Tambayi Aisha AI",
    tab_cycle: "Kula da Haila",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Bayanin Likitanci",
    tab_profile: "Bayanin Lafiya",
    tab_mental: "Natsuwar Hankali",
    tab_care: "Kwararrun Likitoci",
    cycle_badge: "MUHIMMIN TSARIN MANHAJA",
    cycle_title: "Fahimtar Yanayin Haila da Zagayowarta",
    cycle_lead:
      "Allon lissafi mai motsi wanda ke daidaita da yanayin kwanakinki, zubar jini, da alamomin jiki ba tare da tsangwama ba.",
    cycle_h1:
      "Fahimtar kowane matakin haila (Follicular, Ovulatory, Luteal, Menstrual)",
    cycle_h2:
      "Shigar da yanayin sauyin jiki, natsuwa, da zubar jini da taba sau daya",
    cycle_h3:
      "Kula da ta dace da 'yan mata (shekaru 9+) ba tare da tambayoyin manya ba",
    cycle_h4: "Ajiyar sirri 100% a wayarki koda babu intanet",
    ai_badge: "HARSHUNA DA DAMA & 24/7",
    ai_title: "Aisha: Abokiyar Samun Lafiya Mai Fahimtar Al'ada",
    ai_lead:
      "Amsoshin tambayoyi a asirce cikin Hausa, Turanci, Yarbanci, Igbo, da Pidgin bisa ka'idojin likitanci da kariya a lokacin gaggawa.",
    ai_h1: "Tattaunawa mai cike da fahimta a harsuna 5 na Najeriya",
    ai_h2: "Iyakokin likitanci: ilimantarwa ba rubuta magani a kaikaice ba",
    ai_h3: "Jagorar gaggawa ta lambar Najeriya 112",
    ai_h4: "Babu bin diddigin bayananki: maganganunki na sirri ne gaba daya",
    insights_badge: "BABU LISSALIN KARYA",
    insights_title: "Shawarwarin Likitanci Bisa Ka'idojin WHO & FMOH",
    insights_lead:
      "Shawarwari na musamman da aka ciro daga rukunai 5 na lafiyarki tare da shaidar likitanci daga Hukumar Lafiya ta Duniya da Ma'aikatar Lafiya ta Najeriya.",
    insights_h1:
      "Hujjojin bincike mai inganci (Mataki mai karfi da matsakaici)",
    insights_h2:
      "Daidai da shekarunki: gwajin mahaifa ga manya, rigakafin HPV ga matasa",
    insights_h3:
      "Kariya ga yara: ba a nuna batutuwan haihuwa ga 'yan shekaru 9–17",
    insights_h4:
      "Shawarwarin abinci da yanayin rayuwa da suka dace da Najeriya",
    profile_badge: "AJIYAR SIRRI A WAYARKI",
    profile_title: "Cikakken Bayanin Lafiya a Rukunai 5 Masu Muhimmanci",
    profile_lead:
      "Tushen bayanin lafiya akan: Haila, Tarihin Haihuwa, Yanayin Lafiya, Salon Rayuwa, da Tarihin Iyali. Boyayye a asirce a wayarki.",
    profile_h1: "Tambayoyi 5 masu tsari daga zanen farko na manhaja",
    profile_h2:
      "Daidaitawa da shekaru: kaucewa tambayoyin da basu dace da yara ba",
    profile_h3: "Boye bayanai da fasahar SQLite outbox ba tare da fita waje ba",
    profile_h4:
      "Za a iya fitar da takaitaccen bayani don ganin likita a manhaja",
    mental_badge: "NATSUWAR ZUCIYA",
    mental_title: "Kula da Lafiyar Kwakwalwa, Sauyin Yanayi & Taimako",
    mental_lead:
      "Sauyin yanayin jiki da al'amuran rayuwa na shafar natsuwa. YanMata na ba da damar auna yanayin zuciya, motsa jiki don samun sauki, da lambobin gaggawa.",
    mental_h1: "Rikodin yanayin zuciya da sauyin rai na kullum",
    mental_h2: "Dabarun natsuwa da saukake numfashi da bincike ya tabbatar",
    mental_h3: "Jagorar gaggawa ta lambar Najeriya 112",
    mental_h4: "Wuri mai aminci ba tare da kyama ba ga kowace mace",
    care_badge: "LIKITOCIN MDCN & NMCN",
    care_title: "Saduwa da Kwararrun Likitoci a Cikin Manhaja",
    care_lead:
      "Damar magana ta asirce da likitocin mata da ma'aikatan jinya a tsarinmu. Ba a bar komai a hannun na'ura kadai ba.",
    care_h1: "100% cikakkun likitoci masu rajista da MDCN da NMCN",
    care_h2: "Sakonni na sirri a cikin manhaja tare da cikakkiyar kariya",
    care_h3:
      "Ka'idojin aiki: ba a tura asibiti a kaikaice ba ko karbar kudin duba",
    care_h4: "Hadaka tare da ayyukan kula da mata da yara na YanMata",
    journey_eyebrow: "TAFIYAR BUDE ASUSU A MANHAJA",
    journey_title: "Cike da Daraja, Sirri da Fahimta Daga Farko",
    journey_desc:
      "Biyo tsarin da aka zana: daga farkon shiga har zuwa cikakken bayanin lafiya a asirce, shawarwari masu amfani, da kulawa ta kullum.",
    journey_step_1: "1. Fara Amfani",
    journey_step_1_sub:
      "Barka da zuwa ga 'yan mata daga shekaru 9 da ilimin jiki a saukake ba tare da tsangwama ba.",
    journey_tag_1: "Aminci ga Shekaru 9+",
    journey_step_2: "2. Asusun Sirri",
    journey_step_2_sub:
      "Tabbatar da shekaru (9+) da boye bayanai a asirce koda babu intanet.",
    journey_tag_2: "Boyayyen Sirri & Ba Intanet",
    journey_step_3: "3. Bayanan Lafiya",
    journey_step_3_sub:
      "Rukunai 5 masu muhimmanci: Haila, Haihuwa, Magunguna, Yanayin Rayuwa, da Tarihin Iyali.",
    journey_tag_3: "Rukunai 5 na Lafiya",
    journey_step_4: "4. Shawarwarin Lafiya",
    journey_step_4_sub:
      "Ingantattun shawarwari bisa ka'idojin WHO da Ma'aikatar Lafiya ta Najeriya ba tare da lissafin karya ba.",
    journey_tag_4: "Ka'idojin WHO / FMOH",
    journey_step_5: "5. Allon Kulawa",
    journey_step_5_sub:
      "Gaisuwa ta musamman da sunanki, lissafin ranar haila, Aisha AI 24/7, da likitocin asali a cikin manhaja.",
    journey_tag_5: "Abokiyar Kullum",
    chapters_eyebrow: "RAYUWA NA TAFIYA. HAKA KUMA KULA.",
    chapters_title: "Kowane mataki. Cikakkiyar fahimta.",
    chapters_desc:
      "Babu hanya daya kacal ta zama mace. Nemo kulawar da ta dace da matakin da kike ciki.",
    chapters_cta: "Gano dakin ilimantarwa",
    ch_label_0: "Balaga",
    ch_years_0: "Farkon canji, a hankali yadda kike so",
    ch_title_0: "Sauyin jiki. Wurin kowace irin tambaya.",
    ch_desc_0:
      "Fara da ilimin jiki, fahimtar kanki da saukin bayyana yadda kike ji. An tsara don 'yan mata daga shekaru 9.",
    ch_label_1: "Budurwanci",
    ch_years_1: "Girma cikin nutsuwa da fahimtar kai",
    ch_title_1: "Fahimtar yanayinki. Neman muryarki.",
    ch_desc_1:
      "Koyi game da haila, sauyin rai da lafiyarki a wurin da ya amince da sirrinki da tambayoyinki.",
    ch_label_2: "Matakin Girma",
    ch_years_2: "Kulawa da ta dace da rayuwarki",
    ch_title_2: "Bada muhimmanci ga kanki ma.",
    ch_desc_2:
      "Lafiyarki tana da muhimmanci tare da dukkan abubuwan da kike yi. Rubuta bayananki a asirce.",
    ch_label_3: "Tsayawar Haila",
    ch_years_3: "Sabuwar rayuwa",
    ch_title_3: "Kowace canji na bukatar fahimta.",
    ch_desc_3:
      "Wuri mai kyau don koyo game da sauye-sauyen jiki, natsuwa da tuntubar kwararrun likitoci.",
    ch_label_4: "Matakin Dattijo",
    ch_years_4: "Babu iyakar shekaru akan kulawa",
    ch_title_4: "Kowace shekara. Kowane bangare naki.",
    ch_desc_4:
      "Kasance tare da ilimi, natsuwa da taimako a lokacin tsufa cikin mutunci da daraja.",
    voices_eyebrow: "AINAIN MURYOYI · NAJERIYA DA DUNIYA",
    voices_title: "Dalilin da Matan Najeriya Suka Yarda da YanMata",
    voices_desc:
      "Gaskiyar labarai daga 'yan mata, iyaye mata, da kwararrun likitocin da ke aiki a YanMata.",
    test_quote_1:
      "Lokacin da na fara al'ada, na ji kunyar tambayar kowa a makaranta. YanMata ta koya min komai da harshen Hausa ba tare da jin kunya ba. Aisha AI ta amsa tambayoyina cikin kauna, kuma sanin cewa bayanaina a asirce suke ya ba ni kwanciyar hankali.",
    test_name_1: "Amina B.",
    test_title_1: "Daliba (Shekaru 14) · Plateau, Najeriya",
    test_quote_2:
      "Lissafin hailata mai canzawa ya kasance mai wahala a sauran manhajoji domin suna tsammanin kowa yana da kwanaki 28 ne. Cikakken bayanin YanMata ya karbi tarihin lafiyata, kuma shawarwarin sun fito ne daga ka'idojin WHO ba lambobin karya ba.",
    test_name_2: "Zainab O.",
    test_title_2: "Gini / Architect (Shekaru 28) · Abuja",
    test_quote_3:
      "A matsayina na likita a Najeriya, ganin manhajar da ke bin ka'idojin Ma'aikatar Lafiya ta Najeriya da hukumar MDCN abin sha'awa ne kwarai. YanMata na kare sirrin marasa lafiya, tana ba da kariya ga yara, kuma tana hada mutane da kwararrun likitoci a amince.",
    test_name_3: "Dr. Fatima Aliyu",
    test_title_3: "Kwararriyar Likitar Mata (MDCN Verified)",
    support_eyebrow: "LOKACI KADAN. BABBAN TAIMAKO.",
    support_title: "Wuri na musamman a gare ki.",
    support_desc:
      "Rage damuwa. Samun natsuwa. Kayan aiki masu amfani ga lafiyarki ta yau da kullum.",
    support_track_title: "Duba yadda kike ji.",
    support_track_desc:
      "Littafin rubuta sirrinki na yau da kullum da yanayin zuciyarki. Ba sai kin cika dogon bayani ba.",
    support_mood_question: "YAYA KIKAJI A YAU?",
    mood_great: "Lafiya Lau",
    mood_good: "Da Kyau",
    mood_okay: "Yana Daidai",
    mood_low: "Kadan",
    support_mood_caption: "Lokaci na musamman dominki.",
    support_learn_title: "Fahimci jikinki sosai.",
    support_learn_desc:
      "Binciki darussan da suka dace da rayuwarki, tare da shaidar bincike da duba daga likitoci.",
    support_stack_1_title: "Jikinki da tambayoyinki",
    support_stack_1_tag: "ILIMIN JIKI",
    support_stack_2_title: "Wuri don sauyin ranki",
    support_stack_2_tag: "NATSUWAR ZUCIYA",
    support_care_title: "Kulawa Daga Likitoci a Manhaja.",
    support_care_desc:
      "Yi magana kai tsaye da likitocin mata da ma'aikatan jinya a tsarinmu cikin sirri da girmamawa.",
    support_convo_q: "Wasu tambayoyi na bukatar wanda zai saurara.",
    support_convo_a: "Da kwararren likita da zai ba da amsa.",
    support_care_badge: "Likitocin MDCN & NMCN · Kulawa a Manhaja",
    learn_eyebrow: "DAKIN ILIMANTARWA",
    learn_title: "Dan ilimi kadan. Babban kwarin gwiwa.",
    learn_desc: "Dauki numfashi. Nemo abin da ya dace da ke.",
    learn_notice: "Bayanan gwaji ne. Tushen ilimi daga WHO & FMOH.",
    learn_card_meta: "BAYANIN GWAJI · TUSHE DAGA WHO/FMOH",
    learn_loading: "Ana shirya dakin ilimantarwa.",
    learn_retry: "Sake Gwada",
    learn_error:
      "Dakin ilimantarwa baya aiki a yanzu. Da fatan a sake gwadawa.",
    privacy_pill: "Labarinki naki ne kadai.",
    privacy_eyebrow: "SIRRI NA NUFIN SIRRI.",
    privacy_title: "Lafiyarki. Iyakar da kika sa.",
    privacy_desc:
      "Muna gina YanMata akan amana. Wannan na nufin izini na gaskiya, kariya da iko akan abin da kike rabawa.",
    privacy_b1: "Babu bukatar asusu don karanta ilimi",
    privacy_b2: "Rubuta sirri a wayarki koda babu intanet",
    privacy_b3: "Kula da ta dace da shekaru, daga 9 zuwa tsohuwa",
    privacy_cta: "Karanta tsarin kare sirrinmu",
    specialists_eyebrow: "KWARARRUN LIKITOCI A MANHAJA",
    specialists_title: "Kwarewar likitanci ta gaskiya. Ba na'ura kadai ba.",
    specialists_lead:
      "Tun daga farkon gwajinmu har zuwa fadin Najeriya da Afirka, YanMata na hada mata da likitoci da ungozomomi masu rajista a karkashin MDCN da NMCN.",
    specialists_badge: "Likitocin MDCN / NMCN",
    specialists_note:
      "Taimakon likita a YanMata na asirce ne a cikin manhaja. YanMata bata bayar da tura asibiti a kaikaice ba ko rajistar asibitoci.",
    faq_eyebrow: "ABUBUWAN DA AKE YAWAN TAMBAYA",
    faq_title: "Bari mu amsa tambayoyinki.",
    faq_q1: "YanMata ta wane ce?",
    faq_a1:
      "'Yan mata da mata daga shekaru 9 har zuwa karshen rayuwa. Manhajar na daidaita da shekarunki tare da cikakkiyar kariya ga yara: matasa (shekaru 9–17) suna samun ilimin jiki ba tare da tambayoyin haihuwa na manya ba.",
    faq_q2: "Yaya YanMata ke kare bayanan sirrina?",
    faq_a2:
      "Sirri shi ne tushenmu. YanMata na aiki koda babu intanet: bayanan hailarki da rukunai 5 na lafiyarki suna boye a wayarki. Ba ma sayar da bayanai ko rabawa da wasu kamfanoni.",
    faq_q3: "Shawarwarin lafiya sun dogara da kimiyyar gaskiya ne?",
    faq_a3:
      "Kwarai kuwa. YanMata ba ta kirkirar lambobin hadari na karya ba. Kowace shawara tana da tushe daga ka'idojin Hukumar Lafiya ta Duniya (WHO) da Ma'aikatar Lafiya ta Najeriya (FMOH).",
    faq_q4: "Yaya ganin likita ke aiki a YanMata?",
    faq_a4:
      "Likitoci da ma'aikatan jinya masu rajista da MDCN da NMCN suna ba da amsoshi a asirce a cikin manhaja. Ka'ida: YanMata ba ta tura asibiti ba — taimako yana cikin manhaja kadai.",
    faq_q5: "Zan iya tambayar Aisha AI da harshena na asali?",
    faq_a5:
      "Aisha tana nuna amsoshin ilimi a Hausa, Turanci, Yarbanci, Igbo da Pidgin. A cikin gaggawa a Najeriya, kira 112.",
    faq_q6: "Yaushe zan iya amfani da manhajar a waya?",
    faq_a6:
      "Ana ci gaba da aikin manhajar Flutter don Android da iOS. Muna fara gwaji kafin fitar da ita a hukumance ga kowa.",
    closing_eyebrow: "KIN CANCANCI SAMUN FAHIMTA.",
    closing_title:
      "Muna tare da ke a matsayin macen da kike yanzu. Da wacce za ki zama.",
    closing_desc:
      "Zentreeca ce ta gina ta da kyakkyawan tsari. An yi ta a Najeriya, don Afirka da dukkan duniya.",
    closing_cta: "Game da gwajin manhajar",
    footer_tagline: "Kowane mataki na rayuwarki.",
    footer_disclaimer: "Samfurin gwaji ne · Ba asibitin gaggawa ba ne",
    modal_privacy_title: "Amanarki na cikin tsarinmu.",
    modal_privacy_body:
      "Wannan samfurin gwaji yana ba da ilimi ba tare da an bayyana sunanki ba. Manhaja tana ajiye rubutunka a boye a cikin wayarka, kuma ba za a tura komai kan intanet ba sai da izininki.",
    modal_pilot_title: "Fara da kulawa. Fadadawa a fadin Najeriya da Afirka.",
    modal_pilot_body:
      "Ana gina YanMata ne don 'yan mata da mata daga shekaru 9 zuwa girma. Gwajinmu yana samun goyon bayan likitocin Najeriya da ungozomomi, kuma an tsara shi ya bazu a dukkan fadin Najeriya da Afirka.",
    modal_article_demo_notice:
      "Bayanan gwaji ne. Ba shawarar likita ba ne. Lokutan duba na gwaji ne.",
    modal_article_source: "Tushen bincike: World Health Organization (WHO) ↗",
    ai_modal_title: "Tambayi Aisha AI",
    ai_modal_desc:
      "Jagorar ilimi a asirce 24/7 kan lafiyar mata, haila, da natsuwar zuciya.",
    ai_placeholder:
      "Rubuta tambayarki da Hausa, Turanci, Yarbanci, Igbo, ko Pidgin...",
    ai_disclaimer:
      "Aisha abokiyar ilimi ce. A lokacin gaggawa a Najeriya, kira 112.",
    theme_light: "Haske",
    theme_dark: "Duhu",
  },
  yo: {
    announcement:
      "Àkókò tuntun fún àlàáfíà àwọn obìnrin. Pẹ̀lú ìfẹ́ ní Nàìjíríà.",
    preview_tag: "ÀKỌ́WÒ",
    nav_chapters: "Àwọn Ìpele",
    nav_stories: "Àwọn Ìtàn",
    nav_journey: "Ìrìn-Àjò Rẹ",
    nav_learn: "Kẹ́kọ̀ọ́",
    nav_care: "Ètò Ìtọ́jú Wa",
    nav_specialists: "Oníṣègùn",
    nav_ai: "Aisha AI",
    cta_meet: "Pàdé YanMata",
    hero_tag: "ỌDÚN 9 TÍTÍ D'ÒPIN · NÀÌJÍRÍÀ, ÁFÍRÍKÀ ÀTI ÀGBÁYÉ",
    hero_title_1: "O ń dàgbà. O ń yípadà.",
    hero_title_2: "Ìwọ náà ni.",
    hero_desc:
      "Ara rẹ ní ìtàn tirẹ̀. O yẹ kí o ní ààyè láti mọ̀ nípa rẹ̀. Pàdé YanMata — olùrànlọ́wọ́ àlàáfíà rẹ láti ọmọ ọdún 9 títí dé gbogbo ìpele ayé.",
    hero_action_find: "Wo Àwọn Ìtàn Manhaja",
    hero_action_explore: "Wo ìpele ayé rẹ",
    trust_privacy: "Àṣírí rẹ ló ṣe pàtàkì jù (Láìsí Íńtánẹ́ẹ̀tì)",
    trust_designed: "Àbò fún àwọn ọmọdé (Ọdún 9+)",
    hero_note_1: "Ìtọ́jú kékeré lójoojúmọ́.",
    hero_note_1_sub: "Ní ìwọ̀ntúnwọ̀nsì rẹ.",
    hero_note_2: "Gbogbo ìpele rẹ.",
    hero_note_2_sub: "A kí ọ káàbọ̀ nígbà gbogbo.",
    hero_art_caption: "ÌRÌN-ÀJÒ RẸ. ÀÀYÈ RẸ.",
    values_rooted: "Dídúró lórí ìlànà WHO àti FMOH",
    values_built: "Fún ìgbésí ayé àwọn obìnrin Nàìjíríà",
    values_private: "Àṣírí pípé · A kì í ta ìròyìn rẹ",
    values_change: "Pẹ̀lú rẹ nínú gbogbo àyípadà",
    stories_eyebrow: "ÀGBÉKALẸ̀ MANHAJA · LÁTI ÀWÒRÁN ÀKỌ́KỌ́",
    stories_title: "Àwọn Ìtàn Ìlera Pàtàkì 6. Ààyè Ìṣọ̀kan Kan.",
    stories_desc:
      "Gbogbo ojú-ìwé ní YanMata ni a kọ láti yanjú àwọn ìṣòro ìlera gidi tí àwọn ọmọbìnrin àti obìnrin Nàìjíríà ń dojú kọ.",
    stories_cta_journey: "Wo Ìgbésẹ̀ Ìforúkọsílẹ̀",
    stories_cta_ai: "Béèrè lọ́wọ́ Aisha AI",
    tab_cycle: "Nǹkan Oṣù",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Ìmọ̀ràn Dọ́kítà",
    tab_profile: "Àkọsílẹ̀ Ìlera",
    tab_mental: "Ìbàlẹ̀ Ọkàn",
    tab_care: "Àwọn Oníṣègùn",
    cycle_badge: "ÀFÀNÍ PÀTÀKÌ",
    cycle_title: "Títọpa Nǹkan Oṣù àti Ìṣe Rẹ̀",
    cycle_lead:
      "Àwo ìṣirò tó ń yípadà tó bá ìpele rẹ, sísàn ẹ̀jẹ̀, àti àwọn àmì ara rẹ mu láìsí ìdájọ́ tàbí ìtìjú.",
    cycle_h1:
      "Mímọ gbogbo ìpele nǹkan oṣù (Follicular, Ovulatory, Luteal, Menstrual)",
    cycle_h2: "Kíkọ bí ara ṣe ń ṣe ọ́ àti ìbàlẹ̀ ọkàn pẹ̀lú fọwọ́-tọ́kànkan kan",
    cycle_h3: "Ìtọ́jú tó yẹ ọmọbìnrin (ọdún 9+) láìsí àwọn ìbéèrè àgbàlagbà",
    cycle_h4: "Àbò 100% lórí ẹ̀rọ rẹ láìsí íńtánẹ́ẹ̀tì",
    ai_badge: "ÈDÈ PÚPỌ̀ & 24/7",
    ai_title: "Aisha: Olùrànlọ́wọ́ Ìlera Rẹ Tó Mọ Àṣà",
    ai_lead:
      "Ìdáhùn pẹ̀lú àánú ní Èdè Yorùbá, Hausa, Igbo, Gẹ̀ẹ́sì, àti Pidgin tí ó dá lórí ìmọ̀ ìṣègùn tòótọ́.",
    ai_h1: "Ìfọ̀rọ̀wérọ̀ ní èdè 5 ti orílẹ̀-èdè Nàìjíríà",
    ai_h2: "Ìlànà ìṣègùn: ẹ̀kọ́ ìlera kọ́kọ́, kì í ṣe kíkọ oògùn lásán",
    ai_h3: "Ìtọ́sọ́nà pàjáwìrì pẹ̀lú nọ́mbà 112 Nàìjíríà",
    ai_h4: "Àṣírí rẹ wà ní àbò: a kì í ṣe àkọsílẹ̀ ìfọ̀rọ̀wérọ̀ rẹ",
    insights_badge: "KÒ SÍ ÌṢIRÒ ÈTÀN",
    insights_title: "Ìmọ̀ràn Ìlera Tó Dá Lórí Ìlànà WHO & FMOH",
    insights_lead:
      "Ìmọ̀ràn ìdènà àìsàn tí a yọ láti inú àwọn òpó 5 ti ìlera rẹ pẹ̀lú ẹ̀rí ìṣègùn tó dájú láti Àjọ Ìlera Àgbáyé àti Ilé-iṣẹ́ Ìlera Nàìjíríà.",
    insights_h1: "Ẹ̀rí ìwádìí tó lágbára tó ṣeé tọpasẹ̀",
    insights_h2:
      "Ìtọ́jú tó bá ọjọ́ orí mu: àyẹ̀wò ilé-ọmọ fún àgbà, ẹ̀kọ́ HPV fún ọ̀dọ́",
    insights_h3: "Àbò ọmọdé: a kì í fi ìmọ̀ràn ìbímọ àgbà hàn fún ọmọ ọdún 9–17",
    insights_h4: "Ìmọ̀ràn oúnjẹ àti ìgbé-ayé tó bá oúnjẹ ilẹ̀ wa mu",
    profile_badge: "ÀBÒ LÓRÍ Ẹ̀RỌ RẸ",
    profile_title: "Àkọsílẹ̀ Ìlera Tó Péye Lórí Òpó 5",
    profile_lead:
      "Ìpìlẹ̀ ìlera tó dá lórí: Nǹkan Oṣù, Ìtàn Ìbímọ, Àìsàn Tẹ́lẹ̀, Ìgbésí Ayé, àti Ìtàn Ìdílé. A pa á mọ́ ní àṣírí lórí ẹ̀rọ rẹ.",
    profile_h1: "Ìbéèrè 5 tó ní ètò láti àwòrán àkọ́kọ́",
    profile_h2: "Àyípadà tó bá ọjọ́ orí mu: fò kọjá àwọn ìbéèrè tí kò kàn ọmọdé",
    profile_h3: "Àbò SQLite outbox láìsí lílọ sórí ẹ̀rọ ayélujára láìgbàṣẹ",
    profile_h4: "O lè mú àkópọ̀ jáde láti fi han oníṣègùn nínú manhaja",
    mental_badge: "ÌTỌ́JÚ ỌKÀN",
    mental_title: "Ìlera Ọpọlọ, Ìbàlẹ̀ Ọkàn & Ìrànlọ́wọ́ Kíákíá",
    mental_lead:
      "Àyípadà homonu àti wàhálà ayé ń ní ipa lórí ìmọ̀lára. YanMata ń fún ọ ní ààyè láti kọ bí ọkàn rẹ ṣe rí, ìmí ẹ̀dùn ìbàlẹ̀, àti nọ́mbà ìrànlọ́wọ́.",
    mental_h1: "Àkọsílẹ̀ ìmọ̀lára àti ìṣe ọkàn ojoojúmọ́",
    mental_h2: "Ọgbọ́n mímí fún ìbàlẹ̀ ọkàn tí ìmọ̀ sáyẹ́ǹsì fọwọ́ sí",
    mental_h3: "Ìtọ́sọ́nà pàjáwìrì pẹ̀lú nọ́mbà 112 Nàìjíríà",
    mental_h4: "Ààyè tó dára láìsí ẹ̀gàn fún gbogbo obìnrin",
    care_badge: "ONÍṢÈGÙN MDCN & NMCN",
    care_title: "Ìbáraẹnisọ̀rọ̀ Pẹ̀lú Àwọn Oníṣègùn Gidi",
    care_lead:
      "Àǹfààní láti bá àwọn dọ́kítà obìnrin àti nọ́ọ̀sì tó nífẹẹ́sì sọ̀rọ̀ ní ìkọ̀kọ̀. A kì í fi sílẹ̀ fún kọ̀mpútà nìkan.",
    care_h1: "100% àwọn oníṣègùn tí wọ́n ní ìwé-ẹ̀rí MDCN àti NMCN",
    care_h2: "Àwọn ọ̀rọ̀ ìkọ̀kọ̀ nínú manhaja pẹ̀lú àbò tó péye",
    care_h3: "Ìlànà wa: a kì í ṣe ìforúkọsílẹ̀ ilé-ìwòsàn tàbí títà ààyè",
    care_h4: "Àjọṣepọ̀ pẹ̀lú àwọn ètò ìlera ìbímọ ti YanMata",
    journey_eyebrow: "ÌRÌN-ÀJÒ ÌFORÚKỌSÍLẸ̀ NÍ MANHAJA",
    journey_title: "Pẹ̀lú Ọlá, Àṣírí àti Ìyéye Láti Ọjọ́ Àkọ́kọ́",
    journey_desc:
      "Tẹ̀lé àwòrán àkọ́kọ́ wa: láti ìbẹ̀rẹ̀ dé àkọsílẹ̀ ìlera ní àṣírí, ìmọ̀ràn tó wúlò, àti ìtọ́jú ojoojúmọ́.",
    journey_step_1: "1. Ìbẹ̀rẹ̀ Ayé",
    journey_step_1_sub:
      "Kíka àwọn ọmọbìnrin láti ọmọ ọdún 9 káàbọ̀ pẹ̀lú ẹ̀kọ́ nípa ara láìsí wàhálà.",
    journey_tag_1: "Àbò Ọdún 9+",
    journey_step_2: "2. Àkántì Àṣírí",
    journey_step_2_sub:
      "Ìdánimọ̀ ọjọ́ orí (9+) àti àbò àwọn ọ̀rọ̀ ìkọ̀kọ̀ láìsí íńtánẹ́ẹ̀tì.",
    journey_tag_2: "Àṣírí & Láìsí Íńtánẹ́ẹ̀tì",
    journey_step_3: "3. Àkọsílẹ̀ Ìlera",
    journey_step_3_sub:
      "Òpó 5 pàtàkì: Nǹkan Oṣù, Ìbímọ, Oògùn, Ìgbésí Ayé, àti Ìdílé.",
    journey_tag_3: "Òpó Ìlera 5",
    journey_step_4: "4. Ìmọ̀ràn Ìṣègùn",
    journey_step_4_sub:
      "Ìmọ̀ràn tí a fọwọ́ sí nípasẹ̀ WHO àti FMOH láìsí nọ́mbà ètàn.",
    journey_tag_4: "Ìlànà WHO / FMOH",
    journey_step_5: "5. Ojú Ìtọ́jú",
    journey_step_5_sub:
      "Kíka orúkọ rẹ, àwo nǹkan oṣù, Aisha AI 24/7, àti oníṣègùn gidi.",
    journey_tag_5: "Olùrànlọ́wọ́ Ojoojúmọ́",
    chapters_eyebrow: "AYÉ Ń YÍPADÀ. BÉẸ̀ NÁÀ NI ÌTỌ́JÚ.",
    chapters_title: "Gbogbo ìpele. Òye tó túbọ̀ jinlẹ̀.",
    chapters_desc:
      "Ọ̀nà kan kọ́ ló wà láti jẹ́ obìnrin. Wá ìtọ́jú tó bá àkókò tí o wà mu.",
    chapters_cta: "Ṣàwárí ààyè ẹ̀kọ́ rẹ",
    ch_label_0: "Ìbàlágà",
    ch_years_0: "Ìbẹ̀rẹ̀ ayé tuntun, ní ìwọ̀ntúnwọ̀nsì rẹ",
    ch_title_0: "Ara tí ń yípadà. Ààyè fún gbogbo ìbéèrè.",
    ch_desc_0:
      "Bẹ̀rẹ̀ pẹ̀lú ìmọ̀ nípa ara rẹ, òye ara àti ọ̀nà rọrùn láti sọ bí nǹkan ṣe ń ṣe ọ́. Fún àwọn ọmọbìnrin láti ọmọ ọdún 9.",
    ch_label_1: "Ìgbà Ọ̀dọ́",
    ch_years_1: "Dídàgbà sínú ara rẹ àti wíwá ohùn rẹ",
    ch_title_1: "Wíwá ìwọ̀ntúnwọ̀nsì rẹ. Gbígbé ohùn rẹ ga.",
    ch_desc_1:
      "Kẹ́kọ̀ọ́ nípa nǹkan oṣù, ìmọ̀lára àti àlàáfíà ní ààyè tí ó bọ̀wọ̀ fún àṣírí rẹ.",
    ch_label_2: "Ìpele Àgbà",
    ch_years_2: "Ìtọ́jú tó bá ìgbésí ayé rẹ mu",
    ch_title_2: "Fi àkókò sílẹ̀ fún ara rẹ pẹ̀lú.",
    ch_desc_2:
      "Àlàáfíà rẹ ṣe pàtàkì pẹ̀lú gbogbo ohun tí o ń ṣe. Kọ àkọsílẹ̀ ara rẹ ní ìkọ̀kọ̀.",
    ch_label_3: "Ìdáwọ́rọdò Haila",
    ch_years_3: "Ìpele ayé tuntun",
    ch_title_3: "Àyípadà tó yẹ fún òye.",
    ch_desc_3:
      "Ààyè tó dára láti kẹ́kọ̀ọ́ nípa àwọn àyípadà, gbígbé ara yẹ̀wò àti bíbá àwọn oníṣègùn sọ̀rọ̀.",
    ch_label_4: "Ọjọ́ Ogbó",
    ch_years_4: "Kò sí àkókò tí a gbọ́dọ̀ dẹ́kun ìtọ́jú",
    ch_title_4: "Gbogbo ọdún. Gbogbo apá ara rẹ.",
    ch_desc_4:
      "Wà ní ìsopọ̀ pẹ̀lú ìmọ̀, ìtura àti ìrànlọ́wọ́ títí di ọjọ́ ogbó pẹ̀lú ọlá àti ìbọ̀wọ̀.",
    voices_eyebrow: "OHÙN TÒÓTỌ́ · NÀÌJÍRÍÀ ÀTI ÀGBÁYÉ",
    voices_title: "Ìdí Tí Àwọn Obìnrin àti Dọ́kítà Fi Gbẹ́kẹ̀lé YanMata",
    voices_desc:
      "Àwọn ìtàn gidi láti ọ̀dọ̀ àwọn ọmọbìnrin, àwọn ìyá, àti àwọn oníṣègùn tí wọ́n ń lo YanMata.",
    test_quote_1:
      "Nígbà tí mo bẹ̀rẹ̀ nǹkan oṣù mi, ojú ti mí láti bi ẹnikẹ́ni ní ilé-ìwé. YanMata ṣe àlàyé gbogbo rẹ̀ fún mi ní èdè tí mo gbọ́ láìsí ìtìjú. Aisha AI dá mi lóhùn pẹ̀lú inú rere, àti pé mímọ̀ pé àwọn àṣírí mi wà ní àbò fún mi ní ìbàlẹ̀ ọkàn.",
    test_name_1: "Amina B.",
    test_title_1: "Akẹ́kọ̀ọ́ (Ọmọ Ọdún 14) · Plateau, Nàìjíríà",
    test_quote_2:
      "Kíkọ àkọsílẹ̀ nǹkan oṣù mi tí kì í wá déédéé máa ń kọ́ mi lórí nítorí àwọn ètò mìíràn gbà pé ọjọ́ 28 ló wà fún gbogbo èèyàn. Àgbékalẹ̀ YanMata gba ìtàn àlàáfíà mi, àwọn ìmọ̀ràn rẹ̀ sì dá lórí ìlànà WHO gidi dípò àwọn nọ́mbà ẹ̀tàn.",
    test_name_2: "Zainab O.",
    test_title_2: "Oníṣẹ́ Àwòrán Ilé (Ọmọ Ọdún 28) · Àbújá",
    test_quote_3:
      "Gẹ́gẹ́ bí dọ́kítà tó ń ṣiṣẹ́ ní Nàìjíríà, inú mi dùn láti rí ètò ìlera tó tẹ̀lé àwọn ìlànà FMOH àti MDCN pẹ́kípẹ́kí. YanMata bọ̀wọ̀ fún àṣírí aláìsàn, ó dáàbò bo àwọn ọmọdé, ó sì so àwọn obìnrin pọ̀ mọ́ àwọn oníṣègùn gidi.",
    test_name_3: "Dr. Fatima Aliyu",
    test_title_3: "Dọ́kítà Àgbà Fún Àwọn Obìnrin (MDCN Verified)",
    support_eyebrow: "ÀKÓKÒ KÉKERÉ. ÌTỌ́JÚ PÀTÀKÌ.",
    support_title: "Ààyè tí ó jẹ́ tìrẹ.",
    support_desc:
      "Ìfọkànsìn dínkù. Òye púpọ̀ sí i. Àwọn ohun èlò fún àlàáfíà rẹ ojoojúmọ́.",
    support_track_title: "Ṣàyẹ̀wò bí ara rẹ ṣe rí.",
    support_track_desc:
      "Àkọsílẹ̀ ìkọ̀kọ̀ fún ìmọ̀lára rẹ àti ìrírí ojoojúmọ́. Kò sí ìdáhùn tó lábùkù.",
    support_mood_question: "BÁWO NI ARA RẸ ṢE RÍ LÓNÌÍ?",
    mood_great: "Dára Púpọ̀",
    mood_good: "Dára",
    mood_okay: "Wà Níwọ̀ntúnwọ̀nsì",
    mood_low: "Rẹ̀wẹ̀sì",
    support_mood_caption: "Àkókò kan, fún ìwọ nìkan.",
    support_learn_title: "Mọ̀ nípa ara rẹ sí i.",
    support_learn_desc:
      "Ṣàwárí ẹ̀kọ́ tó bá ìgbésí ayé rẹ mu, pẹ̀lú orísun tó dájú àti àyẹ̀wò dọ́kítà.",
    support_stack_1_title: "Ara rẹ, àwọn ìbéèrè rẹ",
    support_stack_1_tag: "ÌMỌ̀ NÍPA ARA",
    support_stack_2_title: "Ààyè fún ìmọ̀lára rẹ",
    support_stack_2_tag: "ÌBÀLẸ̀ ỌKÀN",
    support_care_title: "Ìtọ́jú Láti Ọwọ́ Oníṣègùn.",
    support_care_desc:
      "Bá àwọn dọ́kítà obìnrin àti nọ́ọ̀sì sọ̀rọ̀ tààrà nínú ètò wa ní ìkọ̀kọ̀ àti pẹ̀lú ìbọ̀wọ̀.",
    support_convo_q: "Àwọn ìbéèrè kan nílò etí tó ń fetísílẹ̀.",
    support_convo_a: "Àti dọ́kítà gidi tó máa fún ọ ní èsì.",
    support_care_badge: "Oníṣègùn MDCN & NMCN · Ìtọ́jú Ní Manhaja",
    learn_eyebrow: "YÀRÁ Ẹ̀KỌ́ ÌLERA",
    learn_title: "Ìmọ̀ díẹ̀. Ìgboyà púpọ̀ sí i.",
    learn_desc: "Mí ìmí ẹ̀dùn. Wá ohun tó dára fún ọ.",
    learn_notice: "Àwọn àkọsílẹ̀ àpẹẹrẹ. Orísun ìtọ́jú láti WHO & FMOH.",
    learn_card_meta: "ÀKỌSÍLẸ̀ ÀPẸẸRẸ · ORÍSUN WHO/FMOH",
    learn_loading: "A ń pèsè yàrá ẹ̀kọ́ lọ́wọ́.",
    learn_retry: "Tún Gbìyànjú",
    learn_error: "Yàrá ẹ̀kọ́ kò sí ní àkókò yìí. Jọ̀wọ́ tún gbìyànjú.",
    privacy_pill: "Ìtàn rẹ jẹ́ ti ìwọ nìkan.",
    privacy_eyebrow: "ÀṢÍRÍ ṢE PÀTÀKÌ.",
    privacy_title: "Àlàáfíà rẹ. Àwọn ààlà rẹ.",
    privacy_desc:
      "A kọ́ YanMata lórí ìgbẹ́kẹ̀lé. Èyí túmọ̀ sí àṣẹ tòótọ́, ìrírí ìkọ̀kọ̀ àti àkóso lórí ohun tí o ń pín.",
    privacy_b1: "Kò sí àkántì tí o nílò láti kẹ́kọ̀ọ́",
    privacy_b2: "Àkọsílẹ̀ ìkọ̀kọ̀ tí a ṣe láti ṣiṣẹ́ láìsí íńtánẹ́ẹ̀tì",
    privacy_b3: "Ìtọ́jú tó bá ọjọ́ orí mu, láti ọmọ ọdún 9 títí dé ọjọ́ ogbó",
    privacy_cta: "Ka ọ̀nà tí a ń gbà dáàbò bo àṣírí",
    specialists_eyebrow: "ÀWỌN ONÍṢÈGÙN GIDI NÍNÚ MANHAJA",
    specialists_title: "Ìtọ́sọ́nà tó kún fún ìmọ̀. Kì í ṣe kọ̀mpútà nìkan.",
    specialists_lead:
      "Láti ìbẹ̀rẹ̀ àkọ́kọ́ wa títí dé gbogbo Nàìjíríà àti Áfíríkà, YanMata ń so àwọn obìnrin pọ̀ mọ́ àwọn dọ́kítà àti nọ́ọ̀sì tí wọ́n forúkọsílẹ̀ pẹ̀lú MDCN àti NMCN.",
    specialists_badge: "Oníṣègùn MDCN / NMCN",
    specialists_note:
      "Ìtọ́sọ́nà oníṣègùn ní YanMata wà ní ìkọ̀kọ̀ nínú manhaja. YanMata kì í ṣe ìfiranṣẹ́ sí ilé-ìwòsàn tàbí títà ààyè.",
    faq_eyebrow: "ÀWỌN OHUN TÍ O LÈ MÁA BÈÈRÈ",
    faq_title: "Ẹ jẹ́ kí a fi ààyè sílẹ̀ fún àwọn ìbéèrè.",
    faq_q1: "Ta ni YanMata wà fún?",
    faq_a1:
      "Àwọn ọmọbìnrin àti obìnrin láti ọmọ ọdún 9 títí dé òpin ayé. Ìrírí rẹ yóò bá ìpele rẹ mu pẹ̀lú àbò tó péye fún àwọn ọmọdé: àwọn ọ̀dọ́ (ọdún 9–17) gba ẹ̀kọ́ nípa ara láìsí àwọn ìbéèrè ìbímọ àgbà.",
    faq_q2: "Báwo ni YanMata ṣe ń dáàbò bo àwọn àṣírí mi?",
    faq_a2:
      "Àṣírí ló ṣe pàtàkì jù. YanMata ń ṣiṣẹ́ láìsí íńtánẹ́ẹ̀tì: àwọn àkọsílẹ̀ nǹkan oṣù àti òpó 5 ti ìlera rẹ wà ní àbò lórí ẹ̀rọ rẹ. A kì í ta ìròyìn rẹ tàbí pín in pẹ̀lú àwọn ẹlòmíràn.",
    faq_q3: "Ṣé àwọn ìmọ̀ràn ìlera dá lórí ìmọ̀ sáyẹ́ǹsì gidi?",
    faq_a3:
      "Bẹ́ẹ̀ ni. YanMata kì í ṣe àwọn nọ́mbà ewu ti ètàn. Gbogbo ìmọ̀ràn ní orísun láti inú àwọn ìlànà Àjọ Ìlera Àgbáyé (WHO) àti Ilé-iṣẹ́ Ìlera Nàìjíríà (FMOH).",
    faq_q4: "Báwo ni bíbá oníṣègùn sọ̀rọ̀ ṣe ń ṣiṣẹ́ ní YanMata?",
    faq_a4:
      "Àwọn dọ́kítà àti nọ́ọ̀sì tó forúkọsílẹ̀ lábẹ́ MDCN àti NMCN ń pèsè ìdáhùn ní ìkọ̀kọ̀ nínú manhaja. Ìlànà wa: YanMata kì í ránni lọ sí ilé-ìwòsàn — ìtọ́sọ́nà wà nínú manhaja nìkan.",
    faq_q5: "Ṣé mo lè fi èdè mi béèrè lọ́wọ́ Aisha AI?",
    faq_a5:
      "Aisha ń ṣàfihàn ìdáhùn ẹ̀kọ́ ní Yorùbá, Hausa, Igbo, Gẹ̀ẹ́sì àti Pidgin. Ní pàjáwìrì ní Nàìjíríà, pe 112.",
    faq_q6: "Ìgbà wo ni mo lè lo manhaja lórí fóònù mi?",
    faq_a6:
      "A ń ṣe àgbékalẹ̀ manhaja Flutter fún Android àti iOS lọ́wọ́. A ń bẹ̀rẹ̀ pẹ̀lú àkọ́wò kí a tó tú u síta fún gbogbo ènìyàn.",
    closing_eyebrow: "O YẸ KÍ O NÍ ÒYE TÓ PÉYE.",
    closing_title:
      "A wà níbí fún obìnrin tí o jẹ́ lónìí. Àti èyí tí o ń dàgbà sí.",
    closing_desc:
      "Zentreeca ló fi ìṣọ́ra kọ́ ọ. A ṣe é pẹ̀lú ìfẹ́ ní Nàìjíríà, fún Áfíríkà àti gbogbo àgbáyé.",
    closing_cta: "Nípa àkọ́wò manhaja wa",
    footer_tagline: "Gbogbo ìpele ayé rẹ.",
    footer_disclaimer: "Àkọ́wò ìdàgbàsókè · Kì í ṣe ilé-ìwòsàn pàjáwìrì",
    modal_privacy_title: "Ìgbẹ́kẹ̀lé rẹ wà nínú àgbékalẹ̀ wa.",
    modal_privacy_body:
      "Àkọ́wò yìí ń fún ọ ní ẹ̀kọ́ láìsí dídárúkọ rẹ. Manhaja foonu ń fi àwọn àkọsílẹ̀ rẹ pamọ́ sínú ẹ̀rọ rẹ, a kì í sì í gbé e sórí íńtánẹ́ẹ̀tì láìsí àṣẹ rẹ.",
    modal_pilot_title: "Bíbẹ̀rẹ̀ pẹ̀lú ìtọ́jú. Fífẹ̀ káàkiri Nàìjíríà àti Áfíríkà.",
    modal_pilot_body:
      "A ń ṣe YanMata fún àwọn ọmọbìnrin àti obìnrin láti ọmọ ọdún 9 títí di ọjọ́ ogbó. Àkọ́wò wa bẹ̀rẹ̀ pẹ̀lú àtìlẹyìn àwọn dọ́kítà àti nọ́ọ̀sì Nàìjíríà, a sì ṣe é láti fẹ̀ sí gbogbo Nàìjíríà àti Áfíríkà.",
    modal_article_demo_notice:
      "Àkọsílẹ̀ àpẹẹrẹ ni. Kì í ṣe ìmọ̀ràn ìṣègùn gidi. Àwọn àkókò àyẹ̀wò jẹ́ ti àpẹẹrẹ.",
    modal_article_source: "Orísun ìmọ̀: World Health Organization (WHO) ↗",
    ai_modal_title: "Béèrè lọ́wọ́ Aisha AI",
    ai_modal_desc:
      "Ìtọ́sọ́nà ẹ̀kọ́ ní ìkọ̀kọ̀ 24/7 lórí ìlera obìnrin, nǹkan oṣù, àti ìbàlẹ̀ ọkàn.",
    ai_placeholder:
      "Kọ ìbéèrè rẹ ní Èdè Yorùbá, Hausa, Igbo, Gẹ̀ẹ́sì, tàbí Pidgin...",
    ai_disclaimer: "Aisha jẹ́ olùrànlọ́wọ́ ẹ̀kọ́. Ní pàjáwìrì ní Nàìjíríà, pe 112.",
    theme_light: "Ìmọ́lẹ̀",
    theme_dark: "Òkùnkùn",
  },
  ig: {
    announcement:
      "Oge ọhụrụ maka ahụike ụmụ nwanyị. Mere n’ịhụnanya na Nigeria.",
    preview_tag: "MBIDO",
    nav_chapters: "Nkebi Ndụ",
    nav_stories: "Akụkọ",
    nav_journey: "Njem Gị",
    nav_learn: "Ọmụmụ",
    nav_care: "Usoro Anyị",
    nav_specialists: "Ọkachamara",
    nav_ai: "Aisha AI",
    cta_meet: "Zute YanMata",
    hero_tag: "AFỌ 9 RUO Ọ GWỤCHA · NIGERIA, AFRICA NA ỤWA NIILE",
    hero_title_1: "Ị na-eto. Ị na-agbanwe.",
    hero_title_2: "Ọ bụ gị mgbe niile.",
    hero_desc:
      "Ahụ gị nwere usoro nke ya. O kwesịrị ka ị nwee ohere ịghọta ya. Zute YanMata — enyi ahụike gị site n'afọ 9 ruo n'oge agadi.",
    hero_action_find: "Lelee Akụkọ Ngwa",
    hero_action_explore: "Lelee oge ndụ gị",
    trust_privacy: "Ihe nzuzo gị bụ nke mbụ (Ọ dịghị mkpa ịntanetị)",
    trust_designed: "Nchedo ụmụntakịrị (Afọ 9+)",
    hero_note_1: "Nlekọta dị nwayọọ kwa ụbọchị.",
    hero_note_1_sub: "N'ọsọ nke aka gị.",
    hero_note_2: "Ụdị gị ọ bụla.",
    hero_note_2_sub: "A na-anabata gị mgbe niile.",
    hero_art_caption: "NJEM GỊ. OHERE GỊ.",
    values_rooted: "Gbakwasịrị ụkwụ n'ụkpụrụ WHO na FMOH",
    values_built: "E wuru ya maka ụmụ nwanyị Nigeria",
    values_private: "Ihe nzuzo zuru oke · Anyị anaghị ere ozi gị",
    values_change: "Anyị nọnyeere gị na mgbanwe niile",
    stories_eyebrow: "ATỤTỤ NGWA ANYỊ · SITE N'EGO IHE OSESE",
    stories_title: "Akụkọ Ahụike 6 Dị Mkpa. Otu Ebe Ejikọtara.",
    stories_desc:
      "E kere ihuenyo na ngwa niile dị na YanMata iji dozie ezigbo nsogbu ahụike ụmụ agbọghọ na ụmụ nwanyị Nigeria na-enwe kwa ụbọchị.",
    stories_cta_journey: "Lee Njem Ndebanye Aha",
    stories_cta_ai: "Jụọ Aisha AI",
    tab_cycle: "Oge Nsọ Nwaanyị",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Ndụmọdụ Dọkịta",
    tab_profile: "Profaịlụ Ahụike",
    tab_mental: "Udo nke Uche",
    tab_care: "Ndị Dọkịta Zuru Ezu",
    cycle_badge: "IHE PỤRỤ ICHE NA NGWA",
    cycle_title: "Ịghọta Usoro Nsọ Nwaanyị na Mgbanwe Ya",
    cycle_lead:
      "Usoro eserese na-agbanwe agbanwe nke na-adaba n'oge gị, otu ọbara si agba, na ihe mgbaàmà gị na-enweghị ikpe ọmụma.",
    cycle_h1:
      "Ịghọta nkebi ọ bụla nke nsọ (Follicular, Ovulatory, Luteal, Menstrual)",
    cycle_h2: "Ideba ihe mgbaàmà, udo nke uche, na nsọ n'otu aka",
    cycle_h3:
      "Nlekọta kwesịrị ụmụ agbọghọ (afọ 9+) na-enweghị ajụjụ ndị okenye",
    cycle_h4: "Nchekwa nzuzo 100% n'ekwentị gị na-enweghị ịntanetị",
    ai_badge: "ỌTỤTỤ ASỤSỤ & 24/7",
    ai_title: "Aisha: Enyi Ahụike Gị nke Ghọtara Ọdịnala",
    ai_lead:
      "Azịza dị nro nye ajụjụ ahụike gị n'Asụsụ Igbo, Hausa, Yoruba, Bekee, na Pidgin dabere n'ezi ndụmọdụ ahụike.",
    ai_h1: "Mkparịta ụka n'asụsụ 5 nke ala Nigeria",
    ai_h2:
      "Oke ahụike doro anya: nkuzi ahụike, ọ bụghị ide ọgwụ na-enweghị dọkịta",
    ai_h3: "Nduzi mberede site na nọmba Nigeria 112",
    ai_h4: "Nzuzo zuru oke: mkparịta ụka gị bụ naanị nke gị",
    insights_badge: "ENWEGHỊ ỌNỤỌGỤGỤ ỤGHA",
    insights_title: "Ndụmọdụ Ahụike Dabere n'Ụkpụrụ WHO & FMOH",
    insights_lead:
      "Ndụmọdụ mgbochi ahụike nke sitere n'ogidi 5 gị nwere ezigbo akaebe sitere na World Health Organization na Federal Ministry of Health Nigeria.",
    insights_h1: "Ezigbo nchọpụta sayensị nwere akaebe doro anya",
    insights_h2:
      "Kwekọrọ n'afọ ndụ: nyocha maka ndị okenye, ọgwụ mgbochi HPV maka ndị na-eto eto",
    insights_h3:
      "Nchedo ụmụntakịrị: anyị anaghị egosi ụmụ agbọghọ afọ 9–17 ozi gbasara ọmụmụ nke ndị okenye",
    insights_h4: "Ndụmọdụ nri na ndụ dabere n'ụdị nri ala anyị",
    profile_badge: "NCHEKWA N'EKWENTỊ GỊ",
    profile_title: "Profaịlụ Ahụike Zuru Ezu n'Ogidi 5 Dị Mkpa",
    profile_lead:
      "Ntọala ahụike gbasara: Nsọ Nwaanyị, Ịmụ Nwa, Ọnọdụ Ahụike, Ụzọ Ndụ, na Akụkọ Ezinụlọ. Echekwara ya na nzuzo n'ekwentị gị.",
    profile_h1: "Ajụjụ 5 haziri ahazi site na mbido ngwa anyị",
    profile_h2: "Mgbanwe dịka afọ siri dị: wepụ ajụjụ na-adaghị ụmụ agbọghọ",
    profile_h3:
      "Nchekwa SQLite outbox na-agaghị n'elu ịntanetị n'enweghị nkwenye",
    profile_h4: "Enwere ike ibipụta nchịkọta iji gosi dọkịta na ngwa anyị",
    mental_badge: "NLEKỌTA UCHE",
    mental_title: "Ahụike Uche, Mmetụta Ọnọdụ & Enyemaka Mberede",
    mental_lead:
      "Mgbanwe homonu na nchegbu ndụ na-emetụta uche. YanMata na-enye gị ohere ide otu obi si dị gị, izu ike n'iku ume, na nọmba enyemaka.",
    mental_h1: "Ideba mmetụta uche gị na ọnọdụ obi kwa ụbọchị",
    mental_h2: "Usoro iku ume na ime ka uche dajụọ sayensị kwadoro",
    mental_h3: "Nduzi mberede site na nọmba Nigeria 112",
    mental_h4: "Ebe nchekwa na-enweghị ihere ma ọ bụ ikpe maka nwanyị ọ bụla",
    care_badge: "NDỊ DỌKỊTA MDCN & NMCN",
    care_title: "Mkparịta Ụka Nzuzo nke Ndị Dọkịta Zuru Ezu",
    care_lead:
      "Ohere ịgwa ndị ọkachamara n'ahụike ụmụ nwanyị na ndị nọọsụ nwere ikike okwu na nzuzo. Ọ bụghị naanị kọmputa.",
    care_h1: "100% ndị dọkịta nwere asambodo MDCN na NMCN",
    care_h2: "Ozi nzuzo n'ime ngwa anyị nwere nchebe pụrụ iche",
    care_h3:
      "Ụkpụrụ anyị: anyị anaghị ezipụ mmadụ n'ụlọ ọgwụ ma ọ bụ na-ere ohere",
    care_h4: "Njikọta na ọrụ ahụike nne na nwa nke YanMata",
    journey_eyebrow: "NJEM NDEBANYE AHA N'IME NGWA",
    journey_title: "Site n'Nsọpụrụ, Nzuzo na Nghọta Site n'Ụbọchị Mbụ",
    journey_desc:
      "Soro usoro e sere n'atụmatụ anyị: site na mbido ruo profaịlụ ahụike na nzuzo, ndụmọdụ bara uru, na nlekọta kwa ụbọchị.",
    journey_step_1: "1. Malite",
    journey_step_1_sub:
      "Ịnabata ụmụ agbọghọ site n'afọ 9 n'ụzọ dị nwayọọ na mmụta ahụike na-enweghị nchegbu.",
    journey_tag_1: "Nchedo Afọ 9+",
    journey_step_2: "2. Akụkọ Nzuzo",
    journey_step_2_sub:
      "Nkwenye afọ (9+) na nchekwa ozi nzuzo n'ekwentị na-enweghị ịntanetị.",
    journey_tag_2: "Nzuzo & Na-enweghị Ịntanetị",
    journey_step_3: "3. Profaịlụ Ahụike",
    journey_step_3_sub:
      "Ogidi 5 dị mkpa: Nsọ Nwaanyị, Ọmụmụ Nwa, Ọgwụ, Ụdị Ndụ, na Ezinụlọ.",
    journey_tag_3: "Ogidi Ahụike 5",
    journey_step_4: "4. Ndụmọdụ Dọkịta",
    journey_step_4_sub:
      "Ndụmọdụ mgbochi ahụike WHO na FMOH kwadoro na-enweghị ọnụọgụgụ ụgha.",
    journey_tag_4: "Ụkpụrụ WHO / FMOH",
    journey_step_5: "5. Ihuenyo Nlekọta",
    journey_step_5_sub:
      "Ekele pụrụ iche nwere aha gị, oge nsọ nwaanyị, Aisha AI 24/7, na ezigbo ndị dọkịta.",
    journey_tag_5: "Enyi Kwa Ụbọchị",
    chapters_eyebrow:
      "NDỤ ANAGHỊ AKWỤSỊ AKWỤSỊ. NLEKỌTA KWESỊRỊ DỊKWA OTWU AHỤ.",
    chapters_title: "Oge ndụ ọ bụla. Nghọta miri emi.",
    chapters_desc:
      "Ọ dịghị naanị otu ụzọ isi bụrụ nwaanyị. Chọta nkwado dabara n'oge ndụ gị.",
    chapters_cta: "Chọpụta ebe ọmụmụ gị",
    ch_label_0: "Mbido Ntorobịa",
    ch_years_0: "Mmalite dị nwayọọ, n’ọsọ nke gị",
    ch_title_0: "Ahụ na-agbanwe agbanwe. Ebe maka ajụjụ ọ bụla.",
    ch_desc_0:
      "Malite site n'ịghọta ahụ gị, ịmara onwe gị na ụzọ dị mfe isi kwuo otu obi dị gị. E mere ya maka ụmụ agbọghọ site n'afọ 9.",
    ch_label_1: "Ọbịbịa Nwaanyị",
    ch_years_1: "Itolite n’ime onwe gị na ịchọta olu gị",
    ch_title_1: "Ịchọta usoro gị. Ịchọta olu nke gị.",
    ch_desc_1:
      "Mụta banyere nsọ nwaanyị, mmetụta uche na ahụike n'ebe na-asọpụrụ nzuzo na ajụjụ gị.",
    ch_label_2: "Ndụ Okenye",
    ch_years_2: "Nlekọta kwesịrị ekwesị maka ndụ gị",
    ch_title_2: "Wepụtakwa ohere maka onwe gị.",
    ch_desc_2:
      "Ahụike gị dị mkpa yana ihe niile ị na-eme. Wulite akwụkwọ nzuzo gị ma mụta ihe na-amasị gị.",
    ch_label_3: "Ịkwụsị Nsọ",
    ch_years_3: "Oge ndụ ọzọ",
    ch_title_3: "Mgbanwe kwesịrị nghọta.",
    ch_desc_3:
      "Ebe dị mma ịmụta banyere mgbanwe ahụ, ịtụgharị uche n'ahụike gị na iso ndị dọkịta kparịta ụka.",
    ch_label_4: "Oge Agadi",
    ch_years_4: "Enweghị oke afọ na nlekọta ahụike",
    ch_title_4: "Afọ niile. Akụkụ gị niile.",
    ch_desc_4:
      "Nọgide na-amụta ihe, nweta udo na enyemaka n'oge agadi site n'ugwu na nsọpụrụ.",
    voices_eyebrow: "EZIGBO OLU · NIGERIA NA ỤWA NIILE",
    voices_title:
      "Ihe Mere Ụmụ Nwaanyị na Ndị Dọkịta Nigeria Ji Tụkwasị YanMata Obi",
    voices_desc:
      "Ezi akụkọ sitere n'aka ụmụ agbọghọ, ndị nne, na ndị ọkachamara n'ahụike na-eji YanMata.",
    test_quote_1:
      "Mgbe m hụrụ nsọ mbụ m, ihere mere m ịjụ onye ọ bụla n’ụlọ akwụkwọ. YanMata kọwara m ihe niile n’ụzọ doro anya na-enweghị ihere. Aisha AI zara ajụjụ m n’obi ọma, ịmata na ihe nzuzo m dị nchebe nyere m udo nke uche.",
    test_name_1: "Amina B.",
    test_title_1: "Nwa akwụkwọ (Afọ 14) · Plateau, Nigeria",
    test_quote_2:
      "Ịgbaso nsọ m na-adịghị abịa n’usoro na-ewutebu m n’ihi na ngwa ndị ọzọ na-eche na onye ọ bụla nwere ụbọchị 28. Usoro ogidi ise nke YanMata ghọtara akụkọ ahụike m, ndụmọdụ ahụike ya sikwa n'ụkpụrụ WHO gidi pụta.",
    test_name_2: "Zainab O.",
    test_title_2: "Onye Nhazi Ụlọ / Architect (Afọ 28) · Abuja",
    test_quote_3:
      "Dịka dọkịta na-arụ ọrụ na Nigeria, ọ na-enye obi ụtọ ịhụ usoro ahụike na-agbaso ụkpụrụ FMOH na MDCN nke ọma. YanMata na-echebe nzuzo onye ọrịa, na-echekwa ụmụntakịrị, na-ejikọkwa ndị nne na ndị dọkịta ziri ezi.",
    test_name_3: "Dr. Fatima Aliyu",
    test_title_3: "Dọkịta Ndị Nwaanyị (MDCN Verified)",
    support_eyebrow: "OGE NTA. NLEKỌTA DỊ MKPA.",
    support_title: "Ohere nke bụ nke gị.",
    support_desc:
      "Obere nchegbu. Nghọta karịa. Ngwa bara uru maka ahụike gị kwa ụbọchị.",
    support_track_title: "Lelee otu obi dị gị.",
    support_track_desc:
      "Akwụkwọ nzuzo maka ọnọdụ obi gị na ahụmịhe kwa ụbọchị. Ọ dịghị azịza zuru oke dị mkpa.",
    support_mood_question: "KEDU KA Ọ DỊ GỊ TAA?",
    mood_great: "Ọ Dị Mma Nke Ukwuu",
    mood_good: "Ọ Dị Mma",
    mood_okay: "Ọ Dị Nkịtị",
    mood_low: "Ọ Dịchaghị Mma",
    support_mood_caption: "Oge pụrụ iche, maka naanị gị.",
    support_learn_title: "Ghọta ahụ gị karịa.",
    support_learn_desc:
      "Chọpụta nkuzi ahaziri gburugburu ndụ gị, nwere ezigbo ebe nchọpụta na nyocha dọkịta.",
    support_stack_1_title: "Ahụ gị, ajụjụ gị",
    support_stack_1_tag: "MMỤTA AHỤỊKE",
    support_stack_2_title: "Ohere maka mmetụta gị",
    support_stack_2_tag: "UDO NKE UCHE",
    support_care_title: "Nkwado Dọkịta Zuru Ezu na Ngwa.",
    support_care_desc:
      "Gwa ndị dọkịta ụmụ nwanyị na ndị nọọsụ okwu na nzuzo na nkwanye ùgwù n'usoro anyị.",
    support_convo_q: "Ajụjụ ụfọdụ chọrọ onye ga-ege ntị nke ọma.",
    support_convo_a: "Na ezigbo dọkịta ga-aza azịza dị mma.",
    support_care_badge: "Ndị Dọkịta MDCN & NMCN · Nlekọta na Ngwa",
    learn_eyebrow: "ỤLỌ MMỤTA AHỤỊKE",
    learn_title: "Obere ihe ọmụma. Nkwuwa okwu karịa.",
    learn_desc: "Kuo ume. Chọta ihe dị mma maka gị.",
    learn_notice: "Ihe omume ngosi. Ebe nchọpụta sitere na WHO & FMOH.",
    learn_card_meta: "NGOSI · ENYOCHARA SITE NA WHO/FMOH",
    learn_loading: "A na-akwadebe ụlọ mmụta ahụike.",
    learn_retry: "Nwaa Ọzọ",
    learn_error: "Ụlọ mmụta ahụike anaghị arụ ọrụ ugbu a. Biko nwaa ọzọ.",
    privacy_pill: "Akụkọ gị bụ nke gị naanị.",
    privacy_eyebrow: "NZUZO PỤRỤ ICHE.",
    privacy_title: "Ahụike gị. Oke nke gị.",
    privacy_desc:
      "Anyị ji ntụkwasị obi wuo YanMata. Nke a pụtara ikike doro anya, nzuzo na ịchịkwa ihe ị na-ekekọrịta.",
    privacy_b1: "Ọ dịghị mkpa akaụntụ iji mụta ihe",
    privacy_b2: "Ideba akụkọ nzuzo n'ekwentị na-enweghị ịntanetị",
    privacy_b3: "Nlekọta kwesịrị afọ ndụ gị, site n'afọ 9 ruo agadi",
    privacy_cta: "Gụọ usoro nchekwa nzuzo anyị",
    specialists_eyebrow: "NDỊ DỌKỊTA ZURU EZU NA NGWA",
    specialists_title: "Nduzi ọkachamara. Ọ bụghị naanị kọmputa.",
    specialists_lead:
      "Site na mbido nyocha anyị ruo Nigeria na Africa niile, YanMata na-ejikọ ụmụ nwanyị na ndị dọkịta na ndị nọọsụ nwere ikike n'okpuru MDCN na NMCN.",
    specialists_badge: "Ndị Dọkịta MDCN / NMCN",
    specialists_note:
      "Nkwado ndị dọkịta na YanMata bụ na nzuzo n'ime ngwa a. YanMata anaghị ezipụ mmadụ n'ụlọ ọgwụ ma ọ bụ na-ere ohere.",
    faq_eyebrow: "IHE NDỊ A NA-AJỤKARỊ",
    faq_title: "Ka anyị wepụta ohere maka ajụjụ.",
    faq_q1: "Maka onye ka YanMata bụ?",
    faq_a1:
      "Ụmụ agbọghọ na ụmụ nwanyị site n'afọ 9 ruo ọgwụgwụ ndụ. Ahụmịhe gị na-agbanwe dịka afọ ndụ gị si dị nwere nchedo ụmụaka: ndị na-eto eto (afọ 9–17) na-amụta maka ahụ ha na-enweghị ajụjụ ndị okenye.",
    faq_q2: "Kedu ka YanMata si echebe ozi nzuzo m?",
    faq_a2:
      "Nzuzo bụ ntọala anyị. YanMata na-arụ ọrụ na-enweghị ịntanetị: ozi nsọ gị na ogidi ahụike 5 gị na-adị nchebe n'ekwentị gị. Anyị anaghị ere ozi gị ma ọ bụ nye ndị ọzọ.",
    faq_q3: "Ndụmọdụ ahụike a ọ dabere n'ezi sayensị?",
    faq_a3:
      "Ee n'ezie. YanMata anaghị echepụta ọnụọgụgụ ụgha. Ndụmọdụ ọ bụla nwere ebe nchọpụta sitere na World Health Organization (WHO) na Federal Ministry of Health (FMOH) Nigeria.",
    faq_q4: "Kedu ka ịkpọtụrụ dọkịta si arụ ọrụ na YanMata?",
    faq_a4:
      "Ndị dọkịta na ndị nọọsụ nwere asambodo MDCN na NMCN na-aza ajụjụ na nzuzo n'ime ngwa anyị. Usoro anyị: YanMata anaghị ezipụ mmadụ n'ụlọ ọgwụ — nkwado dị naanị n'ime ngwa a.",
    faq_q5: "Enwere m ike iji asụsụ m jụọ Aisha AI ajụjụ?",
    faq_a5:
      "Aisha na-egosi azịza mmụta n’Igbo, Hausa, Yoruba, Bekee na Pidgin. N’oge mberede na Nigeria, kpọọ 112.",
    faq_q6: "Olee mgbe m nwere ike iji ngwa ekwentị a?",
    faq_a6:
      "A ka na-arụ ngwa Flutter a maka Android na iOS. Anyị na-eme nyocha ule tupu anyị wepụta ya maka mmadụ niile.",
    closing_eyebrow: "O KWESỊRỊ KA A GHỌTA GỊ.",
    closing_title: "Anyị nọ ebe a maka nwanyị ị bụ taa. Na onye ị na-eto ịbụ.",
    closing_desc:
      "Zentreeca ji nlezianya wuo ya. E ji ịhụnanya mee ya na Nigeria, maka Africa na ụwa niile.",
    closing_cta: "Banyere nyocha ule ngwa anyị",
    footer_tagline: "Nkebi ndụ gị ọ bụla.",
    footer_disclaimer: "Ngwa nyocha · Ọ bụghị ụlọ ọgwụ mberede",
    modal_privacy_title: "Ntụkwasị obi gị dị n'atụmatụ anyị.",
    modal_privacy_body:
      "Ngosipụta a na-enye ohere ịmụta ihe na-ekwupụtaghị aha gị. Ngwa ekwentị na-echekwa akụkọ gị n'ekwentị gị, anyị agaghị ebufe ihe n'ịntanetị ma ọ bụghị na ị kwere.",
    modal_pilot_title: "Ịmalite na nlekọta. Ịgbasa na Nigeria na Africa niile.",
    modal_pilot_body:
      "A na-ewu YanMata maka ụmụ agbọghọ na ụmụ nwanyị site n'afọ 9 ruo agadi. Nyocha ule anyị nwere nkwado ndị dọkịta na ndị nọọsụ Nigeria, e mere ya ka o ruo Nigeria na Africa niile.",
    modal_article_demo_notice:
      "Ihe omume ngosi. Ọ bụghị ezigbo ndụmọdụ ahụike. Oge nyocha bụ nke atụmatụ.",
    modal_article_source: "Ebe nchọpụta: World Health Organization (WHO) ↗",
    ai_modal_title: "Jụọ Aisha AI",
    ai_modal_desc:
      "Nduzi mmụta nzuzo 24/7 gbasara ahụike ụmụ nwanyị, nsọ nwaanyị, na udo nke uche.",
    ai_placeholder:
      "Dee ajụjụ gị n'Asụsụ Igbo, Hausa, Yoruba, Bekee, ma ọ bụ Pidgin...",
    ai_disclaimer:
      "Aisha bụ onye inyeaka na mmụta. N’oge mberede na Nigeria, kpọọ 112.",
    theme_light: "Ihe Ìhè",
    theme_dark: "Ọchịchịrị",
  },
  pcm: {
    announcement:
      "Beta new chapter for women health. We build am with love for Nigeria.",
    preview_tag: "TESTING",
    nav_chapters: "Levels",
    nav_stories: "Stories",
    nav_journey: "The Journey",
    nav_learn: "Learn",
    nav_care: "How We Dey Do Am",
    nav_specialists: "Specialists",
    nav_ai: "Aisha AI",
    cta_meet: "Meet YanMata",
    hero_tag: "FROM 9 YEARS OLD TILL OLD AGE · ALL OVER NAIJA & AFRICA",
    hero_title_1: "You dey grow. You dey change.",
    hero_title_2: "Na still you.",
    hero_desc:
      "Your body get special rhythm. You deserve correct place to understand am well. Meet YanMata — your personal wellness buddy from age 9 to senior mama level.",
    hero_action_find: "Check App Stories",
    hero_action_explore: "Check your own level",
    trust_privacy: "Your secret na first priority (No need internet)",
    trust_designed: "Protection for small girls (Age 9+)",
    hero_note_1: "Small care, every single day.",
    hero_note_1_sub: "At your own pace.",
    hero_note_2: "Every level of you.",
    hero_note_2_sub: "You dey always welcome here.",
    hero_art_caption: "YOUR JOURNEY. YOUR OWN SPACE.",
    values_rooted: "Stand solid on WHO and FMOH rules",
    values_built: "Made for real Nigerian women life",
    values_private: "Complete secret · We no dey sell data",
    values_change: "Dey with you through every change",
    stories_eyebrow: "APP BLUEPRINT STORIES · FROM DESIGN PLAN",
    stories_title: "6 Solid Health Stories. One Connected Place.",
    stories_desc:
      "Every screen and feature inside YanMata dey built to solve real health matters wey Naija girls and women dey face every day.",
    stories_cta_journey: "See How To Register",
    stories_cta_ai: "Ask Aisha AI",
    tab_cycle: "Period Tracker",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Doctor Advice",
    tab_profile: "Health Profile",
    tab_mental: "Mind Peace",
    tab_care: "Verified Doctors",
    cycle_badge: "MAIN APP FEATURE",
    cycle_title: "Easy Period Tracking & Body Rhythm",
    cycle_lead:
      "Moving circular dial wey dey adjust to your period stage, how flow dey be, and body signals without any shame or judgment.",
    cycle_h1:
      "Know every stage of your period (Follicular, Ovulatory, Luteal, Menstrual)",
    cycle_h2: "Tap once to save how your body and mood dey do you",
    cycle_h3: "Safe for young girls (age 9+) without adult question",
    cycle_h4: "100% offline-ready storage inside your phone",
    ai_badge: "PLENTY LANGUAGES & 24/7",
    ai_title: "Aisha: Your AI Health Buddy Wey Understand Culture",
    ai_lead:
      "Sweet answers to your personal health questions in Pidgin, Hausa, Yoruba, Igbo, and English wey follow clinical medical rules.",
    ai_h1: "Chat freely in 5 Nigerian languages",
    ai_h2:
      "Clear boundaries: health education first, no be to write medicine carelessly",
    ai_h3: "Emergency guidance with Nigeria national number 112",
    ai_h4: "Zero monitoring: your chat remain strictly your secret",
    insights_badge: "NO FAKE RISK PERCENTAGE",
    insights_title: "Doctor Insights Based on WHO & FMOH Standards",
    insights_lead:
      "Personal health advice wey come from your 5 health pillars with real medical evidence from WHO and Nigeria Ministry of Health.",
    insights_h1: "Real clinical evidence wey you fit trace clearly",
    insights_h2:
      "Fit your exact age: screening for big woman, HPV info for young girl",
    insights_h3:
      "Protect small girls: no adult pregnancy warnings for ages 9–17",
    insights_h4: "Food and lifestyle advice wey match Naija food",
    profile_badge: "SAFE INSIDE YOUR PHONE",
    profile_title: "Full 5-Pillar Health Profile Wey Dey Encrypted",
    profile_lead:
      "Complete health record on: Period, Pregnancy History, Medical Conditions, Lifestyle, and Family Health. All dey locked safe for your phone.",
    profile_h1: "Structured 5-pillar questionnaire from the wireframe design",
    profile_h2: "Adjust to your age: skip adult questions for small girls",
    profile_h3: "SQLite outbox encryption wey no dey leak to internet",
    profile_h4: "Fit export summary show verified doctor inside app",
    mental_badge: "HEART & MIND CARE",
    mental_title: "Mental Health, Mood Check & Crisis Support",
    mental_lead:
      "Body hormones and life wahala dey affect mind. YanMata give you space to check your mood, breathe well to calm down, and direct helpline.",
    mental_h1: "Record your mood and heart feeling every day",
    mental_h2: "Calm breathing exercise wey medical research prove",
    mental_h3: "Emergency guidance with Nigeria national number 112",
    mental_h4: "Safe place without any shame for every woman",
    care_badge: "MDCN & NMCN VERIFIED",
    care_title: "Chat With Verified Doctors Inside App",
    care_lead:
      "Direct, private access to licensed women doctors and nurses across our network. No be computer alone.",
    care_h1: "100% doctors and nurses wey get MDCN and NMCN license",
    care_h2: "Private in-app messages with full security",
    care_h3: "Our rule: no hospital referral marketing or booking fee",
    care_h4: "Connected with YanMata maternal and women care",
    journey_eyebrow: "HOW TO JOIN INSIDE APP",
    journey_title: "With Respect, Complete Secret & Care From Day One",
    journey_desc:
      "Follow our wireframe steps: from first welcome to private health profile, doctor insights, and daily care companion.",
    journey_step_1: "1. Start Am",
    journey_step_1_sub:
      "First-time welcome for young girls from age 9 with gentle body knowledge without any pressure.",
    journey_tag_1: "Safe for Age 9+",
    journey_step_2: "2. Private Account",
    journey_step_2_sub:
      "Age check (9+) with offline password security and protection for children.",
    journey_tag_2: "Secret & Offline",
    journey_step_3: "3. Health Profile",
    journey_step_3_sub:
      "5 main pillars: Period, Pregnancy, Health Conditions, Lifestyle, and Family.",
    journey_tag_3: "5 Health Pillars",
    journey_step_4: "4. Doctor Advice",
    journey_step_4_sub:
      "Solid advice based on WHO and FMOH standards without fake percentage numbers.",
    journey_tag_4: "WHO / FMOH Standard",
    journey_step_5: "5. Daily Dashboard",
    journey_step_5_sub:
      "Greeting with your name, live period dial, Aisha AI 24/7, and real doctors.",
    journey_tag_5: "Everyday Companion",
    chapters_eyebrow: "LIFE DEY MOVE. CARE GAT MOVE TOO.",
    chapters_title: "Every level. Better understanding.",
    chapters_desc:
      "No be only one way to be woman. Find the care wey fit where you dey now.",
    chapters_cta: "Check your learning space",
    ch_label_0: "Small Girl Level",
    ch_years_0: "New beginning, at your own speed",
    ch_title_0: "Changing body. Place for all your questions.",
    ch_desc_0:
      "Start with body knowledge, self understanding and easy way to talk how you dey feel. Made for girls from age 9.",
    ch_label_1: "Growing Up Level",
    ch_years_1: "Finding your way and your own voice",
    ch_title_1: "Find your rhythm. Find your voice.",
    ch_desc_1:
      "Learn about period, feelings and everyday health for place wey respect your secret.",
    ch_label_2: "Big Woman Level",
    ch_years_2: "Care wey fit your daily hustle",
    ch_title_2: "Make room for yourself too.",
    ch_desc_2:
      "Your health dey important just like every other thing you dey do. Write your private journal freely.",
    ch_label_3: "Change Level",
    ch_years_3: "Your next level",
    ch_title_3: "Change deserve understanding.",
    ch_desc_3:
      "Cool place to learn about body change, check your health and yarn with specialist doctors.",
    ch_label_4: "Senior Mama Level",
    ch_years_4: "No age limit for care",
    ch_title_4: "Every single year. Every part of you.",
    ch_desc_4:
      "Stay connected to learning, comfort and support till old age with complete dignity.",
    voices_eyebrow: "REAL VOICES · ALL OVER NIGERIA & BEYOND",
    voices_title: "Why Naija Women and Doctors Trust YanMata",
    voices_desc:
      "Real stories from girls, mothers, and healthcare doctors wey dey use YanMata.",
    test_quote_1:
      "When my period first start, shame catch me to ask person for school. YanMata explain everything clean without any shame. Aisha AI answer my questions with sweet mind, and because my gist dey safe, I get peace of mind.",
    test_name_1: "Amina B.",
    test_title_1: "Student (Age 14) · Plateau, Nigeria",
    test_quote_2:
      "To track my irregular cycle dey give me headache before because other apps dey think say everybody na 28 days. YanMata five pillars capture my real health story, and the advice follow WHO standard, no be fake numbers.",
    test_name_2: "Zainab O.",
    test_title_2: "Architect (Age 28) · Abuja",
    test_quote_3:
      "As doctor wey dey practice for Nigeria, e sweet me well to see health app wey dey follow FMOH and MDCN guidelines strictly. YanMata dey keep patient secret, dey protect young girls, and dey connect women to real verified doctors.",
    test_name_3: "Dr. Fatima Aliyu",
    test_title_3: "Senior Women Doctor (MDCN Verified)",
    support_eyebrow: "SMALL TIME. BIG CARE.",
    support_title: "Place wey be your own.",
    support_desc:
      "Less tension. Better understanding. Useful tools for your everyday health.",
    support_track_title: "Check in with yourself.",
    support_track_desc:
      "Personal journal for your mood and daily life. You no need write perfect grammar.",
    support_mood_question: "HOW YOU DEY FEEL TODAY?",
    mood_great: "Very Great",
    mood_good: "Good",
    mood_okay: "Okay",
    mood_low: "Low",
    support_mood_caption: "Small moment, just for you.",
    support_learn_title: "Understand your body well well.",
    support_learn_desc:
      "Learn things wey match your life, with real medical sources and doctor check.",
    support_stack_1_title: "Your body, your questions",
    support_stack_1_tag: "BODY KNOWLEDGE",
    support_stack_2_title: "Space for your feelings",
    support_stack_2_tag: "MIND HEALTH",
    support_care_title: "Verified Doctors Inside App.",
    support_care_desc:
      "Connect directly with verified women doctors and nurses across our network secretly and with respect.",
    support_convo_q: "Some questions need person wey go listen well.",
    support_convo_a: "And real doctor wey go give correct answer.",
    support_care_badge: "MDCN & NMCN Verified · In-App Care",
    learn_eyebrow: "THE LEARNING ROOM",
    learn_title: "Small knowledge. Big confidence.",
    learn_desc: "Take deep breath. Find something good for you.",
    learn_notice:
      "Testing sample articles. Medical facts follow WHO & FMOH rules.",
    learn_card_meta: "SAMPLE · SOURCES FROM WHO/FMOH",
    learn_loading: "We dey prepare the learning room.",
    learn_retry: "Try Again",
    learn_error:
      "Learning room no dey available now. Abeg try again small time.",
    privacy_pill: "Your story na your own alone.",
    privacy_eyebrow: "SECRET NA REAL SECRET.",
    privacy_title: "Your health. Your boundary.",
    privacy_desc:
      "We build YanMata on top trust. Dat mean correct permission, private experience and power over wetin you share.",
    privacy_b1: "No account needed to read learning topics",
    privacy_b2: "Private journal wey dey work without internet",
    privacy_b3: "Care wey fit your age, from 9 till old mama",
    privacy_cta: "Read our privacy method",
    specialists_eyebrow: "VERIFIED DOCTORS NETWORK",
    specialists_title: "Qualified guidance. No be computer alone.",
    specialists_lead:
      "From our first pilot roll-out to all over Naija and Africa, YanMata dey connect women and girls directly to verified doctors and nurses wey register with MDCN and NMCN.",
    specialists_badge: "MDCN / NMCN Verified",
    specialists_note:
      "Doctor support for YanMata na secret inside this app. YanMata no dey do hospital referral or sell doctor booking.",
    faq_eyebrow: "THINGS WEY YOU FIT DEY WONDER",
    faq_title: "Make we answer all your questions.",
    faq_q1: "Who YanMata dey for?",
    faq_a1:
      "Girls and women from 9 years old till old age. The app dey adapt to your exact level with strong protection for small girls: ages 9–17 dey get body education without adult pregnancy question.",
    faq_q2: "How YanMata dey protect my secret health gist?",
    faq_a2:
      "Secret na our main foundation. YanMata dey work offline: your period records and 5 health pillars dey locked inside your phone. We no dey sell user data or share with third party at all.",
    faq_q3: "The doctor advice follow real science?",
    faq_a3:
      "Yes well well. YanMata no dey manufacture fake percentage numbers. Every single advice get strong source from World Health Organization (WHO) and Nigeria Ministry of Health (FMOH).",
    faq_q4: "How to yarn with doctor dey work for YanMata?",
    faq_a4:
      "Verified doctors and nurses with MDCN and NMCN license dey answer your question inside app in secret. Our rule: YanMata no dey book hospital bed — support dey inside app only.",
    faq_q5: "I fit ask Aisha AI in my own language?",
    faq_a5:
      "Aisha dey show educational answers for Pidgin, Hausa, Yoruba, Igbo and English. For emergency in Nigeria, call 112.",
    faq_q6: "When I fit use the mobile app for my phone?",
    faq_a6:
      "We dey actively build the Flutter app for Android and iOS. We dey run our pilot first before public store release.",
    closing_eyebrow: "YOU DESERVE TO DEY UNDERSTOOD.",
    closing_title:
      "We dey here for the woman wey you be now. And the one wey you dey become.",
    closing_desc:
      "Built with pure care by Zentreeca. Made with love for Nigeria, for Africa and the whole world.",
    closing_cta: "About our pilot rollout",
    footer_tagline: "Every level of you.",
    footer_disclaimer: "Development preview · No be hospital emergency service",
    modal_privacy_title: "Your trust na part of our design.",
    modal_privacy_body:
      "This preview dey give you anonymous learning. Mobile app dey store your journal locked for your phone, and we no dey upload anything unless you say make we do so.",
    modal_pilot_title: "Starting with care. Scaling across Nigeria and Africa.",
    modal_pilot_body:
      "We dey build YanMata for girls and women from 9 years old till old age. Our pilot dey supported by real Nigerian doctors and nurses, and we design am to reach all Nigeria and Africa. This na development preview, no be hospital referral.",
    modal_article_demo_notice:
      "Testing sample article. No be clinical prescription. Timestamps na sample.",
    modal_article_source: "Medical source: World Health Organization (WHO) ↗",
    ai_modal_title: "Ask Aisha AI",
    ai_modal_desc:
      "Private 24/7 educational advice on women health, period, and heart peace.",
    ai_placeholder:
      "Type your question in Pidgin, Hausa, Yoruba, Igbo, or English...",
    ai_disclaimer:
      "Aisha na learning assistant. For emergency in Nigeria, call 112.",
    theme_light: "Light",
    theme_dark: "Dark",
  },
};
