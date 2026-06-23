# Vietnam ChronoGIS — Generated Knowledge Prompting Guide
### Flutter Desktop App · Step-by-Step Build Playbook

> **Cách dùng tài liệu này:** Mỗi Step là một phiên làm việc độc lập với AI assistant. Copy nguyên phần **`[PROMPT DRAFT]`**, paste vào Claude/Cursor/Copilot, đính kèm file liên quan nếu có. Output của step trước là Input của step sau.

---

## Meta — Thông tin dự án

| | |
|---|---|
| **App name** | Vietnam ChronoGIS |
| **Platform** | Flutter Desktop (Windows / macOS / Linux) |
| **Data source** | `tmquan/sapnhap-bando-vn` (HuggingFace) + GADM GeoJSON |
| **AI engine** | Gemini 2.0 Flash via `google_generative_ai` |
| **State mgmt** | Riverpod |
| **Map engine** | `flutter_map` + OpenStreetMap |
| **Database** | SQLite via `drift` |
| **License** | CC BY-NC 4.0 (dataset) |

---

## PHASE 1 — Project Foundation & Shell

---

### Step 1.1 — Khởi tạo project & cấu hình Desktop

**🎯 Aim:** Có một Flutter project chạy được trên desktop với window size đúng, không crash, build thành công.

**📥 Input:**
- Máy đã cài Flutter SDK ≥ 3.22
- Chưa có project nào

**📤 Output:**
- Thư mục `vietnam_chronogis/`
- App mở cửa sổ 1400×900, title "Vietnam ChronoGIS"
- Hot reload hoạt động

**📋 Checklist hoàn thành:**
- [ ] `flutter run -d windows` (hoặc macos/linux) không lỗi
- [ ] Cửa sổ đúng kích thước
- [ ] `window_manager` package đã tích hợp

---

```
[PROMPT DRAFT — Step 1.1]

Tôi muốn tạo một Flutter Desktop app tên "Vietnam ChronoGIS".

Hãy tạo cho tôi:

1. Lệnh khởi tạo project đúng chuẩn:
   - Bật desktop support cho Windows, macOS, Linux
   - Package name: com.chronogis.vietnam

2. File pubspec.yaml hoàn chỉnh với các dependencies sau:
   - window_manager: ^0.3.8
   - flutter_riverpod: ^2.5.1
   - riverpod_annotation: ^2.3.5
   - go_router: ^13.2.0
   - dio: ^5.4.3
   - drift: ^2.18.0
   - drift_flutter: ^0.2.1
   - sqlite3_flutter_libs: ^0.5.0
   - flutter_map: ^6.1.0
   - latlong2: ^0.9.1
   - google_generative_ai: ^0.4.3
   - flutter_animate: ^4.5.0
   - shared_preferences: ^2.2.3
   - freezed_annotation: ^2.4.1
   - json_annotation: ^4.9.0
   
   Dev dependencies:
   - build_runner
   - drift_dev
   - freezed
   - json_serializable
   - riverpod_generator
   - custom_lint
   - riverpod_lint

3. File main.dart với:
   - WindowManager setup: minSize 1200×750, initialSize 1400×900
   - Title "Vietnam ChronoGIS"
   - Theme sáng/tối toggle
   - MaterialApp.router với go_router

4. Cấu trúc thư mục đầy đủ:
   lib/
     core/
       database/ (drift schema)
       router/ (go_router config)
       theme/ (ThemeData)
     features/
       map/        (map_view)
       explorer/   (province detail)
       archives/   (event list)
       ai_chat/    (gemini chat)
     shared/
       widgets/
       models/
       providers/
     data/
       api/        (huggingface fetch)
       repositories/

Giải thích ngắn mục đích từng thư mục.
```

---

### Step 1.2 — App Shell Layout (Navigation + Panels)

**🎯 Aim:** Dựng xong bộ khung UI chính đúng theo design: left sidebar + main content + bottom timeline.

**📥 Input:**
- Project từ Step 1.1
- File design `code.md` đã có (mô tả layout)

**📤 Output:**
- `AppShell` widget với 3 vùng: sidebar trái, main content, bottom bar
- Navigation rail với 4 tab: Map / Explorer / Archives / AI
- Sidebar width 280px, có thể collapse
- Bottom timeline placeholder

**📋 Checklist hoàn thành:**
- [ ] 4 tab điều hướng hoạt động
- [ ] Layout không vỡ khi resize cửa sổ
- [ ] Responsive: sidebar collapse khi width < 1000px

---

```
[PROMPT DRAFT — Step 1.2]

Tôi đang build Flutter Desktop app "Vietnam ChronoGIS".
Đây là layout mô tả từ file design:

- Bên trái: Sidebar 280px chứa search bar và danh sách tỉnh (có thể collapse)
- Giữa: Main content area (Map View mặc định)
- Dưới cùng: Timeline slider panel cao ~140px
- Navigation: 4 tab ở cạnh trái sidebar (Map, Explorer, Archives, AI)
  Icons tương ứng: map, explore, book, smart_toy

Viết cho tôi:

1. Widget `AppShell` (StatefulWidget) với:
   - Row layout: [NavigationRail] + [Sidebar] + [Expanded MainContent]
   - Column layout ngoài: [Row trên] + [TimelinePanel dưới]
   - Sidebar có AnimatedContainer để collapse (width 280 ↔ 0)
   - State management bằng Riverpod (StateProvider<int> cho selected tab)

2. `NavigationRailWidget`:
   - 4 destinations với icon và label
   - selectedIndex controlled by provider
   - Background color: Color(0xFF1A1D23) (dark sidebar)
   - Indicator color: Color(0xFF2D5A8E)

3. `SidebarWidget` placeholder với:
   - Header "Administrative Search" + SearchBar
   - Scrollable list placeholder
   - Footer "Database Sync Online" với dot indicator xanh

4. `TimelinePanel` placeholder cao 140px với:
   - Text "Chronological State" + năm hiện tại
   - Slider placeholder 1975..2025
   - Play button

5. `MainContentArea` dùng IndexedStack cho 4 tab
   Placeholder text cho từng tab

Dùng Material 3. Dark theme mặc định. 
Màu nền chính: Color(0xFF12151C).
```

