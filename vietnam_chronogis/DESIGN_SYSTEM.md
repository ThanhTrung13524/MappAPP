# Vietnam ChronoGIS — Design System

> **Dành cho AI agents**: Đây là tài liệu tham chiếu thiết kế duy nhất cho dự án `vietnam_chronogis`. Mọi UI mới, component, màn hình, hay widget đều phải tuân thủ hệ thống này. Không được tự ý dùng màu sắc, font, spacing, hay pattern ngoài những gì định nghĩa dưới đây trừ khi có lý do rõ ràng và được ghi chú.

---

## 1. Tổng quan dự án

| Thuộc tính | Giá trị |
|---|---|
| **Tên app** | Vietnam ChronoGIS |
| **Mục đích** | Bản đồ lịch sử hành chính Việt Nam + Quảng bá du lịch cho người nước ngoài |
| **Nền tảng** | Flutter (Desktop, Web, Mobile) |
| **Kích thước tối thiểu** | 1200 × 750px (desktop-first) |
| **Ngôn ngữ UI** | Song ngữ: Tiếng Việt + English |
| **Theme hiện tại** | Dark mode (mặc định), hỗ trợ Light mode |

### Aesthetic Direction

**"Cartographic Intelligence"** — Giao thoa giữa bản đồ địa lý cổ điển và giao diện dữ liệu hiện đại. Tối tăm, dày đặc thông tin, nhưng có chiều sâu và tinh tế. Cảm giác như đang nhìn vào một command center nghiên cứu lịch sử.

- Nền tối như màn đêm → nội dung nổi lên như ánh đèn thành phố
- Typography rõ ràng, monospace cho số liệu
- Màu sắc mang ý nghĩa: mỗi era lịch sử một màu
- Animation tinh tế, không phô trương

---

## 2. Color System

### 2.1 Background Palette

```dart
// Dùng đúng các giá trị này, KHÔNG dùng Colors.black hay Colors.grey
const Color backgroundPrimary   = Color(0xFF12151C); // Nền chính toàn app
const Color backgroundCard      = Color(0xFF1E2128); // Card, panel, popup
const Color backgroundElevated  = Color(0xFF1A1D23); // Nav rail, sidebar, bottom bar
const Color backgroundOverlay   = Color(0xFF252830); // Dropdown, tooltip, dialog
```

### 2.2 Brand Colors

```dart
const Color brandPrimary   = Color(0xFF2D5A8E); // Blue — action chính, button, indicator
const Color brandSecondary = Color(0xFF1D9E75); // Teal/Green — AI, success, live status
const Color brandDanger    = Color(0xFFE24B4A); // Red — error, alert
```

### 2.3 Text Colors

```dart
const Color textPrimary    = Color(0xFFE8EAF0); // Tiêu đề, nội dung chính
const Color textSecondary  = Color(0xFF9AA0B0); // Label phụ, caption, placeholder
const Color textDisabled   = Colors.white38;     // 0.38 opacity trên nền tối
const Color textHint       = Colors.white.withValues(alpha: 0.3);
```

### 2.4 Border & Divider

```dart
const borderSubtle  = Colors.white — opacity 0.05  // Border card bình thường
const borderVisible = Colors.white — opacity 0.10  // Border có thể thấy rõ
const divider       = Colors.white12               // Divider ngang/dọc
```

### 2.5 Era Colors (Timeline)

Mỗi giai đoạn lịch sử có màu riêng. KHÔNG thay đổi các màu này vì chúng mang nghĩa ngữ nghĩa:

```dart
// VietnamEra.color — dùng khi hiển thị thông tin era
reunification:         Color(0xFFE53935) // Đỏ — Thống nhất 1975–1976
postWarConsolidation:  Color(0xFF8E24AA) // Tím — Bao cấp 1976–1986
doiMoi:                Color(0xFF1E88E5) // Xanh dương — Đổi Mới 1986–1997
provinceExpansion:     Color(0xFF43A047) // Xanh lá — Chia tách 1997–2008
hanoiExpansion:        Color(0xFFFDD835) // Vàng — Mở rộng HN 2008–2025
merger2025:            Color(0xFFFB8C00) // Cam — Sáp nhập NQ202 2025
```

