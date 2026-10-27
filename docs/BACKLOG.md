# Delivery backlog

Statuses: TODO, IN_PROGRESS, BLOCKED, VERIFIED. VERIFIED requires evidence. Foundation slices are implemented; broad tasks stay IN_PROGRESS until every acceptance criterion is met.

| ID | Priority | Task | Depends on | Acceptance evidence | Status |
|---|---|---|---|---|---|
| PLAN-01 | P0 | Inspect references and establish plan/continuity docs | — | Reference inventory and linked documents | VERIFIED |
| GOV-01 | P0 | Define age-9-plus consent/access rules, named reviewers and safeguarding owner | Founder/clinical team | Recorded decisions and credential review process | TODO |
| DESIGN-01 | P0 | Brand/logo concepts, tokens, priority mobile/web/admin prototype | PLAN-01 | Vector identity, clickable journeys, accessible token checks | IN_PROGRESS |
| TECH-01 | P0 | Audit reusable reference code and licences; pin stable stack | PLAN-01 | Provenance/reuse ledger, version matrix | IN_PROGRESS |
| TECH-02 | P0 | Scaffold monorepo and CI/dev/demo services | TECH-01 | Repeatable setup, builds, isolated seed execution | IN_PROGRESS |
| API-01 | P0 | OpenAPI/domain schema and auth/role/consent policies | TECH-02 | Contract and ownership/role denial tests | IN_PROGRESS |
| MOB-01 | P0 | Riverpod shell, routing, encrypted local DB and secure keys | DESIGN-01, TECH-02 | Android/iOS builds; restart/lock/logout tests | IN_PROGRESS |
| SYNC-01 | P0 | Journal plus outbox/idempotency/cursor protocol | API-01, MOB-01 | Airplane-mode/replay/conflict/delete scenarios | IN_PROGRESS |
| CMS-01 | P0 | React content authoring/review/publication and media pipeline | API-01, DESIGN-01 | Publication state/permission tests; mobile refresh | IN_PROGRESS |
| WEB-01 | P0 | Responsive React public site and learning pages | DESIGN-01, CMS-01 | Mobile/desktop QA, SEO, no private cache/index leakage | IN_PROGRESS |
| CARE-01 | P0 | Specialist verification, in-platform support request and consented chat | API-01, MOB-01 | Scoped access/revocation tests and seeded demo conversation | IN_PROGRESS |
| PUSH-01 | P0 | Private Reverb, FCM/APNs and local reminders | SYNC-01, CARE-01 | Physical-device state matrix, token cleanup, deduplication | TODO |
| MOB-02 | P1 | Mobile staff draft/upload/review/publish capability | CMS-01, MOB-01 | Same policies enforced from mobile and web | TODO |
| AI-01 | P1 | Evaluate bounded multilingual retrieval slice | CMS-01, clinical corpus | Documented evaluation; disabled unless gate passes | TODO |
| DEMO-01 | P0 | Seed synthetic Jos scenarios and record genuine demo | Core vertical slices | Reproducible reset, labelled data, working API recording | IN_PROGRESS |
| GRANT-01 | P0 | Assemble factual application evidence/repository/video | DEMO-01, founder facts | Accessible repository and final human submission package | TODO |
| SAFE-01 | P0 | Threat model, data map, legal/clinical/safeguarding reviews | GOV-01, architecture | Named sign-offs and resolved risks | TODO |
| QA-01 | P0 | Security, accessibility, offline and performance QA | Pilot feature complete | Results/defects linked to commits/builds | IN_PROGRESS |
| OPS-01 | P0 | Release pipeline, monitoring, backups and rollback exercises | TECH-02 | Staging restore/release evidence and runbooks | TODO |
| PILOT-01 | P0 | Limited Jos operational pilot | SAFE-01, QA-01, OPS-01 | Approved recruitment, staffed care, measured baseline | TODO |
| LIFE-01 | P2 | Expand life-stage paths/languages and future commerce | Pilot findings | Separate approved product/safety scope | TODO |

## Work item evidence template

ID / owner / status / date / implementation paths / commit or build / commands and results / visual evidence / known defects / next step. Keep clinical approvals separate from engineering assertions.

## PLAN-01 evidence

27 October 2026: inspected supplied wireframe image, extracted all four PDF pages, read DATER mobile and Relationship-Essential dependency manifests, checked grant/form and official framework pages. Created planning documents. Markdown local-link and file checks performed; no application tests exist or were run. Source-level reference audit remains TECH-01.

## Phase 01 implementation evidence

See [PHASE-01](evidence/PHASE-01.md). Implemented slices: runnable four-app workspace; semantic colours and brand symbol; editorial roles/workflow; public/mobile learning feed; local mobile check-in; encrypted server data; manual outbox/cursor/idempotent sync; synthetic seed guard; builds and initial tests. Broad tickets remain in progress because planned database, complete clinical metadata, media, identity and release gates are outstanding.

## Phase 02 implementation evidence

See [PHASE-02](evidence/PHASE-02.md). Implemented slices:
- CARE-01: In-platform specialist guidance (Jos pilot), MDCN/NMCN synthetic verified clinicians, member support inquiries with journal sharing consent, secure asynchronous messaging, mobile CareChatPage, admin Care inquiries table, public web specialists showcase.
- TRACK-02 / SYNC-01: Expanded life-stage tracking with cycle flow intensity, multi-symptom body signals, energy levels, backward-compatible API sync payload, and explicit mobile conflict resolution.
- ID-02: Life chapter selection across 5 life stages (ages 9 through 55+), topic interests, and private journal JSON data export.
- TECH-02 / QA-01: Activated strict prevention of lazy loading and attribute discarding in Laravel, added DB performance indexes, verified zero N+1 database queries.
- All 17 PHP tests, 5 Flutter tests, layout tests at 200% scale, live mobile-to-API integration tests, and Android/iOS simulator builds pass cleanly.

Next order: PUSH-01 Reverb/FCM/local reminders → MOB-02 media/publishing → QA/OPS production readiness. Each must retain existing regression tests and visual baselines.
