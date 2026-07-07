# Feature Status

Status values are limited to: `Complete`, `Partial`, `Missing`, `Broken`, `Unknown`.

## Firebase Campaign/Event product

| Feature | Status | Files | Backend | Tests | Notes |
| --- | --- | --- | --- | --- | --- |
| Firebase bootstrap | Partial | `lib/core/firebase/firebase_bootstrap.dart`, `lib/main.dart` | Firebase Core | Analyze/test pass | Optional bootstrap works without crashing when config is absent; real config not committed. |
| Login | Partial | `auth_repository.dart`, `login_screen.dart` | Firebase Auth + Google Sign-In | Analyze/test pass | Requires Firebase project and enabled Google provider for end-to-end use. |
| Logout | Partial | `auth_repository.dart`, `login_screen.dart` | Firebase Auth | Analyze/test pass | Implemented, not backend-tested. |
| User profile | Partial | `app_user_profile.dart`, `auth_repository.dart` | Firestore `users/{uid}` | Analyze/test pass | Default profile creation implemented. |
| Managed school | Partial | `managed_school.dart`, `managed_school_repository.dart` | Firestore `managed_schools` | Analyze/test pass; contract test pass | Separate from SQLite OSM `schools`; new writes use `location: GeoPoint`, `active`, `createdBy`, and radius <= 1000m. |
| Campaign creation | Partial | `campaign.dart`, `campaign_repository.dart`, `campaigns_screen.dart` | Firestore `campaigns` | Analyze/test pass | Creates campaign and owner participant; rules allow app-created `published` campaigns. |
| Event creation | Partial | `campaign_event.dart`, `campaign_event_repository.dart`, `campaigns_screen.dart` | Firestore subcollection | Analyze/test pass; contract test pass | Events now write `schoolId`; manager-only by rules. |
| Join Campaign | Partial | `campaign_participant.dart`, `participant_repository.dart` | Firestore participants | Analyze/test pass | Creates pending request using `userId`; rules aligned to this field. |
| Participant approval | Partial | `participant_repository.dart`, `campaigns_screen.dart` | Firestore participants | Analyze/test pass | Owner/organizer workflow uses `approvedAt`/`approvedBy`; rules aligned to those fields. |
| Campaign roles | Partial | `campaign_participant.dart`, `firestore.rules`, Function | Firestore + Functions | Analyze/test pass | Roles: owner, organizer, staff, participant. |
| Check-in | Partial | `check_in_repository.dart`, `check_in_models.dart`, `campaigns_screen.dart` | Cloud Function + Firestore | Flutter validator tests, contract tests, Functions core tests | Client calls `checkInEvent`; Function also exports legacy `validateEventCheckIn`; direct client check-in writes denied. |
| Location validation | Partial | `check_in_validator.dart`, `functions/src/checkInValidation.ts` | Client helper + Cloud Function | Flutter and Node tests pass | Radius/time helpers tested; end-to-end GPS/Firebase not tested. |
| Check-in history | Partial | Firestore check-in subcollection | Firestore | Function build/test pass | Function writes history records; UI does not yet show history list. |
| Security rules | Partial | `firestore.rules`, `firestore.indexes.json` | Firestore Rules | Firestore Emulator tests pass | Rules aligned to current app field names and tested locally; not deployed to a real Firebase project. |
| App Check | Partial | `pubspec.yaml`, `functions/src/index.ts` | App Check | Analyze/build pass | Dependency exists and Function can enforce via env; Flutter App Check activation and production provider are not configured. |
| Notifications | Missing | None | None | None | FCM not implemented in this task. |

## Implemented ChronoGIS app features

| Feature | Status | Files | Backend | Tests | Notes |
| --- | --- | --- | --- | --- | --- |
| App startup | Complete | `lib/main.dart` | SharedPreferences + optional Firebase bootstrap | Analyze/test pass | Missing Firebase config does not crash startup. |
| Routing | Partial | `lib/core/router/app_router.dart` | None | Analyze/test pass | Routes added for auth/login; no complex role guard. |
| Local database | Complete | `lib/core/database/app_database.dart` | Drift/SQLite | Analyze/test pass | Schema version remains 3; no Drift schema change. |
| Administrative data seed | Partial | `seed_provider.dart`, `administrative_unit_repository.dart` | Hugging Face + SQLite | Analyze/test pass | Runtime network dependency remains. |
| GeoJSON boundary cache | Partial | `province_geojson_service.dart`, `geojson_dao.dart` | Asset + SQLite | Geo validator tests | Matching can still fail for name/boundary edge cases. |
| Tourism POI seed | Partial | `tourism_repository.dart`, `overpass_api_client.dart` | Overpass + SQLite | Analyze/test pass | External API dependent. |
| School POI seed | Partial | `school_repository.dart`, `seed_provider.dart`, `school_provider.dart` | Overpass + SQLite | Analyze/test pass | Failed/incomplete seed does not mark success and preserves existing SQLite rows for retry. |
| Map display | Partial | `map_view_screen.dart` | SQLite + map tiles | Analyze/test pass | Large widget file remains. |
| Explorer | Partial | `explorer_screen.dart` | SQLite | Analyze/test pass | Existing feature preserved. |
| Schools | Partial | `schools_screen.dart` | SQLite OSM school POIs | Analyze/test pass | Not Campaign managed schools. |
| AI chat | Partial | `ai_insights_screen.dart`, `chat_provider.dart`, `groq_service.dart` | Groq + SQLite | `groq_service_test.dart` | Missing `GROQ_API_KEY` shows unconfigured state instead of crashing. |
| Routing directions | Partial | `routing_provider.dart`, `osrm_service.dart` | OSRM public API | Analyze/test pass | No retry/user-facing error detail. |
| CI | Partial | `.github/workflows/build.yml` | GitHub Actions/SonarQube | Local commands pass | Flutter/Dart commands use `working-directory: vietnam_chronogis`; hosted CI not observed. |

## Verification on 2026-07-07

| Command | Result |
| --- | --- |
| `flutter clean` | Passed. |
| `flutter pub get` | Passed. 48 packages reported newer incompatible versions. |
| `dart run build_runner build --delete-conflicting-outputs` | Passed; build_runner warned the option is now ignored and wrote generated outputs. |
| `dart format .` | Passed. |
| `dart format --output=none --set-exit-if-changed .` | Passed. |
| `flutter analyze` | Passed. No issues found. |
| `flutter test --reporter expanded` | Passed. 34 tests passed. |
| `npm install` in `functions/` | Passed, with npm audit findings and local Node v25.2.1 vs target Node 20 warning after adding emulator/rules test tooling. Latest `npm audit --audit-level=high` passed with 11 moderate findings and no high/critical findings. |
| `npm run lint` in `functions/` | Passed. |
| `npm run build` in `functions/` | Passed. |
| `npm test` in `functions/` | Passed. 14 Node tests passed. |
| `npm run test:rules:emulator` in `functions/` | Passed. 7 Firestore Rules emulator tests passed. |
