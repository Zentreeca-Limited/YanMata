import { StrictMode, useEffect, useRef, useState } from "react";
import { createRoot } from "react-dom/client";
import {
  ArrowUpRight,
  ArrowRight,
  Heart,
  ShieldCheck,
  Sparkles,
  BookOpen,
  MessageCircle,
  Lock,
  WifiOff,
  ChevronRight,
  Leaf,
  X,
  Plus,
  Minus,
  Menu,
  Globe,
  Moon,
  Sun,
  Send,
  AlertCircle,
  Activity,
  Calendar,
  Smile,
  CheckCircle2,
  UserCheck,
  Compass,
} from "lucide-react";
import { Brand, Tag, api, type Article, type Specialist } from "@yanmata/ui";
import { LANGUAGES, translations, type Language } from "./i18n";
import "@yanmata/ui/styles.css";
import "./styles.css";

const stories = [
  {
    id: "cycle",
    tabKey: "tab_cycle",
    icon: Calendar,
    title: "Intuitive Cycle Rhythm & Period Tracking",
    badge: "CORE WIREFRAME FEATURE",
    lead: "A dynamic visual dial that adapts to your phase, flow, symptoms, and rhythm. Designed without judgment, predicting your next cycle while respecting natural irregularity.",
    highlights: [
      "Dynamic cycle phase visualization (Follicular, Ovulatory, Luteal, Menstrual)",
      "One-tap symptom, mood, and flow logging",
      "Age-appropriate tracking: safe for young adolescents (ages 9+) without adult fertility prompts",
      "100% offline-ready encrypted storage with zero cloud tracking",
    ],
    image: "/screens/today.png",
    alt: "YanMata mobile app cycle rhythm dial and daily care overview",
  },
  {
    id: "ai",
    tabKey: "tab_ai",
    icon: Sparkles,
    title: "Aisha: Your Culturally Grounded AI Wellbeing Companion",
    badge: "MULTILINGUAL & 24/7",
    lead: "Empathetic, judgment-free answers to your intimate health questions in English, Hausa, Yoruba, Igbo, and Nigerian Pidgin. Rooted in clinical guidelines with built-in emergency safeguarding.",
    highlights: [
      "Conversational empathy in 5 Nigerian languages",
      "Strict clinical boundaries: educational guidance, not automated prescribing",
      "Automatic mental health crisis triage (SURPIN Nigeria 0800 123 4567 & 112)",
      "Zero telemetry: your questions and conversations stay completely private",
    ],
    image: "/screens/ai.png",
    alt: "Aisha AI companion interactive conversation in Nigerian context",
  },
  {
    id: "insights",
    tabKey: "tab_insights",
    icon: Activity,
    title: "Evidence-Based Clinical Insights (WHO & FMOH Nigeria)",
    badge: "NO FAKE RISK SCORES",
    lead: "Personalized preventive health advice generated from your 5-pillar health profile. Every insight includes traceable medical evidence from WHO and Federal Ministry of Health Nigeria guidelines.",
    highlights: [
      "Traceable citations and evidence level (High, Moderate)",
      "Life-stage specific: cervical screening for adults, HPV education for teens",
      "Strict minor safeguarding: excludes adult reproductive warnings for ages 9–17",
      "Proactive lifestyle and nutrition recommendations tailored to local Nigerian diets",
    ],
    image: "/screens/insights.png",
    alt: "Evidence-based preventive health insights with WHO and FMOH citations",
  },
  {
    id: "profile",
    tabKey: "tab_profile",
    icon: UserCheck,
    title: "Comprehensive 5-Pillar Encrypted Health Profile",
    badge: "LOCAL ENCRYPTED STORAGE",
    lead: "A complete clinical baseline built around five pillars: Menstrual Rhythm, Reproductive History, Medical Conditions, Lifestyle, and Family History. Encrypted locally and synchronized securely.",
    highlights: [
      "Structured 5-pillar assessment from the wireframe onboarding flow",
      "Age-adapted forms: skips unnecessary adult questions for adolescents",
      "Local SQLite outbox encryption with zero unauthorized cloud sharing",
      "Exportable summary for your in-platform specialist consultations",
    ],
    image: "/screens/profile.png",
    alt: "YanMata 5-pillar encrypted health profile overview",
  },
  {
    id: "mental",
    tabKey: "tab_mental",
    icon: Smile,
    title: "Integrated Mental Health, Mood & Crisis Support",
    badge: "EMOTIONAL CARE",
    lead: "Hormones, life stress, and reproductive milestones profoundly impact emotional wellbeing. YanMata provides daily mood check-ins, mindful breathing exercises, and instant crisis hotlines.",
    highlights: [
      "Daily mood and emotional rhythm logging with somatic check-ins",
      "Evidence-based somatic calming and guided breathing exercises",
      "Immediate emergency support with SURPIN Nigeria helpline integration",
      "Safe, stigma-free space designed for young girls and mature women alike",
    ],
    image: "/screens/mental.png",
    alt: "YanMata mental health mood tracking and breathing exercises",
  },
  {
    id: "care",
    tabKey: "tab_care",
    icon: MessageCircle,
    title: "Verified In-Platform Specialist Consultations (Jos Pilot)",
    badge: "MDCN & NMCN VERIFIED",
    lead: "Direct, asynchronous, confidential access to licensed gynecologists, reproductive health nurses, and maternal health experts in our Jos pilot hub. Never an algorithm alone.",
    highlights: [
      "100% credential-checked specialists verified with MDCN and NMCN",
      "Confidential in-app messaging with end-to-end audit trail",
      "Strict clinical boundaries: no fake hospital referrals or external booking",
      "Integrated with YanMata maternal & reproductive health services",
    ],
    image: "/screens/services.png",
    alt: "In-platform verified specialist consultations and health services",
  },
];

