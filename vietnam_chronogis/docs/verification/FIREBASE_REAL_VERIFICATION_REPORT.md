# Firebase Real Verification Report

Date: 2026-07-07

Branch: `lab3`

Baseline commit: `64840d8 update lab3`

Release decision: `Ready for Local Development`

## Area Status

| Area | Status | Evidence | Command/Test | Blocker | Next action |
| ---- | ------ | -------- | ------------ | ------- | ----------- |
| Firebase project identification | Blocked | `firebase` command not found; `.firebaserc` missing; no `FIREBASE*`, `GCLOUD*`, `GOOGLE*` env vars found | `firebase --version`, `firebase login:list`, env scan | No project ID/access | Install Firebase CLI, login, add `.firebaserc` or set `FIREBASE_PROJECT_ID`. |
| FlutterFire configuration | Blocked | No `lib/firebase_options.dart`; `flutterfire` command not found | `flutterfire --version` | FlutterFire CLI/config missing | Install FlutterFire CLI and run `flutterfire configure` for approved platforms. |
| Android config | Blocked | No `android/app/google-services.json`; Android ID is still `com.example.map_application1` | Source scan | Official package ID not chosen | Choose package ID, register Android app, download config. |
| iOS config | Blocked | No `ios/Runner/GoogleService-Info.plist`; iOS bundle ID is `com.example.mapApplication1` | Source scan | Official bundle ID not chosen | Choose bundle ID, register iOS app, download plist. |
| Google Sign-In | Blocked | Auth repository exists but provider/backend cannot be verified | Source inspection; tests use fakes | Firebase config/provider/SHA setup missing | Enable Google provider and configure SHA/URL schemes. |
| Firebase Authentication | Implemented | `FirebaseAuth.authStateChanges()`, Google sign-in/logout code | `flutter test --reporter expanded` | Real backend missing | Run app with real Firebase config and verify login/logout. |
| Firestore | Implemented | Repositories and Rules exist | `flutter test`, `npm run test:rules:emulator` | Real backend missing | Deploy rules/indexes to identified Firebase project. |
| Cloud Functions | Implemented | `checkInEvent` source builds | `npm run lint`, `npm run build`, `npm test` | No project/deploy | Deploy only after project and tests are approved. |
| `checkInEvent` | Implemented | Callable name matches Flutter; region set to `asia-southeast1` in Function and Flutter provider | `npm test` | Callable not deployed/executed E2E | Run Functions emulator callable test or deploy to real project. |
| Firestore Rules | Verified | Authorization tests pass in Firestore Emulator | `npm run test:rules:emulator` | Not deployed to real project | Deploy rules to verified Firebase project. |
| Rules emulator tests | Verified | 7 Node tests pass against Firestore Emulator on port `18080` | `npm run test:rules:emulator` | None local | Add CI step. |
| Function tests | Verified | 14 Node tests pass, including check-in core security cases | `npm test` | No callable emulator E2E | Add callable emulator tests for request auth and transaction path. |
| App Check | Blocked | Dependency exists; Function can enforce via `ENFORCE_APP_CHECK`; no Flutter activation/provider setup found | Source scan | No Firebase Console provider/device token | Configure debug/prod providers and do not commit debug token. |
| Android physical device | Blocked | No Firebase config and no device run in this phase | Not run | Missing config/device setup | Run manual checklist on physical Android. |
| iOS physical device | Blocked | No Firebase config and no device run in this phase | Not run | Missing config/device setup | Run manual checklist on physical iOS. |
| ChronoGIS regression | Not Tested | Code gates pass but no manual app/device run | `flutter analyze`, `flutter test` | Manual runtime not performed | Execute manual checklist for `/seed`, `/map`, Explorer, Schools, AI, OSRM. |

## Commands Executed