### 2.6 Map Region Colors

Dùng cho `_getColorForRegion()` trong bản đồ:

```dart
red_river_delta:    Color(0xFF2D5A8E) // Đồng bằng sông Hồng
northern_midlands:  Color(0xFF378ADD) // Trung du miền núi BB
central_coast:      Color(0xFF1D9E75) // Bắc Trung Bộ & duyên hải
central_highlands:  Color(0xFFBA7517) // Tây Nguyên
southeast:          Color(0xFFE24B4A) // Đông Nam Bộ
mekong_delta:       Color(0xFF534AB7) // Đồng bằng sông CL
```

### 2.7 Heatmap Colors (Density)

```dart
unknown:      Color(0xFFE5E5E5) // Xám — không có dữ liệu
< 100:        Color(0xFFFFEDA0) // Vàng nhạt
100–250:      Color(0xFFFEB24C) // Cam nhạt
250–500:      Color(0xFFFD8D3C) // Cam
500–1000:     Color(0xFFFC4E2A) // Cam đỏ
1000–2000:    Color(0xFFE31A1C) // Đỏ
> 2000:       Color(0xFFB10026) // Đỏ đậm
```

---

## 3. Typography

### 3.1 Font Families

```yaml
# pubspec.yaml — đã khai báo
primary_font: "Be Vietnam Pro"   # Google Fonts — dùng cho toàn bộ UI text
mono_font:    "JetBrains Mono"   # Dùng cho: số liệu thống kê, năm, mã tỉnh (ma)
```

### 3.2 Text Styles

```dart
// Heading — tiêu đề màn hình, tên tỉnh trong popup
TextStyle heading1 = TextStyle(
  fontSize: 24, fontWeight: FontWeight.bold,
  color: Color(0xFFE8EAF0),
);

TextStyle heading2 = TextStyle(
  fontSize: 20, fontWeight: FontWeight.bold,
  color: Colors.white,
);

TextStyle heading3 = TextStyle(
  fontSize: 18, fontWeight: FontWeight.w600,
  color: Colors.white,
);

// Body — nội dung thông thường
TextStyle bodyLarge = TextStyle(
  fontSize: 14, fontWeight: FontWeight.w400,
  color: Color(0xFFE8EAF0), height: 1.4,
);

TextStyle bodySmall = TextStyle(
  fontSize: 12, fontWeight: FontWeight.w400,
  color: Color(0xFF9AA0B0),
);

// Label — nhãn form, tab, badge
TextStyle labelUppercase = TextStyle(
  fontSize: 10, fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
  color: Colors.white54,
);

// Monospace — số liệu, năm timeline, mã hành chính
TextStyle monoNumber = TextStyle(
  fontFamily: 'JetBrains Mono',
  fontSize: 18, fontWeight: FontWeight.bold,
);
```

---

## 4. Spacing & Layout

### 4.1 Spacing Scale

```dart
// Dùng bội số của 4. KHÔNG dùng số lẻ tùy tiện.
const double spaceXS  =  4.0;
const double spaceSM  =  8.0;
const double spaceMD  = 12.0;
const double spaceLG  = 16.0;
const double spaceXL  = 24.0;
const double space2XL = 32.0;
const double space3XL = 48.0;
```

### 4.2 Layout Structure

