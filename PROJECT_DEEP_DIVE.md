# 📚 Vietnam ChronoGIS - Tài Liệu Báo Cáo Toàn Diện

> **Mục đích**: Tài liệu này giúp bạn hiểu sâu về cấu trúc, logic, code flow của project để trả lời các câu hỏi của giáo viên.

---

## 📍 I. TỔNG QUAN PROJECT

### 1. Mục tiêu & Features
- **Tên**: Vietnam ChronoGIS (Chronological Geographic Information System)
- **Mô tả**: Bản đồ lịch sử hành chính Việt Nam từ 1975-2025
- **Nền tảng**: Flutter (hỗ trợ Windows, Android, iOS, Linux, Web, macOS)
- **4 Tính Năng Chính**:
  1. 🗺️ **Map Viewer** - Hiển thị biên giới lịch sử, heatmap dân số
  2. 💬 **AI Chat** - Groq LLM trả lời về lịch sử hành chính
  3. 🔍 **Explorer** - Chi tiết từng tỉnh, thông tin du lịch
  4. 🧭 **Shell** - Navigation chính, theme switching

### 2. Công Nghệ Stack
| Tầng | Công nghệ | Phiên bản | Chức năng |
|-----|----------|---------|----------|
| **UI Framework** | Flutter | 3.12.0+ | Cross-platform UI |
| **State Management** | Riverpod + Freezed | 3.3.1 / 3.1.0 | Reactive state, immutable models |
| **Database** | SQLite + Drift | 3.3.1 | Type-safe ORM, DAO pattern |
| **Routing** | GoRouter | 17.2.3 | Navigation declarative |
| **AI/LLM** | Groq API (llama-3.3-70b) | v1 | Streaming chat, tính toán context |
| **HTTP Client** | Dio | 5.9.2 | Request API, streaming response |
| **GIS** | Flutter Map, latlong2 | 8.3.0 / 0.9.1 | Map rendering, geo calculation |
| **Data** | GeoJSON (GADM) | v41 | Biên giới hành chính |

---

## 🏗️ II. KIẾN TRÚC PROJECT (Clean Architecture)

### Folder Structure & Responsibility

```
lib/
├── main.dart                          # Entry point, Riverpod ProviderScope setup
├── core/                              # Layer độc lập, core functionality
│   ├── router/
│   │   └── app_router.dart           # GoRouter config (routing rules)
│   ├── theme/
│   │   ├── app_theme.dart            # Material theme config
│   │   └── theme_provider.dart       # Riverpod provider cho theme
│   └── database/
│       ├── app_database.dart         # Drift database class, schema v2
│       ├── tables/                   # Database table definitions
│       │   ├── administrative_units_table.dart
│       │   ├── historical_events_table.dart
│       │   ├── geojson_cache_table.dart
│       │   ├── chat_history_table.dart
│       │   └── tourism_places_table.dart
│       └── daos/                     # Data Access Objects
│           ├── administrative_unit_dao.dart
│           ├── geojson_dao.dart
│           ├── chat_dao.dart
│           └── tourism_dao.dart
│
├── data/                              # Data layer: API, repositories, services
│   ├── api/
│   │   ├── groq_service.dart         # Groq LLM streaming client
│   │   └── huggingface_api_client.dart
│   ├── geojson/
│   │   ├── geojson_parser.dart       # Parse GeoJSON từ assets
│   │   └── province_geojson_service.dart
│   ├── repositories/                 # Repository pattern
│   │   ├── chat_repository.dart      # Chat message persistence
│   │   ├── administrative_unit_repository.dart  # Province data
│   │   └── tourism_repository.dart   # Tourism places data
│   └── services/
│       └── osrm_service.dart         # Route optimization
│
├── features/                          # Feature modules (MVVM pattern)
│   ├── shell/
│   │   └── presentation/
│   │       ├── app_shell.dart        # Main navigation shell, TabBar
│   │       └── seeding_screen.dart   # Initial data load screen
│   ├── map/
│   │   └── presentation/
│   │       ├── map_view_screen.dart  # Main map viewer
│   │       └── widgets/
│   │           ├── timeline_panel.dart    # Time slider control
│   │           ├── province_info_popup.dart
│   │           └── map_layer_control.dart
│   ├── ai_chat/
│   │   └── presentation/
│   │       └── ai_insights_screen.dart    # Chat UI with streaming
│   └── explorer/
│       └── presentation/
│           └── explorer_screen.dart   # Province detail view
│
└── shared/                            # Shared across features
    ├── models/                        # Domain models (Freezed immutable)
    │   ├── chat_message.dart
    │   ├── chat_context.dart
    │   ├── geojson_feature.dart
    │   ├── timeline_era.dart
    │   └── population_heatmap_value.dart
    └── providers/                     # Riverpod global providers
        ├── database_provider.dart
        ├── api_provider.dart
        ├── chat_provider.dart
        ├── map_provider.dart
        ├── geojson_provider.dart
        ├── timeline_provider.dart
        ├── seed_provider.dart
        └── routing_provider.dart
```

