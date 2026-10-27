# Agent handoff — 27 October 2026

## Confirmed user intent

YanMata is supplied by Zentreeca Limited. Build a working product: Flutter Android/iOS with Riverpod, offline-first/realtime sync, WebSockets, FCM and local reminders; Laravel backend; React public website and React administration. Use clean architecture with MVC presentation/controller separation. Support life-stage female wellbeing, verifiable content, specialists and publishing from web/mobile. Demo uses synthetic seeded data with real workflows. Preserve polished UI and comprehensive continuity docs.

Pilot location confirmed: Jos, Plateau State. User has access to doctors/nurses in public/private hospitals for review. Audience confirmed: ages 9 onward, from puberty through the end of life, with no upper age limit. Facilities and hospital referrals are explicitly out of scope. Preserve in-platform specialist interaction. Named clinicians and age-appropriate consent/access protocols still need definition; facility partnerships are not a prerequisite.

## Actual state

Phase 01 now has runnable Laravel, React public/admin and Flutter applications. Read README for actual commands and ADR 0002 for temporary adapters. Browser-tested author → reviewer → publisher workflow displays a synthetic article on public web. Flutter local check-in and two-store live API sync/delete pass. Android debug and iOS simulator builds succeed. CI is declared but has not run remotely. No public deployment or real clinical enrolment.

Important current boundaries: local backend SQLite; mobile secure-storage JSON adapter capped at 100 entries; manual HTTP sync; conflicts preserved but resolution UI pending; client-rendered public site; seeded identities only. Reverb/FCM/reminders, cycle model, specialists, mobile publishing and production safety/operations are not implemented. No claims of clinical approval: seed reviewer timestamps are synthetic and explicitly labelled.

Local demo credentials are in ignored `.env.demo.local`; do not print or commit them. Development ports are API 8091, web 5173, admin 5174. Use `npm run dev`; existing preview processes may not survive a tool/session transition. The source is in the shared workspace, not a separate worktree.

Reference paths:
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata Women’s Health App Wireframe.png`
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata_Wireframe_and_Designer_Handoff.pdf`
- `/Users/user/StudioProjects/dater`
- `/Users/user/Desktop/DevKings/Projects/Relationship-Essential`

Wireframe reviewed visually; PDF text reviewed across four pages. It adds products/commerce, mental wellbeing, learning and clinical/source/privacy requirements. Plan preserves commerce as later scope and changes navigation to prioritise Learn. Cancer-risk percentages in the image are not accepted as a clinical specification.

## Next executable work

1. Read AGENTS, README, ADR 0002 and evidence/PHASE-01 before changing implemented flows.
2. Finish native encrypted database selection/migration with outbox/cursor preservation, explicit conflict resolution, resumption and crash tests. Keep the real two-store API integration test.
3. Add age-appropriate onboarding/consent history, secure account recovery, MFA and export/deletion. Public registration remains disabled until safe rules exist.
4. Build cycle/symptom flows, scoped specialist messaging and the durable event outbox/Reverb plus FCM/local reminders in separate tested increments.
5. Extend CMS to immutable revisions, named reviewer credentials, captions/media pipeline and mobile authoring. Add public prerendering/SEO and offline content validity.
6. Refresh browser screenshots after layout changes, run mobile visual tests, record exact test/build outcomes, and update backlog/change log. Native Simulator GUI was not found by computer-use; simulator build/launch alone does not validate its UI or Keychain runtime.

## Open decisions

Minor-access protocol for the confirmed age-9-plus audience; named clinical/safeguarding owners; specialist credential verification; staffing/budget; hosting region/processor contracts; English/Hausa scope; app identifiers/Apple/Firebase accounts; source licence; final visual identity. These decisions gate corresponding live features rather than all engineering.

## Verification

See docs/evidence/PHASE-01.md for commands, screenshots, defects and limitations. Final checks: API 14 tests/55 assertions; mobile 3 tests plus separate live integration pass; TypeScript, React builds, Prettier, Pint and Flutter analysis pass. Phone web/admin overflow fixed/checked, mobile 200% home scaling passes. The live integration test initially caught an invalid positive cursor path missed by earlier denial tests; fixed by converting Laravel Stringable to string and adding a regression test. Optional empty notes are normalised. Idempotency canonicalises key ordering. Do not reintroduce these regressions.
