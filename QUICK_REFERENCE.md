# 🚀 Vietnam ChronoGIS - QUICK REFERENCE CARD

> **1 trang cheat sheet - dùng khi báo cáo hoặc ôn tập nhanh**

---

## 📍 **ARCHITECTURE AT A GLANCE**

```
┌──────────────────────────────────────────────────┐
│ Features (UI)                                    │
│ ├─ MapViewScreen    │ AIInsightsScreen          │
│ ├─ ExplorerScreen   │ AppShell (Navigation)    │
└──────────────────────────────────────────────────┘
                ↑
┌──────────────────────────────────────────────────┐
│ Data (Business Logic)                            │
│ ├─ Repositories (chat, admin_unit, tourism)    │
│ ├─ API Clients (Groq, HuggingFace)              │
│ └─ Services (GeoJSON parsing, OSRM routing)    │
└──────────────────────────────────────────────────┘
                ↑
┌──────────────────────────────────────────────────┐
│ Core (Infrastructure)                            │
│ ├─ Database (SQLite + Drift ORM)                │
│ ├─ Router (GoRouter)                            │
│ ├─ Theme (Material Design)                      │
└──────────────────────────────────────────────────┘
```

---

## 🗄️ **DATABASE SCHEMA (5 TABLES)**

| Table | Key Columns | Purpose |
|-------|-------------|---------|
| **AdministrativeUnits** | ma, ten, areaKm2, population, centroidLat/Lon | Tỉnh/thành phố |
| **ChatHistoryMessages** | id, role (user/assistant), content, timestamp | Chat history |
| **GeoJsonCaches** | ma, geoJsonBinary, createdAt | Biên giới (polygon) |
| **TourismPlaces** | name, category, location | Địa điểm du lịch |
| **HistoricalEvents** | year, description, decree | Sự kiện lịch sử |

**Schema Version**: v2 (v1→v2 added TourismPlaces)

---

## 🔄 **STATE MANAGEMENT (Riverpod 4 Types)**

| Type | Example | Caching | Reactive |
|------|---------|---------|----------|
| `Provider<T>` | databaseProvider | ✅ Yes | ❌ No |
| `FutureProvider<T>` | provincesProvider | ✅ Yes | ✅ Yes (Stream) |
| `StreamProvider<T>` | chatMessagesProvider | ✅ Yes | ✅ Always |
| `Notifier<T>` | ChatNotifier, SelectedProvince | ✅ Yes | ✅ Yes |

**Key**: When dependency changes → provider invalidates → watchers rebuild → UI updates

---

## 💬 **CHAT FLOW (Token Streaming)**

```
User: "Tỉnh này có mấy tỉnh phụ?"
  ↓
ChatNotifier.sendMessage(text)
  ↓
Build ChatContext (year, province, era)
  ↓
GroqService.sendMessage(text, context) [STREAMING]
  ↓
Groq API: POST /chat/completions {stream: true}
  ↓
SSE Response:
  data: {"choices":[{"delta":{"content":"Nội"}}]}
  data: {"choices":[{"delta":{"content":"dung"}}]}
  data: [DONE]
  ↓
UI: "Nội" (typing) → "Nội dung" (typing) → ...
```

---

## 🗺️ **MAP FLOW (GeoJSON → Rendering)**

```
assets/geojson/gadm41_VNM_1.json
  ↓
GeoJsonParser.parseVietnamBorders()
  ↓
Map<String, List<LatLng>>
  ↓
Cache to DB (GeoJsonCaches)
  ↓
MapViewScreen: 
├─ Watch selectedProvinceProvider
├─ Fetch from provincesProvider
└─ Render PolygonLayer
```

**On Click**: User clicks → select(ma) → state changes → UI rebuild → highlight blue

---

## ⚡ **KEY TECHNOLOGIES**

| Layer | Tech | Version | Purpose |
|-------|------|---------|---------|
| **UI** | Flutter | 3.12.0+ | Cross-platform |
| **State** | Riverpod | 3.3.1 | Reactive, type-safe |
| **Database** | SQLite+Drift | 3.3.1 | Type-safe ORM |
| **Routing** | GoRouter | 17.2.3 | Declarative nav |
| **API** | Dio | 5.9.2 | HTTP streaming |
| **AI/LLM** | Groq | (v1) | llama-3.3-70b |
| **Models** | Freezed | 3.1.0 | Immutable |
| **Map** | Flutter Map | 8.3.0 | Map rendering |
| **Geo** | latlong2 | 0.9.1 | LatLng calculations |

---

## 📋 **TOP 5 CONCEPTS TEACHER WILL ASK**

### **1. Tại sao Clean Architecture?**
**Answer**: Separation of concerns → easy to test, modify, scale. Core independent, Data reusable, Features can change

