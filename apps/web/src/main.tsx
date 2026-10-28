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
import { Brand, Tag, api, type Article } from "@yanmata/ui";
import { LANGUAGES, translations, type Language } from "./i18n";
import "@yanmata/ui/styles.css";
import "./styles.css";

const androidDownloadUrl = import.meta.env.VITE_ANDROID_DOWNLOAD_URL as
  string | undefined;
const iosDownloadUrl = import.meta.env.VITE_IOS_DOWNLOAD_URL as
  string | undefined;

const getStories = (t: Record<string, string>) => [
  {
    id: "cycle",
    tabTitle: t.tab_cycle || "Cycle Rhythm",
    icon: Calendar,
    title: t.cycle_title,
    badge: t.cycle_badge,
    lead: t.cycle_lead,
    highlights: [t.cycle_h1, t.cycle_h2, t.cycle_h3, t.cycle_h4],
    image: "/screens/today.png",
    alt: t.cycle_title,
  },
  {
    id: "ai",
    tabTitle: t.tab_ai || "Aisha AI",
    icon: Sparkles,
    title: t.ai_title,
    badge: t.ai_badge,
    lead: t.ai_lead,
    highlights: [t.ai_h1, t.ai_h2, t.ai_h3, t.ai_h4],
    image: "/screens/ai.png",
    alt: t.ai_title,
  },
  {
    id: "insights",
    tabTitle: t.tab_insights || "Clinical Insights",
    icon: Activity,
    title: t.insights_title,
    badge: t.insights_badge,
    lead: t.insights_lead,
    highlights: [t.insights_h1, t.insights_h2, t.insights_h3, t.insights_h4],
    image: "/screens/insights.png",
    alt: t.insights_title,
  },
  {
    id: "profile",
    tabTitle: t.tab_profile || "5-Pillar Profile",
    icon: UserCheck,
    title: t.profile_title,
    badge: t.profile_badge,
    lead: t.profile_lead,
    highlights: [t.profile_h1, t.profile_h2, t.profile_h3, t.profile_h4],
    image: "/screens/profile.png",
    alt: t.profile_title,
  },
  {
    id: "mental",
    tabTitle: t.tab_mental || "Mental Care",
    icon: Smile,
    title: t.mental_title,
    badge: t.mental_badge,
    lead: t.mental_lead,
    highlights: [t.mental_h1, t.mental_h2, t.mental_h3, t.mental_h4],
    image: "/screens/mental.png",
    alt: t.mental_title,
  },
  {
    id: "care",
    tabTitle: t.tab_care || "Specialist Care",
    icon: MessageCircle,
    title: t.care_title,
    badge: t.care_badge,
    lead: t.care_lead,
    highlights: [t.care_h1, t.care_h2, t.care_h3, t.care_h4],
    image: "/screens/services.png",
    alt: t.care_title,
  },
];

const getJourneySteps = (t: Record<string, string>) => [
  {
    step: 1,
    title: t.journey_step_1,
    sub: t.journey_step_1_sub,
    tag: t.journey_tag_1,
    icon: Compass,
  },
  {
    step: 2,
    title: t.journey_step_2,
    sub: t.journey_step_2_sub,
    tag: t.journey_tag_2,
    icon: Lock,
  },
  {
    step: 3,
    title: t.journey_step_3,
    sub: t.journey_step_3_sub,
    tag: t.journey_tag_3,
    icon: Activity,
  },
  {
    step: 4,
    title: t.journey_step_4,
    sub: t.journey_step_4_sub,
    tag: t.journey_tag_4,
    icon: ShieldCheck,
  },
  {
    step: 5,
    title: t.journey_step_5,
    sub: t.journey_step_5_sub,
    tag: t.journey_tag_5,
    icon: Heart,
  },
];

const getChapters = (t: Record<string, string>) => [
  {
    label: t.ch_label_0,
    years: t.ch_years_0,
    title: t.ch_title_0,
    description: t.ch_desc_0,
    icon: "✳",
  },
  {
    label: t.ch_label_1,
    years: t.ch_years_1,
    title: t.ch_title_1,
    description: t.ch_desc_1,
    icon: "◌",
  },
  {
    label: t.ch_label_2,
    years: t.ch_years_2,
    title: t.ch_title_2,
    description: t.ch_desc_2,
    icon: "❋",
  },
  {
    label: t.ch_label_3,
    years: t.ch_years_3,
    title: t.ch_title_3,
    description: t.ch_desc_3,
    icon: "☼",
  },
  {
    label: t.ch_label_4,
    years: t.ch_years_4,
    title: t.ch_title_4,
    description: t.ch_desc_4,
    icon: "❀",
  },
];

