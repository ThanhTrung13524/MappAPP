# Known Issues

## ISSUE-001

ID: ISSUE-001  
Severity: High  
Title: Firebase project config is not committed or configured  
Evidence: No `google-services.json`, `GoogleService-Info.plist`, generated `firebase_options.dart`, or `.firebaserc` is present. `flutter analyze` and `flutter test` pass because Firebase bootstrap handles missing config as `notConfigured`.  
Affected files: Firebase platform config files are absent; `lib/core/firebase/firebase_bootstrap.dart` handles this state.  
Impact: Auth, Firestore, Functions, and App Check cannot run end-to-end until a real Firebase project is configured.  
Suggested direction: Choose official app identifiers, create Firebase apps, add real client config files, and enable Google sign-in.

## ISSUE-002

ID: ISSUE-002  
Severity: Medium  
Title: Firestore rules are authored but not emulator-tested  
Evidence: `firestore.rules` exists, but Firebase CLI is unavailable. `firebase --version` failed and `npx firebase-tools@latest --version` timed out after 5 minutes on 2026-06-24.  
Affected files: `firestore.rules`, `firestore.indexes.json`  
Impact: Syntax/authorization behavior has not been verified by emulator tests.  
Suggested direction: Install Firebase CLI or add rules-unit-testing setup, then test user/admin/participant/check-in denial paths.

## ISSUE-003

ID: ISSUE-003  
Severity: Resolved  
Title: CI workflow runs Flutter commands from the Flutter project subdirectory  
Evidence: `.github/workflows/build.yml` uses `working-directory: vietnam_chronogis` for `flutter pub get`, `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test`. Local verification on 2026-06-24 passed format/analyze/test.  
Affected files: `.github/workflows/build.yml`  
Impact: Resolved for Flutter command steps.  
Suggested direction: Watch the next hosted GitHub Actions run.

## ISSUE-004

ID: ISSUE-004  
Severity: High  
Title: Android and Apple identifiers are still sample values  
Evidence: Android package id `com.example.map_application1`; iOS bundle id `com.example.mapApplication1`.  
Affected files: `android/app/build.gradle.kts`, `ios/Runner.xcodeproj/project.pbxproj`, `macos/Runner/Configs/AppInfo.xcconfig`  
Impact: Firebase app registration and production release should not use these identifiers.  
Suggested direction: Choose production identifiers before final Firebase setup.

## ISSUE-005

ID: ISSUE-005  
Severity: High  
Title: Android release build uses debug signing config  
Evidence: `android/app/build.gradle.kts` still uses the debug signing config for release.  
Affected files: `android/app/build.gradle.kts`  
Impact: Release artifacts are not production-signed.  
Suggested direction: Configure release signing outside source control.

## ISSUE-006

ID: ISSUE-006  
Severity: Resolved  
Title: Formatter check passes after Dart formatting cleanup  
Evidence: `dart format --output=none --set-exit-if-changed .` passed on 2026-06-24 after running `dart format .`.  
Affected files: Multiple Dart files.  
Impact: Resolved locally; CI includes the same format check.  
Suggested direction: Keep the formatting-only changes visible in review notes.

## ISSUE-007

ID: ISSUE-007  
Severity: Medium  
Title: `MapViewScreen` is too large and mixes UI with data/business logic  
Evidence: `lib/features/map/presentation/map_view_screen.dart` remains a large widget file with geometry/heatmap/provider logic.  
Affected files: `lib/features/map/presentation/map_view_screen.dart`  
Impact: Hard to test and maintain.  
Suggested direction: Move calculation/providers into dedicated files in a separate refactor.

## ISSUE-008

ID: ISSUE-008  
Severity: Medium  
Title: Several local searches load rows into memory before filtering  
Evidence: Existing DAO search methods still filter in Dart after loading rows.  
Affected files: `administrative_unit_dao.dart`, `tourism_dao.dart`, `school_dao.dart`  
Impact: Search may degrade as local data grows.  
Suggested direction: Add SQLite indexes, normalized search columns, or FTS.

## ISSUE-009

ID: ISSUE-009  
Severity: Resolved  
Title: School seed failure no longer marks the seed as successful  
Evidence: `seed_provider.dart` keeps `seeded_schools_v1 = false` on failure/zero persisted schools, and `school_repository.dart` throws on incomplete all-cell failures while preserving already-upserted SQLite rows. `flutter analyze` and `flutter test` passed on 2026-06-24.  
Affected files: `lib/shared/providers/seed_provider.dart`, `lib/data/repositories/school_repository.dart`  
Impact: Failed/incomplete school POI seed can retry later.  
Suggested direction: Add fake Overpass repository tests for partial-cell failure and retry behavior.

## ISSUE-010

ID: ISSUE-010  
Severity: Resolved  
Title: AI chat handles missing `GROQ_API_KEY` without crashing  
Evidence: Missing key path is represented as unconfigured and covered by `test/groq_service_test.dart`; `flutter test` passed on 2026-06-24.  
Affected files: `groq_service.dart`, `chat_provider.dart`, `ai_insights_screen.dart`, `chat_input_bar.dart`, `test/groq_service_test.dart`  
Impact: App and AI tab remain usable without a committed/runtime Groq key.  
Suggested direction: Add widget test for the unconfigured AI banner.

## ISSUE-011

ID: ISSUE-011  
Severity: Medium  
Title: Firebase end-to-end flows are not verified against a real backend  
Evidence: Flutter tests and Functions tests pass locally, but no Firebase config/project is present.  
Affected files: `features/auth`, `features/campaigns`, `features/check_in`, `functions/`  
Impact: Google sign-in, Firestore writes, callable check-in, and rules behavior may need adjustments once connected to a real Firebase project.  
Suggested direction: Configure Firebase project and run emulator/integration tests before release.

## ISSUE-012

ID: ISSUE-012  
Severity: Low  
Title: Source contains mojibake/encoding artifacts in comments and UI strings  
Evidence: Several existing comments/UI strings show garbled Vietnamese text.  
Affected files: Multiple Dart/Markdown files.  
Impact: User-facing Vietnamese may render incorrectly.  
Suggested direction: Normalize encodings/content in a separate cleanup.

## ISSUE-013

ID: ISSUE-013  
Severity: Medium  
Title: Functions dependency tree has npm audit findings  
Evidence: `npm install` in `functions/` passed but reported 8 moderate vulnerabilities on 2026-06-24.  
Affected files: `functions/package-lock.json`, `functions/package.json`  
Impact: Dependency risk should be reviewed before deployment.  
Suggested direction: Run `npm audit`, review fixes, and avoid breaking Firebase Functions compatibility.
