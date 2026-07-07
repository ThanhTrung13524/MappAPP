# Security Review

Date: 2026-07-07

Audit commit: `8fd5ab1`

## Summary

The implementation has a reasonable server-authoritative check-in design in source code: the client sends only IDs/location/accuracy, and the Cloud Function reads Campaign, Event, Participant, ManagedSchool, and existing check-in records inside a transaction. However, this security posture is not yet Verified because there are no Firestore Rules emulator tests and no callable Function integration tests.

## Authentication And User Profile

| Area | Evidence | Status | Notes |
| --- | --- | --- | --- |
| Firebase init | `firebase_bootstrap.dart:59` | Implemented | Missing native config blocks real verification. |
| Auth state | `auth_repository.dart:48-55` | Implemented | Uses `FirebaseAuth.authStateChanges()`. |
| Google Sign-In | `auth_repository.dart:67-90` | Blocked | No app Firebase config found. |
| User profile creation | `auth_repository.dart:105-130` | Implemented | Uses Firestore user doc and server timestamps. |
| Default non-admin role | `app_user_profile.dart:64` | Implemented | `toCreateMap()` forces `GlobalRole.user`. |
| User role escalation rule | `firestore.rules:79-83` | Implemented | Not emulator-tested. |
| Route protection | `auth_gate_screen.dart:11-42`; `app_router.dart:11-13` | Partial | `/map` route bypasses AuthGate. See D-002. |

## Firestore Rules Review

| Rule area | Evidence | Status | Risk |
| --- | --- | --- | --- |
| No global allow-all | No `allow read, write: if true` found | Implemented | Low. |
| User create shape | `firestore.rules:43-47`, `firestore.rules:78` | Implemented | Needs emulator test. |
| User update cannot change role/status | `firestore.rules:79-83` | Implemented | Needs emulator test. |
| Managed school create | `firestore.rules:87-96` | Partial | Shape exists, but no `keys().hasOnly(...)` whitelist for extra fields. |
| Campaign create | `firestore.rules:99-103` | Partial | Owner/status constrained; no field shape/date validation. |
| Campaign update | `firestore.rules:104` | Partial | Manager-only, but no field whitelist or immutable owner checks. |
| Event create/update | `firestore.rules:107-111` | Partial | Only checks `schoolId is string`; no date/status/radius field validation. |
| Participant create | `firestore.rules:114-117`, `participantCreateShape` | Implemented | Needs emulator test. |
| Participant update | `firestore.rules:118-122` | Partial | Manager-only; role/status fields allowed. No emulator tests and `isCampaignManager` does not require participant status approved. |
| Direct check-in writes | `firestore.rules:126-128` | Implemented | Needs emulator test. |

## Check-In Security Rule Table

| Check-in rule | Evidence | Status | Test coverage | Severity if missing |
| ------------- | -------- | ------ | ------------- | ------------------- |
| Authenticated request required | `functions/src/index.ts:112-115` | Implemented | No callable test | Critical |
| UID read from auth context | `functions/src/index.ts:112`, `participantRef` doc by `uid` | Implemented | No callable test | Critical |
| Client sends only campaignId/eventId/location/accuracy | `check_in_models.dart:16-24` | Implemented | Contract inspection only | High |
| Backend reads Campaign | `functions/src/index.ts:134`, `146` | Implemented | No callable test | Critical |
| Backend reads Event | `functions/src/index.ts:135`, `147` | Implemented | No callable test | Critical |
| Backend reads Participant | `functions/src/index.ts:136`, `148` | Implemented | No callable test | Critical |
| Backend reads ManagedSchool | `functions/src/index.ts:199-201` | Implemented | No callable test | Critical |
| Backend reads existing check-in | `functions/src/index.ts:137`, `149` | Implemented | No duplicate test | Critical |
| Participant must be approved | `functions/src/index.ts:180-182` | Implemented | No callable test | Critical |
| Role must be allowed | `functions/src/index.ts:184-186` | Implemented | No invalid-role test | High |
| Campaign/Event must be open | `functions/src/index.ts:172-177` | Implemented | No callable test | High |
| Check-in window enforced | `functions/src/index.ts:189-192` | Implemented | Pure helper test only | High |
| Coordinate validation | `functions/src/index.ts:122-124`; `checkInValidation.ts:6-15` | Implemented | Node helper test | High |
| Accuracy validation | `functions/src/index.ts:127-131` | Implemented | No low-accuracy callable test | Medium |
| Haversine distance calculated backend-side | `functions/src/index.ts:217`; `checkInValidation.ts:17-34` | Implemented | Node helper test | Critical |
| Radius read from Event or School | `functions/src/index.ts:212-215` | Implemented | No callable test | Critical |
| Client distance not trusted | No distance field in request model; backend computes | Implemented | No fake-client test | Critical |
| Client radius not trusted | No radius field in request model; backend reads Firestore | Implemented | No fake-client test | Critical |
| Client timestamp not trusted | `FieldValue.serverTimestamp()` at `index.ts:222-236` | Implemented | No callable test | Critical |
| Transaction used | `functions/src/index.ts:139` | Implemented | No concurrent test | Critical |
| UID as check-in doc ID | `functions/src/index.ts:137` | Implemented | No callable test | High |
| Duplicate check-in blocked | `functions/src/index.ts:165` | Implemented | No duplicate test | Critical |
| Race condition blocked | Transaction + fixed doc ID | Implemented | No concurrent test | Critical |

## Required Security Tests

The following tests are missing and should be added before demo/staging claims:

| Scenario | Current status |
| --- | --- |
| Unauthenticated callable request | Missing |
| Pending participant check-in | Missing |
| Rejected participant check-in | Missing |
| Invalid role check-in | Missing |
| Campaign not open | Missing |
| Event not open | Missing |
| Event check-in window closed | Missing |
| Outside radius | Missing for callable; helper exists |
| Exactly boundary radius | Missing |
| Low accuracy | Missing |
| Duplicate check-in | Missing |
| Two concurrent requests | Missing |
| Fake client radius | Missing |
| Fake client role | Missing |
| Fake client timestamp | Missing |
| Direct Firestore check-in write denied by Rules | Missing |

## Secret And Configuration Audit

| Item | Result | Evidence |
| --- | --- | --- |
| Real API keys/private keys | Not found | `rg` found only placeholders/docs for `GROQ_API_KEY`; no private key patterns. |
| Firebase native config | Missing | No app-level config files found outside generated plugin examples. |
| Firebase public example configs | Present only under generated `.plugin_symlinks` | These are plugin examples created by pub/get tooling, not app config. |
| Groq key | Not committed | `dart_defines.example.json` contains placeholder only. |
| Node dependencies | Risk | `npm install` reports 9 moderate vulnerabilities; Node local version differs from Functions target. |

## Security Verdict

Security status: `Partial`.

The core check-in source design is promising, but the project is not security-verified. The release-blocking items are missing Firebase config, missing Rules emulator tests, broad Campaign/Event update rules, and missing callable check-in security tests.

