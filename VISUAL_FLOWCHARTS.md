# 🎨 Vietnam ChronoGIS - Visual Flowcharts & Diagrams

> Hình ảnh các flows chính để bạn tưởng tượng dễ hơn

---

## 🔄 **FLOW 1: App Initialization Flow**

```
┌────────────────────────────────────────────────────────────┐
│ main.dart                                                  │
│ ├─ WidgetsFlutterBinding.ensureInitialized()              │
│ ├─ windowManager.ensureInitialized() (Windows Desktop)    │
│ └─ SharedPreferences.getInstance()                         │
└────────────────┬─────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│ ProviderScope (Riverpod Root)                             │
│ ├─ Override sharedPreferencesProvider                      │
│ └─ Child: MyApp()                                          │
└────────────────┬─────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│ MyApp (ConsumerWidget)                                     │
│ ├─ theme: themeProvider (Light/Dark)                      │
│ ├─ routerConfig: GoRouter                                 │
│ └─ MaterialApp.router()                                    │
└────────────────┬─────────────────────────────────────────┘
                 │
                 ▼
        GoRouter.initialLocation
                 │
    ┌────────────┴────────────┐
    │                         │
    ▼ (First time)           ▼ (After seed)
 /seed                      /map
    │                         │
    ▼                         ▼
SeedingScreen            AppShell (MainUI)
├─ Load GeoJSON           ├─ Navigation Rail
├─ Parse → DB             ├─ Sidebar
├─ Load AI models         └─ Main Content
└─ Seed data                (4 tabs)
    │
    └─────→ Navigate to /map
```

---

## 🗺️ **FLOW 2: User Click on Map Province**

```
User clicks province on map
         │
         ▼
MapViewScreen.build()
├─ GestureDetector.onTap()
└─ ref.read(selectedProvinceProvider.notifier).select('VN.01')
         │
         ▼
SelectedProvince.select(ma)
├─ state = 'VN.01'
└─ Riverpod rebuilds all watchers
         │
    ┌────┴─────────────────────────────┬──────────────┐
    │                                  │              │
    ▼                                  ▼              ▼
MapViewScreen.rebuild()         Sidebar.rebuild()  PopupInfo.show()
├─ selectedProvince changed    ├─ Fetch details    ├─ Show province
├─ Province highlight blue      │ from repository    │ details
└─ Show marker                  └─ Display info     └─ Tourism places
```

---

## 💬 **FLOW 3: Chat Streaming Flow**

```
User types message in AI Chat UI
         │
         ▼
AIInsightsScreen.onSendMessage(text)
├─ ref.read(chatNotifierProvider.notifier).sendMessage(text)
         │
         ▼
ChatNotifier.sendMessage(text)
├─ ① Create & save UserMessage to DB
├─ ② Create placeholder for AIMessage
├─ ③ Get ChatContext from map state
│    ├─ currentYear
│    ├─ selectedProvinceMa
│    ├─ provinceCount
│    └─ currentEra
└─ ④ Send to GroqService.sendMessage(text, context)
         │
         ▼
GroqService.sendMessage() [Streaming]
├─ POST /chat/completions {stream: true}
├─ Response: Server-Sent Events (SSE)
└─ Stream<String> yields tokens
         │
    ┌────┴─────────────────┐
    │                      │
    ▼ (Per token)         ▼ (Final)
ChatNotifier.state update  Save to DB
├─ Append chunk            └─ ChatRepository.saveMessage()
└─ UI rebuilds
    (Typing effect)
```

### **SSE Example**:
```
Server sends:
  data: {"choices":[{"delta":{"content":"Nội"}}]}
  data: {"choices":[{"delta":{"content":"dung"}}]}
  data: {"choices":[{"delta":{"content":" Việt"}}]}
  data: [DONE]

Client receives Stream:
  "Nội" → "Nội dung" → "Nội dung Việt" → ...
  
UI shows:
  "Nội" (typing)
  "Nội dung" (typing)
  "Nội dung Việt" (typing)
```

---

## 🗄️ **FLOW 4: Database & Data Persistence**

