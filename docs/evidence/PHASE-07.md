# Phase 07 — Public launch hardening

Date: 28 October 2026

## Implemented

- Refined the React public site across desktop and 390px mobile layouts, including accessible navigation, pilot-readiness messaging, privacy/safety sections and a dedicated app-download area.
- Added configurable `VITE_ANDROID_DOWNLOAD_URL` and `VITE_IOS_DOWNLOAD_URL` values. Empty values produce honest “Coming soon” controls; no debug or simulator build is distributed.
- Replaced invented testimonials, practitioner endorsements and public specialist records with clearly labelled readiness statements and synthetic demo profiles.
- Removed the dormant percentage-based risk-assessment mobile implementation and its unused Laravel model. Preventive learning remains available without fabricated personal scores.
- Removed an unverified crisis number and retained Nigeria’s official national emergency number, 112. Registration no longer assumes optional sync consent.
- Kept services-directory fixtures synthetic, unavailable and unverified. They demonstrate the wireframe flow and do not assert facility affiliation.

## Verification

- `cd apps/api && vendor/bin/pint --test && php artisan test`: passed; 34 tests and 209 assertions.
- `cd apps/mobile && dart format lib test && flutter analyze && flutter test`: formatting clean, analysis reported no issues, 13 tests passed and the opt-in live API test was skipped because no seeded test API credential was supplied.
- `npm run format:check && npm run typecheck && npm run build`: passed for the React public and admin apps. Production bundles built successfully.
- Browser acceptance: 1440×900 and 390×844; both had zero horizontal overflow. Mobile navigation was present and the app-download section showed both platforms as “Coming soon” without placeholder navigation.
- Visual evidence: [desktop](screenshots/phase-07-desktop.png) and [mobile](screenshots/phase-07-mobile.png).

## Release gates

- Replace store placeholders only with signed, reviewed Google Play and App Store release destinations.
- Obtain named clinical, safeguarding and language review before publishing health guidance or opening the pilot.
- Verify practitioner credentials and operating procedures before any live specialist is shown as available.
- Complete native encrypted offline storage, physical-device notification testing, production hosting, backups and incident exercises.
