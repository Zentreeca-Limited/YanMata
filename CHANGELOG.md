# Changelog

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