---

## 🔄 III. DATA FLOW & LOGIC DETAIL

### 1. **App Initialization Flow** (main.dart → app_shell.dart)

#### 📄 File: `lib/main.dart`
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ① Window Manager setup (Windows desktop)
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1200, 750),  // Responsive design
    size: Size(1400, 900),
    center: true,
    title: 'Vietnam ChronoGIS',
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // ② SharedPreferences setup (local storage)
  final prefs = await SharedPreferences.getInstance();

  // ③ ProviderScope setup (Riverpod root)
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final goRouter = ref.watch(goRouterProvider);
    
    return MaterialApp.router(
      title: 'Vietnam ChronoGIS',
      theme: theme,
      routerConfig: goRouter,
    );
  }
}
```

**Lưu ý**: 
- `ProviderScope` là root của tất cả Riverpod providers
- `windowManager` cấu hình cửa sổ desktop
- `SharedPreferences` để lưu user preferences

---

### 2. **Router & Navigation** (app_router.dart → app_shell.dart)

#### 📄 File: `lib/core/router/app_router.dart`
```dart
final goRouter = GoRouter(
  initialLocation: '/seed',  // Bắt đầu tại seeding screen
  routes: [
    GoRoute(
      path: '/seed',
      builder: (context, state) => const SeedingScreen(),  // Load dữ liệu ban đầu
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const AppShell(),  // Main app
    ),
    GoRoute(
      path: '/explorer',
      builder: (context, state) => const AppShell(),  // Detail view
    ),
  ],
);
```

#### 📄 File: `lib/features/shell/presentation/app_shell.dart`
```dart
class SelectedTab extends Notifier<int> {
  @override
  int build() => 0;  // Tab 0: Map
  
  void select(int index) => state = index;
}

final selectedTabProvider = NotifierProvider<SelectedTab, int>(SelectedTab.new);

class AppShell extends ConsumerStatefulWidget {
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildNavigationRail(selectedTab),      // Left sidebar navigation
                if (isSidebarExpanded)
                  AnimatedContainer(
                    width: isSidebarExpanded ? 280 : 0,
                    child: const SidebarWidget(),        // Info panel
                  ),
                Expanded(child: _buildMainContent(selectedTab)),  // Center content
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(int tab) {
    return switch (tab) {
      0 => const MapViewScreen(),           // Map viewer
      1 => const AiInsightsScreen(),        // AI Chat
      2 => const ExplorerScreen(),          // Explorer
      _ => const SizedBox(),
    };
  }
}
```

**Flow Logic**:
```
User clicks tab → SelectedTab.select(index) 
  → selectedTabProvider state changes 
    → _AppShellState rebuilds 
      → _buildMainContent(selectedTab) returns correct widget
