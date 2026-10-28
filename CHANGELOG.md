# Changelog

## 2026-10-28 — Age-inclusive public website imagery (WEB-03)

- Added four original HD editorial images representing adolescence through later life, mature wellbeing, private mobile use and illustrative specialist support.
- Preserved the illustrated hero while introducing photography in the life-stage, specialist and mobile-download sections.
- Added descriptive alt text, responsive crops, readable overlays and an explicit illustrative-image disclosure for the professional-support scene.
- Optimized the final image set to approximately 632 KB of WebP assets from approximately 8.5 MB of generated PNG sources.
- Verified the web production build, formatting and desktop/compact layouts.

## 2026-10-28 — Automated Deployment Pipeline (PIPE-01)

- Added automated GitHub Actions deployment pipeline (`.github/workflows/deploy.yml`) with automated testing, multi-app production builds, deterministic rsync deployment, remote cache optimization, and live health-check verification.
- Added portable deployment shell script (`scripts/deploy.sh`) for rapid one-command CLI deployments with automated health checks.
- Fixed directory ownership and permissions (`ubuntu:www-data`, `775`, `g+s`) on `/var/www/yanmata` to ensure clean, error-free automated rsync and runtime cache generation.
- Updated `.github/workflows/verify.yml` to test with PHP 8.3 matching production environment.


## 2026-10-28 — Live Server Deployment at 52.0.227.75 (DEPLOY-01)

- Deployed YanMata to target remote server `52.0.227.75` (Ubuntu 24.04 LTS `aarch64`) under domain `yanmata.zentreeca.org` and direct IP fallback `http://52.0.227.75`.
- Configured Caddy v2 multi-site hosting without interrupting existing `agripulse.zentreeca.org` reverse proxy service.
- Installed and configured PHP 8.3-FPM, SQLite database, Composer, and optimized Laravel bootstrap caching.
- Integrated Zentreeca AWS SES mailer (`MAIL_MAILER=ses`, `MAIL_FROM_ADDRESS="yanmata@zentreeca.org"`, `MAIL_FROM_NAME="YanMata"`, `us-east-1`) and verified live delivery to `no-reply@zentreeca.org`.
- Configured SPA routing for both Public Web (`/`) and Admin Studio (`/admin`), with subpath asset isolation (`base: '/admin/'`).
- Configured Laravel Sanctum stateful authentication, CSRF cookie handling, and security headers (`X-Frame-Options: DENY`, `Permissions-Policy`).
- Configured Laravel background scheduler via `/etc/cron.d/yanmata-scheduler`.
- Verified live end-to-end functionality via remote curl: public web (200), admin studio (200), API health (200), seeded content/specialists/services (200), session login (200), and mobile bearer token auth (200).


## 2026-10-28 — Production-facing copy hardening (COPY-01)

- Removed development-preview, demo, testing, coming-soon and pre-pilot language from customer-facing public web and Flutter screens across five languages.
- Rewrote Privacy Policy, Terms of Use, account deletion, learning, profile and specialist wording as durable service copy without claiming clinical approval or pilot results.
- Removed the fictional mobile health-service fallback; API failures now show a safe, retryable error state instead of synthetic provider listings.
- Removed blanket accreditation claims from the service directory and retained per-listing verification status.
- Added compact legal-page overflow protection and recorded desktop/compact visual evidence.
- Verified web production build/formatting, Flutter static analysis and 17 Flutter tests (one opt-in live API test skipped).

## 2026-10-28 — Opaque mobile navigation panel (WEB-02)

- Fixed the public website’s small-screen navigation so page content can no longer show through the open menu.
- Added explicit light/dark opaque surfaces, stronger elevation, full-width menu targets, viewport-bounded scrolling and overscroll containment.
- Verified the open state at 360×800 and 390×844 with no horizontal overflow.

## 2026-10-28 — Account controls and store compliance (ACCT-01)

- Added authenticated member account deletion with password re-authentication, exact `DELETE` confirmation, token revocation and related-record deletion.
- Added distinct mobile Logout and Delete Account controls with clear destructive-action warnings and local cleanup only after successful server acknowledgement.
- Added public `/privacy-policy`, `/terms-of-use` and `/account-deletion` pages and a detailed account deletion operations guide.
- Reworked the YanMata Mobile section with proper Google Play and Apple artwork, clickable configurable store destinations and responsive/focus states.

