# YanMata API

Laravel modular foundation. Run commands from the root README. Local SQLite is a development adapter; PostgreSQL remains the deployment target. No public registration or specialist service is enabled yet.

Controllers handle HTTP boundaries; `Actions/SyncJournal` implements transactional sync and `Actions/TransitionContent` implements publishing transitions. `ContentItemPolicy` enforces author ownership and role separation. Journal/receipt payloads are encrypted; never rotate APP_KEY without a migration/key-retention plan.

Tests: `php artisan test`. Demo seed: use `python3 scripts/seed-demo.py` from repository root. Requires local/testing APP_ENV and YANMATA_DEMO=true. Credentials are generated locally, not embedded in source.