```
┌─────────────────────────────────────────────────────────┐
│  NavigationRail (72px)  │  Sidebar (280px, optional)   │
│  backgroundColor:       │  backgroundColor:             │
│  Color(0xFF1A1D23)      │  Color(0xFF1A1D23)            │
│                         │                               │
│  ├── Map icon           │  ├── Search bar               │
│  ├── Explorer icon      │  ├── Results list             │
│  ├── Archives icon      │  └── Saved locations          │
│  └── AI icon            │                               │
├─────────────────────────┴───────────────────────────────┤
│                   Main Content Area                       │
│                   (IndexedStack)                          │
│                                                           │
│   - Map Screen (FlutterMap)                              │
│   - Explorer Screen                                       │
│   - Archives Screen                                       │
│   - AI Chat Screen                                        │
├───────────────────────────────────────────────────────────┤
│  Timeline Panel (140px height) — chỉ hiện ở tab Map      │
│  backgroundColor: Color(0xFF1A1D23) opacity 0.95          │
└───────────────────────────────────────────────────────────┘
```

### 4.3 Window Constraints

```dart
minimumSize: Size(1200, 750)
defaultSize:  Size(1400, 900)
```

---

## 5. Component Library

### 5.1 Card / Container

```dart
// Pattern chuẩn cho mọi card trong app
BoxDecoration cardDecoration = BoxDecoration(
  color: Color(0xFF1E2128),
  borderRadius: BorderRadius.circular(16),
  border: Border.all(
    color: Colors.white.withValues(alpha: 0.05),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ],
);

// Dùng alpha: thay vì opacity: (deprecated)
// ĐÚNG:   Colors.white.withValues(alpha: 0.1)
// SAI:    Colors.white.withOpacity(0.1)  ← deprecated
```

### 5.2 Button — Primary

```dart
ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF2D5A8E),
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
)
```

### 5.3 Button — Icon (Map Controls)

```dart
// Pattern cho MapControlsWidget
Container(
  decoration: BoxDecoration(
    color: Color(0xFF1A1D23).withValues(alpha: 0.9),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 8, offset: Offset(0, 4),
      ),
    ],
  ),
  child: IconButton(icon: Icon(icon, color: Colors.white70), ...),
)
```

### 5.4 Badge / Status Chip

```dart
// Era badge trong RegionalProfileCard
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: BoxDecoration(
    color: eraColor.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: eraColor.withValues(alpha: 0.5)),
  ),
  child: Text(label, style: TextStyle(color: eraColor, fontSize: 12, fontWeight: FontWeight.w600)),
)
```

### 5.5 Input / Search Bar

```dart
// Dark input field
Container(
  decoration: BoxDecoration(
    color: Color(0xFF12151C),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
  ),
  child: TextField(
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: '...',
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  ),
)
```

### 5.6 Chat Message Bubble

```dart
// User message
color: Color(0xFF2D5A8E)       // Brand blue
borderRadius: user → top-left 18, top-right 4, bottom 18

// AI message
color: Color(0xFF1E2128)       // Background card
border: Colors.white opacity 0.05
borderRadius: AI → top-left 4, top-right 18, bottom 18
```

### 5.7 Stat Display (RegionalProfileCard)

```dart
// 3 stats ngang nhau: Year | Provinces | Era Badge
// Year value dùng eraColor
// Provinces value dùng Colors.white
// Label uppercase, fontSize: 10, letterSpacing: 1, color: white54
```

### 5.8 Loading Screen (SeedingScreen)

```dart
// Centered, width 400
// Icon: Icons.map_outlined, size 64, color brandPrimary
// Title: "Vietnam ChronoGIS", bold, white
// Subtitle: grey text
// Progress bar: brandPrimary trên nền 0xFF1A1D23
// Percentage: JetBrains Mono font
```

---

## 6. Map Layer Specifications

### 6.1 Tile Providers

```dart
// Street (default)
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'

// Satellite
urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
```

### 6.2 Map Initial State

```dart
initialCenter: LatLng(16.0, 106.0)  // Trung tâm Việt Nam
initialZoom:   5.5
```

### 6.3 Polygon Styles

