# YanMata agent continuity contract

Read README.md, docs/HANDOFF.md, docs/BACKLOG.md and relevant architecture/design/safety sections before editing. User instructions take precedence. Do not treat a roadmap item as an implemented feature.

## Implementation invariants

- Audience is ages 9 through the end of life, with no upper age limit. Preserve age-appropriate experiences and minor safeguarding. Facility directories, hospital referrals and facility booking are out of scope; specialist support stays within YanMata.

- Flutter uses Riverpod. Keep presentation/controllers, application use cases, domain types and data adapters separate. No GetX or business logic in widgets.
- Laravel owns authorisation, clinical publishing rules and shared data. Thin HTTP controllers delegate to use cases; policies enforce resource ownership and professional access. React public/admin apps are required; do not substitute Filament.
- Use the offline outbox/cursor/version protocol in ARCHITECTURE.md. WebSockets and push are hints, never the sole delivery or storage mechanism.
- Use shared semantic design tokens and documented components. Never introduce arbitrary alternate palettes, duplicate controls, tiny type or unreviewed medical copy.
- Health claims require traceable sources and reviewer metadata. Never fabricate risk scores, provider credentials, partnerships, clinical validation or results.
- No health data, access tokens or chat bodies in logs/analytics/push payloads. No secrets, production dumps or signing assets copied from reference projects.
- Reference projects are read-only foundations unless separately authorised. Record provenance and licence for adapted code; rebuild unsuitable patterns.
- Demo fixtures must be synthetic, visibly identified and isolated. No production bypasses for a convenient demo.

## Definition of done for each implementation task

1. Implement the end-to-end flow and applicable loading, empty, offline, denied, validation and failure states.
2. Run relevant formatting, static analysis and meaningful tests; record exact commands, outcomes and blockers. Never claim tests passed if not run.
3. Inspect affected mobile/web layouts and accessibility at documented sizes; record evidence and intentional changes.
4. Update contracts, migrations, environment examples and deployment instructions when affected. No secret values in examples.
5. Update BACKLOG, CHANGELOG and HANDOFF with task IDs, touched modules, verification, remaining risks and the next step. Add an ADR when an invariant or architecture decision changes.
6. Commit coherent increments when Git is established; include task IDs. Do not overwrite unrelated work.

## Handoff rule

End each work session with truthful implemented/verified/blocked/next statuses. Keep acceptance evidence discoverable. A UI screenshot alone does not prove backend integration. A seeded demo does not establish clinical effectiveness or production readiness.