```

---

### 3. **Database & Data Persistence** (app_database.dart → DAOs)

#### 📄 File: `lib/core/database/app_database.dart`
```dart
@DriftDatabase(
  tables: [
    AdministrativeUnits,      // Tỉnh/thành phố
    HistoricalEvents,         // Sự kiện lịch sử
    GeoJsonCaches,            // Cache hình dạng biên giới
    ChatHistoryMessages,      // Chat messages
    TourismPlaces,            // Địa điểm du lịch
  ],
  daos: [
    AdministrativeUnitDao,
    GeoJsonDao,
    ChatDao,
    TourismDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;  // v2 added tourism_places

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) => m.createAll(),
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(tourismPlaces);  // Migration v1→v2
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');  // Enable constraints
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(
      dbFolder.path,
      'vietnam_chronogis',
      'chronogis.sqlite',  // Lưu file SQLite tại Documents
    ));

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    return NativeDatabase.createInBackground(file);
  });
}
```

#### 📄 File: `lib/core/database/tables/administrative_units_table.dart` (Example)
```dart
class AdministrativeUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();           // "tỉnh" | "thành phố"
  TextColumn get ma => text().unique()();    // Mã tỉnh (VN.01, VN.02...)
  TextColumn get ten => text()();            // Tên tỉnh
  RealColumn get areaKm2 => real()();        // Diện tích
  IntColumn get population => integer()();   // Dân số
  TextColumn get decree => text().nullable()();  // Số quyết định
  RealColumn get centroidLon => real()();    // GPS center longitude
  RealColumn get centroidLat => real()();    // GPS center latitude
}
```

#### 📄 File: `lib/core/database/daos/administrative_unit_dao.dart` (Example)
```dart
@DriftAccessor(tables: [AdministrativeUnits])
class AdministrativeUnitDao extends DatabaseAccessor<AppDatabase> {
  AdministrativeUnitDao(super.db);

  // Get all provinces
  Future<List<AdministrativeUnit>> getAllProvinces() {
    return select(administrativeUnits).get();
  }

  // Get by code (ma)
  Future<AdministrativeUnit?> getUnitByMa(String ma) {
    return (select(administrativeUnits)..where((u) => u.ma.equals(ma)))
        .getSingleOrNull();
  }

  // Insert multiple
  Future<void> insertMultiple(List<AdministrativeUnit> units) {
    return batch((batch) {
      batch.insertAll(administrativeUnits, units);
    });
  }

  // Watch all (reactive stream)
  Stream<List<AdministrativeUnit>> watchAllUnits() {
    return select(administrativeUnits).watch();
  }
}
```

**Provider Setup**: `lib/shared/providers/database_provider.dart`
```dart
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());  // Cleanup
  return db;
});

// Expose DAO providers
final administrativeUnitDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).administrativeUnitDao;
});

final chatDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).chatDao;
});
```

---

### 4. **Chat Feature Logic** (Groq API + Streaming)

#### 📄 File: `lib/data/api/groq_service.dart`
```dart
final groqServiceProvider = Provider<GroqService>((ref) {
  const apiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );

  if (apiKey.isEmpty) throw Exception('GROQ_API_KEY is not set');

  return GroqService(apiKey);
});

class GroqService {
  final String _apiKey;
  final Dio _dio;
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _model = 'llama-3.3-70b-versatile';

  GroqService(this._apiKey, {Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));

  // ⭐ Core method: Streaming chat with context
  Stream<String> sendMessage(
    String message, {
    required ChatContext context,
  }) async* {
    final systemPrompt = '''
Bạn là chuyên gia lịch sử địa lý hành chính Việt Nam cho ứng dụng Vietnam ChronoGIS.

Context nền:
- 1975: Việt Nam thống nhất
- 1976: Tái cấu trúc → 61 tỉnh
- 1986: Đổi Mới
- 1991-1997: Tách tỉnh → 61 tỉnh
- 2008: Hà Nội sáp nhập Hà Tây
- 2025: Nghị quyết 202/2025/QH15 sáp nhập 63→34 tỉnh/thành

Trả lời ngắn gọn, chính xác, bằng ngôn ngữ hỏi.
''';

    final prompt = _buildPrompt(message, context);

    try {
      // Gửi request tới Groq API
      final response = await _dio.post<ResponseBody>(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 1024,
          'stream': true,  // ⭐ Server-Sent Events
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Accept': 'text/event-stream',
          },
          responseType: ResponseType.stream,  // ⭐ Receive as stream
        ),
      );