```dart
// Province polygon
fillOpacity:    0.35 (normal) / 0.60 (selected)
borderColor:    Colors.white (selected) / Colors.white opacity 0.4 (normal)
borderWidth:    2.0 (selected) / 1.0 (normal with borders) / 0.0 (borders off)
```

### 6.4 Map Overlays Position

```dart
// Controls
Positioned(right: 24, top: 24)      // MapControlsWidget

// Province info popup
Positioned(right: 24, bottom: 164)  // ProvinceInfoPopup

// 164px = Timeline panel height (140) + padding
```

---

## 7. Animation Guidelines

### 7.1 Duration Standards

```dart
const Duration fast     = Duration(milliseconds: 200);  // Hover, toggle
const Duration normal   = Duration(milliseconds: 300);  // Fade, slide
const Duration slow     = Duration(milliseconds: 500);  // Timeline playback step
```

### 7.2 Polygon Transition

```dart
// Khi year thay đổi → polygon layer fade in
.animate(key: ValueKey(selectedYear))
.fadeIn(duration: 300.ms)
```

### 7.3 Message Bubble Entrance

```dart
.animate()
.fadeIn(duration: 200.ms)
.slideY(begin: 0.1, end: 0)
```

### 7.4 Timeline Playback

```dart
// Auto-play: +1 năm mỗi 500ms
Timer.periodic(Duration(milliseconds: 500), ...)
```

---

## 8. Navigation & Routing

### 8.1 Routes

```dart
'/seed'     → SeedingScreen      // Màn hình khởi động, load dữ liệu
'/map'      → AppShell           // Main app shell
'/explorer' → AppShell           // Alias của /map (redirect)
```

### 8.2 Tab Structure (NavigationRail)

| Index | Icon | Label | Màn hình |
|---|---|---|---|
| 0 | `Icons.map` | Map | MapViewScreen |
| 1 | `Icons.explore` | Explorer | ExplorerScreen *(TODO)* |
| 2 | `Icons.book` | Archives | ArchivesScreen *(TODO)* |
| 3 | `Icons.smart_toy` | AI | AiInsightsScreen |

### 8.3 State Management Pattern

Dự án dùng **Riverpod 3.x** (flutter_riverpod ^3.3.1). Tuân thủ:

```dart
// ĐÚNG — Riverpod 3.x
class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() { return initialState; }
  void doSomething() => state = newState;  // state setter trực tiếp
}
final myProvider = NotifierProvider<MyNotifier, MyState>(MyNotifier.new);

// SAI — cũ, không dùng
class MyNotifier extends StateNotifier<MyState> { ... }  // ← xóa rồi
final myProvider = StateNotifierProvider<..., ...>(...);  // ← xóa rồi
final countProvider = StateProvider<int>(...);            // ← xóa rồi
```

---

## 9. Database Schema (Drift)

### 9.1 Tables

| Table | Mục đích |
|---|---|
| `administrative_units` | Dữ liệu 34 tỉnh mới + communes từ HuggingFace |
| `geo_json_caches` | Cache polygon GeoJSON theo `ma` (key: `ma` hoặc `gadm_<NAME>`) |
| `chat_history_messages` | Lịch sử chat với Groq AI |
| `historical_events` | Sự kiện hành chính lịch sử *(chưa seed)* |

### 9.2 Key Fields — AdministrativeUnit

```dart
id          // UUID string — primary key
ma          // Mã hành chính (VD: "01", "79")
ten         // Tên đầy đủ tiếng Việt
tenShort    // Tên ngắn (VD: "Hà Nội", "TP.HCM")
kind        // 'province' | 'commune'
type        // 'Thành phố trực thuộc TW' | 'Tỉnh' | ...
macroRegion // Một trong 6 vùng kinh tế (xem §2.6)
embedText   // Văn bản mô tả dùng cho AI context
keywords    // List<String> — từ khóa tìm kiếm
predecessorsList  // List<String> — tỉnh cũ trước sáp nhập
nPredecessors    // int — số tỉnh cũ (>=2 → đã sáp nhập)
centroidLat / centroidLon  // Tọa độ trung tâm
```

