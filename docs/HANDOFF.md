# Agent handoff — 1 November 2026

## App Store Connect ITMS-90683 fix, iOS/Android runtime permissions & version 1.0.0+2 alignment (IOS-PERMS-01, 1 November 2026)

- **Resolved ITMS-90683 & Added Complete iOS `Info.plist` Purpose Strings (`apps/yanmata-mobile/ios/Runner/Info.plist`)**:
  - Added clear, user-facing purpose strings for every protected resource referenced by the app or its native plugins (`geolocator_apple`, `flutter_secure_storage_darwin`, `webview_flutter_wkwebview`):
    - `NSLocationWhenInUseUsageDescription`
    - `NSLocationAlwaysAndWhenInUseUsageDescription` (specifically flagged by `ITMS-90683`)
    - `NSLocationAlwaysUsageDescription`
    - `NSLocationTemporaryUsageDescriptionDictionary` (`NearbyCare`)
    - `NSFaceIDUsageDescription` (`LAContext` in `flutter_secure_storage_darwin`)
    - `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, `NSMicrophoneUsageDescription` (`WKWebView` / media picker APIs)
  - Configured `GCC_PREPROCESSOR_DEFINITIONS = ['$(inherited)', 'BYPASS_PERMISSION_LOCATION_ALWAYS=1']` for the `geolocator_apple` target in `apps/yanmata-mobile/ios/Podfile` so `requestAlwaysAuthorization` is also stripped from the compiled `geolocator_apple.framework` binary.
  - Added `apps/yanmata-mobile/ios/Runner/PrivacyInfo.xcprivacy` (Apple Privacy Manifest declaring `NSPrivacyAccessedAPICategoryUserDefaults` reason `CA92.1` and `NSPrivacyTracking = false`) and linked it into the `Runner` Resources build phase in `Runner.xcodeproj/project.pbxproj`.
- **Runtime Permission Requests (`AppDelegate.swift`, `MainActivity.kt`, `notifications.dart`, `journal_controller.dart`)**:
  - Added a `com.yanmata.app/permissions` `MethodChannel` in `ios/Runner/AppDelegate.swift` (`UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])` + `registerForRemoteNotifications()`) and `android/app/src/main/kotlin/com/yanmata/app/MainActivity.kt` (`Manifest.permission.POST_NOTIFICATIONS` on Android 13+).
  - Wired `DeviceService.requestNotificationPermission()` when a member signs in, registers, or toggles Care / Daily Check-In reminders in the `More` tab, alongside the explicit foreground location permission prompt (`Geolocator.checkPermission()` -> `Geolocator.requestPermission()`) in `DeviceLocationGateway`.
- **Version & Build Number Alignment (`1.0.0+2`)**:
  - Updated `apps/yanmata-mobile/pubspec.yaml` to `version: 1.0.0+2` (for the next App Store Connect upload following `1.0.0 Build 1`) and linked `MARKETING_VERSION = "$(FLUTTER_BUILD_NAME)"` and `CURRENT_PROJECT_VERSION = "$(FLUTTER_BUILD_NUMBER)"` across all `Debug`, `Release`, and `Profile` configurations in `ios/Runner.xcodeproj/project.pbxproj`.
- **Verification**:
  - `flutter analyze` (`0 issues`) and `flutter test` (`24 passed, 1 opt-in live test skipped`).
  - `pod install`, `BYPASS_PERMISSION_LOCATION_ALWAYS=1 flutter build ios --simulator`, and `flutter build apk --debug` succeeded.
  - Verified with `plutil -p` and `nm -g` on `build/ios/iphonesimulator/Runner.app` that `CFBundleShortVersionString = "1.0.0"`, `CFBundleVersion = "2"`, all `NS*UsageDescription` keys are present in the compiled `Info.plist`, and `requestAlwaysAuthorization` is stripped from `geolocator_apple.framework`.

## Live account onboarding, email confirmation, password reset, per-member demo seeding & Geoapify Nearby Care integration (PILOT-LIVE-ACCOUNT-01 / NEARBY-GEOAPIFY-01, 1 November 2026)

- **Geoapify Places API v2 Integration (`apps/yanmata-api`)**:
  - Added `services.geoapify` (`key`, `base_url`) in `apps/yanmata-api/config/services.php` and documented `GEOAPIFY_API_KEY=` in `apps/yanmata-api/.env.example` (without committing the secret key).
  - Updated `App\Services\GooglePlacesClient`, `App\Actions\FindNearbyPlaces`, and `App\Http\Controllers\NearbyPlaceController` so `POST /api/v1/nearby-places/search` queries Geoapify Places API v2 (`https://api.geoapify.com/v2/places`) when `GEOAPIFY_API_KEY` is configured, mapping OpenStreetMap categories (`healthcare.hospital`, `healthcare.clinic_or_praxis`, `healthcare.pharmacy`) into the mobile response schema (`id`, `name`, `category`, `category_label`, `address`, `distance_km`, `business_status`, `directions_uri`, `place_uri`, `attributions`) with `meta.provider = "Geoapify · OpenStreetMap"`.
  - Configured `GEOAPIFY_API_KEY` on the production server (`52.0.227.75`, `/var/www/yanmata/backend/.env`) and verified live searches return real Jos hospitals, clinics, and pharmacies (`Old Jos university teaching hospital`, `Tinna pharmacy`, `Dumjos pharmacy`, etc.).
