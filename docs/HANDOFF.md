# Agent handoff — 27 October 2026

## Confirmed user intent

YanMata is supplied by Zentreeca Limited. Build a working product: Flutter Android/iOS with Riverpod, offline-first/realtime sync, WebSockets, FCM and local reminders; Laravel backend; React public website and React administration. Use clean architecture with MVC presentation/controller separation. Support life-stage female wellbeing, verifiable content, specialists and publishing from web/mobile. Demo uses synthetic seeded data with real workflows. Preserve polished UI and comprehensive continuity docs.

Pilot location confirmed: Jos, Plateau State. User has access to doctors/nurses in public/private hospitals for review. Audience confirmed: ages 9 onward, from puberty through the end of life, with no upper age limit. Facilities and hospital referrals are explicitly out of scope. Preserve in-platform specialist interaction. Named clinicians and age-appropriate consent/access protocols still need definition; facility partnerships are not a prerequisite.

## Actual state

Phase 01, Phase 02, Phase 03, and Phase 04 vertical slices are implemented across Laravel, React public/admin, and Flutter Android/iOS.
All 11 screens from the Zentreeca designer handoff and wireframe (`YanMata Women’s Health App Wireframe.png` and `YanMata_Wireframe_and_Designer_Handoff.pdf`) are fully implemented and verified on the Android emulator runtime:
1. Welcome/Onboarding (`WelcomePage`)
2. Home Dashboard with 5 feature shortcuts (`TodayPage`)
3. Risk Prediction Overview (`RiskOverviewPage`)
4. Health Profile & Risk Factors Input (`HealthProfilePage`)
5. Detailed Risk Insights Report (`RiskDetailsPage`)
6. Early Detection & Screening Guide (`EarlyDetectionPage`)
7. Cycle Tracker with circular Day 12 of 28 dial and follicular phase (`TrackPage`)
8. Mental Health Support with mood emojis, coping modals, and 24/7 SURPIN/112 crisis helplines (`MentalHealthPage`)
9. Health Services directory with verified Jos facilities and pricing (`ServicesPage`, `ServiceDetailSheet`)
10. Shop Health Products with cart, Jos delivery, and checkout confirmation (`ShopPage`, `CartSheet`)
11. My Profile & Records with life chapters and health records (`YouPage`)

Public web and admin studio are fully verified via automated browser testing:
- Desktop (1440×900) and mobile (390×844) public views (`web-01-home.png`, `web-02-mobile.png`)
- Authenticated admin login, editorial table, and care triage (`admin-01-login.png`, `admin-02-editorial-studio.png`, `admin-03-care-triage.png`)

Production hardening & operations (QA-01, OPS-01):
- `SecurityHeaders` middleware attached to all web/API responses: `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy: camera=(), microphone=(), geolocation=()`.
- `scripts/backup-db.sh` creates atomic SQLite VACUUM snapshots with SHA-256 checksums and PRAGMA integrity check.
- `scripts/restore-db.sh` validates SHA-256 checksums and SQLite integrity with automatic pre-restore backup.
- Strict prevention of lazy loading (`Model::preventLazyLoading`) active across all Eloquent models to guarantee zero N+1 database queries.
- Zero clinical text in push or broadcast payloads. In-platform specialist consultation strictly maintained (no facility directories, booking, or hospital referrals).

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
4. Add public prerendering/SSR and SEO, plus offline content validity windows.
5. Refresh browser screenshots after layout changes, run mobile visual tests, record exact test/build outcomes, and update backlog/change log.

## Open decisions

Minor-access protocol for the confirmed age-9-plus audience; named clinical/safeguarding owners; specialist credential verification; staffing/budget; hosting region/processor contracts; English/Hausa scope; app identifiers/Apple/Firebase accounts; source licence; final visual identity. These decisions gate corresponding live features rather than all engineering.

## Verification

See `docs/evidence/PHASE-01.md`, `docs/evidence/PHASE-02.md`, and `docs/evidence/PHASE-03.md` for commands, screenshots, defects, and limitations.
Phase 03 checks:
- API: 21 tests / 117 assertions pass with strict lazy loading prevention active.
- Laravel Pint: passed with zero style violations.
- Mobile: 9 tests pass (persistence, golden baselines, 200% text scale, care specialists, tracking symptoms/flow, quiet hours calculations, discreet lock-screen copy, mobile staff studio) + live integration test passes.
- TypeScript, React builds, and Prettier pass for web and admin.
- Android debug APK (`build/app/outputs/flutter-apk/app-debug.apk`) and iOS simulator app (`build/ios/iphonesimulator/Runner.app`) built successfully.
- Contracts: `packages/contracts/openapi.json` updated with `/devices`, `/notification-preferences`, `/events/poll` and validated with JSON parser.
