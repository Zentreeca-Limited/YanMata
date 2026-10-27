# ADR 0002 — Runnable foundation boundary

Date: 2026-10-27. Status: implemented foundation decisions; production architecture remains governed by ADR 0001.

## Foundation scope

Scaffold all four applications and implement two concrete vertical slices: editorial creation/review/publication into the public/mobile learning feed, and private mobile check-ins with explicit account consent and durable HTTP synchronisation. Use seeded identities only; self-registration is not enabled before age/consent rules exist. No clinical efficacy claims or unreviewed medical advice are introduced.

## Deliberate temporary adapters

- SQLite is the local/CI backend datastore; PostgreSQL remains the deployment target. Concurrency, isolation and migrations must be retested against PostgreSQL before pilot approval.
- Mobile currently persists one encrypted secure-storage document through a serialised repository, including entries, outbox, cursor and conflicts. It is capped at 100 entries and is a foundation adapter, not the planned scalable Drift database. Replace with an encrypted database after validating native encryption/migrations, preserving repository contracts and all queued data. Do not release this adapter for longitudinal production use.
- HTTP sync is manual. Native background retries, authenticated Reverb, FCM/APNs, local scheduled reminders and content downloads are subsequent work. The product labels these limitations.
- Public React is Vite SPA in this phase; prerendering/SSR and content routes remain required before public launch. Both React apps share self-hosted fonts, semantic tokens and brand components.
- A cloud **disconnect** revokes the current token while deliberately preserving this device's journal; it is labelled accordingly. Device erase is separately confirmed and is not server deletion. A future full logout must implement the documented wipe policy, including queued data handling.
- Consent currently records the sync preference only. Versioned legal notices, consent history, guardian/assent workflows and data rights are release gates, not implemented compliance claims.

## Security and verification

Sanctum browser cookies + CSRF, expiring mobile tokens, per-account/IP login rate limits, resource ownership, publication role separation, encrypted journal/receipt data, encrypted account-bound cursors, tombstones and idempotency are implemented. Test evidence belongs in docs/evidence/PHASE-01.md. Sample data requires a local/testing environment and explicit demo flag; production hides demo articles.

## Next phase

Replace temporary adapters, add consent/identity and session lifecycle controls, deliver calendar/symptom flows and explicit conflict resolution, then specialist messaging, realtime events and notification delivery. No facility discovery/referral work should be introduced.