```
App Launch
    │
    ▼
DatabaseProvider.build()
├─ LazyDatabase (lazy load)
├─ Check schema version
├─ Run migration if needed
└─ PRAGMA foreign_keys = ON
    │
    ▼
AppDatabase instance created
├─ 5 Tables:
│  ├─ AdministrativeUnits
│  ├─ HistoricalEvents
│  ├─ GeoJsonCaches
│  ├─ ChatHistoryMessages
│  └─ TourismPlaces
└─ 4 DAOs:
   ├─ AdministrativeUnitDao
   ├─ GeoJsonDao
   ├─ ChatDao
   └─ TourismDao


UI needs data:
    │
    ├──────────────────────┬──────────────────┬─────────────┐
    │                      │                  │             │
    ▼                      ▼                  ▼             ▼
Repository           Repository          Repository    Repository
    │                      │                  │             │
    ▼                      ▼                  ▼             ▼
 ChatRepository   AdministrativeUnitRepo  TourismRepo  GeoJsonDao
    │                      │                  │             │
    ▼                      ▼                  ▼             ▼
 ChatDao          AdministrativeUnitDao  TourismDao   GeoJsonDao
    │                      │                  │             │
    │                      │ Query            │             │
    │                      ├─ getUnitByMa()   │             │
    │                      ├─ getAllProvinces()              │
    │                      └─ watch...() → Stream            │
    │                      │                  │             │
    └─────────────────────┴──────────────────┴─────────────┘
                          │
                          ▼
                    SQLite Query
                          │
                    ┌─────┴──────┐
                    │            │
                    ▼            ▼
                  Fetch       Watch (Stream)
                    │            │
                    │            ▼
                    │       StreamProvider
                    │            │
                    └───┬────────┘
                        │
                        ▼
                   UI rebuild
                   (Reactive)
```

---

## 🌍 **FLOW 5: GeoJSON Parsing & Map Rendering**

```
App Seeding Phase
    │
    ▼
SeederService.seedGeoJson()
    │
    ├─ GeoJsonParser.parseVietnamBorders()
    │  └─ Load assets/geojson/gadm41_VNM_1.json
    │
    ▼ (Parse)
JSON Structure:
├─ type: "FeatureCollection"
├─ features: [
│   {
│     properties: { NAME_1: "An Giang" },
│     geometry: {
│       type: "Polygon",
│       coordinates: [
│         [[105.5, 10.5], [105.6, 10.6], ...]
│       ]
│     }
│   },
│   ... (61 provinces)
│ ]
    │
    ▼ (Convert)
Map<String, List<LatLng>>
├─ "An Giang" → [LatLng(10.5, 105.5), LatLng(10.6, 105.6), ...]
├─ "Bạc Liêu" → [...]
└─ ... (61 entries)
    │
    ▼ (Cache to DB)
GeoJsonCaches table
├─ id: 1
├─ ma: "An Giang"
├─ geoJsonBinary: "serialized LatLngs"
└─ createdAt: ...


User sees Map:
    │
    ▼
MapViewScreen.build()
    │
    ▼
ref.watch(provincesProvider)
    │
    ▼ (FutureProvider)
provincesProvider fetches:
├─ FROM: GeoJsonCache table
├─ JOIN: AdministrativeUnits table
└─ RETURN: List<Province>
    │
    ▼
FlutterMap renders:
├─ TileLayer (OSM / Satellite)
├─ PolygonLayer (from GeoJSON)
│  ├─ For each province:
│  │  ├─ Draw polygon(points = latLngs)
│  │  ├─ Color based on selection
│  │  └─ Add marker at centroid
│  └─ Update on selectedProvinceProvider change
└─ User sees interactive map!
```

---

## 🏗️ **FLOW 6: Riverpod Reactivity**

```
Scenario: User selects province & year changes

MapState (Riverpod):
├─ selectedProvinceProvider = "VN.01"
├─ selectedYearProvider = 2008
└─ currentEraProvider = "Post-Renovation"
    │
    ▼ (Dependencies change)
currentChatContextProvider.invalidate()
    ├─ Depends on:
    │  ├─ selectedYearProvider
    │  ├─ selectedProvinceProvider
    │  ├─ currentEraProvider
    │  └─ currentProvinceCountProvider
    │
    ▼ (Recalculates)
ChatContext updated:
├─ currentYear = 2008
├─ selectedProvinceMa = "VN.01"
├─ currentEra = "Post-Renovation"
└─ provinceCount = 63
    │
    ▼
suggestedQuestionsProvider.invalidate()
    ├─ Depends on currentChatContextProvider
    │
    ▼ (Refetch from GroqService)
Suggested questions regenerated
    │
    ▼
UI rebuilds:
├─ AIInsightsScreen shows new questions
├─ MapViewScreen shows new selection
└─ Sidebar shows new province info
```