- **6-Digit Email Confirmation & Password Reset (`apps/yanmata-api` & `apps/yanmata-mobile`)**:
  - Added `POST /api/v1/email/verification-notification`, `POST /api/v1/email/verify`, `POST /api/v1/mobile/password/forgot`, and `POST /api/v1/mobile/password/reset` in `SessionController.php` and `routes/api.php`, with branded HTML emails in `MemberMailService` (`sendEmailVerificationCode`, `sendEmailVerifiedConfirmation`, `sendPasswordResetCode`, `sendPasswordResetSuccess`).
  - Updated `AuthPage` (`_showForgotPasswordSheet`) and `YouPage` (`_showVerifyEmailSheet` + `Verified` / `Unverified · Confirm email` status badge) in `apps/yanmata-mobile` for interactive 6-digit code verification and password reset.
- **Automatic Demo Data Seeding for Signed-In Accounts (`SessionController::seedMemberDemoExperience`)**:
  - When `YANMATA_DEMO=true` on the backend, new member accounts are automatically seeded with:
    - **Cycle Settings** (`last_period_date`: 11 days ago, `cycle_length`: 28, `period_duration`: 5 -> `Day 12 of 28 · Follicular Phase`)
    - **Care Conversation & Support Request** assigned to `Demo Specialist One` with an active specialist reply thread
    - **2 Cloud-Synced Encrypted Journal Check-Ins** (`Great` and `Good` logs in `journal_entries` + `journal_changes`)
    - **Notification Preferences** (`20:00` daily check-in reminder, `22:00–07:00` quiet hours)
- **Live Account `okoloebuga@gmail.com` Tested & Linked to Emulators**:
  - Created live account `okoloebuga@gmail.com` (`Okolo Ebuga`, user ID `18`) on `https://yanmata.zentreeca.org`, verified email confirmation (`email_verified: true`), tested password reset (`YanMata2026`), completed health profile + personalised insights, and linked both the running **iOS Simulator** (`iPhone 16 Pro`) and **Android Emulator** (`Pixel 10 Pro`) to `okoloebuga@gmail.com`.
- **Verification**:
  - Backend: `./vendor/bin/pint` and `php artisan test` passed (`45 tests, 295 assertions`).
  - Mobile: `flutter analyze` (`0 issues`) and `flutter test` (`24 passed, 1 opt-in live test skipped`).
  - Deployed to `https://yanmata.zentreeca.org` via `./scripts/deploy.sh /Users/user/Downloads/yanmata.pem` and verified visually on iOS Simulator (`okolo_ios_home.png`) and Android Emulator (`okolo_android_home.png`).

## Auth UX polish: subtle Forgot password typography, 75% height legal WebView sheets, and Continue as Guest stack clearing (AUTH-UX-01, 1 November 2026)

