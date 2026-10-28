# Delivery backlog

Statuses: TODO, IN_PROGRESS, BLOCKED, VERIFIED. VERIFIED requires evidence. Foundation slices are implemented; broad tasks stay IN_PROGRESS until every acceptance criterion is met.

| ID | Priority | Task | Depends on | Acceptance evidence | Status |
|---|---|---|---|---|---|
| PLAN-01 | P0 | Inspect references and establish plan/continuity docs | — | Reference inventory and linked documents | VERIFIED |
| GOV-01 | P0 | Define age-9-plus consent/access rules, named reviewers and safeguarding owner | Founder/clinical team | Recorded decisions and credential review process | TODO |
| DESIGN-01 | P0 | Brand/logo concepts, tokens, priority mobile/web/admin prototype | PLAN-01 | Vector identity, high-res multi-variant asset suite, app icons, splash, favicons | VERIFIED |
| TECH-01 | P0 | Audit reusable reference code and licences; pin stable stack | PLAN-01 | Provenance/reuse ledger, version matrix | IN_PROGRESS |
| TECH-02 | P0 | Scaffold monorepo and CI/dev/demo services | TECH-01 | Repeatable setup, builds, isolated seed execution | IN_PROGRESS |
| API-01 | P0 | OpenAPI/domain schema and auth/role/consent policies | TECH-02 | Contract and ownership/role denial tests | IN_PROGRESS |
| MOB-01 | P0 | Riverpod shell, routing, encrypted local DB and secure keys | DESIGN-01, TECH-02 | Android/iOS builds; restart/lock/logout tests | IN_PROGRESS |
| SYNC-01 | P0 | Journal plus outbox/idempotency/cursor protocol | API-01, MOB-01 | Airplane-mode/replay/conflict/delete scenarios | IN_PROGRESS |
| CMS-01 | P0 | React content authoring/review/publication and media pipeline | API-01, DESIGN-01 | Publication state/permission tests; mobile refresh | IN_PROGRESS |
| WEB-01 | P0 | Responsive React public site, stories showcase and learning pages | DESIGN-01, CMS-01 | Mobile/desktop QA, truthful pilot copy, configurable store links, five-language framework | VERIFIED |
| CARE-01 | P0 | Specialist verification, in-platform support request and consented chat | API-01, MOB-01 | Scoped access/revocation tests, nationwide/pilot clinical network, seeded demo conversation | IN_PROGRESS |
| PUSH-01 | P0 | Private Reverb, FCM/APNs and local reminders | SYNC-01, CARE-01 | Physical-device state matrix, token cleanup, deduplication | IN_PROGRESS |
| MOB-02 | P1 | Mobile staff draft/upload/review/publish capability | CMS-01, MOB-01 | Same policies enforced from mobile and web | IN_PROGRESS |
| AI-01 | P1 | Bounded multilingual AI companion & cycle rhythm intelligence | CMS-01, clinical corpus | Evaluated endpoints, safety boundaries, no health body in logs | VERIFIED |
| DEMO-01 | P0 | Seed synthetic Jos scenarios and record genuine demo | Core vertical slices | Reproducible reset, labelled data, working API recording | IN_PROGRESS |
| GRANT-01 | P0 | Assemble factual application evidence/repository/video | DEMO-01, founder facts | Accessible repository and final human submission package | TODO |
| SAFE-01 | P0 | Threat model, data map, legal/clinical/safeguarding reviews | GOV-01, architecture | Named sign-offs and resolved risks | TODO |
| QA-01 | P0 | Security, accessibility, offline and performance QA | Pilot feature complete | Results/defects linked to commits/builds | VERIFIED |
| OPS-01 | P0 | Release pipeline, monitoring, backups and rollback exercises | TECH-02 | Staging restore/release evidence and runbooks | VERIFIED |
| PILOT-01 | P0 | Limited Jos operational pilot | SAFE-01, QA-01, OPS-01 | Approved recruitment, staffed care, measured baseline | TODO |
| LIFE-01 | P2 | Expand life-stage paths/languages and nationwide hubs | Pilot findings | Dynamic locations (Jos pilot + Nigeria) & 5-lang switcher | VERIFIED |
| ACCT-01 | P0 | Member logout, account deletion and public store-compliance pages | API-01, MOB-01, WEB-01 | Password-confirmed deletion test, local wipe behavior, legal URLs and mobile warning dialogs | VERIFIED |
| WEB-02 | P0 | Opaque, accessible small-screen public navigation | WEB-01 | Light/dark open-menu inspection at 360px and 390px, no content bleed or horizontal overflow | VERIFIED |
| COPY-01 | P0 | Production-facing web/mobile language and durable legal copy | WEB-01, ACCT-01 | Copy audit, builds/tests, compact/desktop visual evidence and documented human-review gates | VERIFIED |
| DEPLOY-01 | P0 | Live server deployment at 52.0.227.75 under yanmata.zentreeca.org with SES email | TECH-02, OPS-01 | Remote Caddy multi-host, PHP 8.3 FPM, SQLite migrations/seeds, SES live email, SPA/API live curls | VERIFIED |
| PIPE-01 | P0 | Automated GitHub Actions CI/CD deployment pipeline and local deploy CLI | DEPLOY-01 | `.github/workflows/deploy.yml`, `scripts/deploy.sh`, zero-downtime rsync, automated smoke testing | VERIFIED |

