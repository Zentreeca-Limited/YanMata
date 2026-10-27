# Architecture specification

Status: target architecture with a runnable Phase 01 foundation. See ADR 0002 for implemented boundaries and temporary adapters; PostgreSQL, realtime and notifications remain planned.

## Boundaries

Use a modular monolith initially: Laravel owns identity/consent, tracking, education, care access, publishing, notifications and audit. PostgreSQL is the canonical shared datastore; Redis handles queues, rate limits and ephemeral coordination. Private S3-compatible storage holds uploads; approved public media has a separate delivery policy. React public web and React admin/specialist applications consume the same versioned API as Flutter. Public pages should be prerendered/server-rendered for discovery and fast initial load; select the compatible React framework in a scaffold ADR. Keep personalised health data out of public rendering caches.

MVC is an interface structure, combined with clean dependency boundaries rather than duplicating business logic. Laravel: route → FormRequest/policy → controller → application action → domain/infrastructure → API Resource. Eloquent models remain in persistence-aware modules. Flutter: View → Riverpod Notifier/AsyncNotifier controller → use case → repository interface → local/remote implementation. Domain code must not depend on widgets or HTTP clients. React: routed view → feature hook/controller → typed API client; Laravel enforces all permissions.

## Version policy and foundation audit

Official pages on 27 October 2026 identify Laravel 13 and React 19.3. Pin compatible stable patches at scaffold time, along with PHP, Node, Flutter/Dart and Riverpod; record installed versions, minimum supported devices and lockfiles. Verify native plugin compatibility on iOS/Android before adopting a database encryption adapter. Do not use experimental Riverpod persistence as the clinical journal datastore.

Reference Flutter project: `/Users/user/StudioProjects/dater`. Manifest declares GetX/GetStorage, Firebase messaging, Firestore, local notifications, media and networking packages. Reuse candidates: permission flows, platform setup patterns, media handling and notification lifecycle concepts, subject to source and licence review. Rebuild state management and persistence for Riverpod; package presence is not proof of correctness.

Reference backend: `/Users/user/Desktop/DevKings/Projects/Relationship-Essential`. Manifest declares Laravel ^12, React ^18.3, Filament, Sanctum, Reverb, FCM and media/role packages. Reuse candidates: audited queue, broadcast, media and policy patterns. Build React administration as requested. Avoid importing unrelated dating/payments/subscriptions logic, database records, Firebase identity, credentials or signing materials. A limited source review is recorded in FOUNDATION-AUDIT.md; it is not a security audit. Inspect that repository's AGENTS.md before future source work. Do not copy wildcard dependencies or beta stability defaults.

## Authentication and permissions

Browser apps: secure HttpOnly cookies, CSRF protection, explicit CORS/allowed origins and session expiry, using Sanctum's first-party SPA approach where deployment domains support it. Mobile: per-device expiring/revocable Sanctum tokens held in OS secure storage, server-side hashed tokens, documented reauthentication/renewal flow (Sanctum does not supply an OAuth refresh-token flow by default). Require staff MFA and reauthentication for exports, sensitive access and publishing privileges.

Roles: member, author, clinical reviewer, publisher, verified specialist, support operator, security administrator. Apply ownership and assignment policies to every endpoint, upload and private channel. Support/content staff have no default access to journals. Specialist access requires assignment plus scoped, time-limited user consent. Log access metadata without recording health text. Web/mobile role visibility is convenience, never authorisation.

## Core data model

- Account, Device, Session, ConsentRecord (purpose/version/withdrawal), Profile (minimal age-band and chosen topics).
- JournalEntry, CycleEvent, ReminderPreference, SyncMutation, ChangeLog, DeletionTombstone.
- ContentItem, ContentRevision, SourceReference, ClinicalReview, Translation, MediaAsset, Publication.
- SpecialistProfile, ProfessionalCredential, VerificationRecord, SupportRequest, Conversation, Message, AccessGrant.
- NotificationPreference, NotificationDelivery, AuditEvent, ExportRequest, DeletionRequest.

Use opaque IDs, foreign keys, ownership scope, explicit status machines and optimistic versions. Keep age-band decisions separate from optional exact date of birth. Store timestamps in UTC with user timezone and local date for diary semantics. Clinical messages are immutable after send except a governed correction/redaction workflow. Decide retention periods per category before production.

## Offline-first contract

UI reads local persisted state for journal/history, downloaded education and preferences. Use Drift with a vetted encrypted SQLite integration, subject to a native-platform spike. Keys belong in Keychain/Keystore, not preferences or source. Decide recovery and backup policy explicitly: forgotten local-only keys may mean unrecoverable data. Encrypted local data is still exposed on an unlocked compromised device; provide app locking, background privacy cover and shared-device guidance.

1. A local transaction writes the entry and outbox mutation together. Assign client UUID, mutation UUID, entity type, schema version, expected server version and local timestamp.
2. Sync sends bounded batches over authenticated HTTPS. Server checks consent, ownership and validation for each mutation. Idempotency key is scoped to account/device/mutation; repeated requests return the prior outcome.
3. Server applies accepted mutations and records a durable change event in one transaction. Return per-item accepted/conflict/rejected outcomes and canonical versions; remove an outbox item only after durable acknowledgement.
4. Client pulls changes using opaque monotonic cursors, never client clock timestamps. Apply a page transactionally before advancing the cursor. Define cursor expiry/full-resync behaviour that preserves pending local work.
5. Reconnect, app resume and manual refresh trigger reconciliation. Use exponential backoff/jitter and authenticated single-flight sync. A connectivity signal does not prove the server is reachable.

