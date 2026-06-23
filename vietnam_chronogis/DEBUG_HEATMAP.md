# 🔥 Heatmap Debug Guide

## How to test the heatmap toggle

### 1. **Run the app in debug mode**
```bash
flutter run -v
```

### 2. **Look for these debug logs in VS Code console:**

#### When app loads (shows if provinces have density data):
```
🌍 [ProvinceGeometries] Loading 63 provinces...
  📍 Ha Noi: density=2400.5, macroRegion=red_river_delta
  📍 TP Ho Chi Minh: density=1800.3, macroRegion=southeast
  ...
```

**If you see `density=null` for all provinces → Problem: Data not loaded from database**

#### When you click the heatmap toggle button 🔥:
```
🔥 Heatmap toggle clicked: false → true
⚙️ [ShowHeatmapState.toggle] false → true
🗺️ [MapPolygons] showHeatmap=true, provinces=63
  📍 Ha Noi: density=2400.5 → color=0xffb10026
  📍 TP Ho Chi Minh: density=1800.3 → color=0xffe31a1c
  ...
```

**If you see `provinces=0`:** map polygon geometries were not loaded from the local DB cache.
This usually means the GeoJSON seed step has not completed, the province geometry cache is missing, or the local GeoJSON asset is unavailable.

> Ensure `assets/geojson/gadm41_VNM_1.json` exists and is registered in `pubspec.yaml`.

**Expected colors based on density:**
- `0xffb10026` = Dark Red (> 2000 people/km²)
- `0xffe31a1c` = Red (1000-2000)
- `0xfffc4e2a` = Orange-Red (500-1000)
- `0xfffd8d3c` = Orange (250-500)
- `0xfffeb24c` = Yellow-Orange (100-250)
- `0xffffeda0` = Light Yellow (< 100)
- `0xffe5e5e5` = Grey (no data)

---

## 🔍 Debug Checklist

- [ ] **Toggle changes color?** Icon should go from white → orange when enabled
- [ ] **Console shows debug logs?** Check if density values are loaded
- [ ] **Map colors change?** When heatmap is on, provinces should change colors
- [ ] **Icon color matches toggle state?** Orange = on, white = off

---

## 🛠️ Common Problems & Fixes

### Problem: All provinces are **grey** (0xffe5e5e5)
**Cause:** Density values are `null` in database
**Fix:** Seed the database with density data from Hugging Face API

### Problem: **Icon doesn't change color**
**Cause:** State not updating
**Fix:** Check if `showHeatmapStateProvider` is being watched correctly

### Problem: **No debug logs in console**
**Cause:** Might be filtering logs
**Fix:** 
1. Open VS Code Debug Console
2. Clear filters (click the filter icon)
3. Search for "🔥" or "🗺️" symbols