---

### Step 1.3 — Theme System & Typography

**🎯 Aim:** Có một ThemeData nhất quán, dùng được xuyên suốt app, hỗ trợ dark/light toggle.

**📥 Input:**
- App shell từ Step 1.2

**📤 Output:**
- `AppTheme` class với `darkTheme` và `lightTheme`
- Font: Be Vietnam Pro (Google Fonts)
- Color scheme hoàn chỉnh
- `ThemeProvider` (Riverpod) lưu preference vào SharedPreferences

---

```
[PROMPT DRAFT — Step 1.3]

Tôi cần một theme system hoàn chỉnh cho Flutter Desktop app Vietnam ChronoGIS.

Yêu cầu:

1. Class `AppTheme` trong `lib/core/theme/app_theme.dart`:

   Dark Theme colors:
   - Background primary: #12151C
   - Background secondary: #1A1D23  
   - Background card: #1E2128
   - Surface: #252830
   - Primary accent: #2D5A8E (blue)
   - Secondary accent: #1D9E75 (teal/green)
   - Text primary: #E8EAF0
   - Text secondary: #9AA0B0
   - Border: #2A2D35
   - Success: #1D9E75
   - Warning: #BA7517
   - Error: #E24B4A

   Light Theme: derived automatically từ ColorScheme.fromSeed

2. Typography dùng google_fonts package:
   - Display/Heading: Be Vietnam Pro, weight 600
   - Body: Be Vietnam Pro, weight 400
   - Mono: JetBrains Mono (cho mã tỉnh, coordinates)
   
3. ThemeExtensions custom:
   - `MapThemeColors` (polygon colors, marker colors)
   - `TimelineThemeColors` (era colors)

4. `ThemeProvider` dùng Riverpod:
   - Đọc/ghi ThemeMode vào SharedPreferences
   - StateNotifierProvider<ThemeNotifier, ThemeMode>

5. Áp dụng vào `main.dart` với Consumer widget

Thêm `google_fonts: ^6.2.1` vào pubspec.yaml nếu chưa có.
```

---

## PHASE 2 — Data Layer

---

### Step 2.1 — Drift Database Schema

**🎯 Aim:** Định nghĩa đầy đủ schema SQLite cho toàn bộ dữ liệu địa lý và lịch sử.

**📥 Input:**
- Cấu trúc dataset HuggingFace (`provinces`, `communes` subsets)
- Columns quan trọng: `ma`, `ten`, `type`, `predecessors_list`, `centroid_lon/lat`, `bbox`, `macro_region`, `embed_text`, `population`, `area_km2`, `decree`

**📤 Output:**
- File `lib/core/database/app_database.dart` với Drift schema
- Generated files `.g.dart`
- Migration version 1

**📋 Checklist hoàn thành:**
- [ ] `dart run build_runner build` thành công
- [ ] Có thể insert/query 1 record test

---

```
[PROMPT DRAFT — Step 2.1]

Tôi cần viết Drift (Flutter SQLite ORM) schema cho app Vietnam ChronoGIS.

Dataset gốc từ HuggingFace có cấu trúc sau (đây là columns quan trọng):
- id: string (e.g. "diaphanhanhchinhcaptinh_sn.49")
- kind: "province" | "commune" | "committee"
- ma: string (mã hành chính, e.g. "79")
- ten: string (tên đầy đủ)
- type: string (Thành phố / Tỉnh / Thủ đô / Phường / Xã...)
- ten_short: string
- area_km2: double nullable
- population: double nullable
- density: double nullable
- capital: string nullable (trung tâm hành chính)
- address: string nullable
- decree: string (e.g. "Nghị quyết số 202/2025/QH15")
- decree_url: string
- predecessors: string (text dài mô tả sáp nhập)
- predecessors_list: List<String> (JSON array)
- n_predecessors: int
- parent_ma: string nullable (mã tỉnh cha, dành cho commune)
- parent_ten: string nullable
- centroid_lon: double nullable
- centroid_lat: double nullable
- bbox: List<double> (4 elements: minLon,minLat,maxLon,maxLat)
- macro_region: string (red_river_delta / mekong_delta / central_coast...)
- embed_text: string (dùng cho AI context)
- keywords: List<String>
- year_effective: int (năm có hiệu lực — 2025 cho dataset này)

Ngoài ra tôi cần thêm:
- Bảng `historical_events` để lưu sự kiện lịch sử thủ công
- Bảng `geojson_cache` để cache polygon GeoJSON theo mã tỉnh
- Bảng `chat_history` để lưu lịch sử chat AI

Viết cho tôi:

1. File `lib/core/database/tables/`:
   - `administrative_units_table.dart` (provinces + communes chung)
   - `historical_events_table.dart`
   - `geojson_cache_table.dart`
   - `chat_history_table.dart`

2. File `lib/core/database/app_database.dart`:
   - @DriftDatabase annotation
   - Tất cả tables và DAOs
   - SchemaVersion = 1
   - Migration callback

3. File `lib/core/database/daos/`:
   - `administrative_unit_dao.dart`: CRUD + queries theo kind, macro_region, ma
   - `geojson_dao.dart`: get/set cache theo ma
   - `chat_dao.dart`: insert message, get last N messages

4. Models Freezed tương ứng trong `lib/shared/models/`

Dùng drift: ^2.18.0. Giải thích cách lưu List<String> (dùng TextColumn + JSON encode).
```

