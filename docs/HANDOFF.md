# Agent handoff — 27 October 2026

## Confirmed user intent

YanMata is supplied by Zentreeca Limited. Build a working product: Flutter Android/iOS with Riverpod, offline-first/realtime sync, WebSockets, FCM and local reminders; Laravel backend; React public website and React administration. Use clean architecture with MVC presentation/controller separation. Support life-stage female wellbeing, verifiable content, specialists and publishing from web/mobile. Demo uses synthetic seeded data with real workflows. Preserve polished UI and comprehensive continuity docs.

Pilot location confirmed: Jos, Plateau State. User has access to doctors/nurses in public/private hospitals for review. Audience confirmed: ages 9 onward, from puberty through the end of life, with no upper age limit. Facilities and hospital referrals are explicitly out of scope. Preserve in-platform specialist interaction. Named clinicians and age-appropriate consent/access protocols still need definition; facility partnerships are not a prerequisite.

## Actual state

Phase 01 and Phase 02 vertical slices are implemented across Laravel, React public/admin, and Flutter Android/iOS. Browser-tested author → reviewer → publisher workflow displays a synthetic article on the public web. Flutter local check-in, cycle flow, multi-symptom body signals, energy tracking, explicit conflict resolution, and two-store live API sync/delete pass. In-platform specialist guidance (CARE-01) is implemented with verified MDCN/NMCN practitioner models, member inquiries with journal sharing consent, asynchronous messaging with CareChatPage, admin studio inquiry triage/assignment, and public web showcase. Android debug APK and iOS simulator application builds succeed. CI is declared. No public deployment or real clinical enrolment.

Important current boundaries: local backend SQLite; mobile secure-storage JSON adapter capped at 100 entries; manual HTTP sync; client-rendered public site; seeded identities only. Reverb/FCM/reminders, mobile staff publishing, and production safety/operations remain to be implemented. Strict prevention of lazy loading and missing attribute discarding is active on the backend, ensuring zero N+1 database queries. No claims of clinical approval: seed reviewer and specialist timestamps are synthetic and explicitly labelled.

Local demo credentials are in ignored `.env.demo.local`; do not print or commit them. Development ports are API 8091, web 5173, admin 5174. Use `npm run dev`; existing preview processes may not survive a tool/session transition. The source is in the shared workspace, not a separate worktree.

Reference paths:
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata Women’s Health App Wireframe.png`
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata_Wireframe_and_Designer_Handoff.pdf`
- `/Users/user/StudioProjects/dater`
- `/Users/user/Desktop/DevKings/Projects/Relationship-Essential`

Wireframe reviewed visually; PDF text reviewed across four pages. It adds products/commerce, mental wellbeing, learning and clinical/source/privacy requirements. Plan preserves commerce as later scope and changes navigation to prioritise Learn. Cancer-risk percentages in the image are not accepted as a clinical specification.

## Next executable work

1. Read AGENTS, README, ADR 0002, evidence/PHASE-01 and evidence/PHASE-02 before changing implemented flows.
2. Deliver PUSH-01: authenticated Reverb WebSocket hints, Firebase Cloud Messaging (FCM HTTP v1) / APNs remote notifications, and local timezone-aware reminders.
3. Deliver MOB-02: mobile staff drafting, media upload, review, and publishing with the same policy rules as the web studio.
4. Deliver native encrypted Drift database migration with outbox/cursor preservation and crash tests. Keep the real two-store API integration test.
5. Add public prerendering/SSR and SEO, plus offline content validity windows.
6. Refresh browser screenshots after layout changes, run mobile visual tests, record exact test/build outcomes, and update backlog/change log.

## Open decisions

Minor-access protocol for the confirmed age-9-plus audience; named clinical/safeguarding owners; specialist credential verification; staffing/budget; hosting region/processor contracts; English/Hausa scope; app identifiers/Apple/Firebase accounts; source licence; final visual identity. These decisions gate corresponding live features rather than all engineering.

## Verification

See docs/evidence/PHASE-01.md and docs/evidence/PHASE-02.md for commands, screenshots, defects, and limitations.
Phase 02 checks:
- API: 17 tests / 80 assertions pass with strict lazy loading prevention active.
- Laravel Pint: passed.
- Mobile: 5 tests pass (persistence, golden baselines, 200% text scale, care specialists, tracking symptoms/flow) + live integration test passes.
- TypeScript, React builds, and Prettier pass for web and admin.
- Android debug APK (`build/app/outputs/flutter-apk/app-debug.apk`) and iOS simulator app (`build/ios/iphonesimulator/Runner.app`) built successfully.
- Contracts: `packages/contracts/openapi.json` updated and validated with JSON parser.