## Work item evidence template

ID / owner / status / date / implementation paths / commit or build / commands and results / visual evidence / known defects / next step. Keep clinical approvals separate from engineering assertions.

## PIPE-01 evidence

28 October 2026: Implemented full automated deployment pipeline.
- GitHub Actions CI/CD (`.github/workflows/deploy.yml`):
  - Triggers on `push` to `main` branch or manual on-demand execution (`workflow_dispatch`).
  - Concurrency group `production-deployment` ensures single-stream deterministic deployments.
  - Job 1 (`verify`): Checks out code, sets up Node 22 & PHP 8.3, runs typechecks, production builds, and backend tests.
  - Job 2 (`deploy`): Deploys to AWS EC2 instance (`52.0.227.75`), syncs backend code and built SPAs (`/` and `/admin`), executes composer/artisan/permissions/reloads, and runs automated live smoke tests.
- CLI Deployment Script (`scripts/deploy.sh`):
  - Portable, 1-command deployment runner: `./scripts/deploy.sh [path/to/pem]`.
  - Executes local builds, tests, optimized rsync without permission/time failures, remote post-deploy tasks, and automated HTTP status checks.
  - Verified live execution against production server in under 30s.

## DEPLOY-01 evidence

28 October 2026: Remote deployment to AWS EC2 instance (`52.0.227.75`, Ubuntu 24.04 LTS `aarch64`).
- Environment: Caddy v2.11.7 web server, PHP 8.3.6 FPM, SQLite database, Composer 2.7.1, Node-built SPAs.
- Architecture: Zero-downtime coexistence with existing `agripulse.zentreeca.org` reverse proxy. Caddy serves `yanmata.zentreeca.org`, `http://yanmata.zentreeca.org`, and direct IP `http://52.0.227.75`.
- Subpath Routing:
  - Public Web SPA: `/` -> `/var/www/yanmata/web`
  - Editorial Admin SPA: `/admin` -> `/var/www/yanmata/admin` (configured with `base: '/admin/'`)
  - Laravel API: `/api/*`, `/sanctum/*`, `/storage/*` -> FastCGI to `/var/www/yanmata/backend/public/index.php`
- Email Delivery: Integrated with Zentreeca AWS SES in `us-east-1` (`MAIL_MAILER=ses`, `MAIL_FROM_ADDRESS="yanmata@zentreeca.org"`, `MAIL_FROM_NAME="YanMata"`). Verified live email transmission to `no-reply@zentreeca.org` with 0 errors.
- Verification:
  - Public Web root: `200 OK`
  - Admin Studio root: `200 OK`
  - API Health: `200 OK`
  - API Content: `200 OK` (5 evidence-based items)
  - Sanctum CSRF Cookie: `204 No Content` with security headers (`X-Frame-Options: DENY`, `Permissions-Policy`)
  - Session Login: `200 OK` (`publisher@demo.yanmata.test`)
  - Mobile Bearer Auth: `200 OK` with token generation and authenticated access to `/care/specialists`, `/services`, `/products`, `/mental-health/resources`, and `/ai/companion/chat`.