### **2. Tại sao Riverpod?**
**Answer**: Reactive (auto rebuild), type-safe (compiler check), lazy loading, caching, no boilerplate

### **3. Database ngơi, table mấy cái?**
**Answer**: SQLite (offline, fast), 5 tables (admin units, chat, geojson cache, tourism, historical events), v2 schema

### **4. Chat streaming là gì?**
**Answer**: Token-by-token via SSE (not wait full response) → better UX, lower latency, shows AI thinking

### **5. Map interactive sao?**
**Answer**: GeoJSON → LatLng → PolygonLayer. User click → state update → Riverpod rebuild → highlight blue + sidebar update

---

## 🎯 **5-MINUTE ELEVATOR PITCH**

> "Vietnam ChronoGIS is a Flutter app that visualizes Vietnam's administrative history 1975-2025 with 3 main features: 
> 1) Interactive map (GeoJSON + Flutter Map), 
> 2) AI chat (Groq streaming LLM), 
> 3) Data explorer (responsive UI).
>
> **Architecture**: Clean 3-layer (Core/Database, Data/Repositories, Features/UI).
> 
> **State Management**: Riverpod for reactivity + type-safety.
> 
> **Database**: SQLite + Drift ORM (5 tables, type-safe queries, reactive streams).
> 
> **Innovation**: Combine historical maps with AI insights + streaming responses for real-time UX.
> 
> Main challenges: SSE parsing, GeoJSON coordinate conversion, database migration. All solved with proper patterns."

---

## ✅ **BEFORE PRESENTATION CHECKLIST**

**Technical**:
- [ ] App builds & runs on device
- [ ] Chat streaming works (check internet)
- [ ] Map displays all 63 provinces
- [ ] Database seeding completes
- [ ] Code opens in VS Code

**Presentation**:
- [ ] Print architecture diagrams
- [ ] Memorize 10 key lines from code
- [ ] Practice 10-min summary
- [ ] Prepare live demo (3 features)
- [ ] Know answers to 5 top concepts

**Materials**:
- [ ] Laptop + charger
- [ ] Phone for demo
- [ ] USB with backup code
- [ ] Printed diagrams
- [ ] This cheat sheet

---

## 🔗 **FILE QUICK LINKS**

**Understanding**:
- Deep dive: `PROJECT_DEEP_DIVE.md` (read this first)
- Q&A: `Q_AND_A_FOR_TEACHER.md` (22 questions)

**Presenting**:
- Diagrams: `VISUAL_FLOWCHARTS.md` (10 flows)
- Script: `PRESENTATION_GUIDE.md` (structure + timing)
- This guide: `README_REPORT_GUIDE.md` (how to use all docs)

**Code**:
- Start: `lib/main.dart` (entry point)
- State: `lib/shared/providers/` (11 providers)
- Database: `lib/core/database/` (Drift setup)
- API: `lib/data/api/groq_service.dart` (streaming)
- Map: `lib/features/map/` (Flutter Map)

---

## 💡 **PRO TIPS**

1. **Point to code while explaining** → More credible
2. **Show diagrams from VISUAL_FLOWCHARTS.md** → Visual learners understand better
3. **Do live demo** → Concrete > abstract
4. **Admit unknowns** → "Good question, I can research and get back to you" is OK
5. **Keep timing strict** → Better rushed professional than lazy complete

---

## 🎤 **QUICK ANSWERS (When Teacher Asks)**

| Q | A (30-second version) |
|---|-----|
| **Architecture?** | 3-layer: Core (DB/routing), Data (repos/API), Features (UI). Separation of concerns. |
| **State?** | Riverpod - reactive, type-safe, caches automatically. 4 provider types. |
| **Database?** | SQLite + Drift ORM. 5 tables. v2 schema. Type-safe queries. DAO pattern. |
| **Chat?** | Groq LLM streaming SSE. Token-by-token. Context from map state. Real-time UI. |
| **Map?** | GeoJSON (GADM) → LatLng → FlutterMap. Click update Riverpod state → rebuild. |
| **Performance?** | Lazy loading, caching, indexing. ~500ms map load, <10ms query. |
| **Test?** | Widget, Overpass API, GeoJSON validation tests. |
| **Responsive?** | MediaQuery: sidebar collapse < 1000px. AnimatedContainer 250ms. |

---

## 🎓 **REMEMBER**

✅ **Do**: Speak clearly, point to code, show diagrams, do demo, mention tech stack

❌ **Don't**: Read slides word-for-word, go too deep, rush, forget to mention challenges

**Key Takeaway**: "I built a complete full-stack app with Clean Architecture, reactive state management, type-safe database, AI streaming integration, and responsive UI"

---

**Good luck! 🎉 You've got this! 🚀**

---

*Last updated: May 26, 2026*
*Print this page and carry to presentation* 📄
