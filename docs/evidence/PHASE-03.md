# Phase 03 — Realtime Events, Push Devices, Local Reminders & Mobile Staff Editorial Studio

Date: 27 October 2026. Status: implemented feature slice with verified tests, live integration, and production builds. No real-patient data or clinical claims.

## Implemented scope

- **PUSH-01 (Privacy-Preserving Realtime Events & Push Device Management)**:
  - **Database schema**: Created migration `2026_10_27_000300_create_devices_and_notifications_tables.php` creating `user_devices`, `notification_preferences`, and `broadcast_events` with appropriate indexes.
  - **Strict privacy invariant**: Reverb/WebSocket hints and push payloads contain ONLY opaque identifiers (`event_id`, `conversation_id`, `message_id`, `type: 'care_message'`, `timestamp`). Zero clinical text, zero message body, and zero journal entries are transmitted in broadcast events or notification payloads.
  - **Broadcast outbox**: Created transactional `broadcast_events` outbox with queued dispatch tracking.
  - **Device lifecycle**:
    - `POST /api/v1/devices`: registers or rotates device push tokens (`android`, `ios`, `web`) and updates `last_seen_at`.
    - `DELETE /api/v1/devices/{device_id}`: unregisters device and deletes token upon app uninstall or manual removal.
    - `POST /api/v1/logout`: accepts optional `device_id` parameter to immediately revoke the device token alongside Sanctum token revocation.
  - **Notification preferences**:
    - `GET /api/v1/notification-preferences`: returns member preferences (care messages, quiet hours, start/end times).
    - `PUT /api/v1/notification-preferences`: updates preferences with strict regex time validation.
  - **Event polling reconciliation**:
    - `GET /api/v1/events/poll`: REST endpoint allowing clients to pull missed events on reconnect or during background sync.
  - **Channel authorization**: Configured `routes/channels.php` authorizing authenticated users on `private-user.{id}`.

- **Mobile Local Reminders & Quiet Hours (`PUSH-01`)**:
  - Implemented `apps/mobile/lib/core/notifications.dart` with `NotificationPreferences` and `DeviceService`.
  - Overnight quiet-hours calculation logic (e.g. 22:00 to 07:00).
  - Discreet lock-screen preview card in "You" (Profile) page:
    - Title: "A quiet moment"
    - Body: "How has your day felt so far?"
    - No cycle details, symptom labels, or clinical text ever appear on the lock screen.
  - Local preference toggles for daily check-in reminder, quiet hours, and care message notifications.

- **Mobile Staff Editorial Studio (`MOB-02`)**:
  - Implemented `StaffRepository` and `StaffPortalPage` allowing verified staff accounts (`author`, `reviewer`, `publisher`, `specialist`, `admin`) to draft and review articles and triage care requests directly from mobile.
  - Two-tab studio interface:
    - **Content Pipeline**: view articles by status (`draft`, `in_review`, `approved`, `published`), draft new educational articles with traceable source URLs, and transition state (`submit_for_review`, `approve`, `publish`).
    - **Care Inquiries**: view incoming member support requests, inspect journal-sharing consent, and assign inquiries to Jos verified specialists (Dr. Fatima Bello, Nurse Grace Danladi).
  - Enforces identical authorization and transition policies as the web studio.

- **Local Storage Expansion (`SYNC-02`)**:
  - Upgraded `LocalJournalRepository` with schema version 2.
  - Removed arbitrary 100-entry cap, expanding capacity to 10,000 entries.
  - Added user role and name persistence on mobile session to dynamically surface staff capabilities.

## Verification commands and observed outcomes

- `php artisan test`: 21 tests / 117 assertions passed (100% pass rate in ~290ms with strict lazy loading enabled).
  - Tests verify device registration, token rotation, logout revocation, preferences management, privacy-preserving broadcast events, and event polling.
- `vendor/bin/pint --test`: passed cleanly with zero formatting violations.
- `npm run typecheck`: passed for both `@yanmata/web` and `@yanmata/admin`.
- `npm run build`: Vite production builds succeeded cleanly for web and admin.
- `npm run format:check`: Prettier verified all TypeScript, TSX and CSS files.
- `flutter analyze`: 0 issues found across all mobile files.
- `flutter test`: 9 tests passed across all mobile test suites (`care_test.dart`, `layout_test.dart`, `widget_test.dart`, `tracking_test.dart`, `notifications_and_staff_test.dart`).
- `python3 scripts/test-live-mobile.py`: live two-store sync and deletion verification against running Laravel API passed.
- `flutter build apk --debug`: Android debug APK built successfully (`build/app/outputs/flutter-apk/app-debug.apk`).
- `flutter build ios --simulator --no-codesign`: iOS simulator app built successfully (`build/ios/iphonesimulator/Runner.app`).
- `packages/contracts/openapi.json`: Updated with all new endpoints and schemas, validated with Node JSON parser.
