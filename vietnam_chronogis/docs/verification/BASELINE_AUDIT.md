# Baseline Audit

Date: 2026-06-24  
Auditor: Independent Flutter Repository Auditor  
Repository root: `C:\Users\USER\OneDrive\Documents\GitHub\MappAPP`  
Flutter project directory: `C:\Users\USER\OneDrive\Documents\GitHub\MappAPP\vietnam_chronogis`  
Branch: `main`  
Rollback baseline commit: `7c88d5d Update GitHub Actions workflow for build process`

## Scope

This audit records the real repository state before the next development phase. Source code was not intentionally edited in this prompt. The only planned file artifact from this prompt is this verification document.

The working tree was already dirty before baseline commands ran. `dart run build_runner build` was executed because the project uses code generation; it touched generated Dart outputs and caused additional generated files to appear as modified in `git status`, although sampled `git diff` output for generated files showed no content diff beyond line-ending warnings.

## Environment

| Item | Evidence |
| --- | --- |
| Flutter project directory | `C:\Users\USER\OneDrive\Documents\GitHub\MappAPP\vietnam_chronogis\pubspec.yaml` |
| Flutter SDK | `Flutter 3.44.0 stable`, revision `559ffa3f75`, DevTools `2.57.0` |
| Dart SDK | `Dart 3.12.0 stable`, `windows_x64` |
| Connected build targets | Windows desktop, Chrome web, Edge web |
| Android package/application id | `com.example.map_application1` in `android/app/build.gradle.kts` |
| iOS bundle identifier | `com.example.mapApplication1` in `ios/Runner.xcodeproj/project.pbxproj` |
| macOS bundle identifier | `com.example.mapApplication1` in `macos/Runner/Configs/AppInfo.xcconfig` |
| Latest commit | `7c88d5d Update GitHub Actions workflow for build process` |

## Git Baseline

| Command | Exit code | Result |
| --- | ---: | --- |
| `git status --short --branch --untracked-files=all` | 0 | Branch `main...origin/main`; many modified and untracked files. |
| `git branch --show-current` | 0 | `main` |
| `git log --oneline -15` | 0 | 3 commits visible; latest `7c88d5d`. |
| `git diff --stat` | 0 | 55 tracked files, `1330 insertions(+)`, `1032 deletions(-)`; untracked files not included. |
| `git diff` | 0 | Large diff inspected; includes CI, Firebase deps, seed/AI safety, map refactor/search work. Output was too large to quote in full here. |

Modified tracked files include `.github/workflows/build.yml`, `vietnam_chronogis/pubspec.yaml`, `vietnam_chronogis/pubspec.lock`, Android/iOS permission files, many Dart source files, platform generated plugin registrants, and after `build_runner`, several tracked `.g.dart`/`.freezed.dart` generated files are marked modified.

Untracked files include `docs/ai-context/*`, `docs/performance/*`, Firebase config scaffolding (`firebase.json`, `firestore.rules`, `firestore.indexes.json`), Cloud Functions source/package files, Firebase/Auth/Campaign/Event/Participant/Check-in Dart modules, map provider/widget extraction files, and new tests.

Secret scan evidence:

- `rg` for Firebase config files found no `google-services.json`, no `GoogleService-Info.plist`, no `firebase_options.dart`, and no `.firebaserc`.
- Diff/content scan found only placeholder/reference strings such as `GROQ_API_KEY`, `dart_defines.example.json`, and `${{ secrets.SONAR_TOKEN }}`. No real API key, private key, client secret, password, or credential value was found in the inspected diff.

## Baseline Commands