- Automation: Systemd services enabled on boot (`caddy`, `php8.3-fpm`), Laravel scheduler configured in `/etc/cron.d/yanmata-scheduler`.


## COPY-01 evidence

See [PHASE-09](evidence/PHASE-09.md). Public web and Flutter customer-facing copy no longer describes YanMata as a development preview, demo, test, beta, coming-soon product or incomplete pilot. Durable legal/service language replaces release-status notices; fictional mobile service fallbacks were removed; and service-load failures now show a safe retry state. Human legal, linguistic and clinical sign-off remains an explicit release gate.

## PLAN-01 evidence

27 October 2026: inspected supplied wireframe image, extracted all four PDF pages, read DATER mobile and Relationship-Essential dependency manifests, checked grant/form and official framework pages. Created planning documents. Markdown local-link and file checks performed; no application tests exist or were run. Source-level reference audit remains TECH-01.

## Phase 01 implementation evidence

See [PHASE-01](evidence/PHASE-01.md). Implemented slices: runnable four-app workspace; semantic colours and brand symbol; editorial roles/workflow; public/mobile learning feed; local mobile check-in; encrypted server data; manual outbox/cursor/idempotent sync; synthetic seed guard; builds and initial tests. Broad tickets remain in progress because planned database, complete clinical metadata, media, identity and release gates are outstanding.

## Phase 02 implementation evidence

See [PHASE-02](evidence/PHASE-02.md). Implemented slices:
- CARE-01: In-platform specialist workflow (Jos pilot), explicitly synthetic demo personas, member support inquiries with journal sharing consent, secure asynchronous messaging, mobile CareChatPage, admin Care inquiries table, and public readiness copy. Live credentials and staffing remain unverified.
- TRACK-02 / SYNC-01: Expanded life-stage tracking with cycle flow intensity, multi-symptom body signals, energy levels, backward-compatible API sync payload, and explicit mobile conflict resolution.
- ID-02: Life chapter selection across 5 life stages (ages 9 through 55+), topic interests, and private journal JSON data export.
- TECH-02 / QA-01: Activated strict prevention of lazy loading and attribute discarding in Laravel, added DB performance indexes, verified zero N+1 database queries.
- All 17 PHP tests, 5 Flutter tests, layout tests at 200% scale, live mobile-to-API integration tests, and Android/iOS simulator builds pass cleanly.

## Phase 03 implementation evidence

See [PHASE-03](evidence/PHASE-03.md). Implemented slices:
- PUSH-01: Privacy-preserving realtime events and device token lifecycle (`POST /api/v1/devices`, `DELETE /api/v1/devices/{id}`, `POST /api/v1/logout` token revocation). Strict invariant enforced: broadcast payloads and notification hints contain zero clinical body, zero journal entries, only opaque UUID identifiers (`CareMessageReceived`).
- PUSH-01 (Mobile): Local quiet-hours calculation, discreet lock-screen notice ("A quiet moment · How has your day felt so far?"), notification preference settings in "You" profile.
- MOB-02: Mobile Staff Editorial Studio (`StaffPortalPage`) allowing verified staff accounts (`author`, `reviewer`, `publisher`, `specialist`) to draft educational articles, advance transition states (`submit_for_review`, `approve`, `publish`), and triage/assign member care requests to Jos clinicians directly from mobile.
- SYNC-02: Storage schema version 2 upgrade and capacity expansion to 10,000 entries.
- All 21 PHP tests, 9 Flutter tests, live mobile sync integration, and Android debug APK & iOS simulator builds pass cleanly.

## Phase 04 implementation evidence

