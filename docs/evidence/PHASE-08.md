# Phase 08 — Account controls and store compliance

Date: 28 October 2026
Task: ACCT-01

## Implemented

- Added `DELETE /api/v1/account` for member self-service deletion. It requires an authenticated member token, the current password and the exact confirmation `DELETE`; staff and specialist accounts remain administrator-managed.
- Deletion revokes tokens and removes the member through database relationships. The mobile repository clears local account data only after the API returns success; a failed request retains the device copy.
- Added separate **Log out** and **Delete account** actions under **You → Account controls**. Logout warns that this device is cleared and unsynced changes are lost. Delete Account explains the permanent server and device effects, requires password entry and typed confirmation, and cannot be dismissed by tapping outside the dialog.
- Added public `/privacy-policy`, `/terms-of-use` and `/account-deletion` routes plus the operational [account deletion guide](../ACCOUNT-DELETION.md). The copy is an engineering draft and still requires privacy/legal approval before production.
- Reworked YanMata Mobile cards with vector Google Play and Apple artwork, keyboard focus treatment and always-clickable environment-configured destinations. Checked-in destinations are temporary and must be replaced with approved live listings.
- Updated the OpenAPI contract and environment example without including credentials.

## Verification

- `cd apps/api && vendor/bin/pint --test && php artisan test`: passed, 35 tests and 217 assertions.
- `cd apps/mobile && dart format lib test && flutter analyze && flutter test`: formatting clean, analysis reported no issues, 17 tests passed; one opt-in live API integration test was skipped because no seeded test credential was supplied.
- New mobile tests verify logout revokes before local wipe, deletion sends password confirmation, failed deletion preserves local data, and both warning dialogs render the required copy and controls.
- `npm run format && npm run format:check && npm run typecheck && npm run build`: passed for public web and admin; both production bundles built successfully.
- `packages/contracts/openapi.json` parsed successfully after adding the account deletion contract.
- Browser inspection: store cards measured 435×70px at 1440px and 342×70px at 390px. Home and all legal routes had no horizontal overflow. Privacy Policy rendered 7 sections, Terms of Use 7 sections and Account Deletion 5 sections.
- Visual evidence: [mobile store section](screenshots/phase-08-store-mobile.png) and [mobile account deletion page](screenshots/phase-08-account-deletion-mobile.png).

## Remaining release gates

- Replace both temporary store URLs with the approved Google Play and App Store listing URLs.
- Obtain Nigeria-specific privacy/legal review, name the privacy owner and publish approved retention and backup-erasure windows.
- Exercise deletion against staging PostgreSQL, queues, object storage, search/analytics stores and restored backups; current automated coverage is Laravel/SQLite plus the Flutter client.
- Run the opt-in live mobile/API test with isolated seeded credentials and verify logout/deletion on physical Android and iOS devices.
