# ADR 0001 — Foundation and safe delivery boundary

Date: 2026-10-27. Status: proposed; explicit user requirements are binding, remaining choices are planning recommendations.

Required: Flutter/Riverpod Android/iOS, React public/admin web, Laravel backend, offline-first sync, WebSockets, FCM/local reminders, real workflows with seeded demo data, clean architecture and continuity documentation. Jos is the first pilot location. User clarification: ages 9 through the end of life, with no upper age limit; in-platform specialists remain in scope, while facility directories, hospital referrals and facility booking are excluded.

Recommended: modular Laravel monolith; PostgreSQL/Redis/private object storage; Reverb private channels; Drift plus vetted encrypted SQLite; versioned REST/OpenAPI; transactional sync outbox and explicit conflicts. Use a fresh YanMata foundation with audited reuse from DATER, because existing Flutter is GetX and backend includes Filament/older framework constraints.

Separate grant demonstrability from production certification. Initial slice covers learning, tracking and professional access; build age-appropriate accounts from age 9 with live access governed by safeguarding requirements; stage marketplace and unvalidated predictive models behind appropriate evaluation and governance. Propose sourced multilingual retrieval as an evaluable frontier-technology contribution, not an already proven feature.

Consequences: extra initial contract/sync work but consistent mobile/web behaviour and recoverability. OS background constraints require resume reconciliation. Clinician-approved content and staffed specialist access add operational dependencies. Proposed scope/navigation/stack details may evolve with documented rationale; do not silently replace user-required technologies.
