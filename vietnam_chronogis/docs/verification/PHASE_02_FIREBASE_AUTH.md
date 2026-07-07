# Phase 02 Firebase Auth Notes

Date: 2026-06-24

Status: Implemented, backend verification blocked by missing Firebase project configuration.

## Implemented in this phase

- Firebase Core bootstrap is optional and recoverable.
- Firebase Auth and Cloud Firestore dependencies are wired for authentication and user profiles.
- Google Sign-In is routed through an auth repository, not called directly from widgets.
- Auth state is exposed through Riverpod.
- `/seed` remains the startup route and navigates to `/auth` after local seed completes.
- `/auth` resolves to `/login` for signed-out or unconfigured states, and `/map` for signed-in users.
- Login/logout UI shows loading and error states.
- User profile creation targets `users/{uid}`.
- New profiles default to `globalRole = user` and `status = active`.

## Firebase setup required before verification

The repository does not include real Firebase client configuration. To verify Google Sign-In and Firestore profile writes against a backend, configure a real Firebase project:

1. Choose production Android/iOS/macOS package identifiers.
2. Register the target apps in Firebase Console.
3. Add official platform config files such as `google-services.json` and `GoogleService-Info.plist`.
4. Generate `firebase_options.dart` with FlutterFire CLI if the project chooses generated options.
5. Enable Google Sign-In in Firebase Authentication.
6. Configure Firestore rules for `users/{uid}` and run emulator tests.

Do not commit real private credentials or API keys that are not intended to be public Firebase client config.

## Verification status

Local unit tests verify provider behavior, route-decision logic, profile mapping, default non-admin role creation data, logout dispatch, login error handling, and missing Firebase configuration behavior.

Real Google Sign-In, Firestore writes, auth persistence, and hosted backend security are blocked until Firebase configuration is supplied.