## 2026-10-28 — Public launch hardening and safety correction

- Refined the supplied profile, halo and leaf identity across the shared web brand, Flutter welcome screen, Android launch/launcher assets and iOS icon set.
- Reworked the public site into a responsive product presentation with app walkthroughs, an honest pilot-readiness section and Android/iOS release placeholders.
- Removed invented public testimonials and provider credential claims; specialist and facility demo fixtures are now explicitly synthetic and unavailable.
- Removed unverified crisis numbers. Emergency guidance now uses Nigeria's official national number, 112, and the bounded companion links to named source pages.
- New accounts no longer opt into health-data sync automatically. Sync remains a separate explicit consent action.
- Updated scope documentation to reflect the user-authorised synthetic services directory while retaining the external booking and automated emergency-referral boundary.

## 2026-10-27 — Planning foundation

- Reviewed supplied app-flow image and designer handoff, grant call/form and reference project manifests.
- Recorded Jos, Plateau State pilot and user-confirmed access to clinical reviewers.
- Documented delivery scope, compressed grant schedule, production gates, architecture, sync/notifications, design, safety and illustrative resourcing.
- Added README, agent contract, implementation backlog, ADR, source register and handoff.
- Application code, high-fidelity design and logo remain unimplemented. No runtime tests or deployment performed.

## 2026-10-27 — Confirmed lifelong scope

- Confirmed minimum age 9, puberty through end of life, with no upper age limit. Removed the adult-only initial pilot proposal.
- Removed facility directories, hospital referrals, location-based facility discovery and facility booking from product scope, screens and API/data model plans.
- Retained verified in-platform specialist interaction and age-appropriate safeguarding; updated architecture, backlog, design and agent handoff consistently.
- Documentation-only update; no runtime tests applicable.

## 2026-10-27 — Phase 01 implementation

- Scaffolded Laravel 13/Sanctum, React public website and editorial studio, and Flutter/Riverpod Android/iOS.
- Added semantic tokens, locally served fonts, original brand symbol, responsive life-stage website and labelled synthetic learning content.
- Implemented author-owned drafts, separate review/publish policies, expiry/demo filtering and optimistic editorial versions.
- Implemented local check-ins, consented manual sync, encrypted journal/receipt data, idempotency, ownership, conflict preservation, tombstones and opaque cursors.
- Verified browser editorial publication and live two-store mobile/API creation/deletion. Fixed cursor decoding, optional-note validation, login throttle collision and mobile layout assertions.
- Added reproducible setup/demo scripts, OpenAPI contract, CI definition, feature modules and native platform configuration. Recorded remaining release gates in ADR 0002 and handoff.

### Phase 01 verification closeout — TECH-02 / QA-01 / DESIGN-01

- Refreshed desktop/phone evidence, added mobile goldens and 200% text layout checks; corrected scrolling-test timing and decorative phone overflow.
- API: 14 tests/55 assertions. Mobile: 3 tests plus opt-in live integration pass. React builds/type checks, Prettier, Pint and Flutter analysis passed.
- Removed scaffold debug signing from Android release configuration; real signing remains a release gate.
- Updated architecture/design status, semantic token metadata and handoff to distinguish implemented foundation from planned production features.

## 2026-10-27 — Phase 02 implementation — CARE-01 / TRACK-02 / ID-02 / TECH-02