---

### Step 2.2 — HuggingFace API Client

**🎯 Aim:** Fetch dữ liệu từ HuggingFace Datasets API, parse và seed vào SQLite local.

**📥 Input:**
- Schema từ Step 2.1
- Endpoint: `https://datasets-server.huggingface.co/rows?dataset=tmquan/sapnhap-bando-vn&config=provinces&split=train&offset=0&length=100`

**📤 Output:**
- `HuggingFaceApiClient` class
- `DataSeedService` chạy 1 lần khi app khởi động
- Progress indicator trong UI

---

```
[PROMPT DRAFT — Step 2.2]

Tôi cần viết service fetch dữ liệu từ HuggingFace Datasets API cho Flutter app.

API endpoint pattern:
GET https://datasets-server.huggingface.co/rows
  ?dataset=tmquan/sapnhap-bando-vn
  &config=provinces     (hoặc communes, committees)
  &split=train
  &offset=0
  &length=100

Response JSON structure:
{
  "rows": [
    {
      "row_idx": 0,
      "row": {
        "id": "diaphanhanhchinhcaptinh_sn.49",
        "kind": "province",
        "ma": "79",
        "ten": "Thành phố Hồ Chí Minh",
        "type": "Thành phố",
        "ten_short": "Hồ Chí Minh",
        "area_km2": 6772.59,
        "population": 14002598,
        "density": 2067.539597,
        "capital": "Tp. HCM (cũ)",
        "decree": "Nghị quyết số 202/2025/QH15",
        "decree_url": "https://vanban.chinhphu.vn/...",
        "predecessors": "TPHCM, tỉnh Bà Rịa - Vũng Tàu và tỉnh Bình Dương",
        "predecessors_list": ["TPHCM", "tỉnh Bà Rịa - Vũng Tàu", "tỉnh Bình Dương"],
        "n_predecessors": 3,
        "parent_ma": null,
        "centroid_lon": 106.843627,
        "centroid_lat": 10.864358,
        "bbox": [102.14, 8.41, 109.45, 23.39],
        "macro_region": "southeast",
        "embed_text": "Thành phố Hồ Chí Minh ; loại: Thành phố ; sáp nhập từ: ...",
        "keywords": ["tỉnh", "rịa", "vũng", "dương"]
      }
    }
  ],
  "num_rows_total": 34
}

Viết cho tôi:

1. `lib/data/api/huggingface_api_client.dart`:
   - Dùng Dio
   - Method `fetchRows({required String config, int offset = 0, int length = 100})`
   - Tự động paginate nếu total > length
   - Retry logic 3 lần khi timeout
   - Typed response với Freezed model `HuggingFaceResponse`

2. `lib/data/api/models/hf_row_model.dart`:
   - Freezed + JsonSerializable
   - Handle nullable fields
   - Parse `bbox` từ List<dynamic> → List<double>
   - Parse `predecessors_list` từ List<dynamic> → List<String>

3. `lib/data/repositories/administrative_unit_repository.dart`:
   - Method `seedFromApi()`: fetch cả 3 subsets (provinces, communes)
   - Upsert vào Drift database
   - Return stream Progress (0.0 → 1.0)

4. `lib/shared/providers/seed_provider.dart` (Riverpod):
   - FutureProvider check xem đã seed chưa (dùng SharedPreferences key "seeded_v1")
   - Nếu chưa → chạy seed → set key
   - Expose seedProgress stream

5. `SeedingScreen` widget hiển thị khi đang seed:
   - LinearProgressIndicator
   - Text "Đang tải dữ liệu địa lý Vietnam..."
   - Tự động navigate sang AppShell khi xong

Chú ý: communes có ~3320 rows, cần paginate (100 rows/request × 34 requests).
Thêm timeout 30 seconds, log progress ra console.
```

---

### Step 2.3 — GeoJSON Integration (GADM)

**🎯 Aim:** Load polygon ranh giới tỉnh, join với data từ HuggingFace theo mã tỉnh.

**📥 Input:**
- File GeoJSON từ GADM Vietnam Level 1 (user tự download tại gadm.org/download_country.html → VNM → level 1)
- Database từ Step 2.1

**📤 Output:**
- GeoJSON parser service
- Polygons cached trong SQLite
- Method `getPolygonByMa(String ma)` → `List<LatLng>`

---

```
[PROMPT DRAFT — Step 2.3]

Tôi có file GeoJSON từ GADM Vietnam Level 1 đặt tại assets/geojson/gadm41_VNM_1.json.
File này chứa polygon ranh giới của 34 tỉnh/thành Việt Nam (sau sáp nhập 2025 — 
hoặc tôi sẽ dùng bản 63 tỉnh cũ, tùy theo bạn tư vấn cái nào phù hợp hơn).

Cấu trúc GeoJSON chuẩn:
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "GID_1": "VNM.1_1",
        "NAME_1": "An Giang",
        "VARNAME_1": "...",
        "TYPE_1": "Tỉnh"
      },
      "geometry": {
        "type": "MultiPolygon",
        "coordinates": [[[[lon, lat], ...]]]
      }
    }
  ]
}

Tôi cần join GADM data với HuggingFace data theo tên tỉnh (vì mã có thể khác).

Viết cho tôi:

1. `lib/data/geojson/geojson_parser.dart`:
   - Parse file từ assets (rootBundle.loadString)
   - Model `GeoJsonFeature` với properties và geometry
   - Support MultiPolygon và Polygon
   - Convert coordinates → `List<List<LatLng>>` (outer ring + holes)

2. `lib/data/geojson/province_geojson_service.dart`:
   - Load và parse GeoJSON khi app start
   - Method `matchToDatabase()`: fuzzy match NAME_1 với ten_short trong SQLite
     (normalize: bỏ "Tỉnh", "Thành phố", lowercase, remove diacritics)
   - Lưu kết quả match vào `geojson_cache` table (serialize coordinates → JSON string)
   - Method `getPolygons(String ma)` → `List<List<LatLng>>` (từ cache)

3. Fuzzy matching logic:
   - Strip prefixes: "Tỉnh", "Thành phố", "Thủ đô", "TP."
   - Normalize Unicode (NFD → ASCII fallback)
   - Levenshtein distance nếu exact match thất bại
   - Log các match thất bại để tôi fix thủ công

4. `pubspec.yaml` update: thêm assets/geojson/ folder

5. Test case: in ra 5 tỉnh đầu tiên với polygon point count để verify

Tư vấn thêm: dùng GADM bản 63 tỉnh (trước 2025) hay 34 tỉnh (sau 2025)?
Lý do tôi cần biết để chọn đúng file download.
```

