import { StrictMode, useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import {
  BookOpen,
  LogOut,
  Plus,
  ArrowRight,
  Search,
  ShieldCheck,
  Clock,
  CheckCircle,
  FileText,
  ArrowUpRight,
  X,
  RefreshCw,
  MessageCircle,
  Moon,
  Sun,
  Globe,
} from "lucide-react";
import {
  Brand,
  Tag,
  api,
  type Article,
  type Member,
  type SupportRequest,
  type Specialist,
} from "@yanmata/ui";
import "@yanmata/ui/styles.css";
import "./styles.css";
const blank = {
  title: "",
  topic: "Body literacy",
  stage: "All chapters",
  summary: "",
  body: "",
  source_url: "https://www.who.int/health-topics/adolescent-health",
};
function App() {
  const [user, setUser] = useState<Member | null>(null);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [tab, setTab] = useState<"articles" | "care">("articles");
  const [items, setItems] = useState<Article[]>([]);
  const [careRequests, setCareRequests] = useState<SupportRequest[]>([]);
  const [specialists, setSpecialists] = useState<Specialist[]>([]);
  const [careFilter, setCareFilter] = useState("all");
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);
  const [filter, setFilter] = useState("all");
  const [query, setQuery] = useState("");
  const [editing, setEditing] = useState<Article | null | undefined>(undefined);
  const [form, setForm] = useState(blank);
  const [notice, setNotice] = useState("");
  const [theme, setTheme] = useState<"light" | "dark">("light");

  useEffect(() => {
    document.documentElement.setAttribute("data-theme", theme);
  }, [theme]);
  async function load() {
    try {
      const result = await api<{ data: Article[] }>("/studio/content");
      setItems(result.data);
    } catch (e) {
      setError((e as Error).message);
    }
  }
  async function loadCare() {
    try {
      const [reqs, specs] = await Promise.all([
        api<{ data: SupportRequest[] }>("/studio/care/requests"),
        api<{ data: Specialist[] }>("/specialists"),
      ]);
      setCareRequests(reqs.data);
      setSpecialists(specs.data);
    } catch (e) {
      setError((e as Error).message);
    }
  }
  useEffect(() => {
    api<{ user: Member }>("/me")
      .then((r) => setUser(r.user))
      .catch(() => {});
  }, []);
  useEffect(() => {
    if (user) {
      if (tab === "articles") void load();
      if (tab === "care") void loadCare();
    }
  }, [user, tab]);

  async function assignSpecialist(requestId: string, specialistId: string) {
    if (!specialistId) return;
    setBusy(true);
    setError("");
    try {
      await api(`/studio/care/requests/${requestId}/assign`, {
        method: "POST",
        body: JSON.stringify({ specialist_id: specialistId }),
      });
      setNotice("Specialist assigned and conversation opened.");
      await loadCare();
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  async function signIn(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError("");
    try {
      const csrf = await fetch("/sanctum/csrf-cookie", {
        credentials: "include",
      });
      if (!csrf.ok) throw new Error("Cannot establish a secure session.");
      const r = await api<{ user: Member }>("/session", {
        method: "POST",
        body: JSON.stringify({ email, password }),
      });
      setPassword("");
      setUser(r.user);
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  async function logout() {
    setError("");
    try {
      await api("/logout", { method: "POST" });
      setUser(null);
      setItems([]);
      setEditing(undefined);
    } catch (e) {
      setError((e as Error).message);
    }
  }
  async function save(e: React.FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError("");
    try {
      await api(editing ? `/studio/content/${editing.id}` : "/studio/content", {
        method: editing ? "PUT" : "POST",
        body: JSON.stringify({
          ...form,
          ...(editing ? { version: editing.version } : {}),
        }),
      });
      setEditing(undefined);
      setNotice("Draft saved. Clinical review is required before publication.");
      await load();
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  async function transition(item: Article, action: string) {
    setBusy(true);
    setError("");
    try {
      await api(`/studio/content/${item.id}/transition`, {
        method: "POST",
        body: JSON.stringify({ action, version: item.version }),
      });
      setNotice(`“${item.title}” updated successfully.`);
      await load();
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setBusy(false);
    }
  }
  function edit(item: Article | null) {
    setForm(
      item
        ? {
            title: item.title,
            topic: item.topic,
            stage: item.stage,
            summary: item.summary,
            body: item.body,
            source_url: item.source_url,
          }
        : blank,
    );
    setEditing(item);
    setError("");
    setNotice("");
  }
  if (!user)
    return (
      <main className="login-layout">
        <section className="login-story">
          <Brand />
          <div>
            <span className="eyebrow">THE PEOPLE BEHIND THE CARE</span>
            <h1>
              Good guidance
              <br />
              starts with
              <br />
              <em>thoughtful people.</em>
            </h1>
            <p>
              A shared space to write, review and care for the stories we share.
            </p>
            <span className="login-flower">✳</span>
          </div>
          <small>YANMATA EDITORIAL STUDIO · BY ZENTREECA</small>
        </section>
        <section className="login-panel">
          <Tag>
            <ShieldCheck size={13} /> STAFF ACCESS
          </Tag>
          <h2>Welcome to the studio.</h2>
          <p>Sign in to your editorial account.</p>
          {error && (
            <p className="error" role="alert">
              {error}
            </p>
          )}
          <form onSubmit={signIn}>
            <label className="field">
              Email
              <input
                type="email"
                autoComplete="username"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </label>
            <label className="field">
              Password
              <input
                type="password"
                autoComplete="current-password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
              />
            </label>
            <button className="button" disabled={busy}>
              {busy ? "Signing in…" : "Enter the studio"}
              <ArrowRight size={16} />
            </button>
          </form>
          <p className="login-note">
            Development environment. Use a seeded staff account.
            <br />
            Please do not enter real patient information.
          </p>
          <a className="text-link" href="http://127.0.0.1:5173">
            Explore the public website <ArrowUpRight size={15} />
          </a>
        </section>
      </main>
    );
  const visible = items.filter(
    (i) =>
      (filter === "all" || i.status === filter) &&
      `${i.title} ${i.topic}`.toLowerCase().includes(query.toLowerCase()),
  );
  return (
    <div className="studio">
      <aside className="sidebar">
        <Brand small />
        <span className="sidebar-label">WORKSPACE</span>
        <button
          className={`nav-btn ${tab === "articles" ? "nav-active" : ""}`}
          onClick={() => {
            setTab("articles");
            setNotice("");
          }}
        >
          <BookOpen size={18} /> Learning library <span>{items.length}</span>
        </button>
        <button
          className={`nav-btn ${tab === "care" ? "nav-active" : ""}`}
          onClick={() => {
            setTab("care");
            setNotice("");
          }}
        >
          <MessageCircle size={18} /> Care inquiries{" "}
          <span>{careRequests.length}</span>
        </button>
        <div className="sidebar-note">
          <ShieldCheck size={21} />
          <strong>Trust is a team effort.</strong>
          <p>
            Every clinical article needs a separate reviewer before a publisher
            can make it public.
          </p>
        </div>
        <div className="user-block">
          <div className="avatar">{user.name[0]}</div>
          <div>
            <strong>{user.name}</strong>
            <small>{user.role}</small>
          </div>
          <button aria-label="Sign out" onClick={logout}>
            <LogOut size={17} />
          </button>
        </div>
      </aside>
      <div className="studio-main">
        <header className="studio-header">
          <span>
            Workspace <span>/</span>{" "}
            {tab === "articles" ? "Learning library" : "Care inquiries"}
          </span>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <span style={{ fontSize: 12, color: "var(--muted)", display: "flex", alignItems: "center", gap: 4 }}>
              <Globe size={14} /> National Coverage: Jos · Abuja · Lagos · Kano · Telehealth
            </span>
            <button
              aria-label="Toggle theme"
              onClick={() => setTheme(theme === "light" ? "dark" : "light")}
              style={{
                display: "inline-flex",
                alignItems: "center",
                justifyContent: "center",
                width: 32,
                height: 32,
                borderRadius: "50%",
                background: "var(--lilac)",
                border: "none",
                color: "var(--plum)",
                cursor: "pointer",
              }}
            >
              {theme === "light" ? <Moon size={15} /> : <Sun size={15} />}
            </button>
            <Tag>DEVELOPMENT PREVIEW</Tag>
          </div>
        </header>
        <main>
          {tab === "articles" ? (
            <>
              <div className="studio-title">
                <div>
                  <div className="eyebrow">
                    THOUGHTFUL WORDS. MEANINGFUL IMPACT.
                  </div>
                  <h1>The learning library</h1>
                  <p>
                    Create something that helps her feel a little more
                    understood.
                  </p>
                </div>
                {user.role === "author" && (
                  <button className="button" onClick={() => edit(null)}>
                    <Plus size={17} /> New article
                  </button>
                )}
              </div>
              <div className="stats">
                {[
                  ["All articles", items.length, BookOpen],
                  [
                    "In review",
                    items.filter((i) => i.status === "in_review").length,
                    Clock,
                  ],
                  [
                    "Approved",
                    items.filter((i) => i.status === "approved").length,
                    CheckCircle,
                  ],
                  [
                    "Published",
                    items.filter((i) => i.status === "published").length,
                    FileText,
                  ],
                ].map(([label, count, Icon]) => {
                  const C = Icon as typeof BookOpen;
                  return (
                    <div className="stat" key={String(label)}>
                      <C size={19} />
                      <span>{String(label)}</span>
                      <strong>{String(count)}</strong>
                    </div>
                  );
                })}
              </div>
              <p className="notice">
                Synthetic demo content is labelled on the public website. A demo
                review does not establish clinical approval.
              </p>
              {error && (
                <p className="error" role="alert">
                  {error}
                </p>
              )}
              {notice && (
                <p role="status" className="notice">
                  {notice}
                </p>
              )}
              <section className="library-panel">
                <div className="library-toolbar">
                  <div className="filter-tabs">
                    {[
                      "all",
                      "draft",
                      "in_review",
                      "approved",
                      "published",
                      "withdrawn",
                    ].map((s) => (
                      <button
                        key={s}
                        aria-pressed={filter === s}
                        onClick={() => setFilter(s)}
                      >
                        {s === "all" ? "All articles" : s.replace("_", " ")}
                      </button>
                    ))}
                  </div>
                  <label className="search">
                    <Search size={16} />
                    <input
                      placeholder="Search articles"
                      aria-label="Search articles"
                      value={query}
                      onChange={(e) => setQuery(e.target.value)}
                    />
                  </label>
                  <button
                    className="refresh"
                    aria-label="Refresh library"
                    onClick={load}
                  >
                    <RefreshCw size={17} />
                  </button>
                </div>
                <div className="table-scroll">
                  <table>
                    <thead>
                      <tr>
                        <th>ARTICLE</th>
                        <th>CHAPTER</th>
                        <th>STATUS</th>
                        <th>VERSION</th>
                        <th>ACTION</th>
                      </tr>
                    </thead>
                    <tbody>
                      {visible.map((item) => (
                        <tr key={item.id}>
                          <td>
                            <strong>{item.title}</strong>
                            <small>
                              {item.topic} {item.is_demo ? " · Demo" : ""}
                            </small>
                          </td>
                          <td>{item.stage}</td>
                          <td>
                            <span className={`status ${item.status}`}>
                              {item.status.replace("_", " ")}
                            </span>
                          </td>
                          <td>v{item.version}</td>
                          <td>
                            <div className="row-actions">
                              {user.role === "author" &&
                                item.status !== "published" && (
                                  <button onClick={() => edit(item)}>
                                    Edit
                                  </button>
                                )}
                              {user.role === "author" &&
                                item.status === "draft" && (
                                  <button
                                    disabled={busy}
                                    onClick={() => transition(item, "submit")}
                                  >
                                    Submit
                                  </button>
                                )}
                              {user.role === "reviewer" &&
                                item.status === "in_review" && (
                                  <button onClick={() => edit(item)}>
                                    Review
                                  </button>
                                )}
                              {user.role === "publisher" &&
                                item.status === "approved" && (
                                  <button
                                    disabled={busy}
                                    onClick={() => transition(item, "publish")}
                                  >
                                    Publish
                                  </button>
                                )}
                              {user.role === "publisher" &&
                                item.status === "published" && (
                                  <button
                                    disabled={busy}
                                    onClick={() => transition(item, "withdraw")}
                                  >
                                    Withdraw
                                  </button>
                                )}
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                  {!visible.length && (
                    <div className="empty">
                      <BookOpen />
                      <h3>A little room for something new.</h3>
                      <p>No articles match this view.</p>
                    </div>
                  )}
                </div>
              </section>
              <p className="studio-foot">
                Clinical journal data is never displayed in the editorial
                workspace.
              </p>
            </>
          ) : (
            <>
              <div className="studio-title">
                <div>
                  <div className="eyebrow">
                    IN-PLATFORM CARE & SPECIALISTS · JOS PILOT
                  </div>
                  <h1>Care inquiries</h1>
                  <p>
                    Review non-emergency questions from members and assign
                    verified clinical reviewers.
                  </p>
                </div>
              </div>
              <div className="stats">
                <div className="stat">
                  <MessageCircle size={19} />
                  <span>All inquiries</span>
                  <strong>{careRequests.length}</strong>
                </div>
                <div className="stat">
                  <Clock size={19} />
                  <span>Pending assignment</span>
                  <strong>
                    {careRequests.filter((r) => r.status === "pending").length}
                  </strong>
                </div>
                <div className="stat">
                  <CheckCircle size={19} />
                  <span>Assigned & active</span>
                  <strong>
                    {careRequests.filter((r) => r.status === "assigned").length}
                  </strong>
                </div>
              </div>
              <p className="notice">
                YanMata is not an emergency service. Response times are 24–48
                hours by verified clinical volunteers in the Jos pilot.
              </p>
              {error && (
                <p className="error" role="alert">
                  {error}
                </p>
              )}
              {notice && (
                <p role="status" className="notice">
                  {notice}
                </p>
              )}
              <section className="library-panel">
                <div className="library-toolbar">
                  <div className="filter-tabs">
                    {["all", "pending", "assigned"].map((s) => (
                      <button
                        key={s}
                        aria-pressed={careFilter === s}
                        onClick={() => setCareFilter(s)}
                      >
                        {s === "all" ? "All inquiries" : s}
                      </button>
                    ))}
                  </div>
                  <button
                    className="refresh"
                    aria-label="Refresh inquiries"
                    onClick={loadCare}
                  >
                    <RefreshCw size={17} />
                  </button>
                </div>
                <div className="table-scroll">
                  <table>
                    <thead>
                      <tr>
                        <th>Status</th>
                        <th>Topic & Chapter</th>
                        <th>Inquiry Summary</th>
                        <th>Journal Shared?</th>
                        <th>Assigned Specialist</th>
                        <th>Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {careRequests
                        .filter(
                          (r) =>
                            careFilter === "all" || r.status === careFilter,
                        )
                        .map((r) => (
                          <tr key={r.id}>
                            <td>
                              <Tag>{r.status.toUpperCase()}</Tag>
                            </td>
                            <td>
                              <strong>{r.topic}</strong>
                              <small>{r.stage}</small>
                            </td>
                            <td>
                              <p
                                style={{
                                  margin: 0,
                                  fontSize: "13px",
                                  maxWidth: "320px",
                                }}
                              >
                                {r.summary}
                              </p>
                            </td>
                            <td>
                              {r.share_journal_consent ? (
                                <span
                                  style={{
                                    color: "var(--teal)",
                                    fontWeight: 600,
                                    fontSize: "12px",
                                  }}
                                >
                                  ✓ Consented
                                </span>
                              ) : (
                                <span
                                  style={{
                                    color: "var(--muted)",
                                    fontSize: "12px",
                                  }}
                                >
                                  Private (No)
                                </span>
                              )}
                            </td>
                            <td>
                              {r.specialist ? (
                                <div>
                                  <strong>{r.specialist.name}</strong>
                                  <small>{r.specialist.credentials}</small>
                                </div>
                              ) : (
                                <em
                                  style={{
                                    color: "var(--muted)",
                                    fontSize: "12px",
                                  }}
                                >
                                  Unassigned
                                </em>
                              )}
                            </td>
                            <td>
                              {r.status === "pending" ? (
                                <select
                                  aria-label="Assign specialist"
                                  onChange={(e) =>
                                    assignSpecialist(r.id, e.target.value)
                                  }
                                  defaultValue=""
                                  style={{
                                    padding: "6px 10px",
                                    borderRadius: "8px",
                                    border: "1px solid var(--line)",
                                    fontSize: "12px",
                                  }}
                                >
                                  <option value="" disabled>
                                    Assign to...
                                  </option>
                                  {specialists.map((s) => (
                                    <option key={s.id} value={s.id}>
                                      {s.name} ({s.specialty})
                                    </option>
                                  ))}
                                </select>
                              ) : (
                                <span
                                  style={{
                                    fontSize: "12px",
                                    color: "var(--teal)",
                                    fontWeight: 500,
                                  }}
                                >
                                  Assigned
                                </span>
                              )}
                            </td>
                          </tr>
                        ))}
                      {careRequests.length === 0 && (
                        <tr>
                          <td
                            colSpan={6}
                            style={{ textAlign: "center", padding: "30px" }}
                          >
                            No care inquiries found.
                          </td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                </div>
              </section>
              <p className="studio-foot">
                Specialist conversations are confidential and held within
                YanMata. No patient records are exposed outside assigned care.
              </p>
            </>
          )}
        </main>
      </div>
      {editing !== undefined && (
        <div className="editor-wrap">
          <section className="editor" aria-label="Article editor">
            <button
              className="close"
              onClick={() => setEditing(undefined)}
              aria-label="Close editor"
            >
              <X />
            </button>
            <div className="eyebrow">
              {user.role === "reviewer" ? "CLINICAL REVIEW" : "EDITORIAL DRAFT"}
            </div>
            <h2>
              {editing
                ? "A little care with every word."
                : "Begin a new story."}
            </h2>
            {error && (
              <p className="error" role="alert">
                {error}
              </p>
            )}
            <form onSubmit={save}>
              <label className="field">
                Title
                <input
                  required
                  maxLength={160}
                  value={form.title}
                  readOnly={user.role !== "author"}
                  onChange={(e) => setForm({ ...form, title: e.target.value })}
                />
              </label>
              <div className="two-fields">
                <label className="field">
                  Topic
                  <select
                    value={form.topic}
                    disabled={user.role !== "author"}
                    onChange={(e) =>
                      setForm({ ...form, topic: e.target.value })
                    }
                  >
                    {[
                      "Body literacy",
                      "Periods",
                      "Emotional wellbeing",
                      "Healthy ageing",
                    ].map((v) => (
                      <option key={v}>{v}</option>
                    ))}
                  </select>
                </label>
                <label className="field">
                  Life chapter
                  <select
                    value={form.stage}
                    disabled={user.role !== "author"}
                    onChange={(e) =>
                      setForm({ ...form, stage: e.target.value })
                    }
                  >
                    {[
                      "All chapters",
                      "Puberty",
                      "Adolescence",
                      "Adulthood",
                      "Menopause",
                      "Later life",
                    ].map((v) => (
                      <option key={v}>{v}</option>
                    ))}
                  </select>
                </label>
              </div>
              <label className="field">
                Short introduction
                <textarea
                  required
                  maxLength={400}
                  value={form.summary}
                  readOnly={user.role !== "author"}
                  onChange={(e) =>
                    setForm({ ...form, summary: e.target.value })
                  }
                />
              </label>
              <label className="field">
                Article
                <textarea
                  required
                  className="body-editor"
                  maxLength={20000}
                  value={form.body}
                  readOnly={user.role !== "author"}
                  onChange={(e) => setForm({ ...form, body: e.target.value })}
                />
              </label>
              <label className="field">
                Source URL
                <input
                  type="url"
                  required
                  value={form.source_url}
                  readOnly={user.role !== "author"}
                  onChange={(e) =>
                    setForm({ ...form, source_url: e.target.value })
                  }
                />
              </label>
              {user.role === "author" ? (
                <button className="button" disabled={busy}>
                  {busy ? "Saving…" : "Save draft"}
                  <ArrowRight size={16} />
                </button>
              ) : (
                <>
                  <p className="notice">
                    Approving records your account as reviewer. In this demo,
                    approval is a workflow exercise only.
                  </p>
                  <button
                    type="button"
                    className="button"
                    disabled={busy}
                    onClick={async () => {
                      if (editing) {
                        await transition(editing, "review");
                        setEditing(undefined);
                      }
                    }}
                  >
                    Approve reviewed revision
                    <CheckCircle size={16} />
                  </button>
                </>
              )}
            </form>
          </section>
        </div>
      )}
    </div>
  );
}
createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
