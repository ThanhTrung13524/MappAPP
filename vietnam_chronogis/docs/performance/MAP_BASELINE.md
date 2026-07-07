# Map Performance Baseline

Date: 2026-06-24  
Project directory: `vietnam_chronogis`  
Target attempted: Windows desktop profile, Chrome profile fallback

## Environment

| Item | Value |
| --- | --- |
| Flutter | 3.44.0 stable |
| Dart | 3.12.0 |
| DevTools | 2.57.0 |
| Connected devices | Windows desktop, Chrome, Edge |
| OS | Microsoft Windows 10.0.26200.8457 |

## Runtime profiling status

`flutter run --profile` could not reach app runtime in this environment.

| Command | Result | Evidence |
| --- | --- | --- |
| `flutter run --profile -d windows --trace-startup --no-pub` | Failed before launch | Windows build ran 220.9s, then failed because Firebase C++ SDK requires CMake >= 3.22 while local CMake is 3.20.21032501-MSVC_2. |
| `flutter run --profile -d chrome --trace-startup --no-pub` | Failed before launch | Web compile ran 19.1s, then failed because `sqlite3` imports `dart:ffi`, which is unavailable on web. |

Because the app did not launch in profile mode, these runtime metrics were not measurable here:

- App open time.
- `/seed` to `/map` time.
- First map layer display time.
- Slow frame count.
- UI thread frame time.
- Raster thread frame time.
- Widget rebuild count from DevTools.
- Memory usage.
- Pan/zoom frame timing.
- Layer toggle timing.

No performance conclusion is made for frame rate or memory without those measurements.

## Static/source baseline

These metrics were collected from source inspection before optimization work in this pass.

| Metric | Baseline value | Evidence |
| --- | --- | --- |
| `MapViewScreen` size | 899 lines | `Get-Content map_view_screen.dart | Measure-Object -Line` |
| `ref.watch` calls in `MapViewScreen` | 28 | `rg "ref\\.watch" map_view_screen.dart` |
| Tourism marker provider DB access | Loaded all tourism rows with `dao.getAll()` | `lib/shared/providers/tourism_provider.dart` before optimization |
| School marker provider DB access | Loaded all school rows with `dao.getAll()` | `lib/shared/providers/school_provider.dart` before optimization |
| Tourism search DB access | Loaded all tourism rows with `getAll()` then filtered in Dart | `lib/core/database/daos/tourism_dao.dart` before optimization |
| School search DB access | Loaded all school rows with `getAll()` then filtered in Dart | `lib/core/database/daos/school_dao.dart` before optimization |
| Administrative search DB access | Loads broad administrative candidate set then normalizes in Dart | `lib/core/database/daos/administrative_unit_dao.dart` |
| Polygon provider | Builds `Polygon` list from all province geometries when heatmap is enabled | `mapPolygonsProvider` |

## Baseline bottlenecks with evidence

1. Tourism and school search did full-table reads before Dart filtering.
2. Tourism and school marker providers did full-table reads before marker construction.
3. `MapViewScreen` watches many providers in one build method, so unrelated state changes can rebuild the large map screen.
4. `MapViewScreen` still owns geometry, heatmap, tap selection, layer composition, and overlay UI in one file.
5. Runtime frame and memory metrics remain blocked until Windows CMake is upgraded or another native target is available.

## Baseline commands

```bash
flutter devices
flutter --version
flutter run --profile -d windows --trace-startup --no-pub
flutter run --profile -d chrome --trace-startup --no-pub
rg "ref\\.watch" lib/features/map/presentation/map_view_screen.dart
rg "getAll\\(|\\.where\\(" lib/shared/providers/tourism_provider.dart lib/shared/providers/school_provider.dart lib/core/database/daos
```
