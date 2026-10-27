import type { PropsWithChildren } from "react";
export function Brand({ small = false }: { small?: boolean }) {
  return (
    <a
      className={`brand ${small ? "small" : ""}`}
      href="/"
      aria-label="YanMata home"
    >
      <svg viewBox="0 0 48 48" fill="none" aria-hidden="true">
        <path
          d="M24 43C11 34 5 24 8 15c2-7 10-9 16-3 6-6 14-4 16 3 3 9-3 19-16 28Z"
          fill="currentColor"
        />
        <path
          d="M15 20c5 1 9 6 9 15m9-15c-5 1-9 6-9 15"
          stroke="#FFF8F1"
          strokeWidth="2.5"
          strokeLinecap="round"
        />
        <circle cx="24" cy="16" r="3" fill="#FFF8F1" />
      </svg>
      <span>
        YanMata<span className="brand-by">BY ZENTREECA</span>
      </span>
    </a>
  );
}
export function Tag({ children }: PropsWithChildren) {
  return <span className="tag">{children}</span>;
}
export type Article = {
  id: string;
  title: string;
  topic: string;
  stage: string;
  summary: string;
  body: string;
  source_url: string;
  status: string;
  is_demo: boolean;
  version: number;
  reviewed_at: string | null;
  review_due_at: string | null;
};
export type Member = {
  id: number;
  name: string;
  role: string;
  sync_consent: boolean;
};
export type Specialist = {
  id: string;
  name: string;
  title: string;
  credentials: string;
  specialty: string;
  bio: string;
  city: string;
  verification_source: string;
  is_verified: boolean;
  is_available: boolean;
};
export type SupportRequest = {
  id: string;
  user_id: number;
  specialist_id: string | null;
  topic: string;
  stage: string;
  summary: string;
  status: string;
  share_journal_consent: boolean;
  specialist?: Specialist;
  conversation_id?: string;
  created_at: string;
  updated_at: string;
  user?: Member;
};
export async function api<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  const csrf = document.cookie
    .split("; ")
    .find((row) => row.startsWith("XSRF-TOKEN="))
    ?.split("=")
    .slice(1)
    .join("=");
  const response = await fetch(`/api/v1${path}`, {
    ...options,
    credentials: "include",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      ...(csrf ? { "X-XSRF-TOKEN": decodeURIComponent(csrf) } : {}),
      ...options.headers,
    },
  });
  if (!response.ok) {
    let message = "Something went wrong. Please try again.";
    try {
      const body = await response.json();
      message = body.message ?? message;
    } catch {
      /* Keep a safe fallback. */
    }
    throw new Error(message);
  }
  return response.status === 204 ? (undefined as T) : response.json();
}
