# Phase 11 — live API mobile integration

Date: 28 October 2026  
Work item: MOB-03

## Implemented

- Changed the Flutter API default from local loopback to `https://yanmata.zentreeca.org/api/v1` so normal and release builds connect to the deployed HTTPS API without an extra build define.
- Preserved explicit local overrides for Android emulator (`10.0.2.2`) and iOS simulator (`127.0.0.1`). Product/release builds continue to reject non-HTTPS API destinations.
- Updated the live mobile integration runner to accept `YANMATA_API_BASE_URL` and pass it as a Dart compile-time define without storing secrets in source control.
- Reworked the opt-in integration test to create an isolated synthetic member, grant explicit synchronization consent, exercise two independent local stores, propagate a journal tombstone and remove the synthetic account afterward.
- Added a clear mobile-facing rate-limit message for HTTP 429 responses.
- Fixed a live Laravel throttle collision: authenticated sync requests previously consumed the numeric counter later used by account deletion, causing a member's first deletion attempt to return 429. Account deletion now uses a named, route-specific limiter key.

## Live API verification

Base URL: `https://yanmata.zentreeca.org/api/v1`

The deployed API returned HTTP 200 for:

- `/health`
- `/content`
- `/locations`
- `/services`
- `/products`
- `/mental-health/resources`

The Flutter integration flow verified:

1. Mobile member registration.
2. Explicit sync-consent update.
3. Authenticated journal push and pull.
4. A second independent mobile store pulling the first store's entry.
5. Tombstone push and deletion propagation to the second store.
6. Password-confirmed deletion of the isolated synthetic integration account.

No credentials, access tokens, journal bodies or personal health information were printed or committed. The live server currently reports `demo: true`; these checks establish technical connectivity, not production clinical readiness.

## Build and test verification

- `flutter analyze` — passed with no issues.
- `flutter test` — 17 normal tests passed; the live test remains opt-in during normal runs.
- `flutter build apk --debug` — passed using the checked-in live HTTPS default.
- `flutter build ios --simulator --no-codesign` — passed using the checked-in live HTTPS default.
- `YANMATA_API_BASE_URL=https://yanmata.zentreeca.org/api/v1 python3 scripts/test-live-mobile.py` — passed against the deployed API.
- `./vendor/bin/pint --test` — passed.
- `php artisan test` — 36 tests and 227 assertions passed, including the sync-traffic/account-deletion limiter regression.
- `./scripts/deploy.sh /Users/user/Downloads/yanmata.pem` — deployed the limiter correction; live health, content, public web and admin smoke checks returned HTTP 200.
- Post-test database check: zero `live-mobile-%@test.yanmata.invalid` synthetic integration accounts remain.

## Remaining release gates

- The live API is still configured in synthetic demo mode.
- Physical Android and iOS device verification remains required, including network transitions, certificate handling, FCM/APNs and store-signed builds.
- Production identities, data, clinical operations and credentials must not be enabled until governance and release gates are approved.

