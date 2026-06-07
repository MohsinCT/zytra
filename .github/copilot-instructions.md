## Quick context — what this repo is

- Flutter mobile app (multi-platform) named `zytranow` focused on fast local delivery.
- Key locations: `lib/main.dart` (app entry & provider list), `lib/view/` (UI screens),
  `lib/controllers/` (ChangeNotifier providers), `lib/services/` (platform / API wrappers),
  `assets/images/` (static art).

## High-level architecture (the "why")

- Presentation: Flutter widgets under `lib/view/` organized by screen. Example: `lib/view/screens/splash/splash_screen.dart`.
- State: Provider + ChangeNotifier pattern. All app providers are registered centrally in `lib/main.dart` via `_appProviders`.
- Services: Platform and network abstractions live in `lib/services/` (e.g. `api_service.dart`, `location_service.dart`). Providers call services; services avoid UI imports so they can be mocked in tests.
- Backend contract: `lib/services/api_service.dart` contains explicit Node.js/Express expectations and offline mock fallbacks. The app expects endpoints like `/api/products`, `/api/products/popular`, and `/api/products/:id`.
- Persistence & Cloud: Firestore + Firebase Auth are used (see `lib/controllers/address_provider.dart`) for user addresses; Google Maps + geolocation are integrated for location features.

## What AI agents should know to be immediately productive

- State is provider-driven and side-effectful: changes to providers must call `notifyListeners()` and respect existing lifecycle (`dispose()` already implemented in several providers).
- Most UI screens consume providers via `Provider.of<T>(context)` or `Consumer<T>`. Search `ChangeNotifierProvider` usage in `lib/main.dart` to find registered types.
- Network calls use `ApiService.baseUrl` logic (file: `lib/services/api_service.dart`). For local-device testing:
  - Android emulator: uses `http://10.0.2.2:5000/api`
  - iOS simulator & macOS: `http://localhost:5000/api`
  - Web: `http://localhost:5000/api`
  If testing on a physical phone, set `computerIp` inside `ApiConfig.baseUrl` to your machine's LAN IP.
- Offline-first behavior: API wrappers return an `offlineFallback` payload when network fails — many features are intentionally resilient to missing backend during development. Check `ApiService.getPopularProducts` and `ProductService._generateDummyProducts` for examples.

## Important files & examples to reference

- `lib/main.dart` — centralized providers, top-level routing, and a MediaQuery textScale clamp.
- `lib/services/api_service.dart` — base URL logic, request wrapper, and detailed backend contract comments. Use this when changing routes or adding endpoints.
- `lib/services/location_service.dart` + `lib/controllers/location_provider.dart` — permission flow and reverse-geocoding pattern; prefer using the provider API instead of calling geolocator/geocoding directly from UI.
- `lib/controllers/address_provider.dart` — Firestore access patterns (users/{uid}/addresses) and optimistic local state updates.
- `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist` — required permissions and placeholder keys (Google Maps API key). Replace `YOUR_GOOGLE_MAPS_API_KEY` / `YOUR_REAL_GOOGLE_MAPS_API_KEY` with your keys.

## Common tasks & exact commands

Use the Flutter toolchain (assumes Flutter installed and on PATH). Typical commands we use while developing:

```bash
# fetch packages
flutter pub get

# run on an attached Android device/emulator
flutter run -d emulator-5554   # or use `flutter devices` to list targets

# run on iOS simulator
flutter run -d "iPhone 14"

# build release APK
flutter build apk --release

# format & analyze
flutter format .
flutter analyze
```

Notes for backend-local testing:
- If your backend runs on `localhost:5000` and you use a physical Android device, set `ApiConfig.computerIp` in `lib/services/api_service.dart` to your computer LAN IP (e.g. `192.168.x.x`).

## Project-specific conventions & gotchas

- Providers list is canonical: add/remove providers only in `lib/main.dart` under `_appProviders`.
- OTP bypass during development: `AuthProvider.verifyOtp` accepts `"1111"` as a successful OTP. Useful when writing UI or navigation tests.
- Text-scaling: The app injects a clamped textScaleFactor in `ZytraApp.builder` — UI may behave unexpectedly if you bypass that builder in tests; prefer to run widget tests that wrap the widget with the same MediaQuery or use `WidgetTester.binding.window` APIs.
- Firestore paths follow `users/{uid}/addresses`. When adding fields, mirror shape changes in `lib/models/address_entry.dart` and the provider mapping.
- Do not hardcode Google/Firebase keys in repo. Look for missing `google-services.json` / `GoogleService-Info.plist` and ask the owner for them.

## Debugging and logging

- The code uses `dart:developer` logs (emoji-prefixed) in `api_service.dart` and `debugPrint` in providers. Use `flutter logs` or IDE console to see them.
- For location/debugging flows, pay attention to `LocationPermissionStatus` enum in `location_provider.dart` — UI branches on these values instead of raw strings.

## When you modify APIs or state

- Update `ApiService` first when adding new endpoints so the offline fallback pattern can be reused.
- If you change a provider public API (fields/methods), update all consumers across `lib/view/` — many widgets access providers directly and there are no centralized selectors.

---
If anything in this file looks incomplete or you want more detail (example flows, tests to add, or common PR checklist), tell me which area to expand and I will update this file. 
