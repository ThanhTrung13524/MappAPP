# AI Agent Review Defects

Date: 2026-07-07

Audit commit: `8fd5ab1 fix(firebase): align campaign check-in contracts`

## D-001

ID: D-001
Severity: High
Requirement IDs: R01, R02, R03, R04, R05, R07, R08, R10, R11, R18
Title: Firebase features cannot be verified end-to-end because native Firebase config is missing
Evidence: No app-level `google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`, or `.firebaserc` found outside generated plugin example folders. `auth_repository.dart:67-90` implements Google Sign-In, but real Firebase app/provider setup is absent.
Affected files: Firebase platform config files; `lib/core/firebase/firebase_bootstrap.dart`, `lib/features/auth/data/auth_repository.dart`
How to reproduce: Run repository scan for app Firebase config files excluding `.dart_tool`, `build`, `ephemeral`, `node_modules`, and `.plugin_symlinks`.
Expected behavior: Real Firebase project configuration exists for target platforms, or features are explicitly marked blocked.
Actual behavior: Code exists but Google Sign-In, Firestore writes, and callable Functions cannot be verified against a real project.
Security impact: High confidence in auth/rules behavior is not possible without backend verification.
Suggested fix direction: Add official Firebase app config for approved package/bundle identifiers, enable Google provider, and run emulator/deployed backend tests.
Blocking release: Yes

## D-002

ID: D-002
Severity: High
Requirement IDs: R06
Title: `/map` route can bypass AuthGate
Evidence: `app_router.dart:11-13` defines `/auth`, `/login`, and `/map` as independent routes; `auth_gate_screen.dart:11-42` redirects only when user enters `/auth`. There is no GoRouter redirect guarding `/map`.
Affected files: `lib/core/router/app_router.dart`, `lib/features/auth/presentation/auth_gate_screen.dart`
How to reproduce: Navigate directly to `/map` instead of `/auth`.
Expected behavior: Private routes route through AuthGate or a GoRouter redirect policy.
Actual behavior: `/map` builds `AppShell` directly. Public ChronoGIS may be intentional, but requirement asks whether login can be bypassed.
Security impact: Medium to High. Campaign write actions still require auth in repositories/rules, but route-level auth policy is incomplete.
Suggested fix direction: Decide which routes are public. If Campaigns require auth, guard the Campaign tab or apply GoRouter redirect for private surfaces.
Blocking release: Yes for auth-gated product claims

## D-003

ID: D-003
Severity: High
Requirement IDs: R09, R24, R25, R37, R45, R46, R47, R49, R58
Title: Firestore Security Rules have no emulator test coverage
Evidence: `firestore.rules` exists and contains deny/allow logic, but no rules emulator test files were found. Quality gate did not run Firebase emulator tests.
Affected files: `firestore.rules`, `firestore.indexes.json`, test suite
How to reproduce: Search for Rules unit tests or emulator command; none are present.
Expected behavior: Rules tests cover role escalation, self-approval, unauthorized campaign/event updates, and denied direct check-in writes.
Actual behavior: Rules are source-inspected only.
Security impact: High. Rules cannot be marked Verified; regressions could silently allow privilege escalation or unauthorized writes.
Suggested fix direction: Add `@firebase/rules-unit-testing` tests or Firebase emulator tests for users, managed schools, campaigns, events, participants, and check-ins.
Blocking release: Yes

## D-004

ID: D-004
Severity: High
Requirement IDs: R16, R17, R19, R48
Title: Campaign/Event CRUD, validation, and update rules are incomplete
Evidence: `campaign_repository.dart:51-68` and `campaign_event_repository.dart:40-46` implement create/list streams; no edit flows or dedicated detail screens were found. `firestore.rules:104` allows campaign update for managers without field whitelist; `firestore.rules:109-111` only requires event `schoolId is string`. UI uses `DateTime.now()` defaults in `campaigns_screen.dart:302` and `campaigns_screen.dart:505` without robust validation.
Affected files: `lib/features/campaigns/*`, `lib/features/campaign_events/*`, `firestore.rules`
How to reproduce: Inspect Campaign/Event repositories/UI/rules and search for update/edit validation.
Expected behavior: Full create/list/detail/edit flows with field-level update restrictions and date/window validation.
Actual behavior: Create/list exists; edit/detail and validation are partial; rules update restrictions are broad.
Security impact: High. A campaign manager could alter sensitive fields unless rules constrain allowed changes.
Suggested fix direction: Add explicit edit workflows, validators, and rules `affectedKeys().hasOnly(...)` plus immutable owner/created fields and valid date/window checks.
Blocking release: Yes

## D-005