- **Login Screen — "Forgot password?" Typography (`apps/yanmata-mobile/lib/features/account/presentation/auth_page.dart`)**:
  - Updated the "Forgot password?" action on the Sign In tab to use explicit non-bold typography (`FontWeight.w400`, `12.5px`, muted ink/slate colour) with a helpful password recovery modal bottom sheet, avoiding the inherited `FontWeight.w700` button style.
- **Create Account Screen — 75% Height Legal WebView (`apps/yanmata-mobile/lib/core/legal_webview_sheet.dart`)**:
  - Added `webview_flutter: ^4.14.1` and created `LegalWebViewSheet`, which opens a modal bottom sheet wrapped in `FractionallySizedBox(heightFactor: 0.75)` rendering the live public web legal pages (`https://yanmata.zentreeca.org/terms-of-use` and `https://yanmata.zentreeca.org/privacy-policy`) inside an interactive `WebViewWidget` with a loading indicator, external browser button, and graceful fallback.
  - Updated the Create Account terms disclosure in `auth_page.dart` and `account_strings.dart` across all 5 languages (`en`, `ha`, `yo`, `ig`, `pcm`) with tappable `TextSpan` links for **Terms of Service** and **Privacy Policy**.
- **"Continue as Guest" & Auth Stack Clearing (`auth_page.dart`, `personalized_insights_page.dart`)**:
  - Updated `_finishToHome()` in `AuthPage` and `_finishFlow()` in `PersonalizedInsightsPage` to persist `onboarding_done = true` in `SharedPreferences`, invoke `onComplete?.call()`, and execute `Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(builder: (_) => const YanMataShell()), (route) => false)` so tapping **Continue as Guest** immediately lands on the Home screen (`YanMataShell`) and clears all previous onboarding/auth routes from the navigation stack.
- **Verification**:
  - `flutter analyze` passed (`0 issues`).
  - `flutter test` passed (`24 passed, 1 opt-in live test skipped`), including the new regression test in `test/layout_test.dart` verifying `FontWeight.w400` on "Forgot password?", `FractionallySizedBox(heightFactor: 0.75)` on `LegalWebViewSheet`, and `Navigator.canPop() == false` after tapping "Continue as Guest".

## Pilot readiness: Transactional emails, push notifications, workspace reconciliation & iOS/Android simulator QA (PILOT-READY-01, 1 November 2026)

- **Workspace & Deployment Reconciliation (`apps/yanmata-*`)**:
  - Updated `package.json`, `scripts/dev.mjs`, `scripts/generate-tokens.mjs`, `scripts/deploy.sh`, `.github/workflows/verify.yml`, and `.github/workflows/deploy.yml` to target `apps/yanmata-api`, `apps/yanmata-mobile`, `apps/yanmata-web`, and `apps/yanmata-admin`.
  - Removed the leftover untracked `apps/mobile` build directory and verified `google-services.json`, `GoogleService-Info.plist`, `firebase_app.json`, and `shorebird.yaml` in `apps/yanmata-mobile`.
- **Branded HTML Transactional Emails (`apps/yanmata-api`)**:
  - Created `App\Mail\TransactionalNotificationMail`, `App\Services\MemberMailService`, and `resources/views/emails/transactional.blade.php` featuring a warm blush/plum design, circular halo header with the YanMata floral portrait emblem (`https://yanmata.zentreeca.org/logo.png`), pill badges, structured summary cards, a warm sign-off signature (`With warmth, care & dignity — The YanMata Care & Wellbeing Team`), a discreet privacy banner, and the horizontal brand lockup (`logo_horizontal.png`) in the footer.
  - Wired automatic, fault-tolerant transactional email dispatch on:
    - Member registration (`POST /api/v1/mobile/register`)
    - Initial health profile completion (`PUT /api/v1/profile`)
    - Care support request creation (`POST /api/v1/care/requests`), specialist assignment (`POST /api/v1/studio/care/requests/{id}/assign`), and specialist/member replies (`POST /api/v1/care/conversations/{id}/messages`)
    - Essential product orders (`POST /api/v1/orders`)
    - Permanent account deletion (`DELETE /api/v1/account`)
  - Enforced the strict safeguarding invariant: zero clinical answers, cycle logs, product names, or chat message bodies appear in email notifications.
  - Verified live AWS SES (`us-east-1`, `yanmata@zentreeca.org`) delivery to verified addresses (`donald@zentreeca.org`, `zentreeca@gmail.com`). Note: the AWS SES account in `us-east-1` currently has verified identities (`zentreeca.org`, `donald@zentreeca.org`, `zentreeca@gmail.com`); if AWS SES is still in sandbox mode for unverified external recipient domains, request SES Production Access in the AWS Console before public open enrollment. All mail sends are wrapped in `try/catch` so unverified recipients never block API responses.
