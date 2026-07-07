# Firebase Audit

## Summary

Firebase foundation is now implemented in source code, but the repository still has no real Firebase project configuration or secrets.

Implemented:

- Firebase Core optional bootstrap.
- Firebase Auth with Google sign-in/logout.
- Firestore repositories and domain models for users, managed schools, campaigns, events, participants, and check-ins.
- Firebase Functions callable `validateEventCheckIn`.
- Firebase App Check activation attempt.
- Firestore rules and empty indexes file.

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
| Firestore | Yes | Via providers | Users, managed schools, campaigns, events, participants. | Rules added, not emulator-tested/deployed. |
| Cloud Functions | Yes | Via providers | Callable `validateEventCheckIn`. | Functions source added, not deployed. |
| App Check | Yes | Debug provider activation attempted when Firebase is configured. | Callable can enforce App Check via `ENFORCE_APP_CHECK=true`. | Production provider setup still required. |
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
- Admin-only managed school writes.
- Signed-in users can create campaigns where they are owner.
- Campaign managers can create/update events.
- Users can create their own pending participant request.
- Managers can approve/reject participants.
- Direct client writes to check-in documents are denied.

Rules were not emulator-tested because `firebase-tools` is not installed and `npx firebase-tools@latest --version` timed out after 5 minutes.

## Cloud Functions

`functions/src/index.ts` exports `validateEventCheckIn` in region `asia-southeast1`.

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

- `npm install`: passed, with 8 moderate audit findings and Node v25 vs target Node 20 warning.
- `npm run lint`: passed.
- `npm test`: passed 3 Node tests.

## Secrets and API keys

- No real Firebase secrets were added.
- `dart_defines.example.json` remains a template only.
- `GROQ_API_KEY` remains runtime configuration and is not committed.

## Remaining Firebase work

1. Choose official Android/iOS/macOS identifiers.
2. Create Firebase project/apps and add official config files outside this task's placeholder-free implementation.
3. Enable Google sign-in provider.
4. Deploy Firestore rules and Functions.
5. Run Firestore rules emulator tests once Firebase CLI is available.
6. Decide production App Check providers and enforcement policy.
7. Add FCM only if notifications are required.
