import type { PropsWithChildren } from "react";
export function Brand({ small = false }: { small?: boolean }) {
  return (
    <a
      className={`brand ${small ? "small" : ""}`}
      href="/"
      aria-label="YanMata home"
    >
      <img
        src="/logo.png"
        alt=""
        width={small ? 36 : 44}
        height={small ? 36 : 44}
        className="brand-logo-img"
      />
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