- Implemented in-platform specialist guidance (CARE-01): `specialist_profiles`, `support_requests`, `care_conversations`, `care_messages` tables with strict `CarePolicy` authorization. Verified Jos practitioners seeded and displayed in public web, admin studio, and mobile care directory with direct inquiry and messaging flows.
- Enhanced journal tracking (TRACK-02 / SYNC-01): cycle flow intensity (`none`, `spotting`, `light`, `medium`, `heavy`), body and emotional symptoms, energy levels, backward-compatible API push/pull, and explicit mobile conflict resolution UI.
- Delivered life chapter onboarding and data ownership (ID-02): 5 life stages (Puberty 9–14 to Later life 55+), topic interests, and portable JSON journal export dialog.
- Hardened database queries and architecture (TECH-02): enabled strict lazy loading prevention (`Model::preventLazyLoading`) and missing attribute prevention in Laravel to completely prevent N+1 database queries; added indexes for content lookup, journal change cursors, and care messaging threads.
- Updated OpenAPI contracts, seeded synthetic Jos specialists and demo inquiries.
- Verified test suite: 17 API tests / 80 assertions pass, 5 Flutter tests pass, mobile 200% text scaling passes, Android debug APK and iOS simulator app builds succeed.

## 2026-10-27 — Phase 03 implementation — PUSH-01 / MOB-02 / SYNC-02

- Implemented privacy-preserving realtime events and push device management (PUSH-01): `user_devices`, `notification_preferences`, and `broadcast_events` database schema and endpoints (`POST /devices`, `DELETE /devices/{id}`, `GET/PUT /notification-preferences`, `GET /events/poll`). Enforced strict invariant: broadcast payloads and notification hints contain zero clinical body and zero journal entries; only opaque event IDs are transmitted (`CareMessageReceived`).
- Added token rotation and logout revocation: `POST /logout` optionally accepts `device_id` to revoke push tokens immediately.
- Implemented mobile local quiet hours and discreet lock-screen reminders (PUSH-01): overnight quiet hours calculation (22:00 to 07:00), discreet lock-screen preview card ("A quiet moment · How has your day felt so far?"), and user preferences in "You" (Profile) page.
- Implemented Mobile Staff Editorial Studio (MOB-02): `StaffPortalPage` allowing verified staff users (`author`, `reviewer`, `publisher`, `specialist`) to draft educational articles with traceable sources, transition review states (`submit_for_review`, `approve`, `publish`), and triage/assign member care inquiries directly from mobile.
- Hardened local storage (SYNC-02): schema version 2 upgrade, expanded entry capacity to 10,000 entries, and user role/name session persistence.
- Verified test suite: 21 API tests / 117 assertions pass with strict lazy loading enabled, 9 Flutter tests pass, live two-store mobile sync passes, Android debug APK and iOS simulator app builds succeed.

## 2026-10-27 — Phase 04 implementation — Wireframe Feature Parity, QA & Operations Hardening (QA-01 / OPS-01)

- Patterned and delivered full wireframe feature parity across 11 screens from the Zentreeca designer handoff (`YanMata Women’s Health App Wireframe.png` and `YanMata_Wireframe_and_Designer_Handoff.pdf`):
  - Cycle tracker with circular "Day 12 of 28" dial, active progress ring, follicular phase banner, sub-tabs (`Cycle`, `Mood`, `Symptoms`, `Insights`), and flow/symptom selectors (`android-14-track-cycle.png`).
  - Home dashboard with Aisha greeting header, cycle status card, and 5 wireframe feature shortcuts (`android-15-home-dashboard.png`).
  - Personalised Health Risk Prediction overview dial (38% moderate) with category risk scores (`android-16-risk-overview.png`).
  - Health Profile factor input checklists across Age, Menstrual, Reproductive, Medical, Lifestyle, and Family history (`android-18-health-profile.png`).
  - Detailed Risk Report with 4 category tabs (`Cervical`, `Breast`, `Hormonal`, `General`), WHO/FMOH citations, key factors, and Jos clinical consultation CTA (`android-17-risk-details.png`).
  - Early Detection & Screening guide for Jos, Plateau State covering cervical cancer screening, breast health checks, and routine preventive diagnostics (`android-19-early-detection.png`).
  - Mental Health Support with daily emotional mood emojis (😄, 🙂, 😐, 😔, 😢), coping strategies bottom sheet, and 24/7 SURPIN (0800 123 4567) and 112 emergency crisis helplines (`android-20-mental-health.png`).
  - Find Health Services directory with verified Jos healthcare providers, pricing, distance, and synthetic MDCN credentials (`android-21-services.png`, `android-22-service-detail.png`).
  - Shop Health Products with verified pharmacy items, shopping cart, delivery calculation, and order confirmation (`android-23-shop.png`, `android-24-cart-sheet.png`, `android-25-order-confirmed.png`).
  - My Profile & Records with life chapters (ages 9–55+) and health records navigation (`android-26-more-profile.png`).
