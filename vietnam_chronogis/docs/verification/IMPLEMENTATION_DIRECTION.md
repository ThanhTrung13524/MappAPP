# Implementation Direction

Date: 2026-07-07

Branch: `lab3`

Baseline commit:

```text
440b2d4508b39080c2686e89d96abfb6a19d3cfc
```

## Current source state

The repository already contains a Firebase/Campaign/Event/Participant/Check-in implementation from the current `LAB 3` commit. The working tree was clean at the start of this implementation pass.

Existing preserved features:

- Startup seed route `/seed`.
- Flutter/Riverpod/GoRouter app shell.
- Drift/SQLite ChronoGIS local data.
- OSM school POI data in local SQLite `schools`.
- `flutter_map` province polygons, tourism markers, school markers, heatmap, and routing layers.
- Explorer, Schools, AI chat, and OSRM routing.

Firebase-related features present in source:

- Optional Firebase Core bootstrap.
- Firebase Auth and Google Sign-In repository/UI.
- Firestore user profile model.
- Managed school Firestore model/repository.
- Campaign, Campaign Event, Participant, and Check-in modules.
- Firebase Functions TypeScript source.
- Firestore Rules and indexes scaffolding.

## Direction

Stabilize the existing implementation into a coherent data contract instead of adding another parallel skeleton.

Priority fixes:

1. Align managed school schema across Flutter, Cloud Function, and Firestore Rules.
2. Align callable check-in response and callable function name.
3. Align Campaign/Participant field names with Firestore Rules.
4. Keep client check-in as a callable-only flow; no direct client check-in writes.
5. Preserve local SQLite OSM `schools` as map POI data only.
6. Keep missing Firebase config as a friendly blocked state rather than a crash.

## Blockers

- No real Firebase native configuration is committed: no `google-services.json`, no `GoogleService-Info.plist`, no `firebase_options.dart`, and no `.firebaserc`.
- Google Sign-In and Firestore writes cannot be verified against a real project until the user configures Firebase.
- Firebase Rules emulator tests are not currently available in the project.
- App Check production enforcement is not verified.

## Verification policy

Use `Verified` only for behavior with command/test evidence. Use `Implemented` or `Blocked` when source exists but a real Firebase project or emulator is required for end-to-end verification.

## Outcome on 2026-07-07

Implemented in this pass:

- Managed school Firestore writes now use `location: GeoPoint`, `active`, `createdBy`, and server timestamps; reads still tolerate legacy `latitude`/`longitude` and `status == active`.
- Campaign events now write `schoolId`.
- Flutter check-in now calls `checkInEvent`; the Cloud Function exports both `checkInEvent` and legacy `validateEventCheckIn`.
- Cloud Function check-in returns both `success` and `ok`, reads event-level `schoolId` with campaign fallback, accepts `active` managed schools, and reads `location: GeoPoint` with latitude/longitude fallback.
- Firestore Rules were aligned to app field names for managed schools, campaign creation, participant join, owner participant bootstrap, participant approval, and event `schoolId`.
- Contract tests were added for managed school writes, event `schoolId`, and callable result parsing.

Verified locally:

- `dart format --output=none --set-exit-if-changed .`
- `flutter analyze`
- `flutter test --reporter expanded` with 34 tests passing
- `npm run lint` in `functions/`
- `npm run build` in `functions/`
- `npm test` in `functions/` with 3 Node tests passing

Still blocked:

- Real Google Sign-In, Firestore writes, callable check-in, and Firestore Rules behavior require Firebase client config and either a deployed backend or emulator test suite.