### 9.3 GeoJSON Cache Keys

```
ma          → polygon 34 tỉnh mới (HF data, hợp nhất từ GADM)
gadm_<NAME> → polygon 63 tỉnh cũ (GADM data, tên theo NAME_1 trong GADM)
```

---

## 10. AI Integration

### 10.1 Model

```dart
model: 'llama-3.3-70b-versatile'
maxOutputTokens: 1024
temperature: 0.7
```

### 10.2 Context Variables

Mỗi lần gửi message, context gồm:

```dart
ChatContext {
  currentYear:               int         // Năm đang xem trên timeline
  currentEra:                String      // Label của VietnamEra
  provinceCount:             int         // Số tỉnh năm đó
  selectedProvinceMa:        String?     // Mã tỉnh đang chọn
  selectedProvinceEmbedText: String?     // Mô tả embed tỉnh đó
}
```

### 10.3 Suggested Questions

Groq tự generate 4 câu hỏi gợi ý dựa trên context. Format trả về: JSON object `{"questions": ["Q1", "Q2", "Q3", "Q4"]}`.

---

## 11. Temporal Display Logic

```dart
// Số tỉnh theo năm (hàm getProvinceCountForYear)
1975:        66   // Trước thống nhất
1976–1990:   38   // Bao cấp, sáp nhập lớn
1991–1996:   38 + progress*3  // Chia dần
1997–2003:   61
2004–2007:   64
2008–2024:   63   // Sau khi HN mở rộng
2025:        34   // Sau NQ 202/2025/QH15

// Layer bản đồ theo năm
year < 2025  → dùng GADM 63 tỉnh (key: gadm_<NAME>)
year >= 2025 → dùng HF 34 tỉnh (key: ma)
```

---

## 12. New Feature Guidelines

### 12.1 Khi thêm màn hình mới

1. Đặt tại `lib/features/<feature_name>/presentation/`
2. Dùng `ConsumerWidget` hoặc `ConsumerStatefulWidget`
3. Background: `Color(0xFF12151C)` (dùng `Scaffold(backgroundColor: ...`)
4. Thêm route vào `app_router.dart` nếu cần
5. Kết nối vào `IndexedStack` trong `AppShell`

### 12.2 Khi thêm API mới

1. Tạo client tại `lib/data/api/<name>_client.dart`
2. Tạo provider tại `lib/shared/providers/<name>_provider.dart`
3. Dùng `Dio` với timeout 30s
4. Retry 3 lần với delay 2s

### 12.3 Khi thêm bảng DB mới

1. Định nghĩa table tại `lib/core/database/tables/`
2. Thêm vào `@DriftDatabase` trong `app_database.dart`
3. Tạo DAO tại `lib/core/database/daos/`
4. Tăng `schemaVersion` và viết migration
5. Chạy `flutter pub run build_runner build`

### 12.4 Marker du lịch (Tourism POI)

```dart
// Màu theo loại POI
museum:      Colors.purple
beach:       Colors.cyan
ruins:       Colors.amber
nature:      Colors.green
attraction:  Colors.orange (default)

// Size marker: 40×40px
// Shape: CircleAvatar với Icon trắng bên trong
// Có boxShadow: black26, blurRadius 4
```

---

## 13. Coding Conventions

### 13.1 Deprecated APIs — KHÔNG sử dụng

```dart
// ❌ SAI
color.withOpacity(0.5)           // deprecated
StateNotifier<T>                 // removed in Riverpod 3.x
StateNotifierProvider            // removed
StateProvider<T>                 // removed

// ✅ ĐÚNG
color.withValues(alpha: 0.5)
Notifier<T>
NotifierProvider
Notifier<T> (dùng state setter trực tiếp)
```