- **Push Notifications & Realtime Event Polling (`PUSH-01`)**:
  - Created `App\Services\PushNotificationService` in `apps/yanmata-api` to record `BroadcastEvent` outbox items and dispatch discreet FCM push notifications (`A quiet moment` / `You have a new update waiting in your private YanMata space.`) while enforcing user notification preferences and quiet hours (`22:00–07:00`).
  - Declared `android.permission.POST_NOTIFICATIONS` in `AndroidManifest.xml`, `UIBackgroundModes` (`remote-notification`) in `ios/Runner/Info.plist`, and `aps-environment` in `ios/Runner/Runner.entitlements`.
  - Wired `JournalController` and `YanMataShell` in `apps/yanmata-mobile` to automatically register the device (`POST /api/v1/devices`), revoke the device token on logout (`POST /api/v1/logout`), and poll `/api/v1/events/poll` on launch and foreground resume to surface discreet in-app notifications.
- **Verification**:
  - Backend: `./vendor/bin/pint` passed; `php artisan test` passed (`43 tests, 272 assertions`, including `TransactionalEmailAndPushTest`).
  - Mobile: `flutter analyze` (0 issues) and `flutter test` (`23 passed, 1 opt-in live test skipped`).
  - Live Deployment: `./scripts/deploy.sh /Users/user/Downloads/yanmata.pem` deployed backend, web, and admin SPAs to `https://yanmata.zentreeca.org` (`HTTP 200` across `/up`, `/api/v1/content`, `/`, `/admin`).
  - Live End-to-End API Smoke Test: Verified all 24 endpoints against `https://yanmata.zentreeca.org/api/v1` (health, content, locations, services, products, specialists, mental-health, AI companion, AI cycle insights, registration, `/me`, iOS & Android device registration, notification preferences, profile completion, insights, sync consent, cycle settings, care request creation, conversation messages, event polling, and account deletion).
  - Simulator & Emulator Verification: Built, installed, launched, and tested `com.yanmata.app` on **iOS Simulator** (`iPhone 16 Pro`, `xcrun simctl push`) and **Android Emulator** (`Pixel 10 Pro`, `emulator-5554`, `adb shell cmd notification post`).

## Nearby care directory (NEARBY-01, 29 October 2026)

- Member mobile navigation now uses `NearbyPlacesPage` instead of Shop. The clean Riverpod flow is under `apps/yanmata-mobile/lib/features/nearby`; it requests foreground location only after the explicit action, never from initial render or category selection, and does not persist coordinates/results.
- Laravel `POST /api/v1/nearby-places/search` validates coordinates/category/radius, delegates through `FindNearbyPlaces` to `GooglePlacesClient`, requests only bounded Google Places fields and emits `Cache-Control: no-store, private`. See `packages/contracts/openapi.json`.
- Google Maps listings are third-party directory information, not YanMata verification, referral, inventory, appointment booking or emergency monitoring. Privacy and terms copy names Google processing and links to its applicable policies.
- Verification: Pint passed; 40 PHPUnit tests/253 assertions passed; Composer audit is clean after `symfony/mime` 7.4.22; Flutter analysis passed; 23 Flutter tests passed with one expected opt-in live test skipped; Android debug APK and iOS simulator app built; public web typecheck/build/format passed; OpenAPI JSON validated.
- Blockers: `GOOGLE_PLACES_API_KEY` is missing locally and on the deployed server, so live place responses are not verified. Enable Places API (New), billing and server key restrictions, then configure the secret without committing it. Run physical-device checks for grant/deny/permanent deny, search, Google attribution and directions. Update Apple App Privacy and Google Play Data safety declarations before store submission.
- Working tree: a broad user-owned `apps/*` to `apps/yanmata-*` directory migration remains uncommitted. This slice was not committed or deployed to avoid capturing that migration incompletely. The existing deployment script still targets old directory names and must be reconciled before deployment.