---

## PHASE 3 — Map Feature

---

### Step 3.1 — Map View cơ bản với flutter_map

**🎯 Aim:** Hiển thị bản đồ Vietnam, zoom đúng, có polygon ranh giới tỉnh.

**📥 Input:**
- GeoJSON service từ Step 2.3
- Database có centroid data

**📤 Output:**
- `MapViewScreen` với flutter_map
- PolygonLayer hiển thị 34 tỉnh
- Màu sắc theo `macro_region`
- Tap vào tỉnh → highlight + show popup

---

```
[PROMPT DRAFT — Step 3.1]

Tôi cần build Map View screen cho Flutter Desktop app Vietnam ChronoGIS dùng flutter_map ^6.1.0.

Yêu cầu kỹ thuật:

1. `lib/features/map/presentation/map_view_screen.dart`:
   - FlutterMap widget với TileLayer (OpenStreetMap)
   - Center: LatLng(16.0, 106.0), zoom: 5.5
   - interactionOptions: enable scroll/drag/pinch
   - MapController (expose qua Riverpod provider)

2. PolygonLayer với 34 tỉnh:
   - Data load từ `ProvinceGeoJsonService.getPolygons(ma)`
   - Mỗi polygon có color theo macro_region:
     * red_river_delta: Color(0x552D5A8E)
     * northern_midlands: Color(0x55378ADD)
     * central_coast: Color(0x551D9E75)
     * central_highlands: Color(0x55BA7517)
     * southeast: Color(0x55E24B4A)
     * mekong_delta: Color(0x55534AB7)
     * (default): Color(0x55888780)
   - border: 1px màu sáng hơn 40%
   - selected polygon: fill opacity tăng lên 0x99, border 2px trắng

3. Tap detection:
   - Dùng GestureDetector + TapLayer hoặc polygon onTap
   - Khi tap → update `selectedProvinceProvider` (StateProvider<String?> chứa ma)
   - Hiển thị ProvinceInfoPopup (floating card bottom-right)

4. `ProvinceInfoPopup` widget:
   - Tên tỉnh (lớn)
   - Loại (badge: Thành phố / Tỉnh / Thủ đô)
   - Population: format "14.0 triệu"
   - Area: format "6,772 km²"  
   - Predecessors count badge (nếu n_predecessors > 1 → "MERGED từ X tỉnh")
   - Button "Xem chi tiết" → navigate Explorer tab

5. MapControlsWidget (floating, cạnh phải):
   - Button zoom in/out
   - Button "Fit Vietnam" → flyTo center
   - Button toggle satellite/street tile layer
   - Button toggle province borders on/off

6. Provider:
   - `mapControllerProvider`: StateProvider<MapController>
   - `selectedProvinceProvider`: StateProvider<String?> (ma code)
   - `mapTileStyleProvider`: StateProvider<TileStyle> (enum: street/satellite)
   - `showBordersProvider`: StateProvider<bool>

Lưu ý: flutter_map v6 dùng MapOptions thay vì FlutterMapState.
```

---

### Step 3.2 — Timeline Slider & Chronological State

**🎯 Aim:** Timeline 1975–2025 interactive, khi kéo → map cập nhật trạng thái hành chính theo năm.

**📥 Input:**
- Map View từ Step 3.1
- Historical events data (seed thủ công)

**📤 Output:**
- `TimelinePanel` với custom slider
- Play/pause auto-advance animation
- Map polygons filter theo năm
- `RegionalProfileCard` cập nhật realtime

---