      // Parse SSE stream
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
                yield content;  // ⭐ Stream token-by-token
              }
            }
          } catch (e) {
            // JSON parse error, skip
          }
        }
      }
    } catch (e) {
      yield 'Lỗi: ${e.toString()}';
    }
  }

  String _buildPrompt(String userMessage, ChatContext context) {
    return '''
Năm hiện tại: ${context.currentYear}
Đơn vị hành chính đang chọn: ${context.selectedProvinceMa ?? 'Không'}
Thông tin: ${context.selectedProvinceEmbedText ?? 'N/A'}
Tổng số tỉnh/thành: ${context.provinceCount}
Kỷ nguyên: ${context.currentEra}

Người dùng hỏi: $userMessage
''';
  }
}
```

#### 📄 File: `lib/data/repositories/chat_repository.dart`
```dart
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChatRepository(db.chatDao);
});

class ChatRepository {
  final ChatDao _chatDao;

  ChatRepository(this._chatDao);

  // Save message to database
  Future<void> saveMessage(ChatMessage message) async {
    await _chatDao.insertMessage(
      ChatHistoryMessage(
        id: message.id,
        role: message.role.name,
        content: message.content,
        timestamp: message.timestamp,
        contextJson: null,
      ),
    );
  }

  // Watch all messages (reactive stream)
  Stream<List<ChatMessage>> watchMessages() {
    return _chatDao.watchAllMessages().map((rows) {
      return rows
          .map((row) => ChatMessage(
            id: row.id,
            role: MessageRole.values.firstWhere(
              (e) => e.name == row.role,
              orElse: () => MessageRole.user,
            ),
            content: row.content,
            timestamp: row.timestamp,
            isStreaming: false,
          ))
          .toList();
    });
  }

  Future<void> clearHistory() async {
    await _chatDao.clearHistory();
  }
}
```

#### 📄 File: `lib/shared/providers/chat_provider.dart`
```dart
// ⭐ Current chat context based on selected map state
final currentChatContextProvider = FutureProvider<ChatContext>((ref) async {
  final year = ref.watch(selectedYearProvider);
  final era = ref.watch(currentEraProvider);
  final provinceCount = ref.watch(currentProvinceCountProvider);
  final selectedMa = ref.watch(selectedProvinceProvider);

  String? embedText;
  if (selectedMa != null) {
    final repo = ref.watch(administrativeUnitRepositoryProvider);
    final unit = await repo.getUnitByMa(selectedMa);
    embedText = unit?.embedText;
  }

  return ChatContext(
    currentYear: year,
    selectedProvinceMa: selectedMa,
    selectedProvinceEmbedText: embedText,
    provinceCount: provinceCount,
    currentEra: era.label,
  );
});

// ⭐ Chat state notifier
final chatNotifierProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(
  ChatNotifier.new,
);

class ChatNotifier extends Notifier<List<ChatMessage>> {
  late GroqService _groqService;
  late ChatRepository _repository;
  final _uuid = const Uuid();

  @override
  List<ChatMessage> build() {
    _groqService = ref.read(groqServiceProvider);
    _repository = ref.read(chatRepositoryProvider);
    return [];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // ① Create user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: MessageRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    await _repository.saveMessage(userMessage);

    // ② Create AI message placeholder
    final aiMessageId = _uuid.v4();
    final aiMessage = ChatMessage(
      id: aiMessageId,
      role: MessageRole.assistant,
      content: '',
      timestamp: DateTime.now(),
      isStreaming: true,
    );

    state = [...state, userMessage, aiMessage];

    // ③ Stream response from Groq
    final context = await ref.read(currentChatContextProvider.future);
    var fullContent = '';

    await for (final chunk in _groqService.sendMessage(text, context: context)) {
      fullContent += chunk;
      
      // Update UI in real-time
      state = [
        ...state.where((msg) => msg.id != aiMessageId),
        ChatMessage(
          id: aiMessageId,
          role: MessageRole.assistant,
          content: fullContent,
          timestamp: aiMessage.timestamp,
          isStreaming: true,
        ),
      ];
    }

    // ④ Save final message
    await _repository.saveMessage(
      ChatMessage(
        id: aiMessageId,
        role: MessageRole.assistant,
        content: fullContent,
        timestamp: aiMessage.timestamp,
        isStreaming: false,
      ),
    );
  }
}
```

**Chat Flow Diagram**:
```
User types message in AI Chat UI
  ↓