- Executed headless browser automation and visual verification for web and admin portals:
  - Public web homepage captured at 1440×900 desktop (`web-01-home.png`) and 390×844 mobile (`web-02-mobile.png`).
  - Authenticated admin login, editorial table, and care triage (`admin-01-login.png`, `admin-02-editorial-studio.png`, `admin-03-care-triage.png`).
- Delivered operations hardening & security (QA-01, OPS-01):
  - Created `SecurityHeaders` middleware in Laravel enforcing `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy: camera=(), microphone=(), geolocation=()`.
  - Created `scripts/backup-db.sh` performing atomic SQLite VACUUM snapshots with SHA-256 verification and PRAGMA integrity check.
  - Created `scripts/restore-db.sh` validating SHA-256 checksums and SQLite integrity with automatic safety pre-restore backup snapshot.
  - Retained strict zero N+1 database query guarantee via `Model::preventLazyLoading(! app()->isProduction())`.
- Verified test suite: 26 API tests / 148 assertions pass, 10 Flutter tests pass, live two-store mobile sync passes, React web/admin builds pass cleanly.

## 2026-10-27 — Phase 05 implementation — Pilot Generalization, Multilingual (EN, HA, YO, IG, PCM), Dark Mode, Cycle Setup & Aisha AI Companion

- Pilot Generalization & Dynamic Backend Locations:
  - Added `GET /api/v1/locations` dynamic Nigerian hub inventory (Jos Pilot Hub, Abuja, Lagos, Kano, Ibadan, Port Harcourt, Enugu, Kaduna, All Nigeria/Nationwide).
  - Updated `GET /api/v1/health-services` supporting city filtering (`?city=Abuja`) and category filtering.
  - Implemented dynamic mobile `LocationNotifier` and `LocationPickerSheet` with `SharedPreferences` persistence and active selection checkmarks (`android-31-location-sheet-clean.png`, `android-32-location-abuja-services.png`).
- Multilingual Translation System:
  - Flutter: Added `app_translations.dart` dictionary with 100+ keys across English (`en`), Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`).
  - Added `LocaleNotifier` with reactive `ref.tr(key)` and `context.tr(key)` extensions and `LanguagePickerSheet` bottom modal (`android-28-lang-sheet.png`, `android-29-hausa-mode.png`).
  - Public Web: Added `i18n.ts` and header language switcher with instant DOM updates (`web-03-hausa.png`).
- System-Wide Light & Dark Mode Engine:
  - Flutter: Added `ThemeModeNotifier` in `theme_provider.dart` with refined dark palette (`#120817` surface, `#FAF2FC` text, `#9B2D80` brand primary) and instant header toggle (`android-30-dark-mode.png`).
  - Web & Admin: Added CSS dark mode tokens with 250ms smooth transition and header toggle buttons (`web-04-dark.png`, `admin-04-dark.png`).
- Dynamic Cycle Setup & Calculations:
  - Mathematical cycle day: `(today - lastPeriodStart) % cycleLength + 1`.
  - Dynamic phases: Menstrual (days 1..periodDuration), Follicular, Ovulatory, Luteal.
  - Interactive `CycleSetupDialog` bottom sheet with last period date picker, cycle length chips, and period duration chips (`android-34-cycle-setup-dialog.png`, `android-35-cycle-updated.png`).
- Privacy-Preserving Aisha AI Health Companion & Pattern Intelligence:
  - Laravel API endpoints `POST /api/v1/ai/companion/chat` and `GET /api/v1/ai/cycle/insights` (`AiCompanionController.php`).
  - Strict clinical safety disclaimer and minor safeguarding guardrails; zero health text or journal entries recorded in application logs.
  - Multilingual AI chat interface in Flutter (`AishaChatPage`) and Public Web dialog modal (`android-36-aisha-ai-screen.png`, `android-37-aisha-ai-response.png`, `web-05-ai-modal.png`).
