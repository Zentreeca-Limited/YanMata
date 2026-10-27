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
} from "lucide-react";
import { Brand, Tag, api, type Article } from "@yanmata/ui";
import "@yanmata/ui/styles.css";
import "./styles.css";
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
  const [articles, setArticles] = useState<Article[]>([]);
  const [error, setError] = useState("");
  const [selected, setSelected] = useState<Article | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [faq, setFaq] = useState<number | null>(0);
  const [menu, setMenu] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  const load = () => {
    setError("");
    api<{ data: Article[] }>("/content")
      .then((r) => setArticles(r.data))
      .catch(() =>
        setError(
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
  return (
    <>
      <a className="skip" href="#main">
        Skip to content
      </a>
      <div className="announcement">
        <span className="dot" /> A new chapter in women’s wellbeing. Made with
        care, in Nigeria. <span className="demo-label">PRODUCT PREVIEW</span>
      </div>
      <header className="header">
        <Brand />
        <nav className={menu ? "open" : ""} aria-label="Main navigation">
          <a onClick={() => setMenu(false)} href="#chapters">
            Your life, your chapters
          </a>
          <a onClick={() => setMenu(false)} href="#learn">
            Learn & grow
          </a>
          <a onClick={() => setMenu(false)} href="#care">
            Our approach
          </a>
        </nav>
        <a className="button header-cta" href="#explore">
          Meet YanMata <ArrowUpRight />
        </a>
        <button
          className="menu-toggle"
          aria-label="Toggle navigation"
          aria-expanded={menu}
          onClick={() => setMenu(!menu)}
        >
          <Menu />
        </button>
      </header>
      <main id="main">
        <section className="hero wrap">
          <div className="hero-copy">
            <Tag>
              <span className="tiny-flower">✳</span> FOR EVERY CHAPTER OF
              WOMANHOOD
            </Tag>
            <h1>
              Growing. Changing.
              <br />
              Always <span className="serif">you.</span>
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
              Your body has a story. You deserve a space to understand it.
              <br className="desktop" /> Meet YanMata — your wellbeing
              companion, from your
              <br className="desktop" /> first questions to every chapter that
              follows.
            </p>
            <div className="hero-actions">
              <a className="button" href="#explore">
                Find your space <ArrowUpRight />
              </a>
              <a className="text-link" href="#chapters">
                Explore your chapter <ArrowRight size={16} />
              </a>
            </div>
            <div className="hero-trust">
              <span>
                <ShieldCheck /> Privacy comes first
              </span>
              <span>
                <Heart /> Designed around you
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
          <span>Rooted in understanding</span>
          <i>✳</i>
          <span>Built for real life</span>
          <i>✳</i>
          <span>Private by design</span>
          <i>✳</i>
          <span>With you, through change</span>
        </div>
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
        <section className="support-section" id="explore">
          <div className="wrap">
            <div className="section-heading">
              <div>
                <div className="eyebrow">SMALL MOMENTS. MEANINGFUL CARE.</div>
                <h2>
                  A space that’s <span className="serif">yours.</span>
                </h2>
              </div>
              <p>
                Less overwhelm. More understanding.
                <br />
                Thoughtful tools for your everyday wellbeing.
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
                <h3>You don’t have to guess.</h3>
                <p>
                  In-platform specialist conversations are part of our roadmap.
                  A human connection, in your own space.
                </p>
                <div className="mini-conversation">
                  <span className="conversation-bubble">
                    Some questions need a listening ear.
                  </span>
                  <span className="conversation-answer">
                    And a little room to ask. <Heart size={12} />
                  </span>
                  <small>Specialist service not yet available</small>
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
                "Girls and women from age 9 through the end of life. Your experience will adapt to your stage and interests, with age-appropriate safeguards for younger users.",
              ],
              [
                "Is YanMata a medical service?",
                "YanMata is being built for wellbeing education, personal reflection and in-platform specialist support. This preview does not diagnose conditions or provide medical advice.",
              ],
              [
                "Can I speak to a specialist?",
                "Verified specialist conversations are planned within YanMata. They are not available in this foundation preview. There are no facility directories or hospital booking services.",
              ],
              [
                "When can I use the mobile app?",
                "The Flutter app is under active development for Android and iOS. We are preparing a pilot in Jos, Plateau State. Public app-store downloads are not available yet.",
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
          <a href="#chapters">Your chapters</a>
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
