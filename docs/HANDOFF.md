# Agent handoff — 28 October 2026

## Confirmed user intent

YanMata is supplied by Zentreeca Limited. Build a working product: Flutter Android/iOS with Riverpod, offline-first/realtime sync, WebSockets, FCM and local reminders; Laravel backend; React public website and React administration. Use clean architecture with MVC presentation/controller separation. Support life-stage female wellbeing, verifiable content, specialists and publishing from web/mobile. Demo uses synthetic seeded data with real workflows. Preserve polished UI and comprehensive continuity docs. Deploy to remote server `52.0.227.75` under `yanmata.zentreeca.org` with AWS SES mail delivery customized for `yanmata@zentreeca.org`.

## Live deployment status (28 October 2026)

The YanMata platform is deployed and running live on AWS server `52.0.227.75` under Caddy and PHP 8.3 FPM:
- **Public Web**: `http://52.0.227.75/` and `http://yanmata.zentreeca.org/` (and HTTPS once DNS propagates)
- **Admin Studio**: `http://52.0.227.75/admin` and `http://yanmata.zentreeca.org/admin`
- **Backend API**: `http://52.0.227.75/api/v1/content` and `/up`
- **Email Delivery**: AWS SES in `us-east-1` from `yanmata@zentreeca.org` (verified active with test dispatch)
- **Coexistence**: Running in harmony alongside existing `agripulse.zentreeca.org` reverse proxy without interruption.
- **DNS Setup Required**: In Cloudflare DNS for `zentreeca.org`, add:
  - Type: `A`
  - Name: `yanmata`
  - Content: `52.0.227.75`
  - Proxy status: Proxied (or DNS only; Caddy handles automatic SSL certificates either way).

Pilot location confirmed: Jos, Plateau State. User has access to doctors/nurses in public/private hospitals for review. Audience confirmed: ages 9 onward, from puberty through the end of life, with no upper age limit. On 28 October the user authorised the synthetic health-services directory from the supplied wireframe. Preserve in-platform specialist interaction; external booking and automated emergency referral remain out of scope. Named clinicians and age-appropriate consent/access protocols still need definition.

## Actual state

Phase 01 through Phase 09 vertical slices are implemented across Laravel, React public/admin, and Flutter Android/iOS.
All screens from the Zentreeca designer handoff and wireframe are fully implemented and verified on the Android emulator runtime, including the full wireframe Account Flow:
1. Native Branded Launch & Welcome (`WelcomePage`, `android-39-onboarding.png`)
2. Screen 3: Authentication (Sign Up & Sign In with DOB picker, age gate >= 9, terms, guest bypass) (`AuthPage`, `android-40-auth-signup.png`)
3. Screen 4: Complete Health Profile questionnaire (Menstrual, Reproductive, Medical, Lifestyle, Family with minor safeguarding) (`CompleteProfilePage`, `android-41-complete-profile.png`)
4. Screen 5: Personalized Health Insights (evidence-based WHO/FMOH guidance without fake risk percentages, category filters, priority badges, "Go to Dashboard" CTA) (`PersonalizedInsightsPage`, `android-42-personalized-insights.png`)
5. Home Dashboard with dynamic personalized greeting ("Good day, Zainab ☀️"), 5 feature shortcuts, live cycle widget, Aisha AI card, multilingual header, location pill, and dark mode toggle (`TodayPage`, `android-43-today-personalized-greeting.png`)
6. Cycle Tracker with circular dial, dynamic phase, and 3-question cycle setup flow (`TrackPage`, `CycleSetupDialog`)
7. Early Detection & Screening Guide (`EarlyDetectionPage`)
8. Mental Health Support with mood emojis, coping modals, and Nigeria's official emergency number 112 (`MentalHealthPage`)
9. Health Services directory with dynamic city filtering (`ServicesPage`, `ServiceDetailSheet`, `LocationPickerSheet`)
10. Shop Health Products with cart, dynamic delivery, and checkout confirmation (`ShopPage`, `CartSheet`)
11. My Profile & Records with life chapters, health records, notification quiet hours, and language selector (`YouPage`)
12. Aisha AI Health Companion with conversational symptom guidance, clinical guardrails, and cycle pattern intelligence (`AishaChatPage`, `AiCompanionController`)
13. Member account controls with device-clearing logout, password-confirmed permanent deletion and explicit warning dialogs (`You`, `LocalJournalRepository`, `DELETE /api/v1/account`)