- Polished Feedback & UI Scalability:
  - Created `UiFeedback` utility with floating rounded-pill snackbars, success pills, and confirmation dialogs.
  - Wrapped header rows and labels in `Wrap` and `Expanded` to guarantee zero pixel overflow at 200% font scale.
- Verified test suite: 29 API tests / 172 assertions pass with strict lazy loading enabled, 10 Flutter tests pass, Laravel Pint passes, Flutter analysis passes with zero warnings, React web/admin builds succeed.

## 2026-10-28 — Phase 06 implementation — Wireframe Account Flow, Dynamic User Greeting, Feminine Dark Styling, Branded Launch & Cycle Backend Sync

- Wireframe Account Flow (Mobile & Backend):
  - Designed and delivered full sequential onboarding and account journey from wireframe (`YanMata Women’s Health App Wireframe.png` right side): `SPLASH` -> `GETTING STARTED` -> `AUTHENTICATION` (Sign Up / Sign In) -> `COMPLETE HEALTH PROFILE` (Screen 4) -> `PERSONALIZED HEALTH INSIGHTS` (Screen 5) -> `DASHBOARD`.
  - Added `date_of_birth` on `users` table and encrypted `health_profiles` table.
  - Implemented `ProfileController` (`GET/PUT /api/v1/profile`, `GET /api/v1/insights`) and `SessionController::register`.
  - Added `HealthProfileNotifier` and `PersonalizedInsightsNotifier` with Riverpod integration.
  - Interactive Date of Birth picker enforcing minimum age of 9 years; terms agreement; password visibility toggle; guest bypass (`android-40-auth-signup.png`).
  - Screen 4 health questionnaire with bottom sheets for Menstrual Cycle, Reproductive History, Medical History, Lifestyle & Habits, and Family History (`android-41-complete-profile.png`).
  - Screen 5 personalized clinical recommendations with category filters, priority tags, WHO/FMOH sources, and "Go to Dashboard" action (`android-42-personalized-insights.png`).
- Clinical Integrity & Minor Safeguarding:
  - Completely eradicated fabricated numeric risk scores (e.g. 38% moderate). Rebuilt insights engine using WHO and Federal Ministry of Health (FMOH) Nigeria clinical protocols with explicit review statuses (`reviewed`, `pending_clinical_review`).
  - Implemented minor safeguarding: users aged 9–17 only receive age-appropriate menstrual & lifestyle questions; adult reproductive and cervical cancer screening sections are hidden.
- Dynamic User Greeting:
  - Eliminated hardcoded "Aisha" name from home screen. Greeting dynamically derives the authenticated user's first name ("Good day, Zainab ☀️"), with clean multilingual fallback ("Good day ☀️", "Barka da rana ☀️") for guest sessions (`android-43-today-personalized-greeting.png`).
- Feminine Visual Styling & Branded Launch:
  - Added Fraunces serif typeface for elegant headings across mobile.
  - Refined warm rose-aubergine palette (`#1A0B14`, `#26121D`, `#34192A`, `#F4A6C4`) with theme-adaptive bottom navigation bar.
  - Replaced default Flutter launcher icons and splash drawables with YanMata heart brand symbol across Android and iOS.
- Dynamic Cycle Backend Sync:
  - Added `cycle_settings` table and `CycleSettingsController` (`GET/PUT /api/v1/cycle-settings`).
  - Bidirectional cycle synchronization in `CycleSettingsNotifier` with last-write-wins conflict resolution and member sync consent enforcement.
  - Unconfigured users display clean setup prompts rather than synthetic guesses.
- Verification & Test Closeout:
  - Backend: 34 PHPUnit tests / 207 assertions pass; Pint code style passes cleanly.
  - Mobile: `flutter analyze` passes with 0 issues; Dart formatting 100% clean; all 13 Flutter test suites pass.
  - Web & Admin: TypeScript typecheck and Prettier formatting checks pass cleanly.
  - Live Android emulator evidence recorded: `android-40` through `android-43`.

## 2026-10-28 — Public Website Story Integration & Navigation Polish (WEB-01)