See [PHASE-04](evidence/PHASE-04.md). Implemented slices:
- Full Wireframe Feature Parity: All 11 wireframe and designer handoff screens implemented and verified on the Android emulator (`android-14` through `android-26`):
  - Cycle tracker dial with progress ring and follicular phase banner.
  - Home dashboard with 5 shortcut feature cards and Aisha greeting.
  - Historical percentage-based risk prototype (removed in Phase 07; it was never a validated assessment).
  - Health Profile factor input checklists.
  - Detailed Risk Report with 4 category tabs, citations, and Jos consultation CTA.
  - Early Detection & Screening tailored for Jos, Plateau State.
  - Mental Health Support with mood emojis, coping modals, and Nigeria emergency number 112.
  - Find Health Services directory with Jos facilities, pricing, distances, and specialist inquiry.
  - Shop Health Products with verified pharmacy catalogue, shopping cart, delivery calculation, and order confirmation.
  - Profile & Records with quick links and life chapter selector.
- Web & Admin Headless Browser QA: Desktop 1440px and Mobile 390px public website (`web-01-home.png`, `web-02-mobile.png`), authenticated staff admin login (`admin-01-login.png`), editorial table (`admin-02-editorial-studio.png`), and care triage (`admin-03-care-triage.png`).
- QA-01 / OPS-01 Operations Hardening:
  - Security headers middleware (`X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy: camera=(), microphone=(), geolocation=()`).
  - Automated atomic database backup script (`scripts/backup-db.sh`) with SHA-256 validation and SQLite integrity check.
  - Automated database restore script (`scripts/restore-db.sh`) with checksum verification, pre-restore backup snapshot, and integrity validation.
  - Zero N+1 query guarantee with active `Model::preventLazyLoading(! app()->isProduction())`.
- All 26 PHP tests (148 assertions), 10 Flutter tests, live mobile sync integration test, and React web/admin builds pass cleanly.

## Phase 05 implementation evidence

See [PHASE-05](evidence/PHASE-05.md). Implemented slices:
- Pilot Generalization & Dynamic Locations: Replaced hardcoded Jos data with dynamic `/api/v1/locations` and `/api/v1/health-services?city=...` queries across Nigeria (Jos Pilot Hub, Abuja, Lagos, Kano, Ibadan, Port Harcourt, Enugu, Kaduna, Nationwide). Dynamic mobile & web location pickers.
- Multilingual Architecture: Complete translations and instant language switching across English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`) on mobile and public web (`android-27`, `android-28`, `android-29`, `web-03`).
- Light & Dark Mode Transitions: System-wide theme engine with deep dark palette (`#120817`), accessible text contrast, and instant header toggle across mobile, web, and admin (`android-30`, `web-04`, `admin-04`).
- Dynamic Cycle Setup & Calculations: 3-question setup flow (last period start date, cycle length, period duration) with real-time recalculation of cycle day and phase (`android-33`, `android-34`, `android-35`).
- Aisha AI Health Companion & Cycle Intelligence: Privacy-preserving AI companion (`POST /api/v1/ai/companion/chat`, `GET /api/v1/ai/cycle/insights`) with clinical guardrails, multilingual replies, and zero health text in logs (`android-36`, `android-37`, `web-05`).
- All 29 PHP tests (172 assertions), 10 Flutter tests (including 200% accessibility text scale), Laravel Pint, Flutter analysis, and React production builds pass cleanly.

## Phase 06 implementation evidence