const journeySteps = [
  {
    step: 1,
    titleKey: "journey_step_1",
    subKey: "journey_step_1_sub",
    tag: "Ages 9+ Safe",
    icon: Compass,
  },
  {
    step: 2,
    titleKey: "journey_step_2",
    subKey: "journey_step_2_sub",
    tag: "Encrypted & Offline",
    icon: Lock,
  },
  {
    step: 3,
    titleKey: "journey_step_3",
    subKey: "journey_step_3_sub",
    tag: "5 Health Pillars",
    icon: Activity,
  },
  {
    step: 4,
    titleKey: "journey_step_4",
    subKey: "journey_step_4_sub",
    tag: "WHO / FMOH Guidelines",
    icon: ShieldCheck,
  },
  {
    step: 5,
    titleKey: "journey_step_5",
    subKey: "journey_step_5_sub",
    tag: "Daily Companion",
    icon: Heart,
  },
];

const testimonials = [
  {
    quote:
      "When I first started my period, I was too shy to ask anyone at school. YanMata explained everything to me in Hausa without making me feel ashamed. Aisha AI answered my questions kindly, and knowing my details are private made me feel safe.",
    name: "Amina B.",
    title: "Student (Age 14) · Jos, Plateau State",
    avatar: "A",
  },
  {
    quote:
      "Tracking my irregular cycles used to be stressful because every app assumed a standard 28-day cycle. YanMata's 5-pillar health profile captured my medical history, and the clinical insights actually cited WHO guidelines instead of showing random panic numbers.",
    name: "Zainab O.",
    title: "Architect (Age 28) · Abuja (Jos Pilot Participant)",
    avatar: "Z",
  },
  {
    quote:
      "As a physician practicing in Plateau State, seeing a health platform that adheres strictly to FMOH Nigeria guidelines and MDCN verification standards is refreshing. YanMata respects patient privacy, maintains minor safeguarding, and connects patients to verified clinicians responsibly.",
    name: "Dr. Fatima Aliyu",
    title: "Consultant Gynecologist (MDCN Verified) · Jos",
    avatar: "F",
  },
];

const chapters = [
  {
    label: "Puberty",
    years: "A beginning, at your pace",
    title: "A changing body. A space for every question.",
    description:
      "Start with body literacy, self-understanding and simple ways to express how you feel. Designed for girls from age 9.",
    icon: "✳",
  },
  {
    label: "Adolescence",
    years: "Growing into yourself",
    title: "Finding your rhythm. Finding your voice.",
    description:
      "Explore periods, emotions and everyday wellbeing in a space that respects your privacy and your questions.",
    icon: "◌",
  },
  {
    label: "Adulthood",
    years: "Care that fits your life",
    title: "Make room for yourself, too.",
    description:
      "Your wellbeing belongs alongside everything else you do. Build a personal journal and explore the topics that matter to you.",
    icon: "❋",
  },
  {
    label: "Menopause",
    years: "Your next chapter",
    title: "Change deserves understanding.",
    description:
      "A thoughtful place for learning about transitions, reflecting on your wellbeing and connecting with specialists.",
    icon: "☼",
  },
  {
    label: "Later life",
    years: "No age limit on care",
    title: "Every year. Every part of you.",
    description:
      "Stay connected to learning, comfort and support through later life and end-of-life wellbeing. Always with dignity.",
    icon: "❀",
  },
];

