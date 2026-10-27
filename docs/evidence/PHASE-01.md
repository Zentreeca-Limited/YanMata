# Phase 01 — Foundation evidence

Date: 27 October 2026. Status: working foundation, not production-ready. No clinical effectiveness claims.

## Implemented

- Laravel 13 + Sanctum, React public website, React editorial studio, Flutter/Riverpod app.
- Shared semantic colour source, local web fonts, original vector symbol and multigeneration illustration.
- Anonymous learning feed; draft/submit/separate review/publish/withdraw; optimistic editorial versions; expiry and demo visibility controls.
- Mobile local journal/check-in, optional account consent, durable outbox/cursor sync, encrypted server fields/receipts, idempotency, tombstones and ownership restrictions.
- Mobile data adapter uses OS-backed secure storage and serialised writes, capped at 100 entries. It is not the planned production database.

## Commands and observed results

- `npm run typecheck`, `npm run build`, `npm run format:check`: both React apps passed TypeScript/build checks; source formatting passed.
- `php artisan test`: 14 tests / 55 assertions passed; `vendor/bin/pint --test` passed.
- `flutter analyze`: no issues following feature-module split.
- `flutter test`: 3 tests passed (local save/recreation, phone visual baselines and 200% home text scaling); 1 live test deliberately skipped without opt-in credentials. Golden comparison runs on macOS; other platforms retain layout assertions.
- `python3 scripts/test-live-mobile.py`: two independent mobile repositories connected to the running Laravel API; create → sync → second-store pull → delete → second-store absence passed.
- `flutter build apk --debug --dart-define=API_BASE_URL=http://10.0.2.2:8091/api/v1`: Android debug APK built.
- `flutter build ios --simulator --no-codesign --dart-define=API_BASE_URL=http://127.0.0.1:8091/api/v1`: iOS simulator application built, including keychain entitlement update.
- Browser interaction: staff session authenticated with CSRF cookies; authored a synthetic article, submitted it, signed in separately as reviewer then publisher, and verified publication on the public site. Checked desktop 1440px and phone 390px layouts, chapter switching and article dialog.

## Defects found and fixed

A valid encrypted sync cursor was passed as a Stringable rather than a string, causing HTTP 400 on subsequent pulls. Added positive owner-cursor regression coverage. Empty optional notes were normalised before persistence. Numeric throttle rules shared an unintended counter across public traffic and login; replaced login with named account/IP limits. Flutter material/ink composition assertion was corrected. Dart string parsing and template smoke-test issues were fixed before successful builds. Fixed two home overflows at 200% text size and clipped decorative public-web orbits to prevent phone horizontal overflow. The check-in test now waits for scrolling to settle before tapping Save; its initial rerun failed before this correction. Removed one unnecessary test import flagged by analysis.

## Evidence files

`web-desktop.png`, `web-mobile.png`, `admin-desktop.png` capture browser QA. Screenshots refreshed after type-size changes: public desktop 1440px, studio desktop 1280px, both phone 390px. Phone document widths equal viewport widths; the studio table intentionally scrolls inside its container. `admin-mobile.png` records that layout. Mobile baselines are `apps/mobile/test/goldens/{today,track}-phone.png` at 390×844. These are widget renders, not native runtime screenshots. No physical-device notification testing, Android runtime QA, independent penetration test, production deployment, or clinical review has occurred.

## Remaining release gates

See BACKLOG and ADR 0002. In particular: encrypted database migration, consent/age flows, account recovery/export/deletion/MFA, background/realtime sync, explicit conflict resolution UI, cycle/symptom data model, specialist messaging, notifications, offline content, media publishing, accessibility audit and deployment operations.