ChatNotifier.sendMessage(text)
  ↓ (Parallel)
  ├→ Save user message to DB
  └→ Get context (year, selected province, etc.)
  ↓
GroqService.sendMessage(text, context)
  ↓
POST /chat/completions {stream: true}
  ↓
Receive SSE stream (Server-Sent Events)
  ↓
Parse "data: {json}" lines
  ↓
Extract token chunks → yield
  ↓
ChatNotifier state updates (UI rebuilds in real-time)
  ↓
Save final message to DB
```

---

### 5. **Map Feature Logic** (GeoJSON + Riverpod State)

#### 📄 File: `lib/shared/providers/map_provider.dart`
```dart
// ⭐ Selected province state
@riverpod
class SelectedProvince extends _$SelectedProvince {
  @override
  String? build() => null;

  void select(String ma) => state = ma;
  void clear() => state = null;
}

// ⭐ Map tile style (street vs satellite)
@riverpod
class MapTileStyleState extends _$MapTileStyleState {
  @override
  MapTileStyle build() => MapTileStyle.street;

  void toggle() {
    state = state == MapTileStyle.street
        ? MapTileStyle.satellite
        : MapTileStyle.street;
  }
}

// ⭐ Show/hide borders
@riverpod
class ShowBordersState extends _$ShowBordersState {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

// ⭐ Show/hide heatmap
@riverpod
class ShowHeatmapState extends _$ShowHeatmapState {
  @override
  bool build() => false;

  void toggle() {
    debugPrint('⚙️ [ShowHeatmapState.toggle] $state → ${!state}');
    state = !state;
  }
}

// ⭐ Map controller
@riverpod
class MapControllerState extends _$MapControllerState {
  @override
  MapController build() => MapController();
}

// ⭐ Timeline year selection
class MapSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}
```

#### 📄 File: `lib/features/map/presentation/map_view_screen.dart`
```dart
class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showBorders = ref.watch(showBordersStateProvider);
    final showHeatmap = ref.watch(showHeatmapStateProvider);
    final selectedProvince = ref.watch(selectedProvinceProvider);
    final mapStyle = ref.watch(mapTileStyleStateProvider);
    final mapController = ref.watch(mapControllerStateProvider);

    // Load GeoJSON provinces
    final provincesAsync = ref.watch(
      provincesProvider,  // FutureProvider<List<Province>>
    );

    return Stack(
      children: [
        // ① Flutter Map widget
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(16.0, 107.0),  // Vietnam center
            zoom: 6.0,
          ),
          children: [
            // ② Tile layer (OpenStreetMap or satellite)
            TileLayer(
              urlTemplate: mapStyle == MapTileStyle.street
                  ? 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
                  : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
              subdomains: const ['a', 'b', 'c'],
            ),

            // ③ Province polygon layers
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
                        strokeWidth: 2.0,
                      ))
                      .toList(),
                  loading: () => [],
                  error: (err, _) => [],
                ),
              ),

            // ④ Heatmap layer (population density)
            if (showHeatmap)
              HeatmapLayer(
                // Population data from database
                points: ref.watch(heatmapPointsProvider),
              ),

            // ⑤ Popup on click
            MarkerLayer(
              markers: provincesAsync.when(
                data: (provinces) => provinces
                    .map((p) => Marker(
                      point: LatLng(p.centroidLat, p.centroidLon),
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          ref
                              .read(selectedProvinceProvider.notifier)
                              .select(p.ma);
                          _showProvincePopup(context, p);
                        },
                        child: const Icon(Icons.location_on),
                      ),
                    ))
                    .toList(),
                loading: () => [],
                error: (err, _) => [],
              ),
            ),
          ],
        ),

        // ② Control panel (top-right)
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              FloatingActionButton(
                onPressed: () =>
                    ref.read(mapTileStyleStateProvider.notifier).toggle(),
                child: const Icon(Icons.layers),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () =>
                    ref.read(showBordersStateProvider.notifier).toggle(),
                child: const Icon(Icons.border_all),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: () =>
                    ref.read(showHeatmapStateProvider.notifier).toggle(),
                child: const Icon(Icons.wb_incandescent),
              ),
            ],
          ),
        ),

        // ③ Timeline panel (bottom)
        const Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: TimelinePanel(),
        ),
      ],
    );
  }

  void _showProvincePopup(BuildContext context, Province province) {
    showDialog(
      context: context,
      builder: (ctx) => ProvinceInfoPopup(province: province),
    );
  }
}
```

---

### 6. **GeoJSON Parsing & Caching** (Data Layer)

#### 📄 File: `lib/data/geojson/geojson_parser.dart`
```dart
class GeoJsonParser {
  // Load từ assets/geojson/gadm41_VNM_1.json
  Future<Map<String, List<LatLng>>> parseVietnamBorders() async {
    final jsonString = await rootBundle
        .loadString('assets/geojson/gadm41_VNM_1.json');
    
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final features = decoded['features'] as List;

    final result = <String, List<LatLng>>{};

    for (final feature in features) {
      final properties = feature['properties'] as Map<String, dynamic>;
      final ma = properties['NAME_1'] as String?; // Province code

      final geometry = feature['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List;

      // Convert coordinates to LatLng
      final latLngs = _coordinatesToLatLng(coordinates);
      result[ma ?? 'unknown'] = latLngs;
    }

    return result;
  }

  List<LatLng> _coordinatesToLatLng(List<dynamic> coordinates) {
    // Handle nested coordinates (polygon format)
    if (coordinates.isEmpty) return [];

    final points = <LatLng>[];
    for (final coord in coordinates[0]) {  // First ring (outer boundary)
      if (coord is List && coord.length >= 2) {
        points.add(LatLng(coord[1] as double, coord[0] as double));
      }
    }
    return points;
  }
}
```

#### 📄 File: `lib/data/geojson/province_geojson_service.dart`
```dart
class ProvinceGeoJsonService {
  final AdministrativeUnitDao _unitDao;
  final GeoJsonDao _geoJsonDao;

