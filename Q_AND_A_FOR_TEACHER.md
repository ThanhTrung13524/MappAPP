# 🎓 Vietnam ChronoGIS - Q&A Thực Tế (Chuẩn Bị Báo Cáo)

> Các câu hỏi mà giáo viên có thể hỏi + trả lời chi tiết + file/line number

---

## 🔴 **PHẦN 1: CẤU TRÚC PROJECT**

### Q1: "Project của em có mấy tầng, tầng nào là gì?"
**A**: 3 tầng (Clean Architecture):
- **Core Layer** (`lib/core/`): Infra độc lập - database, routing, theme
- **Data Layer** (`lib/data/`): Business logic - repositories, API clients, services
- **Features Layer** (`lib/features/`): UI - widgets, screens, presentation logic
- **Shared Layer** (`lib/shared/`): Models & providers dùng chung

**File chứng minh**: 
- `lib/core/database/app_database.dart` (line 1-30): Database setup
- `lib/data/repositories/chat_repository.dart` (line 1-20): Repository pattern
- `lib/features/shell/presentation/app_shell.dart` (line 1-40): UI layer

---

### Q2: "Em có bao nhiêu databases? Lưu thông tin gì?"
**A**: 1 SQLite database (`chronogis.sqlite`) với **5 tables**:

| Bảng | Mục đích | Key Columns |
|-----|---------|-------------|
| **AdministrativeUnits** | Tỉnh/thành phố | `ma`, `ten`, `centroidLat/Lon`, `population` |
| **HistoricalEvents** | Sự kiện lịch sử | `year`, `description`, `decree` |
| **GeoJsonCaches** | Biên giới (polygon) | `ma`, `geoJsonBinary` |
| **ChatHistoryMessages** | Chat history | `id`, `role`, `content`, `timestamp` |
| **TourismPlaces** | Địa điểm du lịch | `ma`, `name`, `category` |

**File**: `lib/core/database/app_database.dart` (line 25-45)
```dart
@DriftDatabase(
  tables: [
    AdministrativeUnits,
    HistoricalEvents,
    GeoJsonCaches,
    ChatHistoryMessages,
    TourismPlaces,  // ← v2 thêm này
  ],
)
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 2;  // v1 → v2
}
```

---

### Q3: "Schema có version mấy? Tại sao có migration?"
**A**: Schema v2 (từ v1). Migration khi cập nhật database.

**File**: `lib/core/database/app_database.dart` (line 40-60)
```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();  // v1: create tables
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(tourismPlaces);  // v1→v2: add tourism_places table
      }
    },
  );
}
```

**Tại sao**: Khi add feature mới (tourism), cần add table mới mà không làm mất data cũ.

---

### Q4: "Sao không dùng Firestore/Cloud Database mà dùng SQLite?"
**A**: 
- **SQLite**: Offline-first, không cần internet, fast, không bị track user
- **Firestore**: Cloud sync, share real-time, nhưng app này local-only + GeoJSON cache offline
- **Tradeoff**: Chọn SQLite vì app là geospatial (GeoJSON parse lớn) + AI chat local context

---

## 🔵 **PHẦN 2: STATE MANAGEMENT (Riverpod)**

### Q5: "Em dùng gì để manage state? Redux? Provider?"
**A**: **Riverpod 3.3.1** (không phải Redux/Provider).

**Tại sao**:
- Redux: Boilerplate quá (actions, reducers, middleware)
- Provider: Rất cũ, bị deprecated
- **Riverpod**: Modern, type-safe, code generation, lazy loading, memoization

**File**: `lib/shared/providers/` (11 files)

---

### Q6: "Riverpod có mấy loại provider? Dùng cái nào?"
**A**: 4 loại chính:

| Loại | Mục đích | Ví dụ |
|------|---------|-------|
| `Provider<T>` | Single instance, no state | `databaseProvider` |
| `FutureProvider<T>` | Async data, caching | `provincesProvider` |
| `StreamProvider<T>` | Real-time updates | `chatMessagesProvider` |
| `Notifier<T>` | Complex state logic | `ChatNotifier`, `SelectedProvince` |

**File**: 
- `Provider`: `lib/shared/providers/database_provider.dart` (line 5-10)
- `FutureProvider`: `lib/shared/providers/geojson_provider.dart` (line 1-15)
- `StreamProvider`: `lib/shared/providers/chat_provider.dart` (line 8-12)
- `Notifier`: `lib/shared/providers/map_provider.dart` (line 15-50)

