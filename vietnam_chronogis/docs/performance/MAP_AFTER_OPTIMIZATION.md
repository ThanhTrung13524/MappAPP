# Map Performance After Optimization

Date: 2026-06-24

## Scope completed

This pass applied low-risk optimizations backed by source evidence. It did not perform a large `MapViewScreen` rewrite because runtime frame/rebuild data was unavailable in this environment.

## Changes

| Area | Before | After | Evidence |
| --- | --- | --- | --- |
| Tourism search | `getAll()` then Dart filter and `take(20)` | SQL `LIKE` filters on `name`, `nameEn`, `category`, ordered and `LIMIT 20` | `test/dao_search_test.dart` |
| School search | `getAll()` then Dart filter and `take(50)` | SQL `LIKE` filters on `name`, `address`, `provinceName`, ordered and `LIMIT 50` | `test/dao_search_test.dart` |
| Tourism marker candidates | Loaded all tourism rows before category/boundary filter | Loads only active categories with `getByCategories()` before boundary validation | `tourism_provider.dart`, DAO test |
| School marker candidates | Loaded all school rows before bbox filter | Loads only Vietnam bbox candidates with `getInBounds()` before marker creation | `school_provider.dart`, DAO test |
| Map repaint isolation | Map canvas shared repaint boundary with overlays | `FlutterMap` wrapped in `RepaintBoundary` | `map_view_screen.dart` |
| Testability | `AppDatabase` always opened app file path | `AppDatabase([QueryExecutor?])` enables in-memory DAO tests | `test/dao_search_test.dart` |
| Map layer rebuild scope | Marker/route layers were inline in `MapViewScreen.build()` | Marker, route, and tourism empty-state layers moved to `widgets/map_layers.dart` | `flutter analyze`, `flutter test` |
| Geometry/heatmap logic | Province geometry, heatmap values, polygon generation, and tap hit-test helper lived in `map_view_screen.dart` | Moved to `domain/province_geometry.dart` and `providers/map_geometry_providers.dart` | `flutter analyze`, `flutter test` |

## Verification

| Command | Result |
| --- | --- |
| `dart format .` | Passed. |
| `flutter analyze` | Passed. No issues found. |
| `flutter test` | Passed. 17 tests passed. |

## Before/after metrics

Runtime frame/memory metrics could not be measured because profile runs did not launch:

- Windows profile blocked by local CMake 3.20 while Firebase C++ SDK requires >= 3.22.
- Chrome profile blocked by `sqlite3`/`dart:ffi`, which is unavailable on web.

Available measurable deltas:

| Metric | Before | After |
| --- | --- | --- |
| Flutter test count | 13 passing tests before map/search optimization | 17 passing tests after DAO/marker query tests |
| Tourism search read scope | Full table read | SQL-filtered, `LIMIT 20` |
| School search read scope | Full table read | SQL-filtered, `LIMIT 50` |
| Tourism marker candidate read scope | Full table read | SQL category filter before Dart boundary validation |
| School marker candidate read scope | Full table read | SQL bbox filter before marker creation |
| `MapViewScreen` line count | 899 | 266 |
| `ref.watch` calls in `map_view_screen.dart` | 28 | 7 |
| Layer widget file | None | `widgets/map_layers.dart`, 179 lines, 13 localized `ref.watch` calls |
| Geometry provider file | None | `providers/map_geometry_providers.dart`, 359 lines |
| Map domain file | None | `domain/province_geometry.dart`, 20 lines |

No claim is made that frame time, memory, or pan/zoom smoothness improved because those runtime metrics were not collectable in this environment.

## Remaining bottlenecks

- Upgrade/install CMake >= 3.22 and rerun Windows profile with DevTools Performance and Widget Rebuild profiler.
- Split `MapViewScreen` into map canvas, layers, controls, search/selection overlays, and provider/domain files.
- Add map camera/bounds state and debounce map movement before viewport-based marker queries.
- Consider marker clustering only after measuring marker count and pan/zoom frame time.
- Add normalized search fields or FTS if Vietnamese accent-insensitive SQL search becomes a real requirement.
- Add provider/widget tests around layer state and map panel rebuild boundaries.
