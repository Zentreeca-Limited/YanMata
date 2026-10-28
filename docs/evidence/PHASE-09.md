# Phase 09 — release-facing copy hardening

Date: 28 October 2026  
Work item: COPY-01

## Implemented

- Removed customer-facing development, preview, demo, testing, coming-soon and pre-pilot wording from the public website and Flutter application.
- Rewrote Privacy Policy, Terms of Use and account-deletion retention copy as durable service terms without claiming clinical approval or pilot results.
- Updated English, Hausa, Yoruba, Igbo and Nigerian Pidgin public-site strings. These translations still require human linguistic and clinical approval before release.
- Replaced the mobile learning-room fixture warnings with production-safe educational boundaries, source/reviewer prompts, and complete empty/error/retry states.
- Updated profile, account, specialist and health-service copy. The service directory no longer implies that every listing is accredited or verified.
- Removed the mobile repository's fictional service fallback. An unavailable API now produces a safe retry state instead of silently displaying synthetic providers.
- Tightened small-screen legal-page sizing and overflow handling.

## Verification

- `npm run format:check` — passed.
- `npm run --workspace=@yanmata/web build` — passed; TypeScript and Vite production build completed successfully.
- `cd apps/mobile && flutter analyze` — passed with no issues.
- `cd apps/mobile && flutter test` — 17 tests passed; one opt-in live API test skipped because it requires a seeded local API and environment password.
- Release-copy scan across `apps/web/src` and `apps/mobile/lib` found no remaining customer-facing release-status language. Remaining matches are internal compatibility identifiers such as `is_demo`, `preview_tag` and modal key names.
- Visual inspection: public home at 1440×1200 and compact Privacy Policy at 500×844. Copy wraps correctly with no observed horizontal overflow. Headless Chrome on this macOS host enforces a 500px minimum layout viewport; existing 390px browser evidence remains the reference for smaller-device navigation.

## Evidence

- `docs/evidence/screens/release-copy/web-home-desktop.png`
- `docs/evidence/screens/release-copy/privacy-mobile-500.png`

## Remaining release gates

- Human legal review of the public Privacy Policy, Terms of Use and deletion wording.
- Human linguistic and clinical review of Hausa, Yoruba, Igbo and Nigerian Pidgin health/safeguarding copy.
- Pilot completion, named reviewer sign-off, specialist credential verification and production operational approval remain release decisions. The UI does not claim those outcomes.

