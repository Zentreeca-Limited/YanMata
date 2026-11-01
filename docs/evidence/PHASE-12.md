# Phase 12 evidence — opt-in nearby care

Date: 29 October 2026  
Work item: NEARBY-01  
Status: implemented and locally verified; live Google integration and physical-device QA blocked

## Implemented

- Flutter domain/gateway/controller/presentation boundaries under `apps/yanmata-mobile/lib/features/nearby`.
- Explicit foreground location permission with no request on render or category selection, no background permission, and safe denied/permanently-denied/disabled/timeout states.
- Distance-ranked hospital, clinic and pharmacy results with address, operational-state warning, Google/provider attribution and a Google-provided directions URI.
- Member navigation, Today shortcut and You shortcut now lead to Nearby; product/cart purchase entry points are no longer reachable from the member UI.
- Laravel request/controller/action/service/exception boundaries for `POST /api/v1/nearby-places/search`; strict coordinate/category/radius validation; bounded Google types and field mask; server-only key; safe 503 errors; `no-store` responses; no database/cache write.
- OpenAPI contract, environment example, mobile platform permissions, legal disclosure, architecture/safety/source documentation and mobile setup guide.
- Patched `symfony/mime` 7.4.19 to 7.4.22 after Composer reported CVE-2026-45070.

## Verification

| Command | Result |
|---|---|
| `vendor/bin/pint --dirty --format agent` | Passed |
| `php artisan test --compact` | Passed: 40 tests, 253 assertions |
| `composer audit` | Passed after patch: no advisories |
| `flutter test test/nearby_places_test.dart` | Passed: 6 tests |
| `flutter analyze` | Passed: no issues |
| `flutter test` | Passed: 23 tests; 1 opt-in live API test skipped as designed |
| `flutter build apk --debug` | Passed; `build/app/outputs/flutter-apk/app-debug.apk` |
| `flutter build ios --simulator --no-codesign` | Passed; `build/ios/iphonesimulator/Runner.app` |
| `npm run typecheck` | Passed in `apps/yanmata-web` |
| `npm run build` | Passed in `apps/yanmata-web` |
| `npx prettier --check src/main.tsx` | Passed |
| `python3 -m json.tool packages/contracts/openapi.json` | Passed |

Layout coverage includes a 360 × 800 logical-pixel compact viewport at 200% text scale in dark mode, initial opt-in state, category-without-location regression coverage, a visually inspected 390 × 844 `nearby-phone.png` golden and refreshed home/journal goldens reflecting Nearby navigation. The Android build emitted only upstream Java 8/deprecation warnings from the current geolocator Android plugin.

## Privacy and safety evidence

- Coordinates are carried in an HTTPS POST body, not the URL, and are not added to models, logs, analytics or caches by this feature.
- Laravel owns the Google credential; Flutter contains no Places key.
- Place content is not persisted and responses carry `Cache-Control: no-store, private` plus `Pragma: no-cache`.
- UI says listings can change, tells members to confirm details, identifies Google Maps, and does not claim verification, partnership, referral, availability or emergency monitoring.

## Remaining blockers and next step

`GOOGLE_PLACES_API_KEY` was absent from both `apps/yanmata-api/.env` and `/var/www/yanmata/backend/.env`; no secret value was read or printed. Therefore no real Google response is claimed. Create/restrict a server-side key with Places API (New) and billing, configure it outside source control, reconcile the in-progress directory migration/deployment paths, deploy, and verify the complete location/result/directions flow on Android and iOS hardware. Complete store privacy disclosures and privacy/legal review before release.