ID: D-005
Severity: High
Requirement IDs: R50, R51
Title: Campaign Events are not integrated into the map
Evidence: `map_view_screen.dart:73-81` builds tile, province polygon, tourism, school, route layers. `map_layers.dart` contains tourism, school, and routing markers only. Campaign/Event code lives in `CampaignsScreen`, not map layers.
Affected files: `lib/features/map/*`, `lib/features/campaigns/presentation/campaigns_screen.dart`
How to reproduce: Search map module for Campaign/Event providers or markers.
Expected behavior: Event markers on map with status semantics and accessible differentiation.
Actual behavior: No event marker layer or map detail panel exists.
Security impact: Low direct security impact, high product requirement gap.
Suggested fix direction: Add an event marker layer fed by a scoped provider, status model, accessible marker symbols, and detail/check-in panel.
Blocking release: Yes for requested map-based check-in UX

## D-006

ID: D-006
Severity: High
Requirement IDs: R26-R44, R56, R57
Title: Check-in security tests do not cover callable backend edge cases
Evidence: `functions/src/checkInValidation.test.ts` covers pure coordinate/radius/time helpers only. No callable tests cover unauthenticated request, pending/rejected participant, invalid role, event closed, low accuracy, duplicate check-in, concurrent requests, fake client radius/role/timestamp, or direct Firestore write denial.
Affected files: `functions/src/index.ts`, `functions/src/checkInValidation.test.ts`, `test/check_in_validator_test.dart`
How to reproduce: Run `npm test`; only 3 pure helper tests execute.
Expected behavior: Callable or emulator tests exercise transaction and authorization behavior.
Actual behavior: Source is strong, but backend behavior is not tested end-to-end.
Security impact: High. Server-authoritative claims are not fully Verified.
Suggested fix direction: Add callable emulator tests with seeded Firestore docs and duplicate/concurrent scenarios.
Blocking release: Yes

## D-007

ID: D-007
Severity: Medium
Requirement IDs: R33, R52
Title: Check-in UI and error/result states are underdeveloped
Evidence: `_EventTile` calls `checkInActionProvider.notifier.checkIn(...)` from `campaigns_screen.dart:544-550`, but the UI does not render success distance, server check-in time, GPS status, permission status, or friendly mapped error states. `check_in_repository.dart:23-42` throws `StateError`/platform errors rather than domain-specific failures.
Affected files: `lib/features/campaigns/presentation/campaigns_screen.dart`, `lib/features/check_in/data/check_in_repository.dart`
How to reproduce: Inspect `_EventTile` and `CheckInActionNotifier`.
Expected behavior: Loading/success/friendly error states with distance, window, participant status, and retry.
Actual behavior: Button exists; detailed state UX is partial.
Security impact: Low direct security impact, medium product reliability impact.
Suggested fix direction: Add typed check-in failure model and UI panel/banner for GPS/permission/server responses.
Blocking release: No, but blocks demo-quality UX

## D-008

ID: D-008
Severity: Medium
Requirement IDs: R54
Title: Map performance has no runtime proof
Evidence: `docs/performance/MAP_BASELINE.md` states profile runs did not launch; `MAP_AFTER_OPTIMIZATION.md` reports source/static deltas but no frame/memory metrics. Current audit did not run DevTools/profile.
Affected files: `docs/performance/MAP_BASELINE.md`, `docs/performance/MAP_AFTER_OPTIMIZATION.md`, `lib/features/map/*`
How to reproduce: Read performance docs; runtime metrics are explicitly blocked.
Expected behavior: Before/after DevTools frame, rebuild, and memory evidence.
Actual behavior: Static source improvements exist, runtime smoothness is unverified.
Security impact: None.
Suggested fix direction: Fix local profile blockers and capture Windows/Android profile data.
Blocking release: No, but blocks performance claims

## D-009

ID: D-009
Severity: Medium
Requirement IDs: R03, R59
Title: Platform identifiers and release signing remain sample/development values
Evidence: Android `applicationId = "com.example.map_application1"` in `android/app/build.gradle.kts:19`; iOS bundle identifier `com.example.mapApplication1` in `ios/Runner.xcodeproj/project.pbxproj`; release signing uses debug signing at `android/app/build.gradle.kts:37-38`.
Affected files: `android/app/build.gradle.kts`, `ios/Runner.xcodeproj/project.pbxproj`, `macos/Runner/Configs/AppInfo.xcconfig`
How to reproduce: Search for `com.example` and `signingConfig`.
Expected behavior: Official identifiers and release signing configured outside source-controlled secrets.
Actual behavior: Sample identifiers and debug signing remain.
Security impact: Medium for release/staging readiness; blocks correct Firebase app registration.
Suggested fix direction: Choose official identifiers before Firebase config; configure release signing via secure CI/user environment.
Blocking release: Yes for staging/production

