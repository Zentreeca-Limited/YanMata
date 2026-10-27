# Reference audit and dependency baseline

Date: 27 October 2026. Read-only review; no reference source or credentials copied.

## Reference findings

DATER Flutter declares GetX/GetStorage and Firebase integrations. Its `lib/services/local_notification.dart` is empty; dependency declarations alone do not prove a notification implementation. A new Riverpod domain/repository/application/presentation structure was created for YanMata.

Relationship-Essential declares Laravel 12, React 18 and Filament. Reviewed `PostPolicy.php` illustrates a permission-based policy pattern but does not supply YanMata's ownership/clinical-role rules. Reviewed `SendReminderNotificationJob.php` contains two consecutive identical notifications to the coach and includes person-specific details in notification content. YanMata does not copy that job or its payload design.

Adaptation ledger: conceptual Laravel policies/queues and Flutter platform setup only; no copied implementation requiring inherited application licensing. New source originates in this workspace plus official Laravel/Flutter scaffolds and registry dependencies. Runtime keys, Firebase projects, certificates, credentials, real data and unrelated dating/payment features were not imported. Flutter tooling reported a locally saved Apple signing identity; no certificate file was copied, and iOS verification uses `--no-codesign` for simulator builds.

## Resolved local baseline

- PHP 8.5.7; Composer 2.9.5; Laravel framework 13.39.0; Sanctum 4.3.3.
- Node 22.17.1; npm 11.4.2; React 19.3 line; Vite 7.3.7. Exact patches are in package-lock.json.
- Flutter 3.47.5 stable; Dart 3.13.4; Riverpod 3.4.3; flutter_secure_storage 11.2.0. Exact packages are in pubspec.lock.
- Web fonts: locally served Manrope and DM Sans through Fontsource packages; preserve their OFL licences.

These are tested development versions, not claims that every package is the latest possible release. Upgrade through compatibility tests and lockfiles.
