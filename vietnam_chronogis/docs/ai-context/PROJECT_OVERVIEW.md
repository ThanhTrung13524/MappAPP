# Project Overview

## Project summary

`vietnam_chronogis` is a Flutter/Dart application for Vietnam historical-administrative GIS exploration with a newly added Firebase Campaign/Event check-in foundation.

The current product still preserves the ChronoGIS app:

- Vietnam administrative data and GeoJSON boundaries.
- Tourism POI data from Overpass and Wikipedia.
- School POI data from OpenStreetMap stored locally in SQLite.
- Map, Explorer, Schools, AI, and OSRM routing features.
- Startup seed route `/seed`.

Firebase has now been added as an optional backend foundation for Campaign/Event check-in. The app does not contain real Firebase client config files or secrets, so Firebase-dependent screens show a "not configured" state until a real project is configured.

## Tech stack

| Area | Current implementation |
| --- | --- |
| Framework | Flutter |
| Language | Dart SDK `^3.12.0` |
| State management | Riverpod 3 |
| Navigation | GoRouter |
| Local persistence | Drift + SQLite |
| Map | `flutter_map` + `latlong2` |
| HTTP | Dio and `dart:io` clients |
| Remote APIs | Hugging Face datasets, Overpass, Wikipedia, Groq, OSRM |
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `cloud_functions`, `firebase_app_check` |
| Location | `geolocator` |
| Cloud backend | Firebase Functions TypeScript under `functions/` |

## Platforms

Generated platform folders exist for Android, iOS, web, Windows, macOS, and Linux.

| Platform | Status | Notes |
| --- | --- | --- |
| Android | Present | Package id remains `com.example.map_application1`; location permission added. |
| iOS | Present | Bundle id remains `com.example.mapApplication1`; location usage description added. |
| Web | Present | No Firebase web options are committed. |
| Windows | Present | Existing desktop app remains available. |
| macOS | Present | Existing bundle id remains sample-like. |
| Linux | Present | Existing desktop app remains available. |

## Implemented ChronoGIS features

- App startup with `ProviderScope`, SharedPreferences, and optional Firebase bootstrap result override.
- GoRouter routes for `/seed`, `/auth`, `/login`, `/map`, and `/explorer`.
- Drift database for administrative units, GeoJSON cache, tourism places, OSM school POIs, historical events, and chat history.
- Data seeding from Hugging Face and Overpass.
- Map screen with province polygons, heatmap, tourism markers, school markers, and routing overlays.
- Explorer screen for tourism places.
- Schools screen for OSM school POIs.
- AI chat with Groq. Missing `GROQ_API_KEY` is handled without app crash.
- OSRM route calculation.

## Implemented Firebase Campaign/Event foundation

- Optional Firebase initialization in `lib/core/firebase/firebase_bootstrap.dart`.
- Nullable Firebase providers in `lib/core/firebase/firebase_providers.dart`.
- Auth flow with Google sign-in and logout.
- User profile creation in Firestore `users/{uid}`.
- Managed school model separate from local OSM `schools`.
- Campaign, campaign event, participant, role, and check-in domain models.
- Campaign tab in the app shell for managed schools, campaigns, events, join requests, approval/rejection, and check-in actions.
- Server-authoritative callable Cloud Function `validateEventCheckIn`.
- Firestore rules that block direct client writes to `checkins`.
- Flutter unit tests for check-in geometry/time validation.
- TypeScript build/test for Cloud Functions validation helpers.

## Current limitations

- No real Firebase config files are committed: no `google-services.json`, no `GoogleService-Info.plist`, no generated `firebase_options.dart`.
- Firebase Auth/Firestore/Functions flows cannot be exercised against a real backend until a Firebase project is configured.
- Firestore rules were authored but not emulator-tested in this environment because `firebase-tools` was unavailable and `npx firebase-tools@latest` timed out.
- Notifications/FCM are not implemented.
- No Firebase Storage, Analytics, Crashlytics, or Remote Config implementation exists.
- Android/iOS identifiers remain sample values and should be changed before production Firebase app registration.

## Verification performed on 2026-06-24

| Command | Result |
| --- | --- |
| `flutter pub get` | Passed after Firebase/geolocation dependencies were added. |
| `dart format --output=none --set-exit-if-changed .` | Passed after formatting. |
| `flutter analyze` | Passed. No issues found. |
| `flutter test` | Passed. 13 tests passed. |
| `npm install` in `functions/` | Passed, with 8 moderate npm audit findings and Node engine warning because local Node is v25 while Functions target Node 20. |
| `npm run lint` in `functions/` | Passed. |
| `npm test` in `functions/` | Passed. 3 Node tests passed. |

## Configuration warnings

- Android package id and namespace are still `com.example.map_application1`.
- iOS/macOS bundle id is still `com.example.mapApplication1`.
- Android release signing still uses debug signing config.
- `dart_defines.example.json` remains an example only; no real Groq or Firebase secret was committed.
