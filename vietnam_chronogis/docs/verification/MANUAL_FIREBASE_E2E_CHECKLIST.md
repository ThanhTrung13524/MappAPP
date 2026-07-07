# Manual Firebase E2E Checklist

Date: 2026-07-07

Use this checklist only after a real Firebase project is configured with:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `.firebaserc`
- Google provider enabled in Firebase Authentication
- Firestore and Functions enabled

For every item, record:

```text
Status: Pass / Fail / Blocked / Not Tested
Evidence:
Device/environment:
Observed result:
```

## A. Authentication

| Step | Expected result | Status | Evidence |
| --- | --- | --- | --- |
| Open app when signed out | App starts at `/seed`, then routes to auth/login path after seed completes | Not Tested | Requires real app run |
| Check Login redirect | Signed-out private Firebase flow shows Login screen, not raw crash | Not Tested | Requires real config |
| Google Sign-In | Google account signs in through Firebase Auth | Blocked | Firebase project/config missing |
| Verify Firestore user document | `users/{uid}` exists with `globalRole=user`, `status=active`, server timestamps | Blocked | Firebase project/config missing |
| Restart app | Auth state persists and user remains signed in | Blocked | Firebase project/config missing |
| Logout | Firebase Auth and Google session sign out | Blocked | Firebase project/config missing |
| Direct private route check | Private Firebase actions require auth; `/map` public policy must be explicitly reviewed | Not Tested | Route guard currently partial |

## B. Managed School

| Step | Expected result | Status | Evidence |
| --- | --- | --- | --- |
| Login with authorized user | User can access Campaigns tab | Blocked | Firebase project/config missing |
| Create ManagedSchool | Firestore doc in `managed_schools` is created | Blocked | Firebase project/config missing |
| Enter name/address/lat/lon/radius | Data validates radius and coordinate range | Not Tested | Requires UI run |
| Verify Firestore document | Doc has `name`, `address`, `location: GeoPoint`, `checkInRadiusMeters`, `active`, `createdBy`, timestamps | Blocked | Firebase project/config missing |
| Edit ManagedSchool | Creator/admin can update allowed fields | Blocked | Requires UI/edit flow completion |
| Unauthorized user update | Non-creator/non-admin is denied | Verified in Emulator | `npm run test:rules:emulator` |

## C. Campaign/Event

| Step | Expected result | Status | Evidence |
| --- | --- | --- | --- |
| Create Campaign | Firestore doc in `campaigns` with owner ID and status | Blocked | Firebase project/config missing |
| Create Event under Campaign | Firestore doc in `campaigns/{id}/events` | Blocked | Firebase project/config missing |
| Select ManagedSchool | Event writes `schoolId` | Blocked | Firebase project/config missing |
| Set Event time | `startAt < endAt` accepted; invalid order rejected | Verified in Emulator for rules shape | `npm run test:rules:emulator` |
| Set check-in window | `checkInOpenAt <= checkInCloseAt <= endAt` accepted | Verified in Emulator for rules shape | `npm run test:rules:emulator` |
| Verify Firestore schema | Campaign/Event fields match Dart models, Rules, and Function | Blocked | Requires real Firestore |
| Verify Event marker on map | Event marker appears with status | Blocked | Feature missing; see prior audit D-005 |

## D. Participant

| Step | Expected result | Status | Evidence |
| --- | --- | --- | --- |
| Login user B | User B can view campaigns | Blocked | Firebase project/config missing |
| Join Campaign | Participant doc is created with `pending` and role `participant` | Verified in Emulator | `npm run test:rules:emulator` |
| Verify pending status | Firestore participant doc is pending | Blocked | Requires real Firestore |
| Login organizer/owner | Manager can review participants | Blocked | Firebase project/config missing |
| Approve participant | Participant status becomes `approved` | Verified in Emulator | `npm run test:rules:emulator` |
| User self-approval | Denied | Verified in Emulator | `npm run test:rules:emulator` |
| User self role escalation | Denied | Verified in Emulator | `npm run test:rules:emulator` |

## E. Check-In

| Step | Expected result | Status | Evidence |
| --- | --- | --- | --- |
| GPS off | UI shows friendly GPS service error | Not Tested | Requires device/emulator |
| Permission denied | UI shows permission required state | Not Tested | Requires device/emulator |
| Outside radius | Callable rejects with outside-radius error | Verified in Function unit core; not E2E | `npm test` |
| Inside radius | Callable returns success and distance | Verified in Function unit core; not E2E | `npm test` |
| Event not opened | Callable rejects | Verified in Function unit core | `npm test` |
| Event closed | Callable rejects | Verified in Function unit core | `npm test` |
| Participant pending | Callable rejects | Verified in Function unit core | `npm test` |
| Approved participant inside radius | Callable accepts | Verified in Function unit core | `npm test` |
| Server timestamp | Check-in doc uses server timestamp | Implemented, not E2E | `functions/src/index.ts` |
| Backend distance | Distance computed backend-side | Verified in Function unit core | `npm test` |
| Duplicate check-in | Duplicate is rejected | Verified in Function unit core; no concurrent emulator test | `npm test` |
| Direct Firestore write | Denied by Rules | Verified in Emulator | `npm run test:rules:emulator` |
| Function logs | No unexpected errors | Blocked | Requires deployed/emulated callable execution |

## F. ChronoGIS Regression

| Step | Expected result | Status | Evidence |
| --- | --- | --- | --- |
| `/seed` | Startup seed completes or shows retryable error | Not Tested | Manual app run required |
| `/map` | Map renders | Not Tested | Manual app run required |
| Province polygons | Boundaries render | Not Tested | Manual app run required |
| Heatmap | Heatmap toggles and renders | Not Tested | Manual app run required |
| Tourism markers | Tourism markers render and filter | Not Tested | Manual app run required |
| OSM Schools | Local OSM school layer renders | Not Tested | Manual app run required |
| Explorer | Explorer list/search works | Not Tested | Manual app run required |
| AI | Missing `GROQ_API_KEY` shows configured warning; with key chat works | Partially Verified | Unit test covers missing key |
| OSRM routing | Route calculation works | Not Tested | Manual network test required |
| Drift/local data persistence | Existing local data persists | Partially Verified | DAO tests pass |