Conflict policy: append-only logs merge by distinct IDs; same-entry edits compare expected versions and require explicit resolution, preserving both drafts. Do not use last-write-wins for health entries. Settings may use documented per-field server ordering. Server owns content/publication/credential status. Deletes create tombstones; stale devices cannot resurrect deleted records. Retain tombstones for the supported offline interval, then require a full snapshot; account deletion invalidates device tokens and old sync epochs.

Revocation/deletion prevents new server writes immediately. Offline devices reconcile on return; remote erasure cannot be guaranteed while a device is disconnected. Logout wipes local account data, keys, cached media and notification schedules; explicitly handle unsynced changes before voluntary logout. A revoked session must not continue uploading a queued draft. No automatic journal upload when a guest later creates an account: ask for sync consent.

Demo acceptance: save in airplane mode → restart → entry remains → reconnect → server receives exactly once → second device sees it → conflicting edit is surfaced → deletion is not resurrected after stale-device replay.

## API and event contracts

Define OpenAPI before clients. Suggested groups: `/api/v1/auth`, `/consents`, `/journal-entries`, `/sync/push`, `/sync/pull`, `/content`, `/specialists`, `/support-requests`, `/conversations`, `/devices`, `/notification-preferences`, `/exports`, `/account-deletion`, `/admin/content`.

Document request/response schemas, pagination, UTC/local date semantics, scoped idempotency, version conflicts, request IDs, validation errors, rate limits and upgrade compatibility. Generate typed Dart/TypeScript models where practical. API tests must verify resource-level access, including guessed IDs and private channel subscriptions.

Use Laravel Reverb over WSS on authenticated private channels. Events carry event ID, entity ID, version and change type, not clinical text. Publish after commit through a transactional outbox. Clients reconcile through REST and deduplicate events; reconnect gaps are expected. Choose a maintained Flutter Pusher-protocol client only after compatibility/auth/reconnect testing against Reverb. Poll while active as a fallback, with appropriate rate limits.

## Notifications

Laravel queues remote delivery using FCM HTTP v1; iOS delivery uses APNs configured through Firebase. Device registration handles consent, token rotation, multi-device ownership, invalid-token cleanup and logout revocation. Never use public topics for private health or specialist messaging. Push contains a generic notice and opaque event reference; authenticated fetch resolves details.

Flutter handles permission prompting, foreground messages, background entry point and terminated-state navigation. Validate deep-link targets and recheck access after login. Assign deterministic notification IDs so OS notification delivery plus foreground local display cannot duplicate an alert. Keep an in-app inbox and REST reconciliation for missed pushes. Force-stop, denied permissions and OS throttling can prevent delivery; neither push nor WebSockets guarantees background execution.

Personal reminders are scheduled locally with timezone-aware dates, quiet hours and opt-in categories. Reschedule after edits, timezone changes, reboot where supported, sign-in/out and permission changes. Respect iOS scheduling limits with a rolling window; assess Android exact-alarm eligibility and prefer inexact scheduling when sufficient. No clinical details on the lock screen by default. Do not require network access for an already scheduled reminder. Announcements and editorial updates originate on the server; local reminder schedules do not.

## Publishing and specialists

Content lifecycle: draft → clinical review → approved → scheduled/published → superseded/withdrawn. Store source, intended audience, reviewer/credential, revision, approval time and review-due date. Changes to clinical text invalidate approval. Enforce identical policies for web and mobile authors, including privileged publication. Media uploads use signed URLs, MIME/size validation, scanning, transcoding and caption/transcript requirements. Broadcast publication changes only after commit; mobile refresh/download uses revisions and expiry rules. Offline cached content shows last verification and may be disabled when its safety validity window expires.

Specialist lifecycle: submitted credential → independently verified → active → expired/suspended. In-platform support requests allocate a verified professional, record user access consent and establish response expectations. Chat is asynchronous, persisted by API, with private-channel updates and generic notifications. Server-accessible encrypted storage is not end-to-end encryption; do not claim E2EE. Recording/video and payments are separate later decisions.

## Operations and validation

Environments: local, CI, demo, staging, production, each with separate databases, buckets, keys and Firebase projects where applicable. Seed only local/demo; production command guards reject demo seeders. Public demo accounts cannot trigger real SMS/email, contact real clinicians or send push to arbitrary devices.

CI: format/analyse, backend unit/feature/access tests, mobile provider/repository/widget tests, API contract checks, React unit and critical-flow browser tests, migration checks, dependency/secret scans and builds. Add sync property/scenario tests for duplicates/reordering/revocation and visual goldens for shared components. Load-test defined pilot traffic after agreeing a capacity target.

Release: immutable builds, migrations with rollback/forward-repair plan, queue workers and scheduler supervision, database backup/restore exercise, media recovery, redacted metrics, uptime/queue/sync failure alerts, key rotation and incident response. Define measurable performance budgets after target-device baselines. Document every command actually used in README/runbooks as implementation arrives.