**Key**: All deps automatically tracked by Riverpod! No manual setState()

---

## 📱 **FLOW 7: Responsive UI Adaptation**

```
App Layout (AppShell):

Desktop (Width >= 1000px):
┌──────────────────────────────────────────────┐
│ [Nav] [Sidebar (280px)] [Main Content]      │
│ Rail    Info Panel         (Map/Chat/etc)   │
└──────────────────────────────────────────────┘

Tablet/Mobile (Width < 1000px):
┌──────────────────────────────────────────────┐
│ [Nav]     [Main Content]                     │
│ Rail      (Map/Chat/etc)                     │
│           (Sidebar collapsed)                │
└──────────────────────────────────────────────┘

Implementation:
┌────────────────────────────────────────────┐
│ Build method                               │
├────────────────────────────────────────────┤
│ isSidebarExpanded =                        │
│   MediaQuery.of(context).size.width >= 1000│
│                                            │
│ AnimatedContainer(                         │
│   width: isSidebarExpanded ? 280 : 0,     │
│   duration: 250ms,                         │
│   child: SidebarWidget(),                  │
│ )                                          │
└────────────────────────────────────────────┘

Result:
├─ Desktop: Smooth sidebar expand/collapse
├─ Mobile: Full screen for content
└─ Animation: 250ms transition
```

---

## 🔐 **FLOW 8: API Key Management**

```
GroqService Initialization:

① Development (Environment Variable Missing):
   const apiKey = String.fromEnvironment('GROQ_API_KEY',
     defaultValue: '',
   );
   └─ App reports missing GROQ_API_KEY

② Production (Environment Variable Set):
   flutter run --dart-define=GROQ_API_KEY='sk_live_xxxxx'
   └─ Use environment variable


Provider Creation:
final groqServiceProvider = Provider<GroqService>((ref) {
  if (apiKey.isEmpty) {
    throw Exception('GROQ_API_KEY is not set');
  }
  return GroqService(apiKey);
});
    │
    ▼
Singleton pattern:
├─ Instance created once
├─ Reused across app
└─ Same API key for all requests
```

---

## 📊 **FLOW 9: Data Seeding Flow**

```
Initial App Launch:
    │
    ▼
GoRouter: initialLocation = '/seed'
    │
    ▼
SeedingScreen (First Time)
├─ Detected: Database is empty
├─ Call: SeedProvider.seed()
    │
    ├─────────────┬────────────┬──────────────┐
    │             │            │              │
    ▼             ▼            ▼              ▼
seedAdmUnits  seedGeoJson  seedTourism   seedEvents
    │             │            │              │
    ├─ Fetch      ├─ Parse     ├─ Fetch    ├─ Generate
│ from API    │ GeoJSON    │ from API   │ historical
│ (HF)        │ assets     │ (db)       │ events
    │             │            │              │
    ▼             ▼            ▼              ▼
AdministrativeUnitsTable  GeoJsonCache  TourismPlaces  HistoricalEvents
    │             │            │              │
    └─────────────┴────────────┴──────────────┘
                  │
                  ▼
        All tables seeded ✓
                  │
                  ▼
        Update SeedProvider.seedProgressProvider
        ├─ 0% → 25% → 50% → 75% → 100%
        │
        ▼
UI updates progress bar
                  │
                  ▼
        User clicks "Go to Map"
                  │
                  ▼
        GoRouter.go('/map')
                  │
                  ▼
        AppShell (Main UI)
```

---

## 🎯 **FLOW 10: Search & Filter Flow**