## Public header simplification (WEB-04, 29 October 2026)

- Removed the announcement banner above the public navigation from the active `apps/yanmata-web` source, including its obsolete localized strings and responsive CSS.
- Verification: `npm run typecheck` and `npm run build` passed in `apps/yanmata-web`; desktop browser inspection at `http://127.0.0.1:5173/` confirmed the header begins at the top without a residual gap.
- Scope: no API, clinical content or Flutter behavior changed. A broader user-owned `apps/*` to `apps/yanmata-*` directory migration is present in the working tree; keep it intact and do not collapse it into this small UI change unintentionally.
- Next: include WEB-04 when the directory migration is coherently committed and deploy the resulting public build through the established pipeline.

## Mobile App ID, Firebase & Shorebird (28 October 2026)

- **Application ID / Bundle ID**: `com.yanmata.app` for both Android and iOS.
- **Firebase Project**:
  - Project ID: `yanmata-app` (Project number: `1098473372320`)
  - Android App ID: `1:1098473372320:android:d127438d1f89509c3da7c5`
  - iOS App ID: `1:1098473372320:ios:3ee4c1619a1f29013da7c5`
  - Android Config: `apps/mobile/android/app/google-services.json`
  - iOS Config: `apps/mobile/ios/Runner/GoogleService-Info.plist` & `apps/mobile/ios/firebase_app.json`
- **Shorebird Code Push**:
  - App ID: `c0ff34cc-7485-4640-92dc-8179b7d36089` (App Name: `YanMata`)
  - Config: `apps/mobile/shorebird.yaml` (registered in `apps/mobile/pubspec.yaml`)
  - Account: `devkingssolutions@gmail.com`

## Confirmed user intent

YanMata is supplied by Zentreeca Limited. Build a working product: Flutter Android/iOS with Riverpod, offline-first/realtime sync, WebSockets, FCM and local reminders; Laravel backend; React public website and React administration. Use clean architecture with MVC presentation/controller separation. Support life-stage female wellbeing, verifiable content, specialists and publishing from web/mobile. Demo uses synthetic seeded data with real workflows. Preserve polished UI and comprehensive continuity docs. Deploy to remote server `52.0.227.75` under `yanmata.zentreeca.org` with AWS SES mail delivery customized for `yanmata@zentreeca.org`.

## Live deployment status (28 October 2026)

The YanMata platform is deployed and running live on AWS server `52.0.227.75` under Caddy and PHP 8.3 FPM:

- **Public Web**: `http://52.0.227.75/` and `http://yanmata.zentreeca.org/` (and HTTPS once DNS propagates)
- **Admin Studio**: `http://52.0.227.75/admin` and `http://yanmata.zentreeca.org/admin`
- **Backend API**: `http://52.0.227.75/api/v1/content` and `/up`
- **Email Delivery**: AWS SES in `us-east-1` from `yanmata@zentreeca.org` (verified active with test dispatch)
- **Coexistence**: Running in harmony alongside existing `agripulse.zentreeca.org` reverse proxy without interruption.
- **DNS Setup Required**: In Cloudflare DNS for `zentreeca.org`, add:
  - Type: `A`
  - Name: `yanmata`
  - Content: `52.0.227.75`
  - Proxy status: Proxied (or DNS only; Caddy handles automatic SSL certificates either way).

## Deployment pipeline & CI/CD (PIPE-01)

Two deployment mechanisms are established:

1. **GitHub Actions Workflow** (`.github/workflows/deploy.yml`):
   - Automatically tests, builds, and deploys on push to `main` branch, or via manual `workflow_dispatch` button.
   - Required GitHub Repository Secrets (`Settings > Secrets and variables > Actions`):
     - `SERVER_SSH_KEY`: Content of the SSH private key (`yanmata.pem`).
     - `SERVER_HOST`: `52.0.227.75` (optional, default provided).
     - `SERVER_USER`: `ubuntu` (optional, default provided).
