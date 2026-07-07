# Map Regression Review

Date: 2026-07-07

Audit commit: `8fd5ab1`

## Scope

This review checks whether Firebase Campaign/Event/check-in work broke existing ChronoGIS map features and whether Campaign Events are integrated into the map.

## Map Feature Regression Matrix

| Feature | Status | Evidence | Notes |
| --- | --- | --- | --- |
| Startup route | Pass | `app_router.dart:8-13`; `flutter test` passed | App starts at `/seed`. Manual launch not performed. |
| Seed flow | Pass | `seeding_screen.dart`, `seed_provider.dart`; previous tests pass | No manual network seed run in this audit. |
| Map screen | Pass | `map_view_screen.dart`; `flutter analyze` passed | Manual render not performed. |
| Province polygons | Pass | `map_view_screen.dart:77`; `map_geometry_providers.dart`; `vietnam_geo_validator_test.dart` | Tests cover geometry helpers, not visual rendering. |
| Heatmap | Pass | `heatmapStatsProvider`, `mapPolygonsProvider`; heatmap tests pass | Runtime frame impact not measured. |
| Tourism POI markers | Pass | `map_layers.dart:9-24`; DAO tests pass | Manual marker rendering not performed. |
| OSM school POI markers | Pass | `map_layers.dart:26-41`; DAO tests pass | Distinct from Firebase ManagedSchool. |
| Explorer | Pass | `explorer_screen.dart`; `flutter analyze` passed | No manual interaction test. |
| AI chat | Pass | `groq_service_test.dart`; missing key handled | Requires real `GROQ_API_KEY` for live chat. |
| OSRM routing | Pass | `map_layers.dart:43-105`; `routing_provider.dart`; analyze pass | No live OSRM call in this audit. |
| Drift database | Pass | `app_database.dart`; DAO tests pass | `flutter test` passed. |
| Existing Drift migrations | Pass | Schema version source inspected; tests pass | No migration-from-old-db test. |
| Existing test suite | Pass | `flutter test --reporter expanded` | 34 tests passed. |

## Event Map Integration

| Requirement | Status | Evidence | Risk |
| --- | --- | --- | --- |
| Event marker on map | Missing | `map_view_screen.dart:73-81` includes tile/province/tourism/school/route layers only | Requested map-based Event UX is not implemented. |
| Marker status: upcoming/active/check-in available/checked-in/ended | Missing | No event marker/status layer found in map module | Users cannot inspect campaign event state on map. |
| Marker not only color-coded | Missing | No marker exists | Accessibility not addressed. |
| Event detail bottom sheet/panel | Missing | Event UI is in `CampaignsScreen`, not map | Map workflow absent. |
| Check-in UI on map | Missing | Check-in button appears in Campaign tab `_EventTile`, not map | User requirement asks check-in if user is in school area on map. |

## UX Review

| Area | Status | Evidence | Notes |
| --- | --- | --- | --- |
| Campaign tab loading/error states | Partial | `CampaignsScreen` uses `AsyncValue.when` and `_ErrorText` | Raw exception strings may appear. |
| Check-in loading prevention | Partial | `_EventTile` disables button when `checkIn.isLoading` | Does not show success/distance/server time. |
| GPS/permission status | Partial | Repository checks service/permission | UI does not show granular status before/after request. |
| Friendly errors | Partial | Exceptions are surfaced through action state where rendered | No typed error mapping found. |
| Vietnamese encoding | Partial | Some docs/source output still show mojibake in older files; recent UI separators fixed in Campaigns screen | Needs dedicated cleanup. |
| Accessibility | Partial | Icons/text exist, but event markers/status absent | Requires manual review. |

## Performance Review

| Item | Status | Evidence | Notes |
| --- | --- | --- | --- |
| Performance baseline doc exists | Implemented | `docs/performance/MAP_BASELINE.md` | Runtime profiling was blocked. |
| After optimization doc exists | Implemented | `docs/performance/MAP_AFTER_OPTIMIZATION.md` | Reports static/source deltas. |
| Before/after runtime metrics | Blocked | Docs state Windows profile blocked by CMake and web blocked by `dart:ffi` | No frame/memory conclusions allowed. |
| Event state rebuild impact | Not Tested | Event not integrated into map | Cannot measure. |
| Event layer disabled still creates markers | Not Applicable | No event layer | Missing feature. |
| Broad `ref.watch` in map | Improved but Not Verified Runtime | Docs report `MapViewScreen` `ref.watch` count reduced 28 -> 7 | No DevTools rebuild capture. |
| Heavy build logic | Partial | Geometry moved into providers; map still composes overlays | Needs profile. |
| Marker list regeneration | Partial | DAO/provider optimizations documented | Needs runtime marker-count/profile evidence. |

## Conclusion

Legacy ChronoGIS source and tests still pass after Firebase Campaign/check-in work. No build/test regression was found. However, Event map integration is missing, so the requested map-based Campaign/Event/check-in experience is not complete. Performance claims are limited to static/source improvements; runtime smoothness is not verified.

