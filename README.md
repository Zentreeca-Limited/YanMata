# YanMata

A private, accessible wellbeing companion for girls and women, provided by **Zentreeca Limited** (https://zentreeca.org). Initial pilot: **Jos, Plateau State, Nigeria**. Audience: **ages 9 onward, from puberty through the end of life**, with no upper age limit.

## Project status — 28 October 2026

Ten phased working slices are implemented across the React public site and editorial studio, Laravel API, and Flutter app. This is a synthetic-data development preview, **not a production or clinically approved release**. See the [latest phase evidence](docs/evidence/PHASE-10.md) and [foundation decisions](docs/adr/0002-foundation-implementation.md).

## Product

YanMata supports body literacy, puberty, menstrual wellbeing, symptom and mood journaling, trusted health education, and in-platform professional support. Its life-stage scope spans puberty from age 9, adolescence, adulthood, pregnancy/postpartum where relevant, perimenopause, menopause and later life, including end-of-life wellbeing. The current demo includes synthetic health-service listings based on the supplied wireframe; external appointment booking and emergency referral automation are not implemented. Experiences adapt to a person's chosen needs without assuming pregnancy, sexual activity or a regular menstrual cycle.

## Read first

| Document | Purpose |
|---|---|
| [Delivery plan](docs/PLAN.md) | Scope, phases, grant strategy, staffing, risks and acceptance criteria |
| [Architecture](docs/ARCHITECTURE.md) | Flutter/Riverpod, Laravel, React, API, offline sync and notifications |
| [Design specification](docs/design/DESIGN.md) | Brand direction, screen inventory, states and visual quality gates |
| [Safety and clinical governance](docs/SAFETY.md) | Privacy, safeguarding, content review and specialist access |
| [Account deletion guide](docs/ACCOUNT-DELETION.md) | Member deletion, local cleanup, retention boundaries and verification |
| [Backlog](docs/BACKLOG.md) | Sequenced implementation work and completion evidence |
| [Handoff](docs/HANDOFF.md) | Current state, unknowns and next executable steps |
| [Decisions](docs/adr/0001-foundation.md) | Architectural choices and their status |
| [Sources](docs/SOURCES.md) | References inspected and current technical sources |
| [Changelog](CHANGELOG.md) | Work actually completed |
| [Agent instructions](AGENTS.md) | Rules for consistent implementation and handoff |

## Target stack

- Android/iOS: Flutter stable, Dart, Riverpod, feature-based clean architecture, encrypted local database.
- Backend: Laravel 13 target, PostgreSQL, Redis queues/cache, Reverb WebSockets, private object storage.
- Public website and admin/specialist portal: React 19.3 target, TypeScript; public pages server-rendered or prerendered for search and low-bandwidth delivery.
- FCM/APNs for remote notifications; local scheduling for personal reminders.
- One versioned Laravel API and one content publishing workflow for web and mobile.

Installed baseline: Laravel 13.39.0, Sanctum 4.3.3, React 19.3 line, Vite 7.3.7, Flutter 3.47.5, Dart 3.13.4 and Riverpod 3.4.3. Lockfiles are committed with the source. See [audit and versions](docs/FOUNDATION-AUDIT.md).

## Repository layout

```text
apps/api/             Laravel API, policies, jobs, migrations and seeders
apps/mobile/          Flutter app, Riverpod controllers, local storage and sync
apps/web/             React public website
apps/admin/           React admin and specialist portal
packages/contracts/   OpenAPI specification, generated clients and event schemas
packages/design/      Canonical design tokens and platform outputs
infra/                Development services, deployment and operational runbooks
docs/                 Product, design, safety, decisions and delivery evidence
```

The applications and shared packages exist. Infrastructure deployment, production database, realtime events and notification delivery are still planned.

## Demo and open source

Use isolated demo infrastructure with deterministic synthetic accounts and records, sample specialist profiles labelled as demonstrations, test notification devices and no real patient data. Workflows must use the real API, persistence, authorisation and sync implementation. Open-source licensing is proposed for grant alignment; ownership, dependency licences and final licence choice need confirmation before publication. Never include credentials, patient information or private clinical material in an open repository.

## Local setup

Prerequisites: PHP 8.5 with SQLite support, Composer, Node 22.12+, npm, Flutter 3.47.5; Xcode for iOS and Android SDK/JDK 17 for Android. Development uses SQLite, with PostgreSQL planned for deployment.

```sh
npm ci
cd apps/api
composer install
cp .env.example .env
php artisan key:generate
php -r "file_exists('database/database.sqlite') || touch('database/database.sqlite');"
php artisan migrate
```

Set `YANMATA_DEMO=true` in `apps/api/.env` only for this local synthetic demo. Keep `APP_ENV=local`. Return to the repository root, then:

```sh
python3 scripts/seed-demo.py
npm run dev
```

Preview addresses: public web `http://127.0.0.1:5173`, editorial studio `http://127.0.0.1:5174`, API `http://127.0.0.1:8091`. The dev runner checks for occupied ports and does not terminate unrelated services. Stop it with Ctrl+C.

The public app-download cards read optional URLs from `apps/web/.env`:

```sh
cp apps/web/.env.example apps/web/.env
# Set only after signed store releases are approved:
# VITE_ANDROID_DOWNLOAD_URL=https://play.google.com/...
# VITE_IOS_DOWNLOAD_URL=https://apps.apple.com/...
```

The checked-in values are temporary store destinations and must be replaced with approved live listing URLs before release. The public legal URLs are `/privacy-policy`, `/terms-of-use` and `/account-deletion`.

Demo emails: `author@demo.yanmata.test`, `reviewer@demo.yanmata.test`, `publisher@demo.yanmata.test`, `member@demo.yanmata.test`. The generated password is stored locally in ignored `.env.demo.local`, never in this README or source control. Do not reuse it in production.

```sh
cd apps/mobile
flutter pub get
# Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8091/api/v1
# iOS simulator: select the simulator in Flutter, then
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8091/api/v1
```

The app identifier `org.zentreeca.yanmata` is provisional. Release builds require an HTTPS API URL and production signing. No real-device installation was performed. Android backup is disabled; iOS Keychain entitlements are included. Runtime validation of native persistence on physical devices remains required.

## Verification

From the repository root:

```sh
npm run typecheck
npm run build
npm run test:api
npm run test:mobile
# With local API running and demo accounts seeded:
python3 scripts/test-live-mobile.py
```

`npm run tokens` regenerates semantic colour outputs; `npm run format` formats React/shared source. PHP: `cd apps/api && vendor/bin/pint`. Dart: `cd apps/mobile && dart format lib test`. CI is declared in `.github/workflows/verify.yml`; remote CI has not run because no remote repository is configured.

## Working demo journey

1. Sign in to the studio as author, create a synthetic article, save and submit.
2. Sign out; sign in as reviewer, inspect and approve that revision.
3. Sign out; sign in as publisher and publish. Refresh public/mobile learning to see the item.
4. In mobile Track, save a check-in without an account. It persists locally.
5. In You, explicitly consent and connect the demo member account. Tap Sync now. The live integration test verifies a second independent mobile store receives the same record and its deletion.

## Current limits and next phase

Public web remains client-rendered. Production hosting, signed store builds and live store URLs, native encrypted database migration, physical-device notification delivery, staff MFA, account recovery, approved retention schedules, named clinical and safeguarding sign-off, practitioner credential verification, and pilot operating procedures remain release gates. Member account deletion is implemented and tested; its legal copy and backup-retention language still require privacy/legal approval. Some workflows exist as tested demo slices; their presence does not establish clinical effectiveness or operational readiness. Do not use real patient information or claim production/clinical readiness.

The [backlog](docs/BACKLOG.md), [handoff](docs/HANDOFF.md) and [changelog](CHANGELOG.md) distinguish verified foundation slices from remaining work. Brand symbol masters are in `packages/design/assets` (SVG plus 4096px PNG); the full identity suite is still in progress.
