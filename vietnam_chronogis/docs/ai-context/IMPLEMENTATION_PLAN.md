# Implementation Plan

This plan reflects the repository after the Firebase Campaign/Event/check-in foundation was added.

## Phase 0: Stabilization

| Task ID | Goal | Status | Evidence |
| --- | --- | --- | --- |
| P0-01 | Fix CI Flutter working directory | Done | `.github/workflows/build.yml` runs Flutter commands inside `vietnam_chronogis`. |
| P0-02 | Formatting cleanup | Done | `dart format --output=none --set-exit-if-changed .` passed on 2026-06-24. |
| P0-03 | School POI seed failure retry | Done | School seed failure no longer marks `seeded_schools_v1` successful. |
| P0-04 | Missing Groq key safety | Done | AI tab/provider no longer crashes without `GROQ_API_KEY`; test added. |
| P0-05 | Preserve ChronoGIS routes/features | Done | `/seed`, `/auth`, `/login`, `/map`, `/explorer` exist; existing tabs preserved. |

## Phase 1: Firebase foundation

| Task ID | Goal | Status | Evidence |
| --- | --- | --- | --- |
| P1-01 | Add Firebase dependencies | Done | `pubspec.yaml` includes Firebase Core/Auth/Firestore/Functions/App Check. |
| P1-02 | Optional Firebase bootstrap | Done | Missing config returns `notConfigured`; app continues. |
| P1-03 | Auth repository and UI | Partial | Google sign-in/logout/profile creation implemented; needs real Firebase config. |
| P1-04 | Firestore schema models | Partial | Users, managed schools, campaigns, events, participants, check-ins modeled. |
| P1-05 | Campaign/Event UI | Partial | Campaigns tab added; requires real backend for end-to-end validation. |
| P1-06 | Check-in callable | Partial | Function implemented and TypeScript tests pass; not deployed. |
| P1-07 | Firestore rules | Partial | Rules authored; not emulator-tested because Firebase CLI unavailable. |

## Phase 2: Firebase hardening still required

| Task ID | Goal | Expected files | Acceptance criteria |
| --- | --- | --- | --- |
| P2-01 | Choose production identifiers | Android/iOS/macOS configs | Package/bundle IDs approved before Firebase app registration. |
| P2-02 | Add real Firebase app config | Platform config files, optional `firebase_options.dart` | App starts with Firebase status `ready`. |
| P2-03 | Enable Google provider | Firebase Console | Google sign-in works on target platforms. |
| P2-04 | Run rules emulator tests | Rules test files | User/admin/manager/participant/check-in paths verified. |
| P2-05 | Deploy Functions/rules to staging | Firebase project config | Callable check-in passes staging smoke test. |
| P2-06 | Review npm audit findings | `functions/package*.json` | No unacceptable vulnerabilities before deploy. |

## Phase 3: Map performance and UX

| Task ID | Goal | Expected files | Acceptance criteria |
| --- | --- | --- | --- |
| P3-01 | Measure map baseline | `docs/performance/MAP_BASELINE.md` | Metrics are recorded or explicitly marked unavailable with reason. |
| P3-02 | Reduce whole-screen rebuilds | map feature providers/widgets | Map pan/zoom does not rebuild unrelated panels where avoidable. |
| P3-03 | Move heavy map logic out of widgets | `features/map/providers`, `features/map/domain`, `features/map/presentation/widgets` | Business/data transformation is not performed repeatedly in `build()`. |
| P3-04 | Optimize SQLite search | Drift DAOs/tests | Search uses SQL filters/limits instead of full-table filtering where possible. |
| P3-05 | Optimize marker rendering | map layer widgets/providers | Disabled layers do not render; large marker sets are bounded/clustered/debounced. |
| P3-06 | Improve map UX | map controls/layer/search/selection widgets | Controls are Material 3, accessible, and do not occlude map content. |
| P3-07 | Measure after optimization | `docs/performance/MAP_AFTER_OPTIMIZATION.md` | Before/after numbers are documented. |

## Guardrails

- Do not change Drift schema without version bump and migration.
- Do not treat local SQLite `schools` as Firebase managed schools.
- Do not commit real API keys or Firebase secrets.
- Do not break `/seed`, `/map`, Explorer, Schools, AI, routing, or Campaigns.
- Do not make performance claims without measured evidence.