```
[PROMPT DRAFT — Step 3.2]

Tôi cần build Timeline Panel cho Vietnam ChronoGIS — thanh trượt thời gian 1975→2025.

Context lịch sử quan trọng cần hard-code:
- 1975: Giải phóng miền Nam, 2 miền thống nhất
- 1976: Sáp nhập lớn đầu tiên, 61 tỉnh → 38 tỉnh
- 1979–1991: Thời kỳ Bao Cấp
- 1986: Đổi Mới bắt đầu
- 1991–1997: Tách tỉnh (38 → 61 tỉnh, kinh tế phân cấp)
- 1997–2007: Ổn định 61 tỉnh
- 2008: Hà Nội mở rộng (sáp nhập Hà Tây)
- 2025: Sáp nhập lớn theo NQ 202, 63 → 34 tỉnh

Viết cho tôi:

1. `lib/shared/models/timeline_era.dart`:
   Enum `VietnamEra` với values và metadata:
   - reunification(1975..1976)
   - postWarConsolidation(1976..1986)
   - doiMoi(1986..1997)
   - provinceExpansion(1997..2008)
   - hanoiExpansion(2008..2025)
   - merger2025(2025..2025)
   
   Extension methods: label (tên era), color, description (tiếng Việt), provinceCount

2. `lib/shared/providers/timeline_provider.dart`:
   - `selectedYearProvider`: StateProvider<int> (default: 2025)
   - `isPlayingProvider`: StateProvider<bool>
   - `currentEraProvider`: Provider<VietnamEra> (derived từ selectedYear)
   - `playbackController`: class dùng Timer để auto-advance 1 năm/giây
     * Stop tự động khi đến 2025
     * Speed: 1 năm/500ms

3. `lib/features/map/presentation/widgets/timeline_panel.dart`:
   - Height: 140px, background: Color(0xFF1A1D23)
   - Row trên: Era label (màu theo era) + năm lớn (48px, bold) + play/pause button
   - Slider giữa: 1975..2025, divisions: 50
     * Custom track: gradient màu theo era
     * Custom thumb: hình tròn với năm bên trong
   - Row dưới: markers tại 1976, 1986, 1997, 2008, 2025 với label
   - `RegionalProfileCard` hiển thị inline:
     * "Total Provinces: X" (thay đổi theo năm)
     * Status badge (era name)
     * "Significant Change" text nếu năm đó có sự kiện

4. Province count logic theo năm:
   - 1975: 44 (nam) + 22 (bắc) = 66 ≈ hiển thị ~66
   - 1976: 38
   - 1991–1997: 53..61 (tăng dần từng năm khi tách)
   - 2004: 64
   - 2008: 63 (Hà Nội + Hà Tây = 1)
   - 2025: 34
   
   Viết helper function `getProvinceCountForYear(int year) → int`

5. Animation: khi selectedYear thay đổi, map dùng `flutter_animate` để:
   - Fade polygons out/in (150ms)
   - Snap TimelinePanel year label với số đếm animation

Dùng Riverpod Consumer để map lắng nghe selectedYearProvider.
```

---

## PHASE 4 — AI Insights Feature

---

### Step 4.1 — Gemini API Integration

**🎯 Aim:** Kết nối Gemini 2.0 Flash, có system prompt chứa toàn bộ context lịch sử VN.

**📥 Input:**
- `google_generative_ai: ^0.4.3` đã có trong pubspec
- `embed_text` từ database (pre-built text cho mỗi tỉnh)

**📤 Output:**
- `GeminiService` class
- Streaming response
- Context-aware: inject năm + tỉnh đang chọn vào mỗi query

---

```
[PROMPT DRAFT — Step 4.1]

Tôi cần tích hợp Gemini 2.0 Flash vào Flutter app Vietnam ChronoGIS.

Viết cho tôi:

1. `lib/data/api/gemini_service.dart`:
   
   System Prompt (viết tiếng Việt + tiếng Anh):
   ---
   Bạn là một chuyên gia lịch sử địa lý hành chính Việt Nam cho ứng dụng Vietnam ChronoGIS.
   
   Kiến thức nền:
   - Việt Nam thống nhất năm 1975, tái cấu trúc hành chính 1976 (61→38 tỉnh)
   - Đổi Mới 1986: chuyển sang kinh tế thị trường
   - 1991-1997: Tách tỉnh để quản lý phân cấp (38→61 tỉnh)
   - 2008: Hà Nội sáp nhập Hà Tây, mở rộng gấp đôi
   - 2025: Nghị quyết 202/2025/QH15 sáp nhập 63→34 tỉnh/thành
   
   Trả lời ngắn gọn, chính xác, bằng ngôn ngữ người dùng hỏi.
   Khi đề cập sự kiện, nêu rõ năm và số hiệu nghị quyết nếu có.
   ---
   
   Dynamic context (inject vào mỗi request):
   - Năm đang xem trên timeline: {current_year}
   - Tỉnh đang được chọn: {selected_province_embed_text}
   - Số tỉnh thời điểm đó: {province_count}
   
   Methods:
   - `sendMessage(String userMessage, {required ChatContext context})` → Stream<String>
   - `generateSuggestedQuestions(ChatContext context)` → Future<List<String>>
   
   Model: "gemini-2.0-flash"
   Max tokens: 1024
   Temperature: 0.7

2. `lib/shared/models/chat_context.dart` (Freezed):
   - currentYear: int
   - selectedProvinceMa: String?
   - selectedProvinceEmbedText: String?
   - provinceCount: int
   - currentEra: String

3. `lib/shared/models/chat_message.dart` (Freezed):
   - id: String (uuid)
   - role: MessageRole (user/assistant)
   - content: String
   - timestamp: DateTime
   - isStreaming: bool

4. `lib/data/repositories/chat_repository.dart`:
   - Lưu messages vào Drift `chat_history` table
   - `getChatHistory()` → Stream<List<ChatMessage>>
   - `clearHistory()`

5. `lib/shared/providers/chat_provider.dart` (Riverpod):
   - `chatMessagesProvider`: StreamProvider<List<ChatMessage>>
   - `chatNotifierProvider`: AsyncNotifier với method `sendMessage(String)`
   - Xử lý streaming: append từng chunk vào message đang stream
   - Error handling: hiển thị error message trong chat

6. API Key management:
   - Đọc từ environment variable: `const String.fromEnvironment('GEMINI_API_KEY')`
   - Fallback: đọc từ SharedPreferences (user nhập vào Settings)
   - Ném `ApiKeyMissingException` nếu không có key

Lưu ý: flutter_secure_storage cho production, String.fromEnvironment cho dev.
```

---

### Step 4.2 — AI Chat UI

**🎯 Aim:** Chat interface đẹp theo design, streaming response, suggested questions.

**📥 Input:**
- GeminiService từ Step 4.1

**📤 Output:**
- `AiInsightsPanel` widget
- Bubble chat với streaming animation
- Suggested questions chip
- "GEMINI 2.0" badge theo design

---

