# Firebase Audit

## Summary

Firebase foundation is now implemented in source code, but the repository still has no real Firebase project configuration or secrets.

Implemented:

- Firebase Core optional bootstrap.
- Firebase Auth with Google sign-in/logout.
- Firestore repositories and domain models for users, managed schools, campaigns, events, participants, and check-ins.
- Firebase Functions callable `checkInEvent` with legacy `validateEventCheckIn` alias.
- Firestore rules and empty indexes file.
- Local Firebase Emulator Suite configuration for Auth, Firestore, Functions, and UI.
- Firestore Rules emulator tests.

Not committed:

- `google-services.json`
- `GoogleService-Info.plist`
- generated `firebase_options.dart`
- `.firebaserc`
- real API keys or private secrets

## Services

| Firebase service | Dependency installed | Initialized | Current usage | Configuration status |
| --- | --- | --- | --- | --- |
| Firebase Core | Yes | Optional bootstrap in `main.dart` | Enables Firebase services when config exists. | Missing real client config. |
| Authentication | Yes | Via Firebase Core | Google sign-in/logout and auth state. | Google provider must be enabled in Firebase Console. |
| Firestore | Yes | Via providers | Users, managed schools, campaigns, events, participants. | Rules emulator tests pass locally; not deployed to a real project. |
| Cloud Functions | Yes | Via providers | Callable `checkInEvent` in `asia-southeast1`. | Functions source builds and core tests pass; not deployed. |
| App Check | Yes | Not initialized in Flutter source yet. | Callable can enforce App Check via `ENFORCE_APP_CHECK=true`. | Production provider setup still required. |
| Messaging | No | No | Notifications not implemented. | Missing. |
| Storage | No | No | Not used. | Missing. |
| Analytics/Crashlytics/Remote Config | No | No | Not used. | Missing. |

## Auth flow

Implemented files:

- `lib/features/auth/data/auth_repository.dart`
- `lib/features/auth/domain/app_user_profile.dart`
- `lib/features/auth/presentation/auth_gate_screen.dart`
- `lib/features/auth/presentation/login_screen.dart`

Behavior:

- `/auth` handles signed-in, signed-out, not-configured, and bootstrap-failed states.
- `/login` shows Google sign-in when Firebase is configured.
- User profile is created at `users/{uid}` with default `globalRole=user` and `status=active`.
- No real Firebase config means auth UI stays in not-configured mode instead of crashing.

## Firestore usage

Implemented collections:

- `users`
- `managed_schools`
- `campaigns`
- `campaigns/{campaignId}/events`
- `campaigns/{campaignId}/participants`
- `campaigns/{campaignId}/events/{eventId}/checkins`

Client repositories:

- `managed_school_repository.dart`
- `campaign_repository.dart`
- `campaign_event_repository.dart`
- `participant_repository.dart`
- `check_in_repository.dart`

## Security rules

`firestore.rules` currently enforces:

- Self-only profile reads/limited updates.
- Active user managed school create and creator/admin update/delete policy.
- Signed-in users can create campaigns where they are owner.
- Campaign managers can create/update campaigns/events with field shape restrictions.
- Users can create their own pending participant request.
- Managers can approve/reject participants.
- Direct client writes to check-in documents are denied.

Rules are emulator-tested with local `firebase-tools` from the `functions` package:

- `npm run test:rules:emulator`: passed on 2026-07-07 with Firestore Emulator port `18080`.

## Cloud Functions

`functions/src/index.ts` exports `checkInEvent` and legacy alias `validateEventCheckIn` in region `asia-southeast1`.

Function behavior:

- Requires auth.
- Validates payload and coordinates.
- Rejects poor location accuracy when accuracy is over 100 meters.
- Checks campaign/event status.
- Checks participant approval and role.
- Checks server time against check-in window.
- Checks managed school active status.
- Calculates distance with Haversine.
- Prevents duplicate check-in.
- Writes the check-in document and updates participant `lastCheckInAt` in a transaction.

Verification:

- `npm install`: passed, with audit findings and Node v25.2.1 vs target Node 20 warning after adding emulator/rules test tooling.
- `npm audit --audit-level=high`: passed, with 11 moderate findings and no high/critical findings.
- `npm run lint`: passed.
- `npm run build`: passed.
- `npm test`: passed 14 Node tests.
- `npm run test:rules:emulator`: passed 7 Firestore Rules emulator tests.

## Secrets and API keys

- No real Firebase secrets were added.
- `dart_defines.example.json` remains a template only.
- `GROQ_API_KEY` remains runtime configuration and is not committed.

## Remaining Firebase work

1. Choose official Android/iOS/macOS identifiers.
2. Create Firebase project/apps and add official config files outside this task's placeholder-free implementation.
3. Enable Google sign-in provider.
4. Deploy Firestore rules and Functions after project identity is confirmed.
5. Add callable emulator tests for the full HTTPS callable transaction path.
6. Decide production App Check providers and enforcement policy.
7. Add FCM only if notifications are required.