| Working directory | Command | Exit code | Result |
| --- | --- | ---: | --- |
| `vietnam_chronogis` | `flutter clean` | 0 | Deleted `build`, `.dart_tool`, ephemeral Flutter files, generated xcconfig/export files. |
| `vietnam_chronogis` | `flutter pub get` | 0 | Dependencies resolved. 40 packages have newer incompatible versions. |
| `vietnam_chronogis` | `dart format --output=none --set-exit-if-changed .` | 0 | `Formatted 115 files (0 changed)`. |
| `vietnam_chronogis` | `flutter analyze` | 0 | `No issues found!` |
| `vietnam_chronogis` | `flutter test --reporter expanded` | 0 | 17 passed, 0 failed, 0 skipped. |
| `vietnam_chronogis` | `dart run build_runner build --delete-conflicting-outputs` | 0 | Built successfully; warning: `--delete-conflicting-outputs` removed/ignored; wrote 222 outputs. |
| `vietnam_chronogis` | `flutter analyze` | 0 | `No issues found!` after code generation. |
| `vietnam_chronogis` | `flutter test --reporter expanded` | 0 | 17 passed, 0 failed, 0 skipped after code generation. |
| `vietnam_chronogis` | `dart format --output=none --set-exit-if-changed .` | 0 | `Formatted 115 files (0 changed)` after code generation. |
| `vietnam_chronogis/functions` | `npm install` | 0 | Up to date; 8 moderate vulnerabilities; local Node `v25.2.1` does not satisfy Functions engine `node: 20`. |
| `vietnam_chronogis/functions` | `npm run lint` | 0 | `tsc --noEmit` passed. |
| `vietnam_chronogis/functions` | `npm run build` | 0 | `tsc` passed. |
| `vietnam_chronogis/functions` | `npm test` | 0 | 3 passed, 0 failed, 0 skipped. |

Flutter tests observed:

- `test/check_in_validator_test.dart`: 6 passed.
- `test/dao_search_test.dart`: 4 passed.
- `test/groq_service_test.dart`: 1 passed.
- `test/overpass_client_test.dart`: 1 passed.
- `test/vietnam_geo_validator_test.dart`: 5 passed.

Functions tests observed:

- `functions/src/checkInValidation.test.ts`: 3 passed after TypeScript build.

## Requirement Matrix

| Requirement | Status | Source evidence | Test evidence | Risk |
| --- | --- | --- | --- | --- |
| ChronoGIS current app | Verified | `main.dart`, `app_router.dart`, `AppShell`, Drift database, map/explorer/schools/AI providers preserve ChronoGIS flow. | `flutter analyze` pass; `flutter test` 17 passed. | Runtime seed/network/map tile behavior not integration-tested. |
| Firebase initialization | Partial | `firebase_bootstrap.dart` calls `Firebase.initializeApp()` and returns recoverable `notConfigured`; no Firebase config files present. | Analyze/test pass; no real Firebase app smoke test. | Firebase-dependent features cannot run end-to-end yet. |
| Authentication | Partial | `auth_repository.dart`, `auth_gate_screen.dart`, `login_screen.dart` implement Google sign-in/logout and profile creation. | Analyze/test pass only. | No real Google provider/config test; platform support may vary. |
| User profile | Partial | `AppUserProfile` and `ensureUserProfile()` write `users/{uid}`. | Analyze/test pass only. | Firestore rules/profile paths not emulator-tested. |
| Managed School | Partial | `managed_school_repository.dart` writes Firestore `managed_schools`; distinct from SQLite `schools`. | Analyze/test pass only. | Field mismatch: app writes `active` bool, Function checks `school.status == "active"`. Check-in likely fails for app-created schools. |
| Campaign | Partial | `campaign.dart`, `campaign_repository.dart`, `campaigns_screen.dart` create/list campaigns. | Analyze/test pass only. | Firestore rules create requires `status == draft`, app creates `published`; real create may be denied. |
| Campaign Event | Partial | `campaign_event.dart`, repository, and UI create event subdocuments. | Analyze/test pass only. | No end-to-end Firestore/rules test. |
| Participant | Partial | Participant model/repository can join and approve/reject. | Analyze/test pass only. | Rules expect some field names differing from repository data in places; emulator tests missing. |
| Campaign role | Partial | Roles exist in Dart and Function (`owner`, `organizer`, `staff`, `participant`). | Analyze/test pass only. | Authorization behavior not verified against rules. |
| Check-in | Broken | Client calls callable `validateEventCheckIn`; Function writes check-in transaction. Managed school active/status mismatch blocks realistic app-created check-ins. | Dart validator tests pass; Functions helper tests pass. No callable integration test. | High: feature compiles but may fail at runtime. |
| Cloud Functions | Verified | `functions/src/index.ts`, `checkInValidation.ts`, `package.json`. | `npm run lint`, `npm run build`, `npm test` pass; 3 Node tests pass. | Not deployed; Node local version mismatch and npm audit findings remain. |
| Firestore Rules | Partial | `firestore.rules` denies direct client check-in writes and defines auth/admin/campaign manager rules. | No emulator test. | High: rules may deny current app writes due field/status mismatches. |
| App Check | Partial | `firebase_app_check` dependency; debug activation attempted; Function `enforceAppCheck` can depend on env var. | Analyze/build pass only. | No production provider or enforcement validation. |
| Map UX | Partial | `MapViewScreen`, extracted map layers/providers, `flutter_map`. | Analyze/test pass; no screenshot/profile UX check. | Runtime UI quality and mobile layout not verified in this audit. |
| Map performance | Partial | SQL filtering tests and extracted providers/widgets exist; performance docs record static deltas. | DAO tests pass. | Runtime frame/memory profiling not measured; Windows profile blocked previously by CMake. |
| Tests | Partial | Unit tests exist for validators, DAO search, Groq missing key, Overpass client smoke, geo validator. No `integration_test` directory. | Flutter 17 passed; Functions 3 passed. | No widget, integration, Firebase emulator, or E2E route tests. |
| CI/CD | Partial | `.github/workflows/build.yml` uses `working-directory: vietnam_chronogis` for pub get/format/analyze/test; Sonar token is referenced via GitHub secret. | Local equivalent commands pass. | Hosted CI not observed; Functions commands not included in workflow. |
| Secret management | Verified | No real Firebase config files; `dart_defines.example.json` is placeholder; diff scan found no real secrets. | Static scan only. | Need keep real Firebase/Groq config out of source or use approved secret handling. |