```
[PROMPT DRAFT — Step 4.2]

Tôi cần build AI Insights panel cho Vietnam ChronoGIS theo design này:

Design spec:
- Panel nằm trong tab "AI" của app
- Header: "AI Insights" + badge "GEMINI-2.0" (teal background) + "Analysis Engine"
- Scrollable chat area (ngược chiều — tin nhắn mới ở dưới)
- Input bar cuối cùng với TextField + send IconButton
- Suggested question chips hiển thị khi chat trống

Viết cho tôi:

1. `lib/features/ai_chat/presentation/ai_insights_screen.dart`:
   Layout:
   - Column: [AiHeader] + [Expanded ChatArea] + [SuggestedChips (nếu empty)] + [ChatInputBar]

2. `AiHeaderWidget`:
   - "AI Insights" text 18px bold
   - Container badge: "GEMINI-2.0" với background Color(0xFF0F6E56), text trắng, rounded
   - "Analysis Engine" subtext màu secondary

3. `ChatMessageBubble` widget:
   User bubble:
   - Align right
   - Background: Color(0xFF2D5A8E)
   - Text trắng, border-radius: 18 12 4 18
   
   AI bubble:
   - Align left  
   - Background: Color(0xFF1E2128)
   - Text light, border-radius: 4 18 18 12
   - Khi isStreaming=true: hiển thị animated dots cuối text (3 dots fade in/out)

4. `StreamingTextWidget`:
   - Nhận Stream<String> từ GeminiService
   - Build text từng chunk, auto-scroll xuống
   - Dùng flutter_animate cho smooth appearance của từng character chunk

5. `SuggestedQuestionsWidget`:
   - Wrap layout với ActionChip
   - 4 câu hỏi gợi ý từ `generateSuggestedQuestions()`
   - Ví dụ khi chọn tỉnh HCM năm 2025:
     * "Tại sao Bình Dương sáp nhập vào TPHCM?"
     * "So sánh diện tích trước và sau sáp nhập"
     * "Vùng kinh tế Đông Nam Bộ gồm những tỉnh nào?"
   - Loading: 3 skeleton chips

6. `ChatInputBar`:
   - TextField với hintText "Hỏi về lịch sử hành chính..."
   - Send button: Icon send, disable khi TextField trống hoặc đang stream
   - Ctrl+Enter gửi (desktop shortcut)
   - Clear button khi có text

7. Context display bar (nhỏ, trên input):
   - Hiển thị: "Đang xem: 2025 · Hồ Chí Minh" (dùng Riverpod watch selectedYear + selectedProvince)
   - Background: Color(0xFF12151C), text secondary

Dùng flutter_animate cho message appear animation (fadeIn + slideUp, 150ms).
Auto-scroll: ScrollController, animateTo bottom khi có message mới.
```

---

## PHASE 5 — Explorer & Archives

---

### Step 5.1 — Explorer Tab (Province Detail)

**🎯 Aim:** Màn hình chi tiết một tỉnh: thông tin, lịch sử sáp nhập, stats.

**📥 Input:**
- Database với đầy đủ data
- `selectedProvinceProvider`

**📤 Output:**
- `ExplorerScreen` với province detail
- Merge history tree visualization
- Stats cards

---

```
[PROMPT DRAFT — Step 5.1]

Tôi cần build Explorer tab cho Vietnam ChronoGIS — hiển thị chi tiết một tỉnh.

Khi không có tỉnh nào được chọn: placeholder "Chọn một tỉnh/thành phố trên bản đồ"

Khi đã chọn tỉnh (ví dụ Thành phố Hồ Chí Minh):

1. `lib/features/explorer/presentation/explorer_screen.dart`:
   
   Layout (ScrollView):
   - [ProvinceHeroHeader]
   - [StatsRow]  
   - [MergeHistorySection]
   - [AdministrativeInfoSection]
   - [CommnesListSection]

2. `ProvinceHeroHeader`:
   - Tên tỉnh lớn (display font, 32px)
   - Loại badge (Thành phố / Tỉnh / Thủ đô)
   - Macro region badge với màu tương ứng
   - Mini map thumbnail (flutter_map, non-interactive, chỉ hiện polygon tỉnh đó)

3. `StatsRow` — 3 cards ngang:
   - Diện tích: "6,772 km²"
   - Dân số: "14.0 triệu"
   - Mật độ: "2,068 người/km²"
   Format số: NumberFormat với separator dấu phẩy, đơn vị rõ ràng

4. `MergeHistorySection`:
   - Title "Lịch sử sáp nhập"
   - Nếu n_predecessors == 1 và predecessors == "giữ nguyên": 
     * Badge "KHÔNG THAY ĐỔI" (green) + text "Giữ nguyên ranh giới"
   - Nếu n_predecessors > 1:
     * Badge "SÁP NHẬP" (amber) + "Sáp nhập từ {n} đơn vị"
     * Timeline widget đơn giản:
       [Tỉnh A] + [Tỉnh B] → [Tỉnh mới] (năm 2025)
     * Mỗi predecessor: chip có tên, có thể click để search
   - Decree reference: link text "Nghị quyết 202/2025/QH15" → mở URL

5. `AdministrativeInfoSection`:
   - Trung tâm hành chính (capital)
   - Địa chỉ trụ sở
   - Vùng kinh tế (macro_region, tiếng Việt)
   - Mã hành chính (ma)

6. `CommunesListSection`:
   - Title "Đơn vị hành chính cấp xã ({count} phường/xã)"
   - ListView.separated, tối đa 20 rows + "Xem thêm"
   - Mỗi row: tên xã + loại (Phường/Xã) + n_predecessors badge

Provider: `selectedProvinceDetailProvider` — FutureProvider.family(ma) 
fetch từ database cả province + communes của nó.
```

---

### Step 5.2 — Archives Tab

**🎯 Aim:** Danh sách sự kiện hành chính lịch sử, filter theo năm/loại.

**📥 Input:**
- Historical events table
- Seed data thủ công

**📤 Output:**
- `ArchivesScreen` với searchable event list
- Filter chips
- Event detail card

---