| Command | Working directory | Exit code | Result |
| --- | --- | ---: | --- |
| `git status` | repo root | 0 | Clean baseline before Phase 10 changes. |
| `git branch --show-current` | repo root | 0 | `lab3`. |
| `git log --oneline --decorate -20` | repo root | 0 | HEAD `64840d8`. |
| `git tag --list "checkpoint-*"` | repo root | 0 | Existing checkpoint tags listed. |
| `git diff --stat` | repo root | 0 | Empty at baseline. |
| `git diff` | repo root | 0 | Empty at baseline. |
| `firebase --version` | `vietnam_chronogis` | 1 | Blocked: command not found. |
| `flutterfire --version` | `vietnam_chronogis` | 1 | Blocked: command not found. |
| `firebase login:list` | `vietnam_chronogis` | 1 | Blocked: command not found. |
| `firebase projects:list` | `vietnam_chronogis` | 1 | Blocked: command not found. |
| `.firebaserc` read | `vietnam_chronogis` | 0 | Missing. |
| Firebase/Google env scan | `vietnam_chronogis` | 0 | No matching env vars found. |
| `npm install --save-dev @firebase/rules-unit-testing firebase firebase-tools` | `functions` | 0 | Passed; npm audit findings present after install. |
| `npm audit --audit-level=high` | `functions` | 0 | Passed; 11 moderate findings, no high/critical findings. |
| `dart format .` | `vietnam_chronogis` | 0 | Passed; formatted `lib/core/firebase/firebase_providers.dart`. |
| `dart format --output=none --set-exit-if-changed .` | `vietnam_chronogis` | 0 | Passed. |
| `flutter analyze` | `vietnam_chronogis` | 1 | Failed before analyzer exclude because `functions/node_modules/firebase-tools` contains Dart template files. |
| `flutter analyze` | `vietnam_chronogis` | 0 | Passed after excluding `functions/node_modules/**` and `functions/lib/**`. |
| `flutter test --reporter expanded` | `vietnam_chronogis` | 0 | Passed; 34 tests. |
| `npm run lint` | `functions` | 0 | Passed. |
| `npm run build` | `functions` | 0 | Passed. |
| `npm test` | `functions` | 0 | Passed; 14 tests. |
| `npm run test:rules:emulator` | `functions` | 1 | Failed before port change because local port `8080` was occupied by a Java process. |
| `npm run test:rules:emulator` | `functions` | 0 | Passed; Firestore Emulator tests 7/7. |

## Deploy Status

Deploy was not attempted.

Blocked:

- Reason: Firebase project ID/access is not available, Firebase CLI global is not installed, `.firebaserc` is missing, and no project environment variable is present.
- Exact command user must run after configuration:

```bash
firebase deploy --only firestore:rules,firestore:indexes,functions:checkInEvent
```

- Expected success evidence:
  - Firebase CLI shows the intended project ID.
  - Firestore Rules deployment succeeds.
  - Function `checkInEvent` appears in region `asia-southeast1`.
  - Function logs show no runtime error for a test callable invocation.

## Emulator Commands

Start emulators manually:

```bash
cd vietnam_chronogis/functions
npm run test:rules:emulator
```

Run app against emulators only after Firebase app config exists:

```bash
flutter run \
  --dart-define=USE_FIREBASE_EMULATOR=true \
  --dart-define=FIREBASE_EMULATOR_HOST=localhost \
  --dart-define=FIRESTORE_EMULATOR_PORT=18080 \
  --dart-define=FIREBASE_FUNCTIONS_REGION=asia-southeast1
```

For Android Emulator, use:

```bash
flutter run \
  --dart-define=USE_FIREBASE_EMULATOR=true \
  --dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2 \
  --dart-define=FIRESTORE_EMULATOR_PORT=18080 \
  --dart-define=FIREBASE_FUNCTIONS_REGION=asia-southeast1
```

Firestore emulator uses port `18080` in this repository because port `8080`
was occupied by a local Java process during Phase 10 verification.

## Remaining Blockers

- Install Firebase CLI and FlutterFire CLI.
- Identify the real Firebase project through `.firebaserc` or `FIREBASE_PROJECT_ID`.
- Choose production Android/iOS identifiers before Firebase app registration.
- Run `flutterfire configure`; do not hand-write generated config files.
- Enable Google provider and configure Android SHA/iOS URL scheme.
- Configure App Check providers and debug token handling.
- Deploy and verify `checkInEvent` only after local tests pass and project is confirmed.
- Run manual physical-device check-in for GPS and duplicate behavior.