function App() {
  const [chapter, setChapter] = useState(0);
  const [activeStory, setActiveStory] = useState(0);
  const [articles, setArticles] = useState<Article[]>([]);
  const [specialists, setSpecialists] = useState<Specialist[]>([]);
  const [error, setError] = useState("");
  const [selected, setSelected] = useState<Article | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [faq, setFaq] = useState<number | null>(0);
  const [menu, setMenu] = useState(false);
  const [lang, setLang] = useState<Language>("en");
  const [theme, setTheme] = useState<"light" | "dark">("light");
  const [aiOpen, setAiOpen] = useState(false);
  const [aiPrompt, setAiPrompt] = useState("");
  const [aiReply, setAiReply] = useState<string | null>(null);
  const [aiEmergency, setAiEmergency] = useState(false);
  const [aiLoading, setAiLoading] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  const aiDialog = useRef<HTMLDialogElement>(null);

  const t = translations[lang] || translations.en;

  useEffect(() => {
    document.documentElement.setAttribute("data-theme", theme);
  }, [theme]);

  useEffect(() => {
    if (aiOpen) aiDialog.current?.showModal();
    else aiDialog.current?.close();
  }, [aiOpen]);

  const load = () => {
    setError("");
    api<{ data: Article[] }>("/content")
      .then((r) => setArticles(r.data))
      .catch(() =>
        setError(
          "The learning library is temporarily unavailable. Please try again.",
        ),
      );
    api<{ data: Specialist[] }>("/specialists")
      .then((r) => setSpecialists(r.data))
      .catch(() => {});
  };
  useEffect(load, []);
  useEffect(() => {
    if (selected || info) dialog.current?.showModal();
    else dialog.current?.close();
  }, [selected, info]);
  const close = () => {
    setSelected(null);
    setInfo(null);
  };

  const askAi = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!aiPrompt.trim() || aiLoading) return;
    setAiLoading(true);
    setAiReply(null);
    setAiEmergency(false);
    try {
      const res = await api<{
        data: {
          reply: string;
          is_emergency: boolean;
        };
      }>("/ai/companion/chat", {
        method: "POST",
        body: JSON.stringify({ prompt: aiPrompt, language: lang }),
      });
      setAiReply(res.data.reply);
      setAiEmergency(res.data.is_emergency);
    } catch {
      setAiReply(
        "Aisha AI is temporarily unavailable. Please try again shortly.",
      );
    } finally {
      setAiLoading(false);
    }
  };

  return (
    <>
      <a className="skip" href="#main">
        Skip to content
      </a>
      <div className="announcement">
        <span className="dot" /> {t.announcement}{" "}
        <span className="demo-label">{t.preview_tag}</span>
      </div>
      <header className="header">
        <Brand />
        <nav className={menu ? "open" : ""} aria-label="Main navigation">
          <a onClick={() => setMenu(false)} href="#stories">
            {t.nav_stories || "App Stories"}
          </a>
          <a onClick={() => setMenu(false)} href="#journey">
            {t.nav_journey || "The Journey"}
          </a>
          <a onClick={() => setMenu(false)} href="#chapters">
            {t.nav_chapters}
          </a>
          <a onClick={() => setMenu(false)} href="#voices">
            {t.voices_eyebrow || "Real Stories"}
          </a>
          <a onClick={() => setMenu(false)} href="#learn">
            {t.nav_learn}
          </a>
          <a onClick={() => setMenu(false)} href="#care">
            {t.nav_care}
          </a>
          <a onClick={() => setMenu(false)} href="#specialists">
            {t.nav_specialists}
          </a>
          <button
            className="ai-nav-btn"
            style={{
              display: "inline-flex",
              alignItems: "center",
              gap: 6,
              cursor: "pointer",
              background: "none",
              border: "none",
              color: "var(--plum)",
              fontWeight: 600,
              fontSize: 13,
            }}
            onClick={() => {
              setMenu(false);
              setAiOpen(true);
            }}
          >
            <Sparkles size={15} color="var(--plum)" /> {t.nav_ai}
          </button>
        </nav>
        <div
          className="header-controls"
          style={{ display: "flex", alignItems: "center", gap: 10 }}
        >
          {/* Language Selector */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 4,
              background: "var(--lilac)",
              padding: "6px 10px",
              borderRadius: 20,
              fontSize: 13,
              color: "var(--plum)",
              fontWeight: 600,
            }}
          >
            <Globe size={14} />
            <select
              aria-label="Select language"
              value={lang}
              onChange={(e) => setLang(e.target.value as Language)}
              style={{
                background: "transparent",
                border: "none",
                color: "inherit",
                fontWeight: "inherit",
                cursor: "pointer",
                outline: "none",
                fontSize: "inherit",
              }}
            >
              {LANGUAGES.map((l) => (
                <option key={l.code} value={l.code}>
                  {l.native}
                </option>
              ))}
            </select>
          </div>
          {/* Theme Toggle */}
          <button
            className="theme-toggle"
            aria-label="Toggle theme"
            onClick={() => setTheme(theme === "light" ? "dark" : "light")}
            style={{
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              width: 36,
              height: 36,
              borderRadius: "50%",
              background: "var(--lilac)",
              border: "none",
              color: "var(--plum)",
              cursor: "pointer",
            }}
          >
            {theme === "light" ? <Moon size={16} /> : <Sun size={16} />}
          </button>
          <a className="button header-cta" href="#stories">
            {t.cta_meet} <ArrowUpRight />
          </a>
          <button
            className="menu-toggle"
            aria-label="Toggle navigation"
            aria-expanded={menu}
            onClick={() => setMenu(!menu)}
          >
            <Menu />
          </button>
        </div>
      </header>
      <main id="main">
        <section className="hero wrap">
          <div className="hero-copy">
            <Tag>
              <span className="tiny-flower">✳</span>{" "}
              {t.hero_tag ||
                "AGES 9 THROUGH LIFELONG CARE · JOS PILOT TO NATIONWIDE"}
            </Tag>
            <h1>
              {t.hero_title_1 || "Growing. Changing."}
              <br />
              <span className="serif">{t.hero_title_2 || "Always you."}</span>
              <svg viewBox="0 0 180 18" aria-hidden="true">
                <path
                  d="M4 13Q80-2 176 7"
                  stroke="#c8a9ce"
                  strokeWidth="5"
                  fill="none"
                  strokeLinecap="round"
                />
              </svg>
            </h1>
            <p>
              {t.hero_desc ||
                "Your body has a rhythm. Your story deserves understanding. Meet YanMata — your private wellbeing companion from puberty at age 9 to motherhood, menopause, and lifelong health."}
            </p>
            <div className="hero-actions">
              <a className="button" href="#stories">
                {t.hero_action_find || "Explore App Stories"} <ArrowUpRight />
              </a>
              <a className="text-link" href="#chapters">
                {t.hero_action_explore || "Explore your chapter"}{" "}
                <ArrowRight size={16} />
              </a>
            </div>
            <div className="hero-trust">
              <span>
                <ShieldCheck />{" "}
                {t.trust_privacy || "Privacy comes first (Offline-first)"}
              </span>
              <span>
                <Heart /> {t.trust_designed || "Minor safeguarding (Ages 9+)"}
              </span>
            </div>
          </div>
          <div
            className="hero-art"
            aria-label="Illustration of women across generations"
          >
            <div className="art-orbit orbit-one" />
            <div className="art-orbit orbit-two" />
            <span className="art-star star-one">✳</span>
            <span className="art-star star-two">✧</span>
            <div className="portrait">
              <WomenIllustration />
            </div>
            <div className="floating-note note-top">
              <span className="note-icon">
                <Leaf size={18} />
              </span>
              <div>
                A little care, every day.<small>At your own pace.</small>
              </div>
            </div>
            <div className="floating-note note-bottom">
              <span className="note-icon pink">
                <Heart size={20} />
              </span>
              <div>
                Every version of you.<small>Always welcome here.</small>
              </div>
            </div>
            <span className="art-caption">YOUR JOURNEY. YOUR SPACE.</span>
          </div>
        </section>
        <div className="values-strip">
          <span>
            {t.values_rooted || "Rooted in clinical guidelines (WHO & FMOH)"}
          </span>
          <i>✳</i>
          <span>{t.values_built || "Built for real Nigerian lives"}</span>
          <i>✳</i>
          <span>{t.values_private || "Private by design · No data sold"}</span>
          <i>✳</i>
          <span>{t.values_change || "With you, through every change"}</span>
        </div>

        {/* Stories Section: 6 Core Wireframe Features */}
        <section className="stories-section wrap" id="stories">
          <div className="section-heading">
            <div>
              <div className="eyebrow">
                {t.stories_eyebrow ||
                  "THE BLUEPRINT STORIES · DESIGNER WIREFRAME"}
              </div>
              <h2>
                {t.stories_title ||
                  "6 Core Health Stories. One Connected Space."}
              </h2>
            </div>
            <p>
              {t.stories_desc ||
                "Every screen and feature in YanMata was crafted from our designer blueprint to solve real, everyday healthcare challenges faced by Nigerian girls and women."}
            </p>
          </div>
          <div
            className="stories-tabs"
            role="tablist"
            aria-label="YanMata Core Stories"
          >
            {stories.map((s, idx) => {
              const Icon = s.icon;
              return (
                <button
                  key={s.id}
                  role="tab"
                  id={`story-tab-${idx}`}
                  aria-selected={activeStory === idx}
                  aria-controls="story-showcase-panel"
                  className={`story-tab-btn ${activeStory === idx ? "active" : ""}`}
                  onClick={() => setActiveStory(idx)}
                >
                  <Icon size={16} />
                  <span>{t[s.tabKey] || s.title}</span>
                </button>
              );
            })}
          </div>
          <div
            id="story-showcase-panel"
            role="tabpanel"
            aria-labelledby={`story-tab-${activeStory}`}
            className="story-showcase"
          >
            <div className="phone-mockup-wrapper">
              <div className="phone-mockup">
                <div className="phone-notch" />
                <img
                  src={stories[activeStory].image}
                  alt={stories[activeStory].alt}
                  className="phone-screen-img"
                  loading="lazy"
                />
              </div>
            </div>
            <div className="story-details">
              <span className="story-badge">
                <Sparkles size={12} /> {stories[activeStory].badge}
              </span>
              <h3>{stories[activeStory].title}</h3>
              <p className="story-lead">{stories[activeStory].lead}</p>
              <ul className="story-bullets">
                {stories[activeStory].highlights.map((h, i) => (
                  <li key={i}>
                    <CheckCircle2 size={18} />
                    <span>{h}</span>
                  </li>
                ))}
              </ul>
              <div className="story-action-row">
                <a className="button" href="#journey">
                  See Account Journey <ArrowRight size={16} />
                </a>
                <button
                  className="text-link"
                  style={{
                    background: "none",
                    border: "none",
                    cursor: "pointer",
                    display: "inline-flex",
                    alignItems: "center",
                    gap: 6,
                  }}
                  onClick={() => setAiOpen(true)}
                >
                  Ask Aisha AI <Sparkles size={14} />
                </button>
              </div>
            </div>
          </div>
        </section>

        {/* Wireframe Account Journey Section (5 steps) */}
        <section className="journey-section wrap" id="journey">
          <div className="section-heading">
            <div>
              <div className="eyebrow">
                {t.journey_eyebrow || "THE WIREFRAME ACCOUNT JOURNEY"}
              </div>
              <h2>
                {t.journey_title ||
                  "Dignified, Private & Personal From Day One"}
              </h2>
            </div>
            <p>
              {t.journey_desc ||
                "Following our wireframe blueprint: from first-time launch to encrypted health profiling, personalized clinical insights, and daily proactive care."}
            </p>
          </div>
          <div className="journey-steps">
            {journeySteps.map((j) => {
              const Icon = j.icon;
              return (
                <div className="journey-card" key={j.step}>
                  <div className="journey-number">{j.step}</div>
                  <div
                    style={{ display: "flex", alignItems: "center", gap: 8 }}
                  >
                    <Icon size={18} color="var(--plum)" />
                    <h4>{t[j.titleKey]}</h4>
                  </div>
                  <p>{t[j.subKey]}</p>
                  <span className="journey-tag">✓ {j.tag}</span>
                </div>
              );
            })}
          </div>
        </section>
        <section className="wrap chapters" id="chapters">
          <div className="section-heading">
            <div>
              <div className="eyebrow">
                LIFE DOESN’T STAND STILL. NEITHER DOES CARE.
              </div>
              <h2>
                Every chapter.
                <br />
                <span className="serif">A little more understood.</span>
              </h2>
            </div>
            <p>
              There’s no single way to be a woman.
              <br />
              Find the support that feels right for where you are.
            </p>
          </div>
          <div
            className="chapter-tabs"
            role="tablist"
            aria-label="Life chapters"
          >
            {chapters.map((c, i) => (
              <button
                key={c.label}
                role="tab"
                id={`tab-${i}`}
                aria-selected={chapter === i}
                aria-controls="chapter-panel"
                onClick={() => setChapter(i)}
              >
                {c.label}
                <span>{c.icon}</span>
              </button>
            ))}
          </div>
          <div
            id="chapter-panel"
            role="tabpanel"
            aria-labelledby={`tab-${chapter}`}
            className="chapter-panel"
          >
            <div className="chapter-visual">
              <span className="large-flower">{chapters[chapter].icon}</span>
              <span className="chapter-visual-label">
                {chapters[chapter].years}
              </span>
              <div className="chapter-ring" />
            </div>
            <div className="chapter-copy">
              <Tag>{chapters[chapter].label.toUpperCase()}</Tag>
              <h3>{chapters[chapter].title}</h3>
              <p>{chapters[chapter].description}</p>
              <a className="text-link" href="#learn">
                Discover your learning space <ArrowUpRight size={18} />
              </a>
            </div>
          </div>
        </section>

        {/* Real Stories / Testimonials Section */}
        <section className="testimonials-section" id="voices">
          <div className="wrap">
            <div className="section-heading">
              <div>
                <div className="eyebrow">
                  {t.voices_eyebrow || "REAL VOICES · JOS PILOT & NATIONWIDE"}
                </div>
                <h2>
                  {t.voices_title ||
                    "Why Nigerian Women & Clinicians Trust YanMata"}
                </h2>
              </div>
              <p>
                {t.voices_desc ||
                  "Authentic perspectives from girls, mothers, and healthcare professionals experiencing the YanMata platform."}
              </p>
            </div>
            <div className="testimonials-grid">
              {testimonials.map((test, i) => (
                <div className="testimonial-card" key={i}>
                  <p className="testimonial-quote">“{test.quote}”</p>
                  <div className="testimonial-author">
                    <div className="testimonial-avatar">{test.avatar}</div>
                    <div>
                      <h5>{test.name}</h5>
                      <small>{test.title}</small>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section className="support-section" id="explore">
          <div className="wrap">
            <div className="section-heading">
              <div>
                <div className="eyebrow">
                  {t.support_eyebrow || "SMALL MOMENTS. MEANINGFUL CARE."}
                </div>
                <h2>
                  A space that’s <span className="serif">yours.</span>
                </h2>
              </div>
              <p>
                {t.support_desc ||
                  "Less overwhelm. More understanding. Thoughtful tools for your everyday wellbeing."}
              </p>
            </div>
            <div className="support-grid">
              <article className="support-card track-card">
                <div className="feature-icon">
                  <Heart />
                </div>
                <h3>Check in with you.</h3>
                <p>
                  A personal journal for your mood and daily experience. No
                  perfect answers needed.
                </p>
                <div className="mini-journal">
                  <small>HOW ARE YOU FEELING TODAY?</small>
                  <div className="mood-row">
                    <span>
                      ☀<small>Great</small>
                    </span>
                    <span>
                      ☺<small>Good</small>
                    </span>
                    <span className="chosen">
                      ◡<small>Okay</small>
                    </span>
                    <span>
                      ☁<small>Low</small>
                    </span>
                  </div>
                  <span className="journal-caption">
                    <Lock size={11} /> A moment, just for you.
                  </span>
                </div>
              </article>
              <article className="support-card learn-card">
                <div className="feature-icon">
                  <BookOpen />
                </div>
                <h3>Understand a little more.</h3>
                <p>
                  Explore learning organised around your life, with sources and
                  a clear review process.
                </p>
                <div className="mini-stack">
                  <div>
                    <span className="stack-flower">✳</span>
                    <span>
                      Your body, your questions<small>BODY LITERACY</small>
                    </span>
                    <ChevronRight size={16} />
                  </div>
                  <div>
                    <span className="stack-flower pink">❋</span>
                    <span>
                      Space for your feelings<small>EMOTIONAL WELLBEING</small>
                    </span>
                    <ChevronRight size={16} />
                  </div>
                </div>
              </article>
              <article className="support-card care-card">
                <div className="feature-icon">
                  <MessageCircle />
                </div>
                <h3>Verified In-Platform Support.</h3>
                <p>
                  Connect directly with licensed gynecologists and reproductive
                  nurse specialists in our Jos pilot hub. Confidential and
                  respectful.
                </p>
                <div className="mini-conversation">
                  <span className="conversation-bubble">
                    Some questions need a listening ear.
                  </span>
                  <span className="conversation-answer">
                    And a licensed doctor to answer. <Heart size={12} />
                  </span>
                  <small>MDCN & NMCN Verified · Jos Pilot Hub</small>
                </div>
              </article>
            </div>
          </div>
        </section>
        <section className="wrap learning" id="learn">
          <div className="section-heading">
            <div>
              <div className="eyebrow">THE LEARNING ROOM</div>
              <h2>
                A little knowledge.
                <br />
                <span className="serif">A little more confidence.</span>
              </h2>
            </div>
            <p>
              Take a breath. Find something for you.
              <br />
              <small>Preview articles use synthetic, unreviewed content.</small>
            </p>
          </div>
          {error ? (
            <div className="error" role="alert">
              {error} <button onClick={load}>Retry</button>
            </div>
          ) : (
            <div className="article-grid">
              {articles.slice(0, 3).map((a, i) => (
                <button
                  key={a.id}
                  className={`article-card article-${i}`}
                  onClick={() => setSelected(a)}
                >
                  <div className="article-art">
                    <span>{["✳", "☾", "❋"][i]}</span>
                    <span className="art-small">{["◌", "✧", "◡"][i]}</span>
                    <Tag>{a.stage}</Tag>
                  </div>
                  <div className="article-content">
                    <span className="eyebrow">{a.topic}</span>
                    <h3>{a.title}</h3>
                    <p>{a.summary}</p>
                    <div className="article-meta">
                      <span>DEMO • NOT CLINICALLY REVIEWED</span>
                      <ArrowUpRight size={20} />
                    </div>
                  </div>
                </button>
              ))}
              {!articles.length && (
                <p role="status">The learning room is being prepared.</p>
              )}
            </div>
          )}
        </section>
        <section className="wrap privacy" id="care">
          <div className="privacy-art">
            <div className="privacy-shield">
              <ShieldCheck strokeWidth={1} />
            </div>
            <span className="privacy-star">✧</span>
            <div className="privacy-pill">
              <Lock size={14} /> Your story belongs to you.
            </div>
          </div>
          <div className="privacy-copy">
            <div className="eyebrow">PERSONAL MEANS PERSONAL.</div>
            <h2>
              Your wellbeing.
              <br />
              <span className="serif">Your boundaries.</span>
            </h2>
            <p>
              We’re building YanMata around trust. That means thoughtful
              permissions, discreet experiences and control over what you share.
            </p>
            <ul>
              <li>
                <Lock /> No account needed to explore learning
              </li>
              <li>
                <WifiOff /> Private journaling designed for offline use
              </li>
              <li>
                <ShieldCheck /> Age-appropriate care, from 9 through later life
              </li>
            </ul>
            <button className="text-link" onClick={() => setInfo("privacy")}>
              Read our privacy approach <ArrowUpRight size={18} />
            </button>
          </div>
        </section>
        <section className="wrap specialists" id="specialists">
          <div className="eyebrow">VERIFIED CARE CONTRIBUTORS · JOS PILOT</div>
          <h2>
            Qualified guidance.
            <br />
            <span className="serif">Never an algorithm alone.</span>
          </h2>
          <p className="specialists-lead">
            In our Jos, Plateau State pilot, YanMata connects women and girls
            directly with licensed medical practitioners and nurse specialists
            registered with MDCN and NMCN.
          </p>
          <div className="specialists-grid">
            {specialists.map((s) => (
              <div className="specialist-card" key={s.id}>
                <div className="specialist-avatar">{s.name[0]}</div>
                <div>
                  <div className="specialist-verified">
                    <ShieldCheck size={14} /> MDCN / NMCN Verified
                  </div>
                  <h3>{s.name}</h3>
                  <div className="specialist-title">
                    {s.title} · {s.credentials}
                  </div>
                  <div className="specialist-specialty">{s.specialty}</div>
                  <p>{s.bio}</p>
                  <small className="specialist-city">📍 {s.city}</small>
                </div>
              </div>
            ))}
          </div>
          <p className="specialist-note">
            Specialist support is asynchronous and confidential within YanMata.
            YanMata does not provide hospital referrals, directory search or
            emergency admissions.
          </p>
        </section>
        <section className="wrap faq">
          <div>
            <div className="eyebrow">A FEW THINGS YOU MAY BE WONDERING</div>
            <h2>
              Let’s make
              <br />
              <span className="serif">room for questions.</span>
            </h2>
          </div>
          <div className="faq-list">
            {[
              [
                "Who is YanMata for?",
                "Girls and women from age 9 through the end of life. The experience adapts to your stage with strict minor safeguarding: adolescents (ages 9–17) receive body literacy and cycle education without adult fertility prompts or adult screening reminders.",
              ],
              [
                "How does YanMata protect my intimate health data?",
                "Privacy is foundational. YanMata is built offline-first: your menstrual logs, symptoms, and 5-pillar health profile remain encrypted on your device. We do not sell user data, harvest telemetry, or share personal health records with third parties.",
              ],
              [
                "Are the clinical insights based on real science?",
                "Yes. YanMata does not generate fabricated risk scores or fake percentage likelihoods. Every personalized insight is traceable to clinical guidelines from the World Health Organization (WHO) and Federal Ministry of Health (FMOH) Nigeria.",
              ],
              [
                "How does specialist consultation work in YanMata?",
                "In our Jos pilot hub, verified MDCN-registered doctors and NMCN-registered nurse specialists provide asynchronous, confidential in-app consultations. Invariants: YanMata does not offer hospital booking or facility directories — specialist support remains strictly within the platform.",
              ],
              [
                "Can I ask Aisha AI in my local language?",
                "Yes! Aisha AI is trained to understand and respond supportively in English, Hausa, Yoruba, Igbo, and Nigerian Pidgin. It is equipped with automatic emergency triage connecting to Nigeria's SURPIN helpline (0800 123 4567) and emergency services (112).",
              ],
              [
                "When can I use the mobile app?",
                "The Flutter app is under active development for Android and iOS. We are preparing the pilot rollout starting in Jos, Plateau State. Public app-store releases will follow the pilot evaluation.",
              ],
            ].map(([q, a], i) => (
              <div className="faq-item" key={q}>
                <button
                  aria-expanded={faq === i}
                  aria-controls={`faq-${i}`}
                  onClick={() => setFaq(faq === i ? null : i)}
                >
                  {q}
                  {faq === i ? <Minus size={18} /> : <Plus size={18} />}
                </button>
                {faq === i && <p id={`faq-${i}`}>{a}</p>}
              </div>
            ))}
          </div>
        </section>
        <section className="wrap closing">
          <span>✳</span>
          <div className="eyebrow">YOU DESERVE TO FEEL UNDERSTOOD.</div>
          <h2>
            Here for the woman you are.
            <br />
            <span className="serif">And the one you’re becoming.</span>
          </h2>
          <p>Thoughtfully built by Zentreeca. Beginning in Jos, Nigeria.</p>
          <button className="button" onClick={() => setInfo("pilot")}>
            About the Jos pilot <ArrowUpRight />
          </button>
        </section>
      </main>
      <footer className="wrap">
        <div>
          <Brand />
          <p>Every chapter of you.</p>
        </div>
        <div className="footer-links">
          <a href="#stories">App Stories</a>
          <a href="#journey">Account Flow</a>
          <a href="#voices">Real Voices</a>
          <a href="#chapters">Life Chapters</a>
          <a href="#learn">Learn & grow</a>
          <button onClick={() => setInfo("privacy")}>Privacy approach</button>
          <a href="https://zentreeca.org" target="_blank" rel="noreferrer">
            Zentreeca <ArrowUpRight size={12} />
          </a>
        </div>
        <div className="footer-bottom">
          <span>
            © {new Date().getFullYear()} Zentreeca Limited. Made with care.
          </span>
          <span>Development preview · Not a medical service</span>
        </div>
      </footer>
      <dialog ref={dialog} onCancel={close} onClose={close}>
        <button className="close" onClick={close} aria-label="Close dialog">
          <X />
        </button>
        {selected ? (
          <>
            <Tag>{selected.stage}</Tag>
            <h2 className="dialog-title">{selected.title}</h2>
            <p className="notice">
              Demonstration content. Not clinically reviewed or medical advice.
              Workflow review timestamps are synthetic.
            </p>
            <p className="article-body">{selected.body}</p>
            <a
              className="source-link"
              href={selected.source_url}
              target="_blank"
              rel="noreferrer"
            >
              Background source: World Health Organization ↗
            </a>
          </>
        ) : (
          <>
            <div className="eyebrow">YANMATA, BY ZENTREECA</div>
            <h2 className="dialog-title">
              {info === "privacy"
                ? "Your trust is part of the design."
                : "Starting with care. Starting in Jos."}
            </h2>
            <p>
              {info === "privacy"
                ? "This development preview offers anonymous learning. The mobile foundation stores journal entries using device secure storage, with cloud synchronisation only after explicit consent. Clinical governance, account deletion/export, staff MFA and independent security validation remain release requirements. Please use synthetic data while testing."
                : "YanMata is being developed for girls and women from age 9 through later life. The first pilot is planned for Jos, Plateau State, with clinical review support from doctors and nurses. Recruitment and public app downloads have not opened. This is a working product preview, not an invitation to submit personal health information."}
            </p>
          </>
        )}
      </dialog>

      {/* Aisha AI Companion Interactive Modal */}
      <dialog
        ref={aiDialog}
        className="modal-dialog ai-dialog"
        onClose={() => setAiOpen(false)}
      >
        <div
          className="dialog-header"
          style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            borderBottom: "1px solid var(--line)",
            padding: "16px 20px",
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <span style={{ fontSize: 24 }}>✨</span>
            <div>
              <h3 style={{ margin: 0, fontSize: 18, color: "var(--plum)" }}>
                {t.ai_modal_title}
              </h3>
              <small style={{ color: "var(--muted)" }}>{t.ai_modal_desc}</small>
            </div>
          </div>
          <button
            className="dialog-close"
            onClick={() => setAiOpen(false)}
            style={{
              background: "none",
              border: "none",
              cursor: "pointer",
              color: "var(--ink)",
            }}
          >
            <X size={20} />
          </button>
        </div>
        <div className="dialog-body" style={{ padding: "16px 20px" }}>
          {aiEmergency && (
            <div
              style={{
                background: "#fff1f2",
                border: "1px solid #f43f5e",
                borderRadius: 12,
                padding: 12,
                marginBottom: 16,
              }}
            >
              <div
                style={{
                  display: "flex",
                  alignItems: "center",
                  gap: 8,
                  color: "#9f1239",
                  fontWeight: 700,
                }}
              >
                <AlertCircle size={18} /> EMERGENCY CRISIS SUPPORT (NIGERIA)
              </div>
              <p style={{ margin: "6px 0 0", color: "#881337", fontSize: 13 }}>
                • SURPIN Toll-Free: <strong>0800 123 4567</strong>
                <br />• National Emergency: <strong>112</strong>
              </p>
            </div>
          )}
          {aiReply && (
            <div
              style={{
                background: "var(--lilac)",
                padding: 16,
                borderRadius: 16,
                marginBottom: 16,
                whiteSpace: "pre-line",
                lineHeight: 1.6,
                fontSize: 14,
                color: "var(--ink)",
              }}
            >
              {aiReply}
            </div>
          )}
          <form onSubmit={askAi} style={{ display: "flex", gap: 8 }}>
            <input
              type="text"
              required
              value={aiPrompt}
              onChange={(e) => setAiPrompt(e.target.value)}
              placeholder={t.ai_placeholder}
              style={{
                flex: 1,
                padding: "12px 16px",
                borderRadius: 24,
                border: "1px solid var(--line)",
                background: "var(--cream)",
                color: "var(--ink)",
                outline: "none",
                fontSize: 14,
              }}
            />
            <button
              type="submit"
              className="button"
              disabled={aiLoading}
              style={{
                borderRadius: 24,
                padding: "0 20px",
                display: "inline-flex",
                alignItems: "center",
                justifyContent: "center",
              }}
            >
              {aiLoading ? "..." : <Send size={16} />}
            </button>
          </form>
          <small
            style={{
              display: "block",
              marginTop: 10,
              color: "var(--muted)",
              fontSize: 11,
              textAlign: "center",
            }}
          >
            {t.ai_disclaimer}
          </small>
        </div>
      </dialog>
    </>
  );
}
function WomenIllustration() {
  return (
    <svg
      viewBox="0 0 540 600"
      role="img"
      aria-label="Original illustration of three women, growing together"
    >
      <defs>
        <linearGradient id="bg" x2="1" y2="1">
          <stop stopColor="#ecd6dd" />
          <stop offset="1" stopColor="#d5c6df" />
        </linearGradient>
      </defs>
      <rect width="540" height="600" fill="url(#bg)" />
      <circle cx="310" cy="200" r="160" fill="#f9e8df" />
      <path d="M0 590Q32 424 139 435T310 600" fill="#aa7b9a" />
      <path d="M290 600Q343 384 484 436L540 600" fill="#536f63" />
      <path d="M182 600Q174 367 321 372Q440 417 441 600" fill="#795a96" />
      <path d="M246 367l2-80h83l-4 90q-42 43-81-10" fill="#9d614b" />
      <ellipse cx="288" cy="236" rx="72" ry="105" fill="#b77a5c" />
      <path
        d="M219 244q-45-129 43-158 92-19 106 98-42-12-70-67-11 71-79 78"
        fill="#392b37"
      />
      <path d="M226 203q-17-30-23 2t28 38" fill="#b77a5c" />
      <path d="M337 201q25-26 22 8t-24 34" fill="#b77a5c" />
      <path
        d="M250 228q10-5 16 1m40-1q10-5 17 0"
        stroke="#422f32"
        strokeWidth="4"
        fill="none"
        strokeLinecap="round"
      />
      <path
        d="M273 275q17 13 30-2"
        stroke="#754339"
        strokeWidth="4"
        fill="none"
        strokeLinecap="round"
      />
      <path
        d="M283 230l-6 25 12 2"
        stroke="#995b48"
        strokeWidth="3"
        fill="none"
      />
      <ellipse
        cx="222"
        cy="243"
        rx="10"
        ry="16"
        stroke="#e6c49a"
        strokeWidth="4"
        fill="none"
      />
      <ellipse
        cx="350"
        cy="243"
        rx="10"
        ry="16"
        stroke="#e6c49a"
        strokeWidth="4"
        fill="none"
      />
      <path
        d="M245 378q46 55 86-1M213 438q38 34 50 162m117-159q-36 83-21 159"
        stroke="#a48ab6"
        strokeWidth="3"
        fill="none"
      />
      <path d="M83 451l6-47h58l4 55" fill="#794939" />
      <ellipse cx="114" cy="352" rx="56" ry="74" fill="#995f46" />
      <path
        d="M58 373q-28-96 31-111 82-30 91 76-54-10-74-42-11 45-48 42"
        fill="#372b35"
      />
      <circle cx="74" cy="267" r="27" fill="#372b35" />
      <path
        d="M87 354q6-4 12 0m27-1q7-4 13 0m-35 31q11 9 21-1"
        stroke="#422c2b"
        strokeWidth="3"
        fill="none"
        strokeLinecap="round"
      />
      <path
        d="M68 473q45 25 85-6m-95 44l-16 89m111-73l14 73"
        stroke="#c69aaf"
        strokeWidth="3"
        fill="none"
      />
      <path d="M407 454l-3-55h65l3 61" fill="#774739" />
      <ellipse cx="436" cy="343" rx="58" ry="82" fill="#8c5945" />
      <path
        d="M376 340q-9-107 69-98 66 1 58 105-22-36-32-75-28 54-95 68"
        fill="#d9d1d0"
      />
      <path
        d="M376 332q-15-39 3-59m123 75q23-52-8-75"
        stroke="#b5aeb0"
        strokeWidth="8"
        fill="none"
      />
      <path
        d="M407 345q8-5 15 0m25 0q8-5 15 0m-37 35q14 9 26-2"
        stroke="#50342f"
        strokeWidth="3"
        fill="none"
        strokeLinecap="round"
      />
      <path
        d="M403 358l16 4m31 0l16-4m-43 31l25 1"
        stroke="#a87961"
        strokeWidth="2"
      />
      <path
        d="M403 461q38 34 72-1m-59 37l-12 103m94-97l24 97"
        stroke="#789183"
        strokeWidth="3"
        fill="none"
      />
      <path
        d="M38 183q22 44 17 88m0-33q-38-3-34-36 29 0 34 36m-3-25q30-11 24-37-26 8-24 37"
        stroke="#6b897a"
        strokeWidth="4"
        fill="#8ba28e"
      />
      <path
        d="M483 140l-4 39m-18-20l39 2"
        stroke="#fff9ef"
        strokeWidth="3"
        strokeLinecap="round"
      />
    </svg>
  );
}
createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