```
[PROMPT DRAFT — Step 5.2]

Tôi cần build Archives tab — danh sách sự kiện lịch sử hành chính Việt Nam.

BƯỚC 1: Seed data thủ công cho historical_events table.
Viết Dart code để insert các sự kiện này:

Năm | Loại | Tiêu đề | Mô tả ngắn
1975 | UNIFICATION | Thống nhất đất nước | Ngày 30/4/1975, miền Nam hoàn toàn giải phóng. Cả nước có 2 đơn vị hành chính lớn: miền Bắc (22 tỉnh) và miền Nam (44 tỉnh).
1976 | MERGE | Đại hợp nhất 1976 | Nghị quyết kỳ họp Quốc hội thống nhất: sáp nhập 61 tỉnh thành 38 tỉnh, đổi tên Sài Gòn thành TP. Hồ Chí Minh.
1986 | POLICY | Đổi Mới | Đại hội VI quyết định chuyển sang kinh tế thị trường định hướng XHCN. Bắt đầu làn sóng tách tỉnh để quản lý phân cấp.
1991 | SPLIT | Tách tỉnh giai đoạn 1 | Nhiều tỉnh lớn được tách đôi: Sông Bé → Bình Dương + Bình Phước, Hà Sơn Bình → Hà Tây + Hòa Bình...
1997 | SPLIT | Tách tỉnh giai đoạn 2 | Hoàn tất quá trình tách tỉnh: từ 38 lên 61 tỉnh + TP trực thuộc TW. Đà Nẵng tách khỏi Quảng Nam-Đà Nẵng.
2004 | REFORM | 64 tỉnh thành | Đắk Nông tách khỏi Đắk Lắk, lên 64 tỉnh/thành.
2008 | MERGE | Hà Nội mở rộng | Hà Tây sáp nhập vào Hà Nội + một phần Vĩnh Phúc + Hòa Bình. Hà Nội tăng gấp 3 lần diện tích. Về còn 63 tỉnh/thành.
2025 | MERGE | Sáp nhập lịch sử 2025 | Nghị quyết 202/2025/QH15: 63 tỉnh/thành → 34 tỉnh/thành. Cuộc sáp nhập hành chính lớn nhất lịch sử hiện đại Việt Nam.

BƯỚC 2: `lib/features/archives/presentation/archives_screen.dart`:

1. SearchBar + FilterChips:
   - Filter types: TẤT CẢ / MERGE / SPLIT / REFORM / POLICY / UNIFICATION
   - Mỗi type có màu badge riêng

2. `EventCard` widget:
   - Năm (lớn, màu accent)
   - Type badge
   - Tiêu đề (bold)
   - Mô tả 2 dòng, expandable
   - Nút "Xem trên bản đồ" → set selectedYear + navigate Map tab

3. Timeline visualization bên trái:
   - Vertical line với dots tại mỗi sự kiện
   - Khoảng cách tỷ lệ với năm (1975-2025)
   - Dot size tỷ lệ với "magnitude" (số tỉnh thay đổi)

4. Province count mini chart:
   - Trên cùng: simple line chart bằng CustomPainter
   - X: 1975→2025, Y: số tỉnh (66→38→61→64→63→34)
   - Đánh dấu các điểm turning point

Provider: `archivesFilterProvider`: StateProvider<EventType?> (null = all)
`filteredEventsProvider`: Provider derived từ filter + database query
```

---

## PHASE 6 — Polish & Finishing

---

### Step 6.1 — Search & Navigation

**🎯 Aim:** Search bar sidebar hoạt động, kết quả click → map fly-to tỉnh.

---

```
[PROMPT DRAFT — Step 6.1]

Tôi cần build chức năng Search trong sidebar cho Vietnam ChronoGIS.

1. `lib/features/map/presentation/widgets/admin_search_bar.dart`:
   - TextField với prefix icon search
   - Debounce 300ms
   - Clear button khi có text
   - Keyboard shortcut Ctrl+F focus vào search

2. Search logic:
   - Query SQLite: WHERE ten LIKE '%query%' OR ten_short LIKE '%query%' OR ma = query
   - Kết quả ưu tiên: province > commune
   - Tối đa 10 kết quả
   - Highlight matching text trong kết quả

3. `SearchResultsList`:
   - Hiển thị dưới SearchBar như dropdown overlay
   - Mỗi result: icon (province vs commune) + tên + loại badge
   - Hover effect
   - Click → set selectedProvince + mapController.flyTo(centroid, zoom: 9)
   - Escape → đóng dropdown

4. `RegionListWidget` (sidebar, dưới search):
   - Luôn hiển thị top 5 tỉnh theo dân số khi không search
   - Filter theo macro_region qua DropdownButton
   - Mỗi card: tên tỉnh + badge loại (CURRENT/CAPITAL/REFORMED/HISTORICAL theo design gốc)
     * CAPITAL → Hà Nội
     * CURRENT → TP HCM  
     * REFORMED → tỉnh có n_predecessors > 1
     * UNCHANGED → n_predecessors == 1

5. Provider:
   - `searchQueryProvider`: StateProvider<String>
   - `searchResultsProvider`: FutureProvider.family(query) → gọi database search
   - `regionFilterProvider`: StateProvider<String?> (macro_region filter)
```

---

### Step 6.2 — Settings Panel & API Key

**🎯 Aim:** Settings screen cho user nhập Gemini API key, chọn theme, ngôn ngữ.

---