2. **Local / CLI Deploy Script** (`scripts/deploy.sh`):
   - 1-command deployment from developer terminal:
     `./scripts/deploy.sh ~/Downloads/yanmata.pem`
   - Builds production web/admin SPAs, runs PHPUnit test suite, synchronizes files, optimizes Laravel caches, restarts PHP-FPM/Caddy, and verifies live health checks.

Pilot location confirmed: Jos, Plateau State. User has access to doctors/nurses in public/private hospitals for review. Audience confirmed: ages 9 onward, from puberty through the end of life, with no upper age limit. On 28 October the user authorised the synthetic health-services directory from the supplied wireframe. Preserve in-platform specialist interaction; external booking and automated emergency referral remain out of scope. Named clinicians and age-appropriate consent/access protocols still need definition.

## Actual state

Phase 01 through Phase 11 vertical slices are implemented across Laravel, React public/admin, and Flutter Android/iOS.
All screens from the Zentreeca designer handoff and wireframe are fully implemented and verified on the Android emulator runtime, including the full wireframe Account Flow:

1. Native Branded Launch & Welcome (`WelcomePage`, `android-39-onboarding.png`)
2. Screen 3: Authentication (Sign Up & Sign In with DOB picker, age gate >= 9, terms, guest bypass) (`AuthPage`, `android-40-auth-signup.png`)
3. Screen 4: Complete Health Profile questionnaire (Menstrual, Reproductive, Medical, Lifestyle, Family with minor safeguarding) (`CompleteProfilePage`, `android-41-complete-profile.png`)
4. Screen 5: Personalized Health Insights (evidence-based WHO/FMOH guidance without fake risk percentages, category filters, priority badges, "Go to Dashboard" CTA) (`PersonalizedInsightsPage`, `android-42-personalized-insights.png`)
5. Home Dashboard with dynamic personalized greeting ("Good day, Zainab ☀️"), 5 feature shortcuts, live cycle widget, Aisha AI card, multilingual header, location pill, and dark mode toggle (`TodayPage`, `android-43-today-personalized-greeting.png`)
6. Cycle Tracker with circular dial, dynamic phase, and 3-question cycle setup flow (`TrackPage`, `CycleSetupDialog`)
7. Early Detection & Screening Guide (`EarlyDetectionPage`)
8. Mental Health Support with mood emojis, coping modals, and Nigeria's official emergency number 112 (`MentalHealthPage`)
9. Health Services directory with dynamic city filtering (`ServicesPage`, `ServiceDetailSheet`, `LocationPickerSheet`)
10. Shop Health Products with cart, dynamic delivery, and checkout confirmation (`ShopPage`, `CartSheet`)
11. My Profile & Records with life chapters, health records, notification quiet hours, and language selector (`YouPage`)
12. Aisha AI Health Companion with conversational symptom guidance, clinical guardrails, and cycle pattern intelligence (`AishaChatPage`, `AiCompanionController`)
13. Member account controls with device-clearing logout, password-confirmed permanent deletion and explicit warning dialogs (`You`, `LocalJournalRepository`, `DELETE /api/v1/account`)

Brand Identity & Multi-Variant Asset Suite (DESIGN-01):

- Refined Brand Emblem: Extracted and anti-aliased the official YanMata portrait mark (African woman profile with vibrant rose-magenta Gele, white hoop earring, cradling petals, and radiant halo) into high-resolution transparent master assets.
- Complete Asset Variants: Generated stacked full logos (light/dark), horizontal/landscape logos (light/dark), mobile launcher icons across all 5 Android mipmaps and all 15 iOS `AppIcon.appiconset` resolutions, Android launch/splash screens, and web multi-resolution favicons (`favicon.svg`, `favicon.ico`, `apple-touch-icon.png`).
- Cross-Platform Integration: Updated `<Brand />` in `@yanmata/ui` to render the refined emblem across public web and admin studio headers; updated Flutter `WelcomePage` with prominent badge framing; registered assets in `pubspec.yaml`; created `scripts/build_brand_assets.py` for automated regeneration.

Public Website Story Integration, Navigation Polish & Multilingual Localisation (`apps/web`):