const getFaqs = (t: Record<string, string>) => [
  [t.faq_q1, t.faq_a1],
  [t.faq_q2, t.faq_a2],
  [t.faq_q3, t.faq_a3],
  [t.faq_q4, t.faq_a4],
  [t.faq_q5, t.faq_a5],
  [t.faq_q6, t.faq_a6],
];

function App() {
  const [chapter, setChapter] = useState(0);
  const [activeStory, setActiveStory] = useState(0);
  const [articles, setArticles] = useState<Article[]>([]);
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
  const stories = getStories(t);
  const journeySteps = getJourneySteps(t);
  const chapters = getChapters(t);
  const faqs = getFaqs(t);

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
          t.learn_error ||
            "The learning library is temporarily unavailable. Please try again.",
        ),
      );
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
      <div className="header-sticky-container">
        <header className="header">
          <Brand />
          <nav
            className={menu ? "nav-menu open" : "nav-menu"}
            aria-label="Main navigation"
          >
            <a
              className="nav-link"
              onClick={() => setMenu(false)}
              href="#stories"
            >
              {t.nav_stories || "Stories"}
            </a>
            <a
              className="nav-link"
              onClick={() => setMenu(false)}
              href="#chapters"
            >
              {t.nav_chapters || "Chapters"}
            </a>
            <a
              className="nav-link"
              onClick={() => setMenu(false)}
              href="#specialists"
            >
              {t.nav_specialists || "Specialists"}
            </a>
            <a
              className="nav-link"
              onClick={() => setMenu(false)}
              href="#learn"
            >
              {t.nav_learn || "Learning"}
            </a>
            <button
              className="nav-ai-pill"
              onClick={() => {
                setMenu(false);
                setAiOpen(true);
              }}
            >
              <Sparkles size={14} />
              <span>{t.nav_ai || "Aisha AI"}</span>
            </button>
            <div className="mobile-only-links">
              <a
                className="nav-link"
                onClick={() => setMenu(false)}
                href="#journey"
              >
                {t.nav_journey || "Account Journey"}
              </a>
              <a
                className="nav-link"
                onClick={() => setMenu(false)}
                href="#download"
              >
                Get the app
              </a>
              <a
                className="nav-link"
                onClick={() => setMenu(false)}
                href="#care"
              >
                {t.nav_care || "Our Approach"}
              </a>
            </div>
          </nav>
          <div className="header-controls">
            {/* Language Selector */}
            <div className="lang-pill">
              <Globe size={13} />
              <select
                aria-label="Select language"
                value={lang}
                onChange={(e) => setLang(e.target.value as Language)}
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
              aria-label={theme === "light" ? t.theme_dark : t.theme_light}
              onClick={() => setTheme(theme === "light" ? "dark" : "light")}
            >
              {theme === "light" ? <Moon size={15} /> : <Sun size={15} />}
            </button>
            <a className="button header-cta" href="#stories">
              {t.cta_meet} <ArrowUpRight size={14} />
            </a>
            <button
              className="menu-toggle"
              aria-label="Toggle navigation"
              aria-expanded={menu}
              onClick={() => setMenu(!menu)}
            >
              {menu ? <X size={20} /> : <Menu size={20} />}
            </button>
          </div>
        </header>
      </div>
      <main id="main">
        <section className="hero wrap">
          <div className="hero-copy">
            <Tag>
              <span className="tiny-flower">✳</span>{" "}
              {t.hero_tag ||
                "AGES 9 THROUGH LIFELONG CARE · NIGERIA, AFRICA & BEYOND"}
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
                {t.hero_note_1}
                <small>{t.hero_note_1_sub}</small>
              </div>
            </div>
            <div className="floating-note note-bottom">
              <span className="note-icon pink">
                <Heart size={20} />
              </span>
              <div>
                {t.hero_note_2}
                <small>{t.hero_note_2_sub}</small>
              </div>
            </div>
            <span className="art-caption">{t.hero_art_caption}</span>
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
                  <span>{s.tabTitle}</span>
                </button>
              );
            })}
          </div>
          <div
            id="story-showcase-panel"
            role="tabpanel"
            aria-labelledby={`story-tab-${activeStory}`}
            className="story-showcase"
            key={activeStory}
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
                  {t.stories_cta_journey || "See Account Journey"}{" "}
                  <ArrowRight size={16} />
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
                  {t.stories_cta_ai || "Ask Aisha AI"} <Sparkles size={14} />
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
                    <h4>{j.title}</h4>
                  </div>
                  <p>{j.sub}</p>
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
                {t.chapters_eyebrow ||
                  "LIFE DOESN’T STAND STILL. NEITHER DOES CARE."}
              </div>
              <h2>
                {t.chapters_title || "Every chapter. A little more understood."}
              </h2>
            </div>
            <p>
              {t.chapters_desc ||
                "There’s no single way to be a woman. Find the support that feels right for where you are."}
            </p>
          </div>
          <div
            className="chapter-tabs"
            role="tablist"
            aria-label="Life chapters"
          >
            {chapters.map((c, i) => (
              <button
                key={i}
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
                {t.chapters_cta || "Discover your learning space"}{" "}
                <ArrowUpRight size={18} />
              </a>
            </div>
          </div>
        </section>

        <section className="testimonials-section" id="voices">
          <div className="wrap">
            <div className="section-heading">
              <div>
                <div className="eyebrow">BUILT WITH CARE IN NIGERIA</div>
                <h2>A thoughtful beginning, shaped around real needs.</h2>
              </div>
              <p>
                We are preparing a Jos, Plateau State pilot. Public enrolment is
                not yet open, and all demo people and records are synthetic.
              </p>
            </div>
            <div className="pilot-note">
              <ShieldCheck size={24} />
              <p>
                Health content and specialist services will move beyond the demo
                only after their clinical, safeguarding and operational reviews
                are complete.
              </p>
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
                <h2>{t.support_title || "A space that’s yours."}</h2>
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
                <h3>{t.support_track_title}</h3>
                <p>{t.support_track_desc}</p>
                <div className="mini-journal">
                  <small>{t.support_mood_question}</small>
                  <div className="mood-row">
                    <span>
                      ☀<small>{t.mood_great}</small>
                    </span>
                    <span>
                      ☺<small>{t.mood_good}</small>
                    </span>
                    <span className="chosen">
                      ◡<small>{t.mood_okay}</small>
                    </span>
                    <span>
                      ☁<small>{t.mood_low}</small>
                    </span>
                  </div>
                  <span className="journal-caption">
                    <Lock size={11} /> {t.support_mood_caption}
                  </span>
                </div>
              </article>
              <article className="support-card learn-card">
                <div className="feature-icon">
                  <BookOpen />
                </div>
                <h3>{t.support_learn_title}</h3>
                <p>{t.support_learn_desc}</p>
                <div className="mini-stack">
                  <div>
                    <span className="stack-flower">✳</span>
                    <span>
                      {t.support_stack_1_title}
                      <small>{t.support_stack_1_tag}</small>
                    </span>
                    <ChevronRight size={16} />
                  </div>
                  <div>
                    <span className="stack-flower pink">❋</span>
                    <span>
                      {t.support_stack_2_title}
                      <small>{t.support_stack_2_tag}</small>
                    </span>
                    <ChevronRight size={16} />
                  </div>
                </div>
              </article>
              <article className="support-card care-card">
                <div className="feature-icon">
                  <MessageCircle />
                </div>
                <h3>{t.support_care_title}</h3>
                <p>{t.support_care_desc}</p>
                <div className="mini-conversation">
                  <span className="conversation-bubble">
                    {t.support_convo_q}
                  </span>
                  <span className="conversation-answer">
                    {t.support_convo_a} <Heart size={12} />
                  </span>
                  <small>{t.support_care_badge}</small>
                </div>
              </article>
            </div>
          </div>
        </section>
        <section className="wrap learning" id="learn">
          <div className="section-heading">
            <div>
              <div className="eyebrow">{t.learn_eyebrow}</div>
              <h2>{t.learn_title}</h2>
            </div>
            <p>
              {t.learn_desc}
              <br />
              <small>{t.learn_notice}</small>
            </p>
          </div>
          {error ? (
            <div className="error" role="alert">
              {error} <button onClick={load}>{t.learn_retry}</button>
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
                      <span>{t.learn_card_meta}</span>
                      <ArrowUpRight size={20} />
                    </div>
                  </div>
                </button>
              ))}
              {!articles.length && <p role="status">{t.learn_loading}</p>}
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
              <Lock size={14} /> {t.privacy_pill}
            </div>
          </div>
          <div className="privacy-copy">
            <div className="eyebrow">{t.privacy_eyebrow}</div>
            <h2>{t.privacy_title}</h2>
            <p>{t.privacy_desc}</p>
            <ul>
              <li>
                <Lock /> {t.privacy_b1}
              </li>
              <li>
                <WifiOff /> {t.privacy_b2}
              </li>
              <li>
                <ShieldCheck /> {t.privacy_b3}
              </li>
            </ul>
            <button className="text-link" onClick={() => setInfo("privacy")}>
              {t.privacy_cta} <ArrowUpRight size={18} />
            </button>
          </div>
        </section>
        <section className="wrap specialists" id="specialists">
          <div className="eyebrow">IN-PLATFORM SPECIALIST SUPPORT</div>
          <h2>A careful path to qualified guidance.</h2>
          <p className="specialists-lead">
            YanMata includes a working specialist-support workflow. Named
            professionals will be shown publicly only after their identity,
            credentials, scope and availability have been verified.
          </p>
          <div className="specialists-grid readiness-grid">
            <div className="specialist-card">
              <ShieldCheck className="readiness-icon" />
              <div>
                <h3>Credentials checked</h3>
                <p>
                  Registration, scope of practice and expiry are reviewed before
                  activation.
                </p>
              </div>
            </div>
            <div className="specialist-card">
              <Lock className="readiness-icon" />
              <div>
                <h3>Access stays scoped</h3>
                <p>
                  Specialist access is assigned, consented and limited to the
                  support request.
                </p>
              </div>
            </div>
          </div>
          <p className="specialist-note">
            Demo profiles are synthetic. Specialist support is not an emergency
            service and public enrolment is not yet open.
          </p>
        </section>
        <section className="wrap faq">
          <div>
            <div className="eyebrow">{t.faq_eyebrow}</div>
            <h2>{t.faq_title}</h2>
          </div>
          <div className="faq-list">
            {faqs.map(([q, a], i) => (
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
        <section className="download-section wrap" id="download">
          <div className="download-copy">
            <div className="eyebrow">YANMATA MOBILE</div>
            <h2>Your private wellbeing companion, wherever you are.</h2>
            <p>
              Android and iPhone releases are being prepared. These placeholder
              links can be replaced with the Play Store and App Store URLs when
              signed production builds are approved.
            </p>
          </div>
          <div
            className="download-actions"
            aria-label="Mobile app availability"
          >
            <a
              className="store-link"
              href={androidDownloadUrl || "#download"}
              target={androidDownloadUrl ? "_blank" : undefined}
              rel={androidDownloadUrl ? "noreferrer" : undefined}
              aria-disabled={!androidDownloadUrl}
              onClick={(event) => {
                if (!androidDownloadUrl) event.preventDefault();
              }}
            >
              <span className="store-icon">A</span>
              <span>
                <small>Android app</small>
                {androidDownloadUrl ? "Download" : "Coming soon"}
              </span>
            </a>
            <a
              className="store-link"
              href={iosDownloadUrl || "#download"}
              target={iosDownloadUrl ? "_blank" : undefined}
              rel={iosDownloadUrl ? "noreferrer" : undefined}
              aria-disabled={!iosDownloadUrl}
              onClick={(event) => {
                if (!iosDownloadUrl) event.preventDefault();
              }}
            >
              <span className="store-icon">i</span>
              <span>
                <small>iPhone app</small>
                {iosDownloadUrl ? "Download" : "Coming soon"}
              </span>
            </a>
          </div>
        </section>
        <section className="wrap closing">
          <span>✳</span>
          <div className="eyebrow">{t.closing_eyebrow}</div>
          <h2>{t.closing_title}</h2>
          <p>{t.closing_desc}</p>
          <button className="button" onClick={() => setInfo("pilot")}>
            {t.closing_cta} <ArrowUpRight />
          </button>
        </section>
      </main>
      <footer className="wrap">
        <div>
          <Brand />
          <p>{t.footer_tagline}</p>
        </div>
        <div className="footer-links">
          <a href="#stories">{t.nav_stories || "App Stories"}</a>
          <a href="#journey">{t.nav_journey || "Account Journey"}</a>
          <a href="#voices">Our approach</a>
          <a href="#download">Get the app</a>
          <a href="#chapters">{t.nav_chapters || "Life Chapters"}</a>
          <a href="#learn">{t.nav_learn || "Learning"}</a>
          <button onClick={() => setInfo("privacy")}>
            {t.privacy_cta || "Privacy approach"}
          </button>
          <a href="https://zentreeca.org" target="_blank" rel="noreferrer">
            Zentreeca <ArrowUpRight size={12} />
          </a>
        </div>
        <div className="footer-bottom">
          <span>
            © {new Date().getFullYear()} Zentreeca Limited. Made with care.
          </span>
          <span>{t.footer_disclaimer}</span>
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
            <p className="notice">{t.modal_article_demo_notice}</p>
            <p className="article-body">{selected.body}</p>
            <a
              className="source-link"
              href={selected.source_url}
              target="_blank"
              rel="noreferrer"
            >
              {t.modal_article_source}
            </a>
          </>
        ) : (
          <>
            <div className="eyebrow">YANMATA, BY ZENTREECA</div>
            <h2 className="dialog-title">
              {info === "privacy" ? t.modal_privacy_title : t.modal_pilot_title}
            </h2>
            <p>
              {info === "privacy" ? t.modal_privacy_body : t.modal_pilot_body}
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
                National emergency number: <strong>112</strong>
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