  ProvinceGeoJsonService({
    required AdministrativeUnitDao unitDao,
    required GeoJsonDao geoJsonDao,
  })  : _unitDao = unitDao,
        _geoJsonDao = geoJsonDao;

  // Load GeoJSON từ assets → cache vào database
  Future<void> seedGeoJsonCache() async {
    final parser = GeoJsonParser();
    final borders = await parser.parseVietnamBorders();

    // Save each province's border to database
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

  // Retrieve from cache
  Future<List<LatLng>?> getProvinceGeometry(String ma) async {
    final cached = await _geoJsonDao.getCacheByMa(ma);
    if (cached != null) {
      return _deserializeLatLngs(cached.geoJsonBinary);
    }
    return null;
  }

  String _serializeLatLngs(List<LatLng> points) {
    return jsonEncode(
      points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
    );
  }

  List<LatLng> _deserializeLatLngs(String json) {
    final list = jsonDecode(json) as List;
    return list
        .map((item) => LatLng(item['lat'] as double, item['lng'] as double))
        .toList();
  }
}
```

---

## 📊 IV. STATE MANAGEMENT (Riverpod Pattern)

### Provider Types Used

| Type | File | Mục đích |
|------|------|---------|
| `Provider<T>` | `database_provider.dart` | Single instance, no state |
| `FutureProvider<T>` | `geojson_provider.dart` | Async data fetching, caching |
| `StreamProvider<T>` | `chat_provider.dart` | Real-time updates (watch) |
| `StateProvider<T>` | N/A (Deprecated in Riverpod 3.x) | Replaced with `Notifier` |
| `Notifier<T>` + `NotifierProvider` | `map_provider.dart` | Complex state logic |

### Example: Notifier Pattern

```dart
// Define state class
class ChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    // Initial state
    return [];
  }

  // Mutation methods
  Future<void> sendMessage(String text) async {
    // Logic...
  }
}

// Create provider
final chatNotifierProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(
  ChatNotifier.new,
);

