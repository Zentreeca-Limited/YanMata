# YanMata mobile

Flutter/Riverpod Android/iOS foundation. See root README and ADR 0002 for setup and explicit limitations.

Structure: `core` for API, theme and shared widgets; feature `domain`, `data`, `application`, `presentation` for dependencies that point inward. Repository interfaces are injectable in tests. Local secure-storage persistence is currently a bounded 100-entry foundation adapter, pending encrypted database migration. Do not use with real longitudinal health data.

`flutter analyze` and `flutter test` validate source and offline check-in behaviour. The opt-in live test uses two independent stores against Laravel; run the root `scripts/test-live-mobile.py` with the local API running. Normal test runs skip that test if its credential environment variable is absent.

Android emulator: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8091/api/v1`. iOS simulator: use `http://127.0.0.1:8091/api/v1`. Release builds require an HTTPS API URL. Physical-device testing, release signing, FCM/APNs and reminder delivery remain pending.