## Current Phase Assessment

Prior agent work appears to have implemented:

- Phase 0 stabilization: CI working-directory, formatting, school seed retry safety, missing Groq key safety.
- Phase 1 Firebase foundation: dependencies, optional bootstrap, Auth skeleton, Firestore models/repositories, Campaign/Event/Participant UI, callable Function, Firestore rules.
- Phase 3 map performance first pass: DAO SQL filtering tests, marker query narrowing, `MapViewScreen` extraction, performance docs.

Skeleton or partial areas:

- Real Firebase configuration and project binding.
- Auth/Google sign-in end-to-end.
- Firestore rules correctness against actual app writes.
- Campaign/Event/Participant admin UX beyond a basic combined screen.
- Check-in history UI.
- App Check production setup.
- CI for Functions.

Compile-pass but not proven operational:

- Firebase Auth/Firestore repositories.
- Campaign/Event/Participant workflows.
- Callable check-in.
- Firestore rules.
- App Check.
- Map performance improvements beyond static/source-level evidence.

Untested areas:

- Firebase emulator rules.
- Real Firebase staging deployment.
- Widget/UI tests for `/seed`, `/map`, Explorer, Schools, AI, Campaigns.
- Integration tests.
- Real GPS/location permission flows.
- Hosted GitHub Actions run.
- Android/iOS physical builds.

## Critical and High Defects

| Severity | Defect | Evidence | Impact |
| --- | --- | --- | --- |
| Critical | Check-in Function expects `managed_schools.status == "active"` while app-created managed schools store `active: true`. | `managed_school.dart` writes `active`; `functions/src/index.ts` checks `school.status`. | App-created schools are likely rejected as inactive during check-in. |
| High | Campaign create path likely conflicts with Firestore rules. | `campaign_repository.dart` creates `status: published`; `firestore.rules` allows campaign create only when `status == 'draft'`. | Real campaign creation may be denied. |
| High | Working tree is heavily dirty on `main`. | `git status` shows many modified/untracked files. | Hard to isolate baseline, review, rollback, and phase ownership. |
| High | Firebase config absent. | No `google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`, `.firebaserc`. | Firebase features cannot run end-to-end. |
| High | Firestore rules not emulator-tested. | No rules test command executed; no rules test files found. | Authorization may be wrong despite compile passing. |
| High | Android/iOS/macOS identifiers are still sample values. | `com.example.map_application1`, `com.example.mapApplication1`. | Blocks correct production Firebase app registration/release identity. |

## Recommended Next Branch

Use a dedicated branch before making fixes, for example:

`codex/baseline-firebase-hardening`

Do not continue feature work directly on dirty `main` without first deciding which uncommitted changes belong together.

## Next Task Recommendation

Stabilize Firebase data contract mismatches before adding new features:

1. Align managed school active/status schema across Flutter model, Firestore rules, and Function.
2. Align campaign create status with Firestore rules.
3. Add Firebase emulator/rules tests for users, managed schools, campaigns, participants, and denied direct check-in writes.
4. Add callable check-in integration test or emulator smoke path.
5. Only after those pass, proceed to real Firebase config/staging deployment.
