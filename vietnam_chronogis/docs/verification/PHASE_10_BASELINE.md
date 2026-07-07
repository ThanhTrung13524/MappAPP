# Phase 10 Baseline

Date: 2026-07-07

Branch: `lab3`

Baseline commit: `64840d8 update lab3`

## Current Firebase Files

| File | Status |
| --- | --- |
| `firebase.json` | Present; Firestore/Functions configured before Phase 10; emulator config added during Phase 10. |
| `firestore.rules` | Present. |
| `firestore.indexes.json` | Present, empty indexes. |
| `.firebaserc` | Missing. |
| `lib/firebase_options.dart` | Missing. |
| `android/app/google-services.json` | Missing. |
| `ios/Runner/GoogleService-Info.plist` | Missing. |

## Current Functions Status

| Item | Status |
| --- | --- |
| Source | `functions/src/index.ts` exports `checkInEvent` and legacy alias `validateEventCheckIn`. |
| Region | `asia-southeast1`. |
| App Check | Function uses `enforceAppCheck: process.env.ENFORCE_APP_CHECK === "true"`. |
| Baseline tests | Before Phase 10, `npm test` covered only pure validation helpers. |

## Current Rules Status

| Item | Status |
| --- | --- |
| Rules file | `firestore.rules` present. |
| Baseline emulator tests | Missing before Phase 10. |
| Direct check-in writes | Denied by source rule. |

## Current Test Count

| Test area | Baseline count |
| --- | ---: |
| Flutter tests | 34 passing tests from `flutter test --reporter expanded`. |
| Functions tests | 3 passing Node tests before Phase 10 expansion. |
| Firestore Rules emulator tests | 0 before Phase 10. |

## Firebase CLI And Project Identification

| Check | Result |
| --- | --- |
| `firebase --version` | Failed: command not found. |
| `flutterfire --version` | Failed: command not found. |
| `firebase login:list` | Failed: command not found. |
| `firebase projects:list` | Failed: command not found. |
| `.firebaserc` | Missing. |
| `FIREBASE*`, `GCLOUD*`, `GOOGLE*` environment variables | None found in this shell. |

## Known Blockers

- Real Firebase project ID/access is not available.
- FlutterFire CLI is not installed.
- Firebase native app config files are missing.
- Google Sign-In cannot be verified against a real backend.
- Real Firestore/Functions deploy is blocked.
- App Check production provider/device verification is blocked.
- Android/iOS package identifiers remain sample values and must be chosen before real Firebase app registration.