### 13.2 Pattern được khuyến khích

```dart
// Tìm kiếm không dấu tiếng Việt
// Dùng _normalizeVietnamese() trong AdministrativeUnitDao

// Serialize List<String> cho SQLite → dùng ListStringConverter (separator: '||')
// Serialize List<double> → dùng ListDoubleConverter (separator: ',')

// Geometry type check
if (geometry.type == 'Polygon') { ... }
else if (geometry.type == 'MultiPolygon') { ... }
```

### 13.3 Error Handling trong async providers

```dart
// Luôn dùng try-catch trong seedFromApi và các API call
// Log lỗi bằng debugPrint('ServiceName: error message: $e')
// Không throw lại lỗi từ UI providers — return empty list thay thế
```

---

## 14. File Structure

```
lib/
├── core/
│   ├── database/
│   │   ├── app_database.dart         # Root DB, schemaVersion
│   │   ├── tables/                   # Drift table definitions
│   │   └── daos/                     # Data Access Objects
│   ├── router/
│   │   └── app_router.dart           # GoRouter config
│   └── theme/
│       ├── app_theme.dart            # ThemeData light/dark
│       └── theme_provider.dart       # ThemeNotifier
│
├── data/
│   ├── api/
│   │   ├── groq_service.dart         # Groq (Llama 3)
│   │   ├── huggingface_api_client.dart
│   │   └── models/                   # Freezed models
│   ├── geojson/
│   │   ├── geojson_parser.dart
│   │   ├── province_geojson_service.dart
│   │   └── temporal_geojson_service.dart  # Chọn 63 vs 34 theo năm
│   └── repositories/
│       ├── administrative_unit_repository.dart
│       └── chat_repository.dart
│
├── features/
│   ├── shell/                        # AppShell, SeedingScreen
│   ├── map/                          # MapViewScreen, widgets
│   ├── ai_chat/                      # AiInsightsScreen, widgets
│   ├── explorer/                     # TODO: POI explorer
│   └── archives/                     # TODO: Historical archive
│
└── shared/
    ├── models/                       # ChatMessage, ChatContext, GeoJsonFeature, VietnamEra
    └── providers/                    # Riverpod providers
        ├── timeline_provider.dart    # selectedYear, isPlaying, currentEra
        ├── map_provider.dart         # selectedProvince, mapStyle, borders, heatmap
        ├── chat_provider.dart        # chatNotifier, chatContext, suggestedQuestions
        ├── database_provider.dart    # databaseProvider, DAOs
        ├── geojson_provider.dart     # geoJsonParser, provinceGeoJsonService
        └── seed_provider.dart        # seedInitialization, seedProgress
```

---

## 15. Checklist cho AI Agent

Trước khi generate bất kỳ code UI nào, kiểm tra:

- [ ] Màu nền có phải `0xFF12151C` / `0xFF1E2128` / `0xFF1A1D23` không?
- [ ] Đã dùng `.withValues(alpha:)` thay vì `.withOpacity()` chưa?
- [ ] Provider có dùng `Notifier<T>` / `NotifierProvider` không (không dùng StateNotifier)?
- [ ] Font có phải "Be Vietnam Pro" không (không dùng Inter/Roboto/system fonts)?
- [ ] Spacing có theo bội số 4 không?
- [ ] Border radius: card = 16, button = 8, badge = 16, input = 24?
- [ ] Import đường dẫn đúng (3 cấp `../../../` từ `lib/features/<x>/presentation/`)?
- [ ] Có `ConsumerWidget` hay `ConsumerStatefulWidget` cho widget cần Riverpod?
- [ ] Text màu chính `Color(0xFFE8EAF0)`, phụ `Color(0xFF9AA0B0)`?
- [ ] Polygon map dùng `.withValues(alpha: 0.35)` cho fill?
