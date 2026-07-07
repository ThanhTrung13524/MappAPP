# Requirement Traceability Matrix

Date: 2026-07-07

Audit commit: `8fd5ab1 fix(firebase): align campaign check-in contracts`

Working directory: `C:\Users\USER\OneDrive\Documents\GitHub\MappAPP\vietnam_chronogis`

Status values: `Verified`, `Implemented`, `Partial`, `Failed`, `Missing`, `Blocked`.

## Command Evidence

| Command | Working directory | Exit code | Result | Evidence |
| ------- | ----------------- | --------: | ------ | -------- |
| `git status` | repo root | 0 | Passed | On branch `lab3`, working tree clean before audit docs. |
| `git branch --show-current` | repo root | 0 | Passed | `lab3`. |
| `git log --oneline --decorate -30` | repo root | 0 | Passed | HEAD `8fd5ab1`, tags `checkpoint-firebase-campaign-contracts`, `checkpoint-phase-01`. |
| `git tag --list "checkpoint-*"` | repo root | 0 | Passed | `checkpoint-firebase-campaign-contracts`, `checkpoint-phase-01`. |
| `git diff --stat` | repo root | 0 | Passed | Empty before audit docs. |
| `git diff` | repo root | 0 | Passed | Empty before audit docs. |
| `flutter clean` | `vietnam_chronogis` | 0 | Passed | Deleted build artifacts. |
| `flutter pub get` | `vietnam_chronogis` | 0 | Passed with warning | 48 packages have newer incompatible versions. |
| `dart format --output=none --set-exit-if-changed .` | `vietnam_chronogis` | 0 | Passed | Formatted 118 files, 0 changed. |
| `flutter analyze` | `vietnam_chronogis` | 0 | Passed | No issues found. |
| `flutter test --reporter expanded` | `vietnam_chronogis` | 0 | Passed | 34 tests passed. |
| `dart run build_runner build --delete-conflicting-outputs` | `vietnam_chronogis` | 0 | Passed with warning | Current build_runner ignored removed option; wrote 228 outputs. |
| `flutter analyze` after codegen | `vietnam_chronogis` | 0 | Passed | No issues found. |
| `flutter test --reporter expanded` after codegen | `vietnam_chronogis` | 0 | Passed | 34 tests passed. |
| `npm install` | `vietnam_chronogis/functions` | 0 | Passed with warnings | Node local `v25.2.1` vs required Node 20; 9 moderate vulnerabilities. |
| `npm run lint` | `vietnam_chronogis/functions` | 0 | Passed | `tsc --noEmit`. |
| `npm run build` | `vietnam_chronogis/functions` | 0 | Passed | `tsc`. |
| `npm test` | `vietnam_chronogis/functions` | 0 | Passed | 3 Node tests passed. |

## Matrix