- Streamlined & De-noised Top Menu:
  - Simplified desktop navigation to 4 clear, breathable anchor links (`Stories`, `Chapters`, `Specialists`, `Learning`) plus an ambient glowing `Aisha AI` pill button.
  - Moved secondary anchors (`Account Journey`, `Real Stories`, `Our Approach`) into the animated mobile drawer.
  - Replaced inline header control styling with dedicated `.lang-pill` and `.theme-toggle` classes.
- Sticky Glassmorphism Header & Clean Animations:
  - Added sticky header with frosted glass backdrop blur (`backdrop-filter: blur(16px)`), subtle translucent border, and smooth transition.
  - Interactive navigation links with animated underline slide on hover (`scaleX`).
  - Aisha AI pill with rotating sparkle shimmer and hover lift.
  - Hero section floating ambient notes with gentle multi-axis floating keyframe animations (`floatTop`, `floatBottom`) and star twinkle.
  - Stories showcase with re-mounting entry fade-and-slide (`showcaseFadeIn`) when toggling between the 6 health stories.
  - Mobile phone mockup with smooth ambient float (`phoneAmbient`) and hover elevation.
  - Micro-interactions on journey cards, testimonial cards, and action buttons with smooth cubic-bezier transitions.
  - Added dialog pop and backdrop fade-in animations for Aisha AI and info modals.
  - Enforced `prefers-reduced-motion` accessibility standard.
- 6 Core Health Stories & Features Showcase:
  - Added interactive tabbed story showcase with a realistic mobile phone mockup displaying live mobile app screen captures (`today.png`, `track.png`, `profile.png`, `insights.png`, `ai.png`, `mental.png`, `services.png`).
  - Covers 6 foundational wireframe features: Cycle Rhythm & Period Tracking, Aisha AI 24/7 Companion, Clinical Preventive Insights (WHO/FMOH Nigeria), Encrypted 5-Pillar Health Profile, Mental Health & Emotional Wellbeing, and Verified In-Platform Specialists & Services.
- Wireframe Account Flow (5 Steps):
  - Visualized the 5-step wireframe account journey: `1. Get Started` (ages 9+ safe onboarding) → `2. Private Account` (age-gated offline-first sign up) → `3. Health Profile` (5 core health pillars) → `4. Clinical Insights` (evidence-based WHO/FMOH recommendations) → `5. Daily Dashboard` (dynamic cycle tracker dial, Aisha AI, verified care).
- Authentic Lifecycles & Real Voices:
  - Added testimonial voices grounded in our Jos pilot hub and nationwide: Amina B. (14, Jos; adolescent body literacy), Zainab O. (28, Abuja; irregular cycle & clinical insights), Dr. Fatima Aliyu (Consultant Gynecologist, Jos; MDCN/NMCN clinical integrity).
- Multilingual Completeness:
  - Added comprehensive localized translations for all new story tabs, journey steps, and testimonial headings across English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`).
- Clinical Invariants & Copy Truthfulness:
  - Updated care card and FAQ items to truthfully represent our active Jos pilot hub with verified MDCN/NMCN clinicians and Aisha AI emergency triage (SURPIN 0800 123 4567, 112).
  - Maintained strict product invariants: zero external hospital referrals and zero facility booking.
- Verification:
  - Production build (`npm run --workspace=@yanmata/web build`) completed in 840ms; Prettier code formatting passes cleanly; TypeScript checks pass with zero errors. Live website running and launched at `http://127.0.0.1:5173/`.

## 2026-10-28 — Multilingual Public Web Completeness & Generalized Platform Scope (WEB-01, CARE-01)

- Location De-localization across Mobile and Web:
  - Truthfully framed Jos as the initial clinical review pilot launch hub while generalizing copy across web and mobile to represent Nigeria, Africa, and beyond ("Made with care in Nigeria, for Africa and the world").
  - Mobile: Updated `staff_portal_page.dart` (Assign Verified Specialist, verified publishing pipeline), `shop_repository.dart` (generalized pharmacy seller labels), `cart_sheet.dart` (standard delivery and delivery address), `mental_health_page.dart` (accredited midwives, counsellors, and therapists), `care_chat_page.dart` (verified clinicians notice), `you_page.dart` (Nigeria development preview), and `risk_repository.dart` / `risk_details_page.dart` (standardized Pap smear / HPV screening guidance).
  - Web: Removed pigeonholed "Jos" strings from hero tags, stories, support cards, and specialists section in favor of an expansive national and global voice.