- Generalized National & Global Scope: Truthfully framed Jos as the initial clinical review pilot launch hub while expanding copy across web and mobile to represent Nigeria, Africa, and beyond ("Made with care in Nigeria, for Africa and the world").
- Multilingual Public Web: The public website has English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`) copy. Non-English clinical and safeguarding copy still requires human linguistic and clinical review before release.
- Streamlined & De-noised Top Menu: Clean, breathable desktop navigation focused on 4 core anchors (`Stories`, `Chapters`, `Specialists`, `Learning`) plus a glowing `Aisha AI` pill; secondary anchors (`Account Journey`, `Real Stories`, `Our Approach`) cleanly housed in the mobile drawer.
- Sticky Glassmorphism Header: Frosted-glass backdrop blur (`backdrop-filter: blur(16px)`), subtle border, and responsive mobile slide-down drawer with animated menu toggle (`Menu` / `X`).
- Fluid Micro-Animations: Nav link underline slide, rotating sparkle pulse on Aisha AI pill, floating ambient notes in Hero, ambient phone mockup float, smooth tab switch entry transition (`showcaseFadeIn`), interactive card hover lifts on journey steps & testimonials, and accessible `prefers-reduced-motion` compliance.
- 6 Core Health Stories / Features Showcase: Interactive phone mockup displaying live mobile app screen captures (`public/screens/*.png`) across Cycle Rhythm, Aisha AI 24/7 Companion, Clinical Preventive Insights, Encrypted 5-Pillar Health Profile, Mental Health Wellbeing, and Verified Specialists.
- Wireframe Account Flow (5 steps): Visualized from first-time onboarding (ages 9+) through private age-gated registration, 5-pillar health profile assessment, WHO/FMOH evidence-based clinical insights, and daily companion rhythm.
- Release-facing copy: public web and mobile no longer present YanMata as a development preview, demo, test, coming-soon product or incomplete pilot. Legal and safety boundaries remain explicit without claiming clinical approval or pilot results. See `docs/evidence/PHASE-09.md`.
- Age-inclusive editorial photography: the illustrated hero is retained and four original, optimized editorial images now represent adolescence through later life, private mobile use and illustrative specialist support. Image subjects are fictional and must never be presented as users, clinicians, reviewers, partners or testimonial sources. See `docs/evidence/PHASE-10.md`.
- Live mobile API: Flutter now defaults to `https://yanmata.zentreeca.org/api/v1`; local Android/iOS URLs remain explicit development overrides. An isolated synthetic-account test verifies registration, consent, two-store journal synchronization, deletion propagation and account cleanup against the deployed API. The server still reports demo mode. See `docs/evidence/PHASE-11.md`.
- Account deletion rate limiting is isolated under the named `account-deletion` limiter. Do not revert it to numeric `throttle:5,1`: numeric route throttles share an authenticated-user counter, and prior sync traffic can otherwise block a first deletion request.
- Truthful Clinical Invariants: in-platform specialist consultation remains primary; the services directory is synthetic and must never imply a partnership. No external booking or automated emergency referral. No fabricated risk scores or provider credentials.

Multilingual system covers English, Hausa (`ha`), Yoruba (`yo`), Igbo (`ig`), and Nigerian Pidgin (`pcm`) on mobile and web. System-wide light/dark mode transitions verified on mobile, public web, and admin with warm rose-aubergine feminine aesthetics and Fraunces typography. Dynamic location engine spans Nigeria (Jos Pilot Hub, Abuja, Lagos, Kano, Ibadan, Port Harcourt, Enugu, Kaduna, Nationwide). Dynamic cycle settings sync with Laravel backend (`GET/PUT /api/v1/cycle-settings`).

Public web and admin studio are fully verified via automated browser testing:

- Desktop (1440×900) and mobile (390×844) public views (`web-01-home.png`, `web-02-mobile.png`)
- Authenticated admin login, editorial table, and care triage (`admin-01-login.png`, `admin-02-editorial-studio.png`, `admin-03-care-triage.png`)
- Public Privacy Policy, Terms of Use and Account Deletion routes plus configured Google Play/App Store cards (`PHASE-08.md`)
- Small-screen public navigation uses an opaque elevated panel in light and dark themes; verified at 360×800 and 390×844 with no horizontal overflow (`WEB-MOBILE-MENU.md`).

Production hardening & operations (QA-01, OPS-01):

- `SecurityHeaders` middleware attached to all web/API responses.
- `scripts/backup-db.sh` creates atomic SQLite VACUUM snapshots with SHA-256 checksums and PRAGMA integrity check.
- `scripts/restore-db.sh` validates SHA-256 checksums and SQLite integrity with automatic pre-restore backup.
- Strict prevention of lazy loading (`Model::preventLazyLoading`) active across all Eloquent models to guarantee zero N+1 database queries.
- Zero clinical text in push or broadcast payloads. The synthetic services directory must stay visibly labelled; external booking and automated emergency referral remain excluded.
- The Flutter client no longer falls back to fictional health-service listings when the API is empty or unavailable. Governed server records remain the only source displayed to members; failures show a retry state.
- All 35 PHPUnit tests (217 assertions) pass; Pint passes with 0 issues; `flutter analyze` is clean; 17 Flutter tests pass with one opt-in live API test skipped; Prettier, TypeScript and both React production builds pass.

Important current boundaries: local backend SQLite; manual HTTP sync; client-rendered public site; seeded identities only. Strict prevention of lazy loading and missing attribute discarding is active on the backend, ensuring zero N+1 database queries. No claims of clinical approval: seed reviewer and specialist timestamps are synthetic and explicitly labelled. Zero clinical text in push or broadcast payloads.

Local demo credentials are in ignored `.env.demo.local`; do not print or commit them. Development ports are API 8091, web 5173, admin 5174. Use `npm run dev`; existing preview processes may not survive a tool/session transition. The source is in the shared workspace, not a separate worktree.

Reference paths:

- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata Women’s Health App Wireframe.png`
- `/Users/user/Desktop/APPS/Zentreeca/Yanmata/YanMata_Wireframe_and_Designer_Handoff.pdf`
- `/Users/user/StudioProjects/dater`
- `/Users/user/Desktop/DevKings/Projects/Relationship-Essential`

Wireframe reviewed visually; PDF text reviewed across four pages. It adds products/commerce, mental wellbeing, learning and clinical/source/privacy requirements. Plan preserves commerce as later scope and changes navigation to prioritise Learn. Cancer-risk percentages in the image are not accepted as a clinical specification.

## Next executable work

1. Read AGENTS, README, ADR 0002, and evidence documents (`PHASE-01.md`, `PHASE-02.md`, `PHASE-03.md`) before changing implemented flows.
2. Deliver QA & operations hardening (QA-01, OPS-01): rate-limiting audit, automated backup and restore script, metrics redaction, error boundary inspection.
3. Deliver native encrypted Drift database migration with outbox/cursor preservation and crash tests. Keep the real two-store API integration test.
4. Replace temporary store destinations with approved live listings, obtain privacy/legal review of the public policies, then add public prerendering/SSR and SEO plus offline content validity windows.
5. Refresh browser screenshots after layout changes, run mobile visual tests, record exact test/build outcomes, and update backlog/change log.

## Open decisions

Minor-access protocol for the confirmed age-9-plus audience; named clinical/safeguarding owners; specialist credential verification; staffing/budget; hosting region/processor contracts; English/Hausa scope; app identifiers/Apple/Firebase accounts; source licence; final visual identity. These decisions gate corresponding live features rather than all engineering.

## Verification

See `docs/evidence/PHASE-01.md` through `docs/evidence/PHASE-11.md` for commands, screenshots, defects, and limitations.
Phase 05 checks:

- API: 29 tests / 172 assertions pass with strict lazy loading prevention active.
- Laravel Pint: passed with zero style violations.
- Mobile: 10 tests pass (persistence, golden baselines, 200% text scale, care specialists, tracking symptoms/flow, quiet hours calculations, discreet lock-screen copy, mobile staff studio, layout stability) + live integration test passes.
- TypeScript, React builds, and Prettier pass for web and admin.
- Visual evidence: 15 screenshots captured across Android live emulator (`android-27` through `android-37`), Public Web (`web-03`, `web-04`, `web-05`), and Admin (`admin-04`).
- Contracts: `packages/contracts/openapi.json` updated with `/locations`, `/health-services`, `/ai/companion/chat`, `/ai/cycle/insights` and validated.