| ID | Requirement | Status | Source evidence | Test evidence | Manual test required | Defect ID | Notes |
| -- | ----------- | ------ | --------------- | ------------- | -------------------- | --------- | ----- |
| R01 | Firebase initialization exists. | Implemented | `lib/core/firebase/firebase_bootstrap.dart:59`, `lib/main.dart:34` | `flutter analyze`; `auth_flow_test` missing-config tests | Yes, with real config | D-001 | Optional bootstrap handles missing config. |
| R02 | User login with Firebase Authentication exists. | Implemented | `auth_repository.dart:67-90`, `login_screen.dart` | `auth_flow_test.dart:37-67` | Yes | D-001 | Real login blocked by missing native Firebase config. |
| R03 | Google Sign-In or configured login method exists. | Blocked | `auth_repository.dart:70`, `auth_repository.dart:84` | Auth unit tests use fakes only | Yes | D-001 | No app `google-services.json`, `GoogleService-Info.plist`, or `firebase_options.dart`. |
| R04 | Logout exists. | Implemented | `auth_repository.dart:95-101`, `login_screen.dart` | `auth_flow_test.dart:72-81` | Yes | D-001 | Real provider sign-out not tested. |
| R05 | Auth state persistence exists. | Implemented | `auth_repository.dart:48-55` uses `FirebaseAuth.authStateChanges()` | `auth_flow_test.dart:11-34` | Yes | D-001 | Firebase SDK persistence not E2E-tested. |
| R06 | Route guard/AuthGate exists. | Partial | `auth_gate_screen.dart:11-42`; `app_router.dart:11-13` | `auth_flow_test.dart:84-115` | Yes | D-002 | `/map` route is directly reachable and not guarded by router redirect. |
| R07 | Firestore user profile exists. | Implemented | `app_user_profile.dart`, `auth_repository.dart:105-130` | `auth_flow_test.dart:119-150` | Yes | D-001 | Uses Firestore `users/{uid}`. |
| R08 | New user document is created correctly. | Implemented | `auth_repository.dart:105-130` | `auth_flow_test.dart:136-150` | Yes | D-001 | Uses server timestamps and default user role. |
| R09 | User cannot self-upgrade global role to admin. | Implemented | `app_user_profile.dart:64`; `firestore.rules:79-83` | `auth_flow_test.dart:136-150` | Emulator test required | D-003 | Rules not emulator-tested. |
| R10 | Firebase-managed event school data exists. | Implemented | `managed_school.dart`, `managed_school_repository.dart` | `firebase_campaign_contract_test.dart:8-44` | Yes | D-001 | Distinct from local SQLite schools. |
| R11 | Event school has name, address, coordinate, radius. | Implemented | `managed_school.dart:16-23`, `managed_school.dart:61-63` | `firebase_campaign_contract_test.dart:8-44` | Yes | D-001 | Coordinate stored as GeoPoint. |
| R12 | Managed school is not confused with OSM/local school. | Implemented | `FirestorePaths.managedSchools`, `Schools` Drift table, `CampaignsScreen` imports managed school module | Source inspection | Yes | None | Separation is clear in source. |
| R13 | Campaign exists. | Implemented | `campaign.dart`, `campaign_repository.dart` | `flutter analyze`; no campaign repo integration test | Yes | D-004 | CRUD incomplete. |
| R14 | Campaign has many Campaign Events. | Implemented | `FirestorePaths.campaignEvents`, `campaignEventRepository.watchEvents()` | `firebase_campaign_contract_test.dart:47-72` | Yes | D-004 | Uses `campaigns/{id}/events`. |
| R15 | Campaign Event is not confused with HistoricalEvent. | Implemented | `campaign_event.dart`; `historical_events_table.dart` | Source inspection | Yes | None | Separate Firebase vs Drift domains. |
| R16 | Create/list/detail/edit Campaign. | Partial | Create/list: `campaign_repository.dart:30-68`; UI card in `campaigns_screen.dart` | No edit/detail tests | Yes | D-004 | No real edit workflow or dedicated detail screen found. |
| R17 | Create/list/detail/edit Event. | Partial | Create/list: `campaign_event_repository.dart:26-46`; `_EventForm` in `campaigns_screen.dart` | Contract test only serialization | Yes | D-004 | No real edit workflow or dedicated detail screen found. |
| R18 | Event references correct managed school. | Implemented | `campaign_event.dart:25`, `campaigns_screen.dart:398`, `functions/src/index.ts:195-199` | `firebase_campaign_contract_test.dart:47-72` | Yes | D-001 | Function falls back to campaign school for legacy docs. |
| R19 | Campaign/Event time validation exists. | Partial | Function validates check-in window: `index.ts:189-192` | Time helper tests only | Yes | D-004 | UI/repository/rules do not validate campaign/event date ordering robustly. |
| R20 | Join Campaign exists. | Implemented | `participant_repository.dart:63-80`, UI `campaigns_screen.dart:442-455` | No repository/rules integration test | Yes | D-003 | Source creates pending participant. |
| R21 | Participant status exists. | Implemented | `campaign_participant.dart:5`, `participant_repository.dart:92` | Source inspection | Yes | D-003 | Pending/approved/rejected/cancelled. |
| R22 | Participant role exists. | Implemented | `campaign_participant.dart:3`, `participant_repository.dart:93` | Source inspection | Yes | D-003 | Owner/organizer/staff/participant. |
| R23 | Approve/reject participant exists. | Implemented | `participant_repository.dart:124-160`, UI `campaigns_screen.dart:586-602` | No rules/repository test | Yes | D-003 | Manager-only depends on rules. |
| R24 | User cannot self-approve. | Implemented | `firestore.rules:118-122` requires `isCampaignManager`; normal join is pending | No emulator test | Emulator required | D-003 | Owner bootstrap is intentionally allowed. |
| R25 | User cannot self-upgrade campaign role. | Implemented | `firestore.rules:116-122` | No emulator test | Emulator required | D-003 | Update allowed only to campaign managers. |
| R26 | Event check-in exists. | Implemented | `check_in_repository.dart:19-54`, `functions/src/index.ts:106-254` | `check_in_validator_test.dart`; function helper tests | Yes | D-006 | Full callable not unit/integration tested. |
| R27 | Check-in requires login. | Implemented | Client `check_in_repository.dart:73`; Function `index.ts:112-115` | Source + no direct callable test | Emulator/device test required | D-006 | Backend enforces auth context. |
| R28 | Check-in requires approved participant. | Implemented | `index.ts:180-182` | No callable test | Emulator required | D-006 | Source-only evidence. |
| R29 | Check-in validates role. | Implemented | `index.ts:184-186` | No callable test | Emulator required | D-006 | Backend reads role from Firestore. |
| R30 | Check-in validates event/check-in window. | Implemented | `index.ts:189-192`; `checkInValidation.ts:52-58` | `checkInValidation.test.ts:26-38` | Emulator required | D-006 | Uses server-side `Date.now()` and Firestore timestamps. |
| R31 | Check-in checks GPS service. | Implemented | `check_in_repository.dart:23-26` | No geolocator test | Device/manual required | D-006 | Throws `StateError`. |
| R32 | Check-in checks location permission. | Implemented | `check_in_repository.dart:28-35` | No geolocator test | Device/manual required | D-006 | Handles denied and deniedForever. |
| R33 | Check-in handles denied/denied forever/timeout. | Partial | `check_in_repository.dart:28-42` | No timeout/permission tests | Device/manual required | D-006 | Timeout exception is not mapped to a friendly domain result. |
| R34 | Check-in checks GPS accuracy. | Implemented | Client sends accuracy `check_in_models.dart:14-22`; backend validates `index.ts:127-131` | No callable test | Device/emulator required | D-006 | Threshold hard-coded at 100m. |
| R35 | Check-in checks user inside school radius. | Implemented | `index.ts:217-220`; `checkInValidation.ts:36-50` | `check_in_validator_test.dart:30-59`; `checkInValidation.test.ts:26-34` | Emulator required | D-006 | Haversine tested, callable path not. |
| R36 | School coordinates/radius read from Firestore. | Implemented | `index.ts:199-215` | Contract tests for write shape only | Emulator required | D-006 | Reads event radius or school fallback. |
| R37 | Client cannot write direct check-in to Firestore. | Implemented | `firestore.rules:126-128`; client calls Function | No rules test | Emulator required | D-003 | Source rules deny writes. |
| R38 | Check-in verified through Cloud Function/backend. | Implemented | `check_in_repository.dart:52-53`; `functions/src/index.ts` | Function helper tests only | Deploy/emulator required | D-006 | Callable itself not tested. |
| R39 | Backend reads Campaign/Event/Participant/School/Check-in. | Implemented | `index.ts:134-149`, `index.ts:199-201` | No callable test | Emulator required | D-006 | Uses transaction reads. |
| R40 | Backend does not trust client role/radius/distance/timestamp. | Implemented | Payload only IDs/location/accuracy: `check_in_models.dart:16-24`; backend derives fields | No fake-client tests | Emulator required | D-006 | Source appears correct. |
| R41 | Backend calculates Haversine. | Implemented | `checkInValidation.ts:17-34`, `index.ts:217` | `checkInValidation.test.ts:16-24` | No | D-006 | Pure helper covered. |
| R42 | Backend uses server timestamp. | Implemented | `index.ts:222-236` | No callable test | Emulator required | D-006 | Uses `FieldValue.serverTimestamp()`. |
| R43 | Backend uses transaction against duplicate/race. | Implemented | `index.ts:139-151`, `index.ts:165`, `index.ts:223` | No concurrent test | Emulator required | D-006 | Source transaction exists, race not tested. |
| R44 | Each user only checks in once per Event. | Implemented | `checkInRef = ...doc(uid)` and exists check `index.ts:137`, `index.ts:165` | No duplicate test | Emulator required | D-006 | Source-only proof. |
| R45 | Firestore Security Rules exist. | Implemented | `firestore.rules` | No emulator tests | Emulator required | D-003 | Cannot be Verified. |
| R46 | Rules block global role upgrade. | Implemented | `firestore.rules:79-83` | No emulator test | Emulator required | D-003 | Field equality enforced. |
| R47 | Rules block self-approval. | Implemented | `firestore.rules:116-122` | No emulator test | Emulator required | D-003 | Depends on `isCampaignManager`. |
| R48 | Rules block unauthorized Campaign/Event edit. | Partial | `firestore.rules:104`, `firestore.rules:109-111` | No emulator test | Emulator required | D-004 | Manager-only exists, but update field whitelist is weak/missing. |
| R49 | Rules block direct check-in write. | Implemented | `firestore.rules:126-128` | No emulator test | Emulator required | D-003 | Source denies create/update/delete. |
| R50 | Event integrated on map. | Missing | `map_view_screen.dart` layers include tourism/schools/routes, no campaign/event layer | No test | Manual required | D-005 | Campaigns live in separate tab only. |
| R51 | Event marker has clear status. | Missing | No event marker source found in map module | No test | Manual required | D-005 | No upcoming/active/checked-in marker UX. |
| R52 | Check-in UI shows reasonable state. | Partial | Button in `_EventTile`; action state watched but result not displayed | No widget/manual test | Manual required | D-007 | No distance/server time/friendly error panel. |
| R53 | Map UX does not break old ChronoGIS functions. | Implemented | Existing map layers remain in `map_view_screen.dart` and `map_layers.dart` | `flutter test` 34 pass | Manual map run required | None | No runtime manual test in this audit. |
| R54 | Map not obviously laggy due to Event/Check-in. | Blocked | Event not integrated into map; perf docs lack runtime metrics | Tests pass only | Runtime profile required | D-008 | Cannot conclude without DevTools/profile. |
| R55 | Legacy features do not regress. | Implemented | Drift/map/school/tourism/AI/routing source present | `flutter analyze`; `flutter test` 34 pass | Manual required | None | No device/manual regression performed. |
| R56 | Tests exist for new business logic. | Partial | `auth_flow_test.dart`, `firebase_campaign_contract_test.dart`, `check_in_validator_test.dart` | 34 tests pass | More tests required | D-006 | Missing authorization/callable/rules edge tests. |
| R57 | Cloud Functions tests exist. | Partial | `functions/src/checkInValidation.test.ts` | 3 Node tests pass | More tests required | D-006 | Tests pure helpers, not callable transaction/security. |
| R58 | Firestore Rules tests exist. | Missing | No rules test files found | None | Emulator required | D-003 | Must not mark rules Verified. |
| R59 | Docs updated for architecture/schema/Firebase/config. | Implemented | `docs/ai-context/*`, `docs/verification/*` | Source inspection | No | None | Current audit adds this matrix and review docs. |
| R60 | No real secret/API key committed. | Implemented | Secret scan only found placeholders/docs; no app config files outside generated plugin examples | `rg` secret scan | History scan deeper optional | None | Firebase public config also absent. |