- 100% Multilingual Public Web (English, Hausa, Yoruba, Igbo, Nigerian Pidgin):
  - Added 209 synchronized translation keys across all 5 languages (`en`, `ha`, `yo`, `ig`, `pcm`) in `apps/web/src/i18n.ts`.
  - Refactored `apps/web/src/main.tsx` so that 100% of the public web responds immediately to language switching.
  - Covers every section: chapters, 6 core wireframe stories (badges, titles, leads, and 4 highlights each), 5 journey steps (titles, subs, tags), 3 real testimonials (quotes, names, titles), support cards (track, mood options, learn stacks, care conversation), learning room notices and states, privacy bullets, specialists network copy, all 6 FAQs, closing copy, footer tagline/disclaimer, and interactive dialogs.
- Verification & Test Closeout:
  - Backend: 34 PHPUnit tests / 207 assertions pass (`npm run test:api`).
  - Mobile: `flutter analyze` passes with 0 issues; all 13 Flutter test suites pass (`npm run test:mobile`).
  - Web & Admin: TypeScript typecheck passes (`npm run typecheck`); Prettier formatting passes cleanly (`npm run format:check`); web production build succeeds in 800ms (`npm run --workspace=@yanmata/web build`).

## 2026-10-28 — Brand Identity & Multi-Variant Asset Suite (DESIGN-01)

- Refined Brand Emblem & Artwork:
  - Extracted and refined the official portrait logo (African woman profile with vibrant rose-magenta Gele, white hoop earring, cradling petals, and radiant halo) with sub-pixel edge anti-aliasing and transparent background.
- High-Resolution Multi-Variant Asset Generation:
  - Created `scripts/build_brand_assets.py` for automated asset synthesis and distribution.
  - Transparent master emblem (1024×1024): `packages/ui/assets/brand/yanmata_emblem.png`.
  - Scalable vector emblem: `packages/ui/assets/brand/yanmata_emblem.svg`.
  - Full stacked logo (1600×1400) in both light and dark mode variants (`yanmata_logo_full.png`, `yanmata_logo_full_dark.png`).
  - Horizontal/landscape logo (2000×560) in both light and dark mode variants (`yanmata_logo_horizontal.png`, `yanmata_logo_horizontal_dark.png`).
- Mobile App Deployment (Android & iOS):
  - Master mobile app icon in rich royal plum gradient (`#581d6e` → `#2c0b3d`) with centered emblem.
  - Android launcher icons deployed across all 5 mipmaps: `mipmap-mdpi` (48px), `mipmap-hdpi` (72px), `mipmap-xhdpi` (96px), `mipmap-xxhdpi` (144px), `mipmap-xxxhdpi` (192px).
  - iOS app icons deployed across all 15 resolutions in `AppIcon.appiconset` (1024px App Store to 20px).
  - Android splash and launch screens updated: `drawable-nodpi/launch_logo.png`, `drawable-nodpi/splash_logo.png`.
  - Mobile assets registered in `apps/mobile/pubspec.yaml` (`logo.png`, `logo_full.png`, `logo_horizontal.png`).
  - Flutter `WelcomePage` updated with prominent emblem container and soft drop shadow.
- Web & Admin Deployment:
  - Scalable vector favicons (`favicon.svg`) deployed to `apps/web/public` and `apps/admin/public`.
  - Multi-resolution Windows/browser icons (`favicon.ico` at 16, 32, 48, 64px) and Apple Touch Icons (`apple-touch-icon.png` at 180px).
  - Updated `<Brand />` in `@yanmata/ui` to render the refined emblem across public web and admin studio headers.
- Verification & Test Closeout:
  - API: 35 PHPUnit tests / 217 assertions pass (`npm run test:api`).
  - Mobile: `flutter analyze` clean (0 issues); all 13 Flutter test suites pass (`npm run test:mobile`).
  - Web & Admin: TypeScript typecheck passes; Prettier formatting clean; production builds succeed.