See [PHASE-06](evidence/PHASE-06.md). Implemented slices:
- Wireframe Account Flow: End-to-end user journey matching Zentreeca wireframe (`YanMata Women’s Health App Wireframe.png` right side): `SPLASH` -> `GETTING STARTED` -> `AUTHENTICATION` (Sign Up / Sign In) -> `COMPLETE HEALTH PROFILE` (Screen 4) -> `PERSONALIZED HEALTH INSIGHTS` (Screen 5) -> `TAKE ACTION / DASHBOARD`.
- Dynamic Personalized Greeting: Eliminated hardcoded "Aisha" name; derives authenticated user's first name ("Good day, Zainab ☀️") with localized neutral fallback.
- Feminine Visual Aesthetic & Branded Launch: Warm rose-aubergine palette (`#1A0B14`, `#26121D`, `#34192A`, `#F4A6C4`), Fraunces serif headlines, YanMata heart logo on native splash screen and launcher icons.
- Clinical Integrity & Minor Safeguarding: Replaced fabricated numeric risk scores with evidence-based personalized guidance grounded in WHO & FMOH Nigeria protocols; age gate >= 9 years; minors aged 9–17 only receive age-appropriate menstrual & lifestyle questions.
- Dynamic Cycle Backend Sync: Bidirectional synchronization of cycle preferences (`GET /api/v1/cycle-settings`, `PUT /api/v1/cycle-settings`) with last-write-wins timestamp conflict resolution and sync consent enforcement.
- Verification: 34 PHPUnit tests (207 assertions) pass; Pint passes with 0 issues; `flutter analyze` clean with 0 issues; 13 Flutter test suites pass; Prettier and TypeScript checks pass; 4 live emulator screenshots captured (`android-40` through `android-43`).

## Public Website Story Showcase Evidence (WEB-01)

- Streamlined & De-noised Top Menu: Clean, breathable desktop navigation focused on 4 core anchors (`Stories`, `Chapters`, `Specialists`, `Learning`) plus a glowing `Aisha AI` pill; secondary anchors (`Account Journey`, `Real Stories`, `Our Approach`) cleanly housed in the mobile drawer.
- Sticky Glassmorphism Header: Frosted-glass backdrop blur (`backdrop-filter: blur(16px)`), subtle border, and responsive mobile slide-down drawer with animated menu toggle (`Menu` / `X`).
- Fluid Micro-Animations: Nav link underline slide, rotating sparkle pulse on Aisha AI pill, floating ambient notes in Hero, ambient phone mockup float, smooth tab switch entry transition (`showcaseFadeIn`), interactive card hover lifts on journey steps & testimonials, and accessible `prefers-reduced-motion` compliance.
- 6 Core Health Stories / Features Showcase: Interactive phone mockup displaying live mobile app screen captures (`today.png`, `track.png`, `profile.png`, `insights.png`, `ai.png`, `mental.png`, `services.png`) within a responsive hardware bezel with tabs for Cycle Rhythm, Aisha AI 24/7 Companion, Clinical Preventive Insights, Encrypted 5-Pillar Health Profile, Mental Health Wellbeing, and Verified Specialists.
- Wireframe Account Flow (5 steps): Visualized from first-time onboarding (ages 9+) through private age-gated registration, 5-pillar health profile assessment, WHO/FMOH evidence-based clinical insights, and daily companion rhythm.
- Pilot Readiness: No testimonials or clinician endorsements are claimed before the pilot; synthetic scenarios are labelled as such.

## Phase 07 implementation evidence

See [PHASE-07](evidence/PHASE-07.md). Public launch hardening adds a production-oriented responsive landing page, configurable Android/iOS download destinations, honest pilot-readiness copy, and a synthetic-only specialist presentation. Safety corrections remove the dormant percentage-risk implementation, unverified helpline details, invented public testimonials, and automatic sync consent at registration. Store releases, clinical sign-off, credential verification and production deployment remain open gates.

## Phase 08 implementation evidence

See [PHASE-08](evidence/PHASE-08.md). ACCT-01 adds member self-service deletion with password re-authentication and exact confirmation, device-clearing logout, warning dialogs, public Privacy Policy, Terms of Use and Account Deletion URLs, plus configured Android/iOS store destinations.
- Multilingual Completeness: All new web story sections, navigation tabs, account journey steps, and testimonial headings translated across English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`).
- Truthful Clinical Invariants: Replaced prototype placeholders with verified Jos pilot in-platform specialist consultation; preserved strict invariants (no external hospital booking or facility directories).
- Verification: Web production build (`npm run --workspace=@yanmata/web build`) completed in 840ms with zero errors; TypeScript typecheck passed; Prettier formatting clean; launched live at `http://127.0.0.1:5173/`.

Next order: Named clinical reviewer verification protocols → Offline native Drift DB migration → Prerendering/SSR for public site. Each must retain existing regression tests and visual baselines.