---

### Q7: "Cách dùng Notifier + NotifierProvider trong map là sao?"
**A**: Example: Selected Province

**File**: `lib/shared/providers/map_provider.dart` (line 15-25)
```dart
@riverpod
class SelectedProvince extends _$SelectedProvince {
  @override
  String? build() => null;  // Initial state: no selection

  void select(String ma) => state = ma;  // Mutate state
  void clear() => state = null;
}

final selectedProvinceProvider = notifierProvider(SelectedProvince.new);

// Usage in UI:
final selectedMa = ref.watch(selectedProvinceProvider);  // Read state
ref.read(selectedProvinceProvider.notifier).select('VN.01');  // Mutate
```

**Flow**: User clicks province → `select(ma)` → state changes → `ref.watch()` rebuilds UI

---

### Q8: "Khi nào dùng watch vs read?"
**A**:
- **`ref.watch()`**: UI reactive - khi provider thay đổi, rebuild widget
- **`ref.read()`**: One-time read - không rebuild, chỉ lấy giá trị

**File**: `lib/features/map/presentation/map_view_screen.dart` (line 10-20)
```dart
// WATCH - UI reactive
final selectedProvince = ref.watch(selectedProvinceProvider);
final showBorders = ref.watch(showBordersStateProvider);

// READ - In callback, one-time
FloatingActionButton(
  onPressed: () => 
    ref.read(selectedProvinceProvider.notifier).select('VN.01'),
  child: const Icon(Icons.pin),
)
```

---

## 🟢 **PHẦN 3: DATABASE & REPOSITORY PATTERN**

### Q9: "Drift là gì? Sao không dùng raw SQLite?"
**A**: Drift là **ORM (Object-Relational Mapping)** - bảo vệ lỗi runtime.

**So sánh**:
```dart
// Raw SQLite - dễ lỗi
final result = await db.rawQuery('SELECT * FROM provinces WHERE ma = ?', [maId]);

// Drift - type-safe
final unit = await administrativeUnitDao.getUnitByMa(maId);  // Returns AdministrativeUnit | null
```

**Tại sao Drift**:
- Compiler check SQL (không runtime error)
- Auto code generation (không write boilerplate)
- `watch()` → Stream (reactive)
- DAO pattern (isolate DB logic)

**File**: `lib/core/database/daos/administrative_unit_dao.dart` (line 1-30)

---

### Q10: "DAO là gì? Tại sao cần DAO?"
**A**: DAO = Data Access Object = Layer giữa UI & Database

**Lợi ích**:
- Isolate database logic (UI không biết SQL)
- Reusable queries
- Easy to mock (testing)
- Single responsibility

**File**: `lib/core/database/daos/administrative_unit_dao.dart` (line 1-50)
```dart
@DriftAccessor(tables: [AdministrativeUnits])
class AdministrativeUnitDao extends DatabaseAccessor<AppDatabase> {
  // Query methods
  Future<List<AdministrativeUnit>> getAllProvinces() { ... }
  Future<AdministrativeUnit?> getUnitByMa(String ma) { ... }
  Stream<List<AdministrativeUnit>> watchAllUnits() { ... }  // Reactive!
}
```

---

### Q11: "Repository pattern dùng để gì?"
**A**: Repository = Adapter giữa DAO & Business Logic

**Flow**: UI → Repository → DAO → Database

**File**: `lib/data/repositories/chat_repository.dart` (line 1-40)
```dart
class ChatRepository {
  final ChatDao _chatDao;
  
  // Business logic methods
  Future<void> saveMessage(ChatMessage message) async {
    await _chatDao.insertMessage(...);
  }
  
  Stream<List<ChatMessage>> watchMessages() {
    return _chatDao.watchAllMessages().map((rows) { ... });
  }
}
```

**Tại sao cần**:
- Separate concerns (UI không biết DAO)
- Add business logic (validation, transformation)
- Easy to test (mock repository)

---

## 🟡 **PHẦN 4: API & STREAMING (AI Chat)**

### Q12: "Groq API là gì? Sao streaming?"
**A**: 
- **Groq**: LLM provider (llama-3.3-70b model)
- **Streaming**: Server gửi token-by-token (không wait full response)

**Lợi ích streaming**:
- Lower latency (user thấy AI "thinking" real-time)
- Better UX (typing effect)
- Save bandwidth