```
[PROMPT DRAFT — Step 6.2]

Tôi cần Settings panel cho Vietnam ChronoGIS.

Mở bằng: click icon settings trên top app bar.
Hiển thị: Drawer từ phải (width 320px) hoặc Dialog tùy desktop UX.

Sections:

1. AI Configuration:
   - TextField "Gemini API Key" (obscureText, toggle show/hide)
   - Button "Test kết nối" → gọi simple API call, show checkmark hoặc error
   - Link "Lấy API key tại Google AI Studio"
   - Lưu vào flutter_secure_storage

2. Appearance:
   - ThemeMode toggle: Tối / Sáng / Hệ thống
   - Map tile selector: OpenStreetMap / CartoDB Dark / Satellite

3. Data:
   - "Cập nhật dữ liệu" button → re-seed từ HuggingFace
   - "Xóa cache bản đồ" button → clear geojson_cache table
   - "Xóa lịch sử chat" button
   - Database info: "6,712 bản ghi · Cập nhật: {date}"

4. About:
   - Version app
   - "Dữ liệu: tmquan/sapnhap-bando-vn (CC BY-NC 4.0)"
   - Link GitHub

Viết `SettingsNotifier` (Riverpod AsyncNotifier) xử lý tất cả settings logic.
Persist settings vào SharedPreferences (non-sensitive) và SecureStorage (API key).
```

---

### Step 6.3 — Build & Packaging

**🎯 Aim:** Build ra file exe/dmg/deb có thể distribute.

---

```
[PROMPT DRAFT — Step 6.3]

Tôi cần hướng dẫn đầy đủ build và package Vietnam ChronoGIS cho desktop.

Viết cho tôi:

1. Windows:
   - `flutter build windows --release --dart-define=GEMINI_API_KEY=xxx`
   - Inno Setup script (installer.iss) tạo file .exe installer
   - Include: app icon, license, uninstaller
   - App icon: hướng dẫn tạo file .ico từ PNG 1024x1024

2. macOS:
   - `flutter build macos --release`
   - Tạo .dmg với create-dmg tool
   - Info.plist: CFBundleName, CFBundleIdentifier, minimum macOS 12
   - Entitlements: network.client (cho API calls)

3. Linux:
   - `flutter build linux --release`
   - Tạo .deb package
   - .desktop file cho application menu

4. CI/CD GitHub Actions workflow (`.github/workflows/build.yml`):
   - Trigger: push tag v*
   - Build 3 platforms (Windows, macOS, Linux)
   - Upload artifacts
   - Secret: GEMINI_API_KEY từ GitHub Secrets

5. Pre-build checklist:
   - Verify tất cả assets đã declare trong pubspec.yaml
   - `flutter analyze` không error
   - Remove debug prints
   - Version bump trong pubspec.yaml
   - Kiểm tra API key không hardcode trong code

6. App icon setup:
   - Package `flutter_launcher_icons: ^0.13.1`
   - Config trong pubspec.yaml
   - Lệnh generate: `dart run flutter_launcher_icons`

Tôi đang dùng: Flutter 3.22, Windows 11, target cả 3 platform.
```

---

## APPENDIX

---

### Appendix A — Troubleshooting Prompts

```
[PROMPT — Fix flutter_map polygon tap detection]

Trong Flutter Desktop với flutter_map v6, tôi dùng PolygonLayer để hiển thị 
ranh giới tỉnh nhưng tap detection không hoạt động. 
Code hiện tại: [paste code]
Error/behavior: [mô tả]
Hãy debug và fix, giải thích tại sao vấn đề xảy ra.
```

```
[PROMPT — Fix Drift migration error]

App crash với error: [paste error message]
Database schema version: [X]
Migration code: [paste code]
Hãy viết migration đúng và giải thích cách Drift handle schema changes.
```

```
[PROMPT — Fix GeoJSON polygon matching]

Service matchToDatabase() của tôi không match được X tỉnh:
Matched: [list]
Failed: [list]
GADM names: [list]
Database ten_short: [list]
Hãy cải thiện fuzzy matching algorithm.
```

```
[PROMPT — Optimize map performance]

Map bị lag khi hiển thị 34 polygons với nhiều vertices (một số tỉnh có 30k vertices).
FPS khoảng 15-20 thay vì 60.
Hãy suggest cách optimize: simplify polygons, LOD, lazy loading, hoặc dùng WebGL.
```

---

### Appendix B — Quick Reference

**API Endpoints:**
```
# HuggingFace Datasets API
GET https://datasets-server.huggingface.co/rows
  ?dataset=tmquan/sapnhap-bando-vn
  &config=provinces|communes|committees
  &split=train
  &offset=0
  &length=100

# Gemini API (dùng qua google_generative_ai package)
model: gemini-2.0-flash-exp

# OSM Tile
https://tile.openstreetmap.org/{z}/{x}/{y}.png

# CartoDB Dark
https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png
```

**Key Province Counts by Year:**
```
1975: ~66  |  1976: 38  |  1991: 53
1997: 61   |  2004: 64  |  2008: 63  |  2025: 34
```

**Macro Regions (7 vùng):**
```
red_river_delta    → Đồng bằng sông Hồng
northern_midlands  → Trung du và miền núi phía Bắc
central_coast      → Duyên hải miền Trung
central_highlands  → Tây Nguyên
southeast          → Đông Nam Bộ
mekong_delta       → Đồng bằng sông Cửu Long
northeast          → Đông Bắc
```

**SQLite Queries hay dùng:**
```sql
-- Provinces by macro_region
SELECT * FROM administrative_units WHERE kind = 'province' AND macro_region = ?

-- Search
SELECT * FROM administrative_units 
WHERE (ten LIKE '%' || ? || '%' OR ten_short LIKE '%' || ? || '%')
AND kind IN ('province', 'commune')
LIMIT 10

-- Communes of a province
SELECT * FROM administrative_units 
WHERE kind = 'commune' AND parent_ma = ?
ORDER BY ten ASC
```

---

*Document version: 1.0 · Vietnam ChronoGIS · Generated Knowledge Prompting Guide*
*Cập nhật theo dataset tmquan/sapnhap-bando-vn · NQ 202/2025/QH15*