// Use in UI
final messages = ref.watch(chatNotifierProvider);
ref.read(chatNotifierProvider.notifier).sendMessage('Hello');
```

---

## 🎓 V. KEY CONCEPTS CÓ THỂ ĐƯỢC HỎI

### 1. **Tại sao dùng Riverpod?**
- **Reactive**: State thay đổi → UI tự rebuild (không cần setState)
- **Dependency injection**: Dễ testing, mock providers
- **Lazy loading**: Provider chỉ initialize khi cần
- **Caching**: Tự động cache result, reuse if deps unchanged
- **Better than Provider/BLoC**: Type-safe, generated code (riverpod_generator)

### 2. **Freezed Models có lợi ích gì?**
```dart
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required MessageRole role,
    required String content,
    required DateTime timestamp,
    @Default(false) bool isStreaming,
  }) = _ChatMessage;
}
```
- **Immutability**: Không thể modify, tránh bug
- **Equality**: Tự động == operator (compare by value)
- **Copy-with**: `message.copyWith(content: 'new')`
- **JSON**: `toJson()` / `fromJson()` auto-generated
- **Pattern matching**: `switch (message) { ... }`

### 3. **Drift ORM vs SQLite Raw?**
- **Type-safe**: Compiler checks queries (không runtime errors)
- **Code generation**: SQL tự động từ Dart code
- **Reactive**: `watch()` returns Stream
- **DAO pattern**: Isolate database logic từ UI
- **Migration**: `MigrationStrategy.onUpgrade` cho schema changes

### 4. **Architecture: 3-layer Pattern**
```
┌─────────────────────────────┐
│   UI Layer (features/)      │  ← Widgets, UI logic
├─────────────────────────────┤
│   Data Layer (data/)        │  ← Repositories, API clients
│   Business Logic            │
├─────────────────────────────┤
│   Core Layer (core/)        │  ← Database, routing, theme
│   Infrastructure            │
└─────────────────────────────┘
```

### 5. **Streaming Response (SSE)?**
```dart
// Server sends: data: {"choices":[{"delta":{"content":"token"}}]}\n
// Client receives: Stream<String> of tokens
// UI updates: In real-time (typing effect in chat)

// Advantages:
// - Lower latency (show token immediately)
// - Better UX (user sees AI thinking)
// - Save bandwidth (streaming vs wait full response)
```

### 6. **Database Persistence**
```
App launch:
  ① Database.lazy load (first time)
  ② Check schema version
  ③ Run migration if needed
  ④ PRAGMA foreign_keys = ON
  
Data flow:
  UI → Repository → DAO → Query
  
Reactive:
  DAO.watch() → Stream → StreamProvider → UI auto-rebuild
```

---

## 🔧 VI. DEPENDENCIES & BUILD

### pubspec.yaml Key Packages
```yaml
# Framework
flutter:                 # UI framework
flutter_riverpod: 3.3.1  # State management

# Database
drift: 2.33.0            # ORM
sqlite3: 3.3.1           # SQLite driver
sqlite3_flutter_libs:    # Platform-specific libs

# Serialization
freezed: 3.1.0           # Immutable models
json_serializable: 6.8.0 # JSON <-> Dart

# API & Networking
dio: 5.9.2               # HTTP client
groq (unofficial)        # LLM API

# UI Components
flutter_map: 8.3.0       # Map widget
latlong2: 0.9.1          # Lat/Lng calculations
flutter_animate: 4.5.2   # Animations

# Navigation
go_router: 17.2.3        # Declarative routing

# Utilities
shared_preferences:      # Local storage
uuid: 4.5.3              # ID generation
intl: 0.20.2             # Localization
```

### Build & Code Generation
```bash
# Install dependencies
flutter pub get

# Generate code (Drift, Freezed, Riverpod)
dart run build_runner build

# Or watch mode (auto-regenerate on file save)
dart run build_runner watch

