# YanMata mobile

Flutter/Riverpod Android/iOS foundation. See root README and ADR 0002 for setup and explicit limitations.

Structure: `core` for API, theme and shared widgets; feature `domain`, `data`, `application`, `presentation` for dependencies that point inward. Repository interfaces are injectable in tests. Local secure-storage persistence is currently a bounded 100-entry foundation adapter, pending encrypted database migration. Do not use with real longitudinal health data.

`flutter analyze` and `flutter test` validate source and offline check-in behaviour. The opt-in live test uses two independent stores against Laravel; run the root `scripts/test-live-mobile.py` with the local API running, or set `YANMATA_API_BASE_URL=https://yanmata.zentreeca.org/api/v1` to verify the deployed synthetic-data API. Normal test runs skip that test if its credential environment variable is absent.

The checked-in API default is `https://yanmata.zentreeca.org/api/v1`, so `flutter run` and release builds connect to the deployed HTTPS API without an extra define. For local development, Android emulator: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8091/api/v1`. iOS simulator: use `http://127.0.0.1:8091/api/v1`. Release builds reject non-HTTPS API URLs. Physical-device testing, release signing, FCM/APNs and reminder delivery remain pending.

## Nearby care

The member navigation uses an opt-in nearby directory in place of mobile product purchasing. It searches Google Maps for hospitals, clinics and pharmacies within 10 km, ranked by distance, and opens the provider-supplied Google Maps directions link. Category selection does not request location; only the explicit **Use my current location** action does. Android and iOS request foreground/while-in-use permission only. The feature has loading, empty, offline/upstream failure, denied, permanently denied, disabled-service and timeout states.

The Flutter client never receives a Google API key. Configure `GOOGLE_PLACES_API_KEY` only in the Laravel environment after enabling Places API (New), billing and suitable server-side key restrictions. Coordinates travel in a `POST` body and neither coordinates nor returned place listings are persisted by YanMata. Google Maps attribution remains visible. Before a store release, update Google Play Data safety and Apple App Privacy disclosures for foreground precise location processing, complete physical-device permission/directions checks, and obtain privacy/legal approval.
