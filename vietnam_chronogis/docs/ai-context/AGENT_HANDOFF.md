# Agent Handoff

## What this project is

`vietnam_chronogis` is a Flutter app for Vietnam historical-administrative GIS exploration with a Firebase Campaign/Event/check-in foundation added on top.

The app supports:

- Vietnam administrative data and GeoJSON boundary seeding.
- `flutter_map` map display.
- Tourism POI data from Overpass and Wikipedia.
- School POI layer from OpenStreetMap stored in local SQLite.
- AI chat through Groq.
- OSRM route calculation.
- Firebase Auth/Firestore/Functions foundation for managed schools, campaigns, events, participants, and server-authoritative check-in.

## Important distinction

There are two different school concepts:

- SQLite `schools`: OpenStreetMap school POIs for map display. Do not use as organizer/campaign schools.
- Firestore `managed_schools`: Campaign/Event organizer schools with coordinates and check-in radius.

## Current architecture

- Flutter/Dart SDK `^3.12.0`.
- Riverpod 3 for state management and dependency injection.
- GoRouter for navigation.
- Drift/SQLite for local ChronoGIS data.
- Firebase Auth/Firestore/Functions for Campaign/Event workflows.
- TypeScript Firebase Functions under `functions/`.

Main flow:

`main.dart` -> optional Firebase bootstrap -> `ProviderScope` -> GoRouter -> `/seed` -> local seed -> `/auth` -> `/login` or `/map` -> `AppShell`.

## Read these files first

1. `lib/main.dart`
2. `lib/core/router/app_router.dart`
3. `lib/core/firebase/firebase_bootstrap.dart`
4. `lib/core/firebase/firebase_providers.dart`
5. `lib/core/database/app_database.dart`
6. `lib/shared/providers/seed_provider.dart`
7. `lib/features/shell/presentation/app_shell.dart`
8. `lib/features/map/presentation/map_view_screen.dart`
9. `lib/features/campaigns/presentation/campaigns_screen.dart`
10. `functions/src/index.ts`
11. `firestore.rules`

## Completed parts

- CI Flutter commands use `working-directory: vietnam_chronogis`.
- Dart format/analyze/test pass locally.
- Local school POI seed failure does not mark success and can retry without deleting existing SQLite rows.
- Missing `GROQ_API_KEY` no longer crashes AI.
- Firebase dependencies added.
- Optional Firebase bootstrap added; app remains usable when Firebase config is absent.
- Auth gate/login/logout/profile creation added.
- Firestore domain models and repositories added for managed schools, campaigns, events, participants, and check-ins.
- Campaigns tab added to the shell.
- Cloud Function `validateEventCheckIn` added.
- Firestore rules added and direct client check-in writes denied.
- Flutter check-in validator tests added.
- Functions TypeScript validation tests added.

## Not completed

- Real Firebase config files are not present.
- Google sign-in has not been tested against a real Firebase project.
- Firestore rules have not been emulator-tested.
- Functions have not been deployed.
- Notifications/FCM are not implemented.
- Production Android/iOS/macOS identifiers are still not chosen.
- Map performance work is the next active phase.

## Verification on 2026-06-24

- `flutter pub get`: passed.
- `dart format --output=none --set-exit-if-changed .`: passed after formatting.
- `flutter analyze`: passed.
- `flutter test`: passed with 13 tests.
- `npm install` in `functions/`: passed with 8 moderate audit findings and Node v25 vs target Node 20 warning.
- `npm run lint` in `functions/`: passed.
- `npm test` in `functions/`: passed with 3 Node tests.
- Firebase CLI was not available; `npx firebase-tools@latest --version` timed out after 5 minutes.

## Do not break

- Startup seed route `/seed`.
- `/map`, Explorer, Schools, AI, Campaigns, and routing.
- Local Drift schema unless intentionally migrating.
- Existing SQLite data.
- Optional behavior when Firebase config is missing.
- `dart_defines.example.json` as an example-only file.

## Next recommended task

Proceed with measured map performance and UX work:

1. Create `docs/performance/MAP_BASELINE.md`.
2. Measure what the local environment can actually measure.
3. Optimize only bottlenecks with evidence.
4. Keep `MapViewScreen` behavior stable during the first refactor pass.
5. Create `docs/performance/MAP_AFTER_OPTIMIZATION.md` with before/after evidence.