```
User types search query:
    │
    ▼
MapSearchQuery (TextEditingController)
    │
    ├─ setQuery(searchText)
    │
    ▼
ref.watch(mapSearchQueryProvider)
    │
    ▼
FutureProvider filters:
├─ FROM: AdministrativeUnits table
├─ WHERE: name LIKE '%searchText%'
│         OR code LIKE '%searchText%'
└─ RETURN: Filtered List<AdministrativeUnit>
    │
    ▼
MapViewScreen rebuilds:
├─ Show filtered provinces
├─ Highlight matching regions
└─ Focus map on first result (optional)


Example:
Input: "Hà"
    │
    ▼
Query: SELECT * FROM administrative_units WHERE ten LIKE '%Hà%'
    │
    ▼
Results:
├─ Hà Nội (VN.01)
├─ Hà Giang (VN.02)
├─ Hà Tây (VN.03) [merged 2008]
└─ Hà Nam (VN.04)
    │
    ▼
UI shows 4 provinces, user can click any
```

---

## 🎨 **COMPONENT HIERARCHY**

```
MyApp
├─ MaterialApp.router
│  └─ GoRouter
│     ├─ /seed → SeedingScreen
│     └─ /map → AppShell
│        └─ Row
│           ├─ NavigationRail (left sidebar)
│           ├─ AnimatedContainer (info panel)
│           │  └─ SidebarWidget
│           │     ├─ ProvinceInfo
│           │     ├─ Statistics
│           │     └─ TourismPlaces
│           └─ Expanded (main content)
│              └─ IndexedStack (tab switching)
│                 ├─ MapViewScreen (tab 0)
│                 │  └─ Stack
│                 │     ├─ FlutterMap
│                 │     ├─ PolygonLayer
│                 │     ├─ MarkerLayer
│                 │     ├─ Controls (FAB)
│                 │     └─ TimelinePanel
│                 ├─ AIInsightsScreen (tab 1)
│                 │  └─ Column
│                 │     ├─ ChatMessages (ListView)
│                 │     └─ InputField
│                 ├─ ExplorerScreen (tab 2)
│                 │  └─ ...
│                 └─ [4th tab]
```

---

## 📈 **STATE TREE (Riverpod Dependency Graph)**

```
databaseProvider
├─ administrativeUnitDaoProvider
│  └─ administrativeUnitRepositoryProvider
│     ├─ currentChatContextProvider
│     │  ├─ selectedYearProvider
│     │  ├─ selectedProvinceProvider
│     │  ├─ currentEraProvider
│     │  └─ currentProvinceCountProvider
│     │     └─ provincesProvider
│     │        ├─ MapViewScreen (watch)
│     │        └─ ExplorerScreen (watch)
│     │
│     └─ suggestedQuestionsProvider
│        └─ AIInsightsScreen (watch)
│
├─ chatDaoProvider
│  └─ chatRepositoryProvider
│     └─ chatNotifierProvider
│        └─ AIInsightsScreen (watch)
│
├─ geoJsonDaoProvider
│  └─ provinceGeoJsonServiceProvider
│     └─ geoJsonProvider
│        └─ MapViewScreen (watch)
│
└─ tourismDaoProvider
   └─ tourismRepositoryProvider
      └─ tourismProvider
         └─ SidebarWidget (watch)

UI Layer (Top):
├─ MapViewScreen (watch: selectedProvinceProvider, showBordersState, provincesProvider)
├─ AIInsightsScreen (watch: chatNotifierProvider, suggestedQuestionsProvider)
├─ ExplorerScreen (watch: selectedProvinceProvider, provincesProvider)
└─ SidebarWidget (watch: selectedProvinceProvider, tourismProvider)
```

---

## ✅ **CHECKLIST: Key Flows to Understand**

- [ ] **Initialization** (main.dart → ProviderScope → GoRouter)
- [ ] **Navigation** (GoRouter /seed → /map)
- [ ] **Database** (DAO pattern, lazy load, Drift)
- [ ] **Chat Streaming** (Riverpod state → GroqService → SSE → UI update)
- [ ] **Map Rendering** (GeoJSON parse → cache → FlutterMap display)
- [ ] **Reactivity** (Riverpod dependency tracking, auto-rebuild)
- [ ] **Responsive** (MediaQuery for layout adaptation)
- [ ] **Data Seeding** (Initial load, progress tracking)
- [ ] **State Management** (Provider, FutureProvider, Notifier types)
- [ ] **Error Handling** (Try-catch, fallback values)

---

**Save these diagrams! Very helpful for explaining to teacher! 📚✨**