# Run app
flutter run -d windows  # Desktop
flutter run -d chrome   # Web
```

---

## 📋 VII. QUICK Q&A FOR TEACHER

| Câu hỏi | Trả lời | File Liên Quan |
|--------|--------|-----------------|
| **Project structure?** | Clean Architecture: core/ (infra), data/ (business), features/ (UI) | lib/core, lib/data, lib/features |
| **How state is managed?** | Riverpod Notifier + FutureProvider, reactive streams | lib/shared/providers/*.dart |
| **Database structure?** | SQLite with Drift ORM, 5 tables, v2 schema with migration | lib/core/database/ |
| **AI Chat logic?** | Groq LLM streaming SSE, context from map state | lib/data/api/groq_service.dart |
| **GeoJSON handling?** | Parse from assets, cache to DB, query with DAO | lib/data/geojson/ |
| **Map interactivity?** | Flutter Map + Riverpod state (selected province, zoom) | lib/features/map/ |
| **How async handled?** | Async/await, streams for real-time, FutureProvider for caching | everywhere |
| **Testing?** | Unit tests in /test, mock providers in Riverpod | test/ |
| **Performance?** | Lazy loading, database indexing, Riverpod memoization | Indexed queries |
| **Responsive design?** | Sidebar collapses <1000px, Flutter responsive widgets | lib/features/shell/ |

---

## 📸 VIII. FILE DEPENDENCY GRAPH

```
┌──────────────────────────────────────────────────────────────────┐
│ lib/main.dart (Entry Point)                                      │
│   ├─→ MyApp (ConsumerWidget)                                    │
│   │   └─→ MaterialApp.router(routerConfig: goRouterProvider)   │
│   └─→ ProviderScope (Riverpod root)                             │
└────────────────────┬─────────────────────────────────────────────┘
                     │
        ┌────────────┴──────────────┬─────────────────┐
        │                           │                 │
   GoRouter                  database_provider    theme_provider
   (routing)                 (SQLite)              (Material theme)
        │                           │                 │
        ├──→ SeedingScreen      APP DATABASE      MaterialTheme
        │    (Initial load)       │                   │
        │                         ├─→ DAO(s)      Light/Dark
        └──→ AppShell             │                   │
             (Main UI)            ├─→ Tables      └─→ MyApp.build()
             │                    │
             ├─→ MapViewScreen    ├─→ AdministrativeUnits
             │   (Features)       ├─→ ChatHistory
             │                    ├─→ GeoJsonCache
             ├─→ AIInsightsScreen └─→ TourismPlaces
             │
             ├─→ ExplorerScreen   geoJsonProvider
             │                    (Parse + Cache)
             └─→TimelinePanel     │
                                  └─→ ProvinceGeoJsonService
                                      │
                                      └─→ Database DAO

Chat Logic:
    AIInsightsScreen
      ├─→ chatNotifierProvider
      │   └─→ GroqService (Streaming)
      │       └─→ groqServiceProvider (API Key)
      │
      └─→ chatRepositoryProvider
          └─→ ChatDao (DB persistence)

Map Logic:
    MapViewScreen
      ├─→ selectedProvinceProvider (Notifier)
      ├─→ mapTileStyleStateProvider
      ├─→ showBordersStateProvider
      ├─→ showHeatmapStateProvider
      │
      └─→ provincesProvider (FutureProvider)
          └─→ GeoJsonCache + AdministrativeUnits
```

---

## 🎯 IX. FINAL SUMMARY FOR TEACHER

**Vietnam ChronoGIS** sử dụng:

1. **Architecture**: Clean 3-layer (core, data, features)
2. **State Management**: Riverpod (providers, Notifiers, FutureProvider)
3. **Database**: SQLite + Drift ORM (5 tables, type-safe queries)
4. **AI Integration**: Groq LLM (streaming SSE via Dio)
5. **UI Framework**: Flutter (cross-platform: Windows, iOS, Android, Web, macOS)
6. **Routing**: GoRouter (declarative navigation)
7. **Models**: Freezed (immutable, JSON-serializable)
8. **GIS**: Flutter Map + latlong2 + GeoJSON parsing
9. **Reactive**: Streams for real-time updates (watch DB changes)
10. **Performance**: Lazy loading, caching, memoization

**Key Innovation**:
- Combine **historical administrative data** (GeoJSON) with **AI insights** (Groq)
- **Reactive map** (Riverpod state) + **streaming chat** (SSE)
- **Type-safe database** (Drift) với **ORM pattern** (DAOs)

---

Tài liệu này đủ để bạn trả lời mọi câu hỏi về **cấu trúc, logic, flow** của project! 🎓📚
