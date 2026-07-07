# Device Test Matrix

Date: 2026-07-07

Status values: `Verified`, `Blocked`, `Not Tested`, `Not Applicable`.

| Feature | Android Emulator | Android Physical Device | iOS Simulator | iOS Physical Device | Web | Firebase Emulator | Firebase Real Project |
| ------- | ---------------- | ----------------------- | ------------- | ------------------- | --- | ----------------- | --------------------- |
| Firebase bootstrap | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Blocked |
| Google Sign-In | Blocked | Blocked | Blocked | Blocked | Not Tested | Not Tested | Blocked |
| Auth persistence | Blocked | Blocked | Blocked | Blocked | Not Tested | Not Tested | Blocked |
| User profile creation | Blocked | Blocked | Blocked | Blocked | Not Tested | Not Tested | Blocked |
| ManagedSchool create/read | Blocked | Blocked | Blocked | Blocked | Not Tested | Verified rules only | Blocked |
| Campaign create/read | Blocked | Blocked | Blocked | Blocked | Not Tested | Verified rules only | Blocked |
| Event create/read | Blocked | Blocked | Blocked | Blocked | Not Tested | Verified rules only | Blocked |
| Participant join | Blocked | Blocked | Blocked | Blocked | Not Tested | Verified rules only | Blocked |
| Participant approve/reject | Blocked | Blocked | Blocked | Blocked | Not Tested | Verified rules only | Blocked |
| Check-in inside radius | Not Tested | Blocked | Not Tested | Blocked | Not Applicable | Verified function core only | Blocked |
| Check-in outside radius | Not Tested | Blocked | Not Tested | Blocked | Not Applicable | Verified function core only | Blocked |
| Duplicate check-in | Not Tested | Blocked | Not Tested | Blocked | Not Applicable | Verified function core only | Blocked |
| Direct Firestore check-in write denied | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Verified | Blocked |
| Firestore Rules emulator | Not Applicable | Not Applicable | Not Applicable | Not Applicable | Not Applicable | Verified | Not Applicable |
| Callable `checkInEvent` deployed | Not Applicable | Not Applicable | Not Applicable | Not Applicable | Not Applicable | Not Tested | Blocked |
| App Check | Blocked | Blocked | Blocked | Blocked | Not Tested | Not Tested | Blocked |
| `/seed` regression | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Not Applicable |
| `/map` regression | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Not Applicable |
| Explorer regression | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Not Applicable |
| Schools regression | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Not Applicable |
| AI missing key behavior | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Not Applicable |
| OSRM routing | Not Tested | Not Tested | Not Tested | Not Tested | Not Tested | Not Applicable | Not Applicable |

## Blocker Notes

- Android/iOS real Firebase tests are blocked by missing native Firebase config files.
- Android physical GPS/check-in is blocked until Firebase config and device location test setup exist.
- iOS physical GPS/check-in is blocked until Firebase config, Apple app setup, and physical device access exist.
- Web is not a supported verification target for the current Drift/sqlite3 app because prior profile attempts were blocked by `dart:ffi` web limitations.
- Firebase Emulator currently verifies Firestore Rules behavior. Callable emulator execution is still not an end-to-end app/device test.
