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
    hero_tag: "AGES 9 THROUGH LIFELONG CARE · JOS PILOT TO NATIONWIDE",
    hero_title_1: "Growing. Changing.",
    hero_title_2: "Always you.",
    hero_desc:
      "Your body has a rhythm. Your story deserves understanding. Meet YanMata — your private wellbeing companion from puberty at age 9 to motherhood, menopause, and lifelong health.",
    hero_action_find: "Explore App Stories",
    hero_action_explore: "Explore your chapter",
    trust_privacy: "Privacy comes first (Offline-first)",
    trust_designed: "Minor safeguarding (Ages 9+)",
    values_rooted: "Rooted in clinical guidelines (WHO & FMOH)",
    values_built: "Built for real Nigerian lives",
    values_private: "Private by design · No data sold",
    values_change: "With you, through every change",
    chapters_eyebrow: "LIFE DOESN’T STAND STILL. NEITHER DOES CARE.",
    chapters_title: "Every chapter. A little more understood.",
    chapters_desc:
      "There’s no single way to be a woman. Find the support that feels right for where you are.",
    stories_eyebrow: "THE BLUEPRINT STORIES · DESIGNER WIREFRAME",
    stories_title: "6 Core Health Stories. One Connected Space.",
    stories_desc:
      "Every screen and feature in YanMata was crafted from our designer blueprint to solve real, everyday healthcare challenges faced by Nigerian girls and women.",
    tab_cycle: "Cycle Rhythm",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Clinical Insights",
    tab_profile: "Health Profile",
    tab_mental: "Mental Wellbeing",
    tab_care: "Verified Care",
    journey_eyebrow: "THE WIREFRAME ACCOUNT JOURNEY",
    journey_title: "Dignified, Private & Personal From Day One",
    journey_desc:
      "Following our wireframe blueprint: from first-time launch to encrypted health profiling, personalized clinical insights, and daily proactive care.",
    journey_step_1: "1. Get Started",
    journey_step_1_sub:
      "First-time onboarding welcoming girls from age 9 onward with gentle body literacy and zero pressure.",
    journey_step_2: "2. Private Account",
    journey_step_2_sub:
      "Age-gated onboarding (ages 9+) with encrypted offline-first credentials and strict minor safeguarding.",
    journey_step_3: "3. Health Profile",
    journey_step_3_sub:
      "5 core health pillars: Menstrual, Reproductive, Medical, Lifestyle, and Family history.",
    journey_step_4: "4. Clinical Insights",
    journey_step_4_sub:
      "Evidence-based preventive recommendations grounded in WHO and FMOH Nigeria guidelines without fake percentages.",
    journey_step_5: "5. Daily Dashboard",
    journey_step_5_sub:
      "Personalized greeting, dynamic cycle dial, 24/7 Aisha AI companion, and in-platform specialist support.",
    voices_eyebrow: "REAL VOICES · JOS PILOT & NATIONWIDE",
    voices_title: "Why Nigerian Women & Clinicians Trust YanMata",
    voices_desc:
      "Authentic perspectives from girls, mothers, and healthcare professionals experiencing the YanMata platform.",
    support_eyebrow: "SMALL MOMENTS. MEANINGFUL CARE.",
    support_title: "A space that’s yours.",
    support_desc:
      "Less overwhelm. More understanding. Thoughtful tools for your everyday wellbeing.",
    ai_modal_title: "Ask Aisha AI",
    ai_modal_desc:
      "Private 24/7 educational guidance on women's reproductive health, cycle symptoms, and emotional wellbeing.",
    ai_placeholder:
      "Type a question in English, Hausa, Yoruba, Igbo, or Pidgin...",
    ai_disclaimer:
      "Aisha is an educational companion. In medical emergencies, contact SURPIN (0800 123 4567) or 112.",
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
    hero_tag: "SHEKARU 9 ZUWA KARSHE · DAGA JOS ZUWA DUKKAN NAJERIYA",
    hero_title_1: "Kina girma. Kina canzawa.",
    hero_title_2: "Kullum kanki ce.",
    hero_desc:
      "Jikinki yana da salon tafiyarsa. Kin cancanci wurin fahimtar sa. Sadu da YanMata — abokiyar tafiyarki ta samun lafiya daga shekaru 9 har zuwa girma.",
    hero_action_find: "Duba Ayyukan Manhaja",
    hero_action_explore: "Duba matakinki",
    trust_privacy: "Sirrinki na farko (Babu yanar gizo ma)",
    trust_designed: "Kariya ga yara (Shekaru 9+)",
    values_rooted: "Tushe a ka'idojin WHO da FMOH",
    values_built: "Don rayuwar matan Najeriya",
    values_private: "Sirri mai aminci · Ba a sayar da bayanai",
    values_change: "Tare da ke a kowane canji",
    chapters_eyebrow: "RAYUWA NA TAFIYA. HAKA KUMA KULA.",
    chapters_title: "Kowane mataki. Cikakkiyar fahimta.",
    chapters_desc:
      "Babu hanya daya kacal ta zama mace. Nemo kulawar da ta dace da matakin da kike ciki.",
    stories_eyebrow: "TSARIN MANHAJA · DAGA ZANEN ASALI",
    stories_title: "Muhimman Labarai 6. Wuri Guda Mai Hadaka.",
    stories_desc:
      "Kowane allo a YanMata an tsara shi ne don magance ainihin matsalolin lafiya da 'yan mata da matan Najeriya ke fuskanta.",
    tab_cycle: "Kula da Haila",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Bayanin Likitanci",
    tab_profile: "Bayanin Lafiya",
    tab_mental: "Natsuwar Hankali",
    tab_care: "Kwararrun Likitoci",
    journey_eyebrow: "TAFIYAR BUDE ASUSU A MANHAJA",
    journey_title: "Cike da Daraja, Sirri da Fahimta Daga Farko",
    journey_desc:
      "Biyo tsarin da aka zana: daga farkon shiga har zuwa cikakken bayanin lafiya a asirce, shawarwari masu amfani, da kulawa ta kullum.",
    journey_step_1: "1. Fara Amfani",
    journey_step_1_sub:
      "Barka da zuwa ga 'yan mata daga shekaru 9 da ilimin jiki a saukake ba tare da tsangwama ba.",
    journey_step_2: "2. Asusun Sirri",
    journey_step_2_sub:
      "Tabbatar da shekaru (9+) da boye bayanai a asirce koda babu intanet.",
    journey_step_3: "3. Bayanan Lafiya",
    journey_step_3_sub:
      "Rukunai 5 masu muhimmanci: Haila, Haihuwa, Magunguna, Yanayin Rayuwa, da Tarihin Iyali.",
    journey_step_4: "4. Shawarwarin Lafiya",
    journey_step_4_sub:
      "Ingantattun shawarwari bisa ka'idojin WHO da Ma'aikatar Lafiya ta Najeriya ba tare da lissafin karya ba.",
    journey_step_5: "5. Allon Kulawa",
    journey_step_5_sub:
      "Gaisuwa ta musamman da sunanki, lissafin ranar haila, Aisha AI 24/7, da likitocin asali a cikin manhaja.",
    voices_eyebrow: "AINAIN MURYOYI · MATUKAR KULA DAGA JOS",
    voices_title: "Dalilin da Matan Najeriya Suka Yarda da YanMata",
    voices_desc:
      "Gaskiyar labarai daga 'yan mata, iyaye mata, da kwararrun likitocin da ke aiki a YanMata.",
    support_eyebrow: "LOKACI KADAN. BABBAN TAIMAKO.",
    support_title: "Wuri na musamman a gare ki.",
    support_desc:
      "Rage damuwa. Samun natsuwa. Kayan aiki masu amfani ga lafiyarki ta yau da kullum.",
    ai_modal_title: "Tambayi Aisha AI",
    ai_modal_desc:
      "Shawarwarin ilimin lafiya a asirce 24/7 game da haila, canjin jiki, da lafiyar hankali.",
    ai_placeholder: "Rubuta tambaya da Hausa ko wani harshe...",
    ai_disclaimer:
      "Aisha na koyarwa ne. Idan ciwo ya tsananta, kira SURPIN (0800 123 4567) ko 112.",
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
    hero_tag: "ỌDÚN 9 TÍTÍ D'ÒPIN · JOS SÍ GBOGBO NÀÌJÍRÍÀ",
    hero_title_1: "O ń dàgbà. O ń yípadà.",
    hero_title_2: "Ìwọ náà ni.",
    hero_desc:
      "Ara rẹ ní ìtàn tirẹ̀. O yẹ kí o ní ààyè láti mọ̀ nípa rẹ̀. Pàdé YanMata — olùrànlọ́wọ́ àlàáfíà rẹ láti ọmọ ọdún 9 títí dé gbogbo ìpele ayé.",
    hero_action_find: "Wo Àwọn Ìtàn Manhaja",
    hero_action_explore: "Wo ìpele rẹ",
    trust_privacy: "Àṣírí ló ṣe pàtàkì jù",
    trust_designed: "Ààbò fún àwọn ọmọdé (Ọdún 9+)",
    values_rooted: "Àwọn ìlànà WHO àti FMOH",
    values_built: "Fún àwọn obìnrin Nàìjíríà",
    values_private: "Àṣírí pípé · A kì í ta dátà",
    values_change: "A wà pẹ̀lú rẹ nínú àyípadà gbogbo",
    chapters_eyebrow: "AYÉ KÒ DÚRÓ. BẸ́Ẹ̀ NÀÁ NI ÌTỌ́JÚ.",
    chapters_title: "Gbogbo ìpele. Òye kíkún.",
    chapters_desc:
      "Kò sí ọ̀nà kan ṣoṣo láti jẹ́ obìnrin. Wá ìtìlẹ́yìn tó bá ibi tí o wà mu.",
    stories_eyebrow: "ÌTÀN ÀKỌ́KỌ́ · ÀWỌN ÀWÒRÁN MANHAJA",
    stories_title: "Àwọn Ìtàn Ìlera 6 Pàtàkì. Ààyè Ìṣọ̀kan Kan.",
    stories_desc:
      "Gbogbo àbájáde ní YanMata ni a kọ́ láti yanjú àwọn ìṣòro gidi tí àwọn obìnrin ń dojú kọ lójojúmọ́.",
    tab_cycle: "Nǹkan Oṣù",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Ìmọ̀ Ìlera",
    tab_profile: "Àkọsílẹ̀ Ìlera",
    tab_mental: "Àlàáfíà Ọkàn",
    tab_care: "Àwọn Oníṣègùn",
    journey_eyebrow: "ÌRÌN-ÀJÒ ÌFÚN-ORÚKỌ-SÍLẸ̀",
    journey_title: "Pẹ̀lú Ọlá, Àṣírí àti Ìtọ́jú Láti Ọjọ́ Àkọ́kọ́",
    journey_desc:
      "Bí a ṣe ṣe àtòlẹ́sẹẹsẹ rẹ̀: láti ìbẹ̀rẹ̀ pẹ̀pẹ̀ dé orí àkọsílẹ̀ ìlera, ìmọ̀ tó péye, àti ìtọ́jú ojoojúmọ́.",
    journey_step_1: "1. Ìbẹ̀rẹ̀",
    journey_step_1_sub:
      "Àkọ́wọ́lé pẹ̀lú ọ̀wọ̀ fún àwọn ọmọbìnrin láti ọmọ ọdún 9 láìsí ìtìjú kankan.",
    journey_step_2: "2. Àkọọ́lẹ̀ Àṣírí",
    journey_step_2_sub:
      "Ìmúdájú ọjọ́ orí (9+) àti àkọsílẹ̀ tí a fi pa mọ́ dáadáa láìsí intanẹ́ẹ̀tì.",
    journey_step_3: "3. Àkọsílẹ̀ Ìlera",
    journey_step_3_sub:
      "Àwọn apá 5 pàtàkì: Nǹkan Oṣù, Ìbímọ, Ìtọ́jú Àrùn, Ìgbé-ayé, àti Ìtàn Ìdílé.",
    journey_step_4: "4. Ìmọ̀ Ìlera Rẹ",
    journey_step_4_sub:
      "Àwọn ìmọ̀ràn tó wúlò tí a gbé karí ìlànà WHO àti FMOH Nàìjíríà.",
    journey_step_5: "5. Ojú-ewé Ìtọ́jú",
    journey_step_5_sub:
      "Kíka orúkọ rẹ gangan lónìí, àkókò nǹkan oṣù, Aisha AI 24/7, àti àwọn dọ́kítà inu manhaja.",
    voices_eyebrow: "ÀWỌN OHÙN TÒÓTỌ́ · JOS SÍ NÀÌJÍRÍÀ",
    voices_title: "Ìdí Tí Àwọn Obìnrin Nàìjíríà Fi Gbẹ́kẹ̀ Lé YanMata",
    voices_desc:
      "Àwọn ìtàn tòótọ́ láti ọ̀dọ̀ àwọn ọmọbìnrin, àwọn ìyá, àti àwọn dọ́kítà tó ń ṣiṣẹ́ ní YanMata.",
    support_eyebrow: "ÀKÓKÒ KÉKERÉ. ÌTỌ́JÚ PÚPỌ̀.",
    support_title: "Ààyè tó jẹ́ tìrẹ nìkan.",
    support_desc:
      "Dín ìnira kù. Ní àlàáfíà ọkàn. Àwọn ohun èlò tí a fi tọ́jú rẹ lónìí.",
    ai_modal_title: "Béèrè lọ́wọ́ Aisha AI",
    ai_modal_desc:
      "Ìrànlọ́wọ́ ẹ̀kọ́ lórí nǹkan oṣù àti ilera pẹ̀lú àṣírí ní gbogbo ìgbà.",
    ai_placeholder: "Kọ ìbéèrè rẹ ní Èdè Yorùbá tàbí èdè míràn...",
    ai_disclaimer:
      "Fún ẹ̀kọ́ nìkan ni Aisha wà. Tí ara bá le, pe SURPIN (0800 123 4567) tàbí 112.",
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
    hero_tag: "AFỌ 9 RUO Ọ GWỤCHA · JOS RUO NIGERIA NIILE",
    hero_title_1: "Ị na-eto. Ị na-agbanwe.",
    hero_title_2: "Ọ bụ gị mgbe niile.",
    hero_desc:
      "Ahụ gị nwere usoro nke ya. O kwesịrị ka ị nwee ohere ịghọta ya. Zute YanMata — enyi ahụike gị site n'afọ 9 ruo n'oge agadi.",
    hero_action_find: "Lee Akụkọ Ngwa",
    hero_action_explore: "Nyochaa oge ndụ gị",
    trust_privacy: "Nzuzo na-abịa na mbụ",
    trust_designed: "Nchedo maka ụmụaka (Afọ 9+)",
    values_rooted: "Usoro WHO na FMOH",
    values_built: "Maka ụmụ nwanyị Nigeria",
    values_private: "Nzuzo zuru oke · Ọ dịghị ere data",
    values_change: "Nọnyeere gị n’ mgbanwe ọ bụla",
    chapters_eyebrow: "NDỤ ANAGHỊ AKWỤSỊ AKWỤSỊ. NLEKỌTA ANAGHỊ AKWỤSỊKWA.",
    chapters_title: "Oge ọ bụla. Aghọtara nke ọma.",
    chapters_desc:
      "Enweghị otu ụzọ naanị iji bụrụ nwanyị. Chọta nkwado dabara n’ebe ị nọ.",
    stories_eyebrow: "ATỤMATỤ NGWA · AKỤKỌ NDỊ PỤRỤ ICHE",
    stories_title: "Akụkọ Ahụike 6 Dị Mkpa. Otu Ebe Ejikọtara.",
    stories_desc:
      "Ihe niile dị na YanMata ka e mere iji dozie ezigbo nsogbu ahụike ụmụ agbọghọ na ụmụ nwanyị na-ezute kwa ụbọchị.",
    tab_cycle: "Oge Nsọ",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Nghọta Ọgwụgwọ",
    tab_profile: "Nkọwa Ahụike",
    tab_mental: "Udo nke Uche",
    tab_care: "Ndị Ọkachamara",
    journey_eyebrow: "NJEM NDEBANYE AHA NGWA",
    journey_title: "Nkwanye Ùgwù, Nzuzo na Nlekọta Pụrụ Iche",
    journey_desc:
      "Site na mbido rue n'inweta ndụmọdụ ahụike ziri ezi na nlekọta nke kwa ụbọchị.",
    journey_step_1: "1. Malite Ebe A",
    journey_step_1_sub:
      "Nnabata maka ụmụ agbọghọ site n'afọ 9 n'enweghị ihere ma ọ bụ nchekasị.",
    journey_step_2: "2. Akaụntụ Nzuzo",
    journey_step_2_sub:
      "Nkwenye afọ (9+) na nchekwa nzuzo ọbụlagodi na enweghị intaneti.",
    journey_step_3: "3. Nkọwa Ahụike",
    journey_step_3_sub:
      "Akụkụ 5: Oge Nsọ, Ịmụ Nwa, Ahụike Ọgwụ, Ụdị Ndụ, na Ezinụlọ.",
    journey_step_4: "4. Ezi Ndụmọdụ",
    journey_step_4_sub:
      "Ndụmọdụ ahụike dabeere n'ụkpụrụ WHO na FMOH Nigeria na-enweghị nọmba ụgha.",
    journey_step_5: "5. Ebe Nlekọta Gị",
    journey_step_5_sub:
      "Ekele nke aha gị, nlekọta oge nsọ, Aisha AI 24/7, na ndị dọkịta n'ime ngwa.",
    voices_eyebrow: "EZI OLU · JOS RUO NIGERIA NIILE",
    voices_title: "Ihe Mere Ụmụ Nwanyị Nigeria Ji Tụkwasị YanMata Obi",
    voices_desc:
      "Ezi akụkọ sitere n'aka ụmụ agbọghọ, ndị nne, na ndị dibịa bekee na-arụ ọrụ na YanMata.",
    support_eyebrow: "OGE NTA. EZI NLEKỌTA.",
    support_title: "Ebe bụ nke gị.",
    support_desc:
      "Belata nchekasị. Nwekwuo nghọta. Ngwa nlekọta maka ahụike gị kwa ụbọchị.",
    ai_modal_title: "Jụọ Aisha AI",
    ai_modal_desc: "Enyemaka nzuzo banyere oge nsọ na ahụike n’oge ọ bụla.",
    ai_placeholder: "Dee ajụjụ gị n’Asụsụ Igbo ma ọ bụ n’asụsụ ọzọ...",
    ai_disclaimer:
      "Aisha bụ maka mmụta. N’oge mberede, kpọọ SURPIN (0800 123 4567) ma ọ bụ 112.",
    theme_light: "Ìhè",
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
    hero_tag: "FROM 9 YEARS OLD TILL OLD AGE · JOS PILOT TO ALL NAIJA",
    hero_title_1: "You dey grow. You dey change.",
    hero_title_2: "Na still you.",
    hero_desc:
      "Your body get special rhythm. You deserve correct place to understand am well. Meet YanMata — your personal wellness buddy from age 9 to senior mama level.",
    hero_action_find: "Check App Stories",
    hero_action_explore: "Check your stage",
    trust_privacy: "Secret dey first (Even without internet)",
    trust_designed: "Small pikin safety (From 9 years)",
    values_rooted: "Grounded in WHO & FMOH guidelines",
    values_built: "Built for real Naija women",
    values_private: "Top secret level · We no dey sell data",
    values_change: "We dey with you as body dey change",
    chapters_eyebrow: "LIFE NO DEY WAIT. CARE NO SUPPOSE WAIT.",
    chapters_title: "Every life stage. You go understand am well.",
    chapters_desc:
      "No be only one way dey to be woman. Find correct care wey match your exact level.",
    stories_eyebrow: "THE BLUEPRINT TORI · DESIGNER WIREFRAME",
    stories_title: "6 Correct Health Stories. One Sweet Place.",
    stories_desc:
      "Every screen inside YanMata dey answer real problem wey Naija girls and women dey face everyday.",
    tab_cycle: "Period Rhythm",
    tab_ai: "Aisha AI 24/7",
    tab_insights: "Doctor Insights",
    tab_profile: "Health Profile",
    tab_mental: "Peace of Mind",
    tab_care: "Real Doctors",
    journey_eyebrow: "HOW YOU DEY JOIN YANMATA",
    journey_title: "Respect, Privacy & Better Care From Day One",
    journey_desc:
      "As e dey for our wireframe blueprint: from first time download to safe health profile, personalized doctor insights, and daily health tracking.",
    journey_step_1: "1. Start Am",
    journey_step_1_sub:
      "Gentle welcome for young girls from age 9 without shame or fear.",
    journey_step_2: "2. Secret Account",
    journey_step_2_sub:
      "Check age (9+) with top security and offline check-in even when data finish.",
    journey_step_3: "3. Health Profile",
    journey_step_3_sub:
      "5 key areas: Period, Pregnancy, Health History, Daily Habits, and Family Health.",
    journey_step_4: "4. Correct Insights",
    journey_step_4_sub:
      "Original medical advice from WHO and Federal Ministry of Health without fake numbers.",
    journey_step_5: "5. Daily Dashboard",
    journey_step_5_sub:
      "Good day greeting with your name, cycle dial, 24/7 Aisha AI, and direct specialist chat inside app.",
    voices_eyebrow: "REAL NAIJA STORIES · JOS PILOT TO NATIONWIDE",
    voices_title: "Why Naija Women and Doctors Trust YanMata",
    voices_desc:
      "True tori from young girls, mothers, and licensed Nigerian doctors wey dey inside YanMata.",
    support_eyebrow: "SMALL SMALL TIME. CORRECT CARE.",
    support_title: "Place wey be your own.",
    support_desc:
      "No more confusion. Better peace of mind. Easy tools for your everyday health.",
    ai_modal_title: "Ask Aisha AI",
    ai_modal_desc:
      "Secret guide wey go explain period, cramps and wellness give you 24/7.",
    ai_placeholder: "Type your question in Pidgin or any language...",
    ai_disclaimer:
      "Aisha na to learn. If bodi dey pain you die, call SURPIN (0800 123 4567) or 112.",
    theme_light: "Light",
    theme_dark: "Dark",
  },
};