**File**: `lib/data/api/groq_service.dart` (line 1-30)
```dart
final groqServiceProvider = Provider<GroqService>((ref) {
  const apiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );
  return GroqService(apiKey);
});
```

---

### Q13: "Chat streaming flow là sao? Token-by-token?"
**A**: SSE (Server-Sent Events)

**File**: `lib/data/api/groq_service.dart` (line 60-120)
```dart
Stream<String> sendMessage(String message, {required ChatContext context}) async* {
  // ① POST request with stream: true
  final response = await _dio.post<ResponseBody>(
    '/chat/completions',
    data: {
      'model': 'llama-3.3-70b-versatile',
      'stream': true,  // ← Enable streaming
      ...
    },
    options: Options(
      responseType: ResponseType.stream,  // ← Receive as stream
    ),
  );

  // ② Parse SSE stream
  final stream = response.data!.stream
      .cast<List<int>>()
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  await for (final line in stream) {
    if (line.startsWith('data: ')) {
      final data = line.substring(6).trim();
      if (data == '[DONE]') break;
      
      try {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        final choices = decoded['choices'] as List;
        if (choices.isNotEmpty) {
          final delta = choices[0]['delta'] as Map<String, dynamic>;
          final content = delta['content'] as String?;
          if (content != null) {
            yield content;  // ← Yield token
          }
        }
      } catch (e) { /* skip */ }
    }
  }
}
```

**Ví dụ**:
```
Token 1: "Nội"
Token 2: "dung"
Token 3: " Việt"
Token 4: " Nam"

UI: "Nội" → "Nội dung" → "Nội dung Việt" → "Nội dung Việt Nam"
```

---

### Q14: "Chat context là gì? Sao cần context?"
**A**: Context = Thông tin ngữ cảnh giúp AI trả lời chính xác

**File**: `lib/shared/models/chat_context.dart`
```dart
@freezed
class ChatContext with _$ChatContext {
  const factory ChatContext({
    required int currentYear,
    required String? selectedProvinceMa,
    required String? selectedProvinceEmbedText,
    required int provinceCount,
    required String currentEra,
  }) = _ChatContext;
}
```

**Ví dụ**:
- User: "Tỉnh này có mấy tỉnh phụ?"
- Context:
  - `currentYear`: 2008
  - `selectedProvinceMa`: "VN.01" (Hà Nội)
  - `currentEra`: "Post-Renovation"
- AI trả lời based on context

**File**: `lib/shared/providers/chat_provider.dart` (line 10-40)
```dart
final currentChatContextProvider = FutureProvider<ChatContext>((ref) async {
  final year = ref.watch(selectedYearProvider);
  final era = ref.watch(currentEraProvider);
  final selectedMa = ref.watch(selectedProvinceProvider);
  
  // Build context từ map state
  return ChatContext(
    currentYear: year,
    selectedProvinceMa: selectedMa,
    ...
  );
});
```

---

### Q15: "ChatNotifier là gì? Sao phải Notifier?"
**A**: ChatNotifier = Complex state logic (đơn giản list + hành động gửi)

**File**: `lib/shared/providers/chat_provider.dart` (line 50-120)
```dart
class ChatNotifier extends Notifier<List<ChatMessage>> {
  late GroqService _groqService;
  late ChatRepository _repository;
  final _uuid = const Uuid();

  @override
  List<ChatMessage> build() {
    _groqService = ref.read(groqServiceProvider);
    _repository = ref.read(chatRepositoryProvider);
    return [];  // Initial state
  }

  Future<void> sendMessage(String text) async {
    // ① Create & save user message
    final userMessage = ChatMessage(id: ..., role: user, content: text);
    await _repository.saveMessage(userMessage);
    
    // ② Create placeholder for AI response
    final aiMessageId = _uuid.v4();
    state = [...state, userMessage, ChatMessage(id: aiMessageId, ...)];

    // ③ Stream response from Groq
    final context = await ref.read(currentChatContextProvider.future);
    var fullContent = '';

    await for (final chunk in _groqService.sendMessage(text, context: context)) {
      fullContent += chunk;
      
      // ④ Update state in real-time
      state = [...state.where((msg) => msg.id != aiMessageId), 
               ChatMessage(id: aiMessageId, content: fullContent)];
    }

    // ⑤ Save final message
    await _repository.saveMessage(ChatMessage(..., content: fullContent));
  }
}
```

