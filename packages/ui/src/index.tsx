import type { PropsWithChildren } from "react";
export function Brand({ small = false }: { small?: boolean }) {
  return (
    <a
      className={`brand ${small ? "small" : ""}`}
      href="/"
      aria-label="YanMata home"
    >
      <svg viewBox="0 0 256 256" fill="none" aria-hidden="true">
        <circle cx="126" cy="118" r="93" fill="#F3A2BE" />
        <path
          d="M106 217c-4-28-13-45-28-62-18-21-26-46-21-71 6-31 31-53 62-58 26-5 52 3 69 22 15 17 22 41 18 64-2 15-10 29-23 39-9 7-17 14-20 25l-3 41z"
          fill="#56327A"
        />
        <path
          d="M153 93c12 0 19 9 17 19l-6 12 10 8-13 5c-4 11-14 18-27 17l-14-1c-3 17-1 39 4 64l-26 1c1-28 2-50-1-69-5-31 12-56 39-56z"
          fill="#56327A"
        />
        <path
          d="M96 219c-30 10-53 5-69-15 17-1 33 2 47 10-16-14-23-30-20-49 19 9 32 25 38 47z"
          fill="#7751A5"
        />
        <path
          d="M72 178c13 10 23 22 30 37"
          stroke="#BBA5D5"
          strokeWidth="4"
          strokeLinecap="round"
        />
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