Brand Identity & Multi-Variant Asset Suite (DESIGN-01):
- Refined Brand Emblem: Extracted and anti-aliased the official YanMata portrait mark (African woman profile with vibrant rose-magenta Gele, white hoop earring, cradling petals, and radiant halo) into high-resolution transparent master assets.
- Complete Asset Variants: Generated stacked full logos (light/dark), horizontal/landscape logos (light/dark), mobile launcher icons across all 5 Android mipmaps and all 15 iOS `AppIcon.appiconset` resolutions, Android launch/splash screens, and web multi-resolution favicons (`favicon.svg`, `favicon.ico`, `apple-touch-icon.png`).
- Cross-Platform Integration: Updated `<Brand />` in `@yanmata/ui` to render the refined emblem across public web and admin studio headers; updated Flutter `WelcomePage` with prominent badge framing; registered assets in `pubspec.yaml`; created `scripts/build_brand_assets.py` for automated regeneration.

Public Website Story Integration, Navigation Polish & Multilingual Localisation (`apps/web`):
- Generalized National & Global Scope: Truthfully framed Jos as the initial clinical review pilot launch hub while expanding copy across web and mobile to represent Nigeria, Africa, and beyond ("Made with care in Nigeria, for Africa and the world").
- Multilingual Public Web: The public website has English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`) copy. Non-English clinical and safeguarding copy still requires human linguistic and clinical review before release.
- Streamlined & De-noised Top Menu: Clean, breathable desktop navigation focused on 4 core anchors (`Stories`, `Chapters`, `Specialists`, `Learning`) plus a glowing `Aisha AI` pill; secondary anchors (`Account Journey`, `Real Stories`, `Our Approach`) cleanly housed in the mobile drawer.
- Sticky Glassmorphism Header: Frosted-glass backdrop blur (`backdrop-filter: blur(16px)`), subtle border, and responsive mobile slide-down drawer with animated menu toggle (`Menu` / `X`).
- Fluid Micro-Animations: Nav link underline slide, rotating sparkle pulse on Aisha AI pill, floating ambient notes in Hero, ambient phone mockup float, smooth tab switch entry transition (`showcaseFadeIn`), interactive card hover lifts on journey steps & testimonials, and accessible `prefers-reduced-motion` compliance.
- 6 Core Health Stories / Features Showcase: Interactive phone mockup displaying live mobile app screen captures (`public/screens/*.png`) across Cycle Rhythm, Aisha AI 24/7 Companion, Clinical Preventive Insights, Encrypted 5-Pillar Health Profile, Mental Health Wellbeing, and Verified Specialists.
- Wireframe Account Flow (5 steps): Visualized from first-time onboarding (ages 9+) through private age-gated registration, 5-pillar health profile assessment, WHO/FMOH evidence-based clinical insights, and daily companion rhythm.
- Release-facing copy: public web and mobile no longer present YanMata as a development preview, demo, test, coming-soon product or incomplete pilot. Legal and safety boundaries remain explicit without claiming clinical approval or pilot results. See `docs/evidence/PHASE-09.md`.
- Truthful Clinical Invariants: in-platform specialist consultation remains primary; the services directory is synthetic and must never imply a partnership. No external booking or automated emergency referral. No fabricated risk scores or provider credentials.

Multilingual system covers English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`) on mobile and web. System-wide light/dark mode transitions verified on mobile, public web, and admin with warm rose-aubergine feminine aesthetics and Fraunces typography. Dynamic location engine spans Nigeria (Jos Pilot Hub, Abuja, Lagos, Kano, Ibadan, Port Harcourt, Enugu, Kaduna, Nationwide). Dynamic cycle settings sync with Laravel backend (`GET/PUT /api/v1/cycle-settings`).

Public web and admin studio are fully verified via automated browser testing:
- Desktop (1440×900) and mobile (390×844) public views (`web-01-home.png`, `web-02-mobile.png`)
- Authenticated admin login, editorial table, and care triage (`admin-01-login.png`, `admin-02-editorial-studio.png`, `admin-03-care-triage.png`)
- Public Privacy Policy, Terms of Use and Account Deletion routes plus configured Google Play/App Store cards (`PHASE-08.md`)
- Small-screen public navigation uses an opaque elevated panel in light and dark themes; verified at 360×800 and 390×844 with no horizontal overflow (`WEB-MOBILE-MENU.md`).

Production hardening & operations (QA-01, OPS-01):
- `SecurityHeaders` middleware attached to all web/API responses.
- `scripts/backup-db.sh` creates atomic SQLite VACUUM snapshots with SHA-256 checksums and PRAGMA integrity check.
- `scripts/restore-db.sh` validates SHA-256 checksums and SQLite integrity with automatic pre-restore backup.
- Strict prevention of lazy loading (`Model::preventLazyLoading`) active across all Eloquent models to guarantee zero N+1 database queries.
- Zero clinical text in push or broadcast payloads. The synthetic services directory must stay visibly labelled; external booking and automated emergency referral remain excluded.
- The Flutter client no longer falls back to fictional health-service listings when the API is empty or unavailable. Governed server records remain the only source displayed to members; failures show a retry state.
- All 35 PHPUnit tests (217 assertions) pass; Pint passes with 0 issues; `flutter analyze` is clean; 17 Flutter tests pass with one opt-in live API test skipped; Prettier, TypeScript and both React production builds pass.

Important current boundaries: local backend SQLite; manual HTTP sync; client-rendered public site; seeded identities only. Strict prevention of lazy loading and missing attribute discarding is active on the backend, ensuring zero N+1 database queries. No claims of clinical approval: seed reviewer and specialist timestamps are synthetic and explicitly labelled. Zero clinical text in push or broadcast payloads.

Local demo credentials are in ignored `.env.demo.local`; do not print or commit them. Development ports are API 8091, web 5173, admin 5174. Use `npm run dev`; existing preview processes may not survive a tool/session transition. The source is in the shared workspace, not a separate worktree.

Reference paths:
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata Women’s Health App Wireframe.png`
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata_Wireframe_and_Designer_Handoff.pdf`
- `/Users/user/StudioProjects/dater`
- `/Users/user/Desktop/DevKings/Projects/Relationship-Essential`

Wireframe reviewed visually; PDF text reviewed across four pages. It adds products/commerce, mental wellbeing, learning and clinical/source/privacy requirements. Plan preserves commerce as later scope and changes navigation to prioritise Learn. Cancer-risk percentages in the image are not accepted as a clinical specification.

## Next executable work

1. Read AGENTS, README, ADR 0002, and evidence documents (`PHASE-01.md`, `PHASE-02.md`, `PHASE-03.md`) before changing implemented flows.
2. Deliver QA & operations hardening (QA-01, OPS-01): rate-limiting audit, automated backup and restore script, metrics redaction, error boundary inspection.
3. Deliver native encrypted Drift database migration with outbox/cursor preservation and crash tests. Keep the real two-store API integration test.
4. Replace temporary store destinations with approved live listings, obtain privacy/legal review of the public policies, then add public prerendering/SSR and SEO plus offline content validity windows.
5. Refresh browser screenshots after layout changes, run mobile visual tests, record exact test/build outcomes, and update backlog/change log.

## Open decisions

Minor-access protocol for the confirmed age-9-plus audience; named clinical/safeguarding owners; specialist credential verification; staffing/budget; hosting region/processor contracts; English/Hausa scope; app identifiers/Apple/Firebase accounts; source licence; final visual identity. These decisions gate corresponding live features rather than all engineering.

## Verification

See `docs/evidence/PHASE-01.md` through `docs/evidence/PHASE-09.md` for commands, screenshots, defects, and limitations.
Phase 05 checks:
- API: 29 tests / 172 assertions pass with strict lazy loading prevention active.
- Laravel Pint: passed with zero style violations.
- Mobile: 10 tests pass (persistence, golden baselines, 200% text scale, care specialists, tracking symptoms/flow, quiet hours calculations, discreet lock-screen copy, mobile staff studio, layout stability) + live integration test passes.
- TypeScript, React builds, and Prettier pass for web and admin.
- Visual evidence: 15 screenshots captured across Android live emulator (`android-27` through `android-37`), Public Web (`web-03`, `web-04`, `web-05`), and Admin (`admin-04`).
- Contracts: `packages/contracts/openapi.json` updated with `/locations`, `/health-services`, `/ai/companion/chat`, `/ai/cycle/insights` and validated.