---

## 🟣 **PHẦN 5: MAP & GEOJSON**

### Q16: "GeoJSON là gì? Lưu ở đâu?"
**A**: GeoJSON = JSON format cho địa lý (polygons = boundaries)

**Lưu ở**:
- Assets: `assets/geojson/gadm41_VNM_1.json` (biên giới GADM v41)
- Database: `GeoJsonCaches` table (cache sau parse)

**File**: `lib/assets/geojson/gadm41_VNM_1.json`
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "properties": {"NAME_1": "An Giang"},
      "geometry": {
        "type": "Polygon",
        "coordinates": [[[105.5, 10.5], [105.6, 10.6], ...]]
      }
    },
    ...
  ]
}
```

---

### Q17: "GeoJSON parse flow là sao?"
**A**: Load → Parse → Cache

**File**: `lib/data/geojson/geojson_parser.dart` (line 1-50)
```dart
class GeoJsonParser {
  Future<Map<String, List<LatLng>>> parseVietnamBorders() async {
    // ① Load from assets
    final jsonString = await rootBundle.loadString('assets/geojson/gadm41_VNM_1.json');
    
    // ② Decode JSON
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final features = decoded['features'] as List;

    // ③ Extract coordinates → LatLng
    final result = <String, List<LatLng>>{};
    for (final feature in features) {
      final ma = feature['properties']['NAME_1'];  // Province name
      final coordinates = feature['geometry']['coordinates'];
      final latLngs = _coordinatesToLatLng(coordinates);  // Convert
      result[ma] = latLngs;
    }
    
    return result;
  }
}
```

**File**: `lib/data/geojson/province_geojson_service.dart` (line 20-40)
```dart
Future<void> seedGeoJsonCache() async {
  final parser = GeoJsonParser();
  final borders = await parser.parseVietnamBorders();

  // ④ Save to database
  for (final MapEntry(:key, :value) in borders.entries) {
    await _geoJsonDao.insertCache(
      GeoJsonCache(
        ma: key,
        geoJsonBinary: _serializeLatLngs(value),  // Compress
        createdAt: DateTime.now(),
      ),
    );
  }
}
```

---

### Q18: "Map hiển thị sao? Flutter Map + Riverpod?"
**A**: Flutter Map widget + Riverpod state

**File**: `lib/features/map/presentation/map_view_screen.dart` (line 20-80)
```dart
class MapViewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ① Watch Riverpod state
    final showBorders = ref.watch(showBordersStateProvider);
    final selectedProvince = ref.watch(selectedProvinceProvider);
    
    // ② Load GeoJSON
    final provincesAsync = ref.watch(provincesProvider);

    return Stack(
      children: [
        // ③ Flutter Map
        FlutterMap(
          options: MapOptions(center: LatLng(16.0, 107.0), zoom: 6.0),
          children: [
            // Tile layer (OSM or satellite)
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),

            // ④ Polygon layer (provinces)
            if (showBorders)
              PolygonLayer(
                polygons: provincesAsync.when(
                  data: (provinces) => provinces
                      .map((p) => Polygon(
                        points: p.geoJsonFeature.latLngs,  // Coordinates
                        color: selectedProvince == p.ma
                            ? Colors.blue.withOpacity(0.4)
                            : Colors.grey.withOpacity(0.2),
                        isFilled: true,
                        strokeColor: Colors.black,
                      ))
                      .toList(),
                  loading: () => [],
                  error: (err, _) => [],
                ),
              ),
          ],
        ),

        // ⑤ Controls (top-right)
        Positioned(
          top: 16, right: 16,
          child: FloatingActionButton(
            onPressed: () =>
                ref.read(showBordersStateProvider.notifier).toggle(),
            child: const Icon(Icons.border_all),
          ),
        ),
      ],
    );
  }
}
```

---

## 🔴 **PHẦN 6: TESTING & VALIDATION**

### Q19: "Em có test gì? Cách nào?"
**A**: 3 loại test:

| Loại | File | Mục đích |
|------|------|---------|
| Widget test | `test/widget_test.dart` | UI testing |
| Overpass test | `test/overpass_client_test.dart` | API integration |
| GeoJSON test | `test/vietnam_geo_validator_test.dart` | Data validation |

**File**: `test/vietnam_geo_validator_test.dart`
```dart
void main() {
  test('Vietnam GeoJSON has 63 provinces', () async {
    final parser = GeoJsonParser();
    final borders = await parser.parseVietnamBorders();
    
    expect(borders.length, 63);
  });

  test('Each province has coordinates', () async {
    final parser = GeoJsonParser();
    final borders = await parser.parseVietnamBorders();
    
    for (final MapEntry(:value) in borders.entries) {
      expect(value.isNotEmpty, true);
    }
  });
}
```

---

## 🟢 **PHẦN 7: PERFORMANCE & OPTIMIZATION**

### Q20: "App performance như thế nào? Slow không?"
**A**: Optimizations:

| Optimization | Cách | File |
|--------------|------|------|
| Lazy loading | GeoJSON parse only when needed | `geojson_provider.dart` |
| Caching | Riverpod auto-cache, Database cache | `database_provider.dart` |
| Memoization | Provider result reused if deps unchanged | Riverpod built-in |
| Pagination | (If needed) load provinces by region | N/A (future) |

**File**: `lib/shared/providers/database_provider.dart` (line 5-10)
```dart
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());  // Clean up
  return db;
});
// ← Riverpod auto-caches, reuses instance
```

---

## 🟣 **PHẦN 8: ERROR HANDLING & EDGE CASES**

### Q21: "Xử lý lỗi sao? Khi API down?"
**A**: Try-catch + fallback

**File**: `lib/data/api/groq_service.dart` (line 95-110)
```dart
Stream<String> sendMessage(String message, {required ChatContext context}) async* {
  try {
    // API request
    final response = await _dio.post<ResponseBody>(...);
    // Process response
    await for (final line in stream) { ... }
  } catch (e) {
    yield 'Lỗi: ${e.toString()}';  // User-friendly error
  }
}
```

**File**: `lib/shared/providers/geojson_provider.dart` (line 5-20)
```dart
final provincesProvider = FutureProvider<List<Province>>((ref) async {
  try {
    return await ref.watch(provinceGeoJsonServiceProvider)
        .getProvinces();
  } catch (e) {
    return [];  // Fallback empty list
  }
});
```

---

## 🎯 **PART 9: RESPONSIVE DESIGN**

### Q22: "App responsive sao? Tablet vs Mobile vs Desktop?"
**A**: Media query + conditional UI

**File**: `lib/features/shell/presentation/app_shell.dart` (line 30-50)
```dart
class _AppShellState extends ConsumerState<AppShell> {
  @override
  Widget build(BuildContext context) {
    final isSidebarExpanded = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildNavigationRail(selectedTab),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isSidebarExpanded ? 280 : 0,  // ← Hide on small screens
                  child: const SidebarWidget(),
                ),
                Expanded(child: _buildMainContent(selectedTab)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📋 **QUICK CHECKLIST FOR TEACHER**

Khi thầy hỏi, bạn có thể trả lời:

- ✅ **Kiến trúc**: Clean 3-layer (core, data, features)
- ✅ **State**: Riverpod (4 loại provider)
- ✅ **Database**: SQLite + Drift ORM (5 tables, v2 schema)
- ✅ **AI**: Groq streaming (token-by-token)
- ✅ **Map**: Flutter Map + GeoJSON parsing + Riverpod
- ✅ **Responsive**: MediaQuery for adapting UI
- ✅ **Testing**: 3 types (widget, API, data validation)
- ✅ **Performance**: Lazy loading, caching, memoization
- ✅ **Error handling**: Try-catch + fallback

---

## 🎓 **GỢI Ý: CÁCH TRÌNH BÀY**

**Thầy hỏi**: "Em giải thích cấu trúc project được không?"

**Bạn trả lời**:
1. Giải thích 3-layer (30 giây)
2. Chỉ file trong workspace
3. Giải thích 1 specific flow (e.g., Chat)
4. Show code snippet từ file

**Ví dụ**:
> "Project em có 3 tầng. Tầng core là infra như database (lib/core/database/app_database.dart), tầng data là repositories và API clients (lib/data/repositories, lib/data/api), tầng features là widgets (lib/features/map, lib/features/ai_chat). Em quản lý state bằng Riverpod có 4 loại provider (Provider, FutureProvider, StreamProvider, Notifier). Khi user gửi chat message, nó đi qua ChatNotifier.sendMessage() → call GroqService với context từ map state → stream tokens → update UI real-time."

---

**Chúc bạn báo cáo thành công! 🎓🚀**
