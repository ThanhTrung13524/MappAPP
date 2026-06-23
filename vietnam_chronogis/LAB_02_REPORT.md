# BÁO CÁO LAB 02 — VIETNAM CHRONOGIS

**Môn:** PRM393 (Mobile Application Development)  
**Dự án:** Vietnam ChronoGIS — Bản đồ lịch sử hành chính Việt Nam  
**Nền tảng:** Flutter (Android / Windows)  
**Phiên bản:** 1.0.0+1  

---

## 1. Giới thiệu dự án

**Vietnam ChronoGIS** là ứng dụng GIS (Geographic Information System) trên mobile, cho phép người dùng:

- Xem bản đồ Việt Nam với ranh giới tỉnh/thành (GeoJSON) và heatmap dân số theo thời kỳ lịch sử.
- Khám phá điểm du lịch, di tích qua Overpass API.
- **Xem trường Trung học phổ thông (THPT)** trên bản đồ và danh sách, kết hợp thống kê giáo dục từ dataset **Nemotron-Personas-Vietnam** (NVIDIA / HuggingFace).
- Hỏi đáp lịch sử hành chính bằng AI (Groq API), có ngữ cảnh theo tỉnh và năm đang xem trên bản đồ.

**Luồng khởi động app:** Màn hình tải dữ liệu (Seeding) → Bản đồ chính (AppShell) → chuyển tab Map / Explorer / **Trường học** / AI Chat.

---

## 2. Cấu trúc source code

Dự án tuân theo **Clean Architecture**: tách **UI**, **logic nghiệp vụ**, **dữ liệu** và **hạ tầng**. State management dùng **Riverpod** (gần MVVM: UI watch Provider, Provider gọi Repository).

### 2.1. Sơ đồ thư mục chính

```text
vietnam_chronogis/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── router/app_router.dart
│   │   ├── theme/
│   │   └── database/                    # Drift ORM + SQLite (6 bảng)
│   ├── data/
│   │   ├── api/
│   │   │   ├── groq_service.dart        # AI chat
│   │   │   ├── overpass_api_client.dart # Du lịch + trường THPT (OSM)
│   │   │   ├── nemotron_api_client.dart # Dataset Nemotron (HuggingFace)
│   │   │   └── huggingface_api_client.dart
│   │   ├── geojson/
│   │   └── repositories/
│   │       ├── administrative_unit_repository.dart
│   │       ├── tourism_repository.dart
│   │       └── school_repository.dart   # ← MỚI: seed & quản lý trường THPT
│   ├── features/
│   │   ├── shell/                       # AppShell, SeedingScreen
│   │   ├── map/                         # Bản đồ + marker THPT
│   │   ├── explorer/                    # Landmark du lịch
│   │   ├── schools/                     # ← MỚI: tab Trường học
│   │   └── ai_chat/
│   └── shared/providers/
│       ├── tourism_provider.dart
│       └── school_provider.dart         # ← MỚI
├── android/
├── assets/geojson/
└── pubspec.yaml
```

### 2.2. Chi tiết từng lớp

| Lớp | Thư mục | Vai trò |
|-----|---------|---------|
| **Presentation (UI)** | `lib/features/*/presentation/` | Map, Explorer, **SchoolsScreen**, AI Chat, AppShell |
| **State** | `lib/shared/providers/` | Riverpod: map, seed, tourism, **school**, chat |
| **Domain/Data** | `lib/data/repositories/` | Admin, Tourism, **School**, Chat |
| **Infrastructure** | `lib/core/database/` | Drift DAO — **6 bảng** (thêm `schools`) |
| **Routing** | `lib/core/router/` | GoRouter: `/seed` → `/map` |

### 2.3. Luồng dữ liệu (Data Flow)

```text
[API bên ngoài]                         [SQLite local]           [UI]
Overpass (tourism)        ──► TourismRepository  ──► tourism_places ──► Map markers
Overpass (school/THPT)    ──► SchoolRepository   ──► schools        ──► Map + tab Trường học
Nemotron (HuggingFace)    ──► NemotronApiClient  ──► (runtime)      ──► School popup stats
Groq                      ──► GroqService        ──► chat_history   ──► AI Chat
HuggingFace (admin)       ──► AdminRepository    ──► administrative_units
GeoJSON assets            ──► GeoJsonService     ──► geojson_cache  ──► Polygon bản đồ
```

**Lần mở đầu:** `seedInitializationProvider` tải tuần tự: dữ liệu hành chính → GeoJSON → du lịch → **trường THPT** → lưu SQLite offline.

---

## 3. Các kỹ thuật & thư viện sử dụng

| Kỹ thuật / Thư viện | Mục đích trong dự án |
|---------------------|----------------------|
| **Flutter 3.44+** | Framework đa nền tảng; 1 codebase UI cho Android & Desktop |
| **Riverpod 3.x** | Quản lý state type-safe, reactive UI |
| **GoRouter** | Điều hướng declarative (`/seed`, `/map`) |
| **Drift + SQLite** | ORM lưu offline: tỉnh, GeoJSON, tourism, **schools**, chat |
| **Freezed + json_serializable** | Model bất biến, serialize JSON an toàn |
| **flutter_map + latlong2** | Render bản đồ, polygon, marker du lịch & **trường THPT** |
| **Dio** | HTTP client: Groq, Overpass, Wikipedia, **HuggingFace Datasets Server** |
| **Groq API (SSE stream)** | AI chat trả lời từng token realtime |
| **Overpass API** | POI du lịch + **trường `amenity=school` (lọc THPT)** |
| **Nemotron-Personas-VN** | Dataset NVIDIA trên HuggingFace — thống kê `education_level` theo vùng |
| **SharedPreferences** | Đánh dấu đã seed (`seeded_schools_v1`, …) |
| **compute() / Isolate** | Parse GeoJSON lớn trên background thread |
| **dart-define-from-file** | Cấu hình `GROQ_API_KEY` qua `dart_defines.json` |

### 3.1. Cơ sở dữ liệu (6 bảng Drift)

| Bảng | Nội dung |
|------|----------|
| `administrative_units` | Tỉnh/xã, dân số, diện tích, mật độ |
| `geojson_cache` | Polygon ranh giới tỉnh |
| `tourism_places` | Điểm du lịch từ Overpass |
| **`schools`** | **Trường THPT: tên, loại, tọa độ, địa chỉ, tỉnh, vùng Nemotron** |
| `chat_history` | Tin nhắn AI chat |
| `historical_events` | Sự kiện lịch sử hành chính |

---

## 4. Tính năng Trường THPT + Nemotron (Lab 2/3)

Theo yêu cầu giảng viên: kết hợp **dataset Nemotron-Personas-Vietnam** với API dữ liệu trường học.

### 4.1. Nguồn dữ liệu trường THPT (Overpass / OpenStreetMap)

- File: `lib/data/api/overpass_api_client.dart` — method `fetchSchoolsByBbox()`
- Query OSM: `amenity=school` trong bounding box Việt Nam
- Lọc THPT theo tag: `school:level=secondary`, `isced:level=3`, hoặc tên chứa "THPT"
- Lưu SQLite qua `SchoolRepository.seedSchools()` (lưới 3×3 ô, tương tự tourism)

**Thông tin hiển thị mỗi trường:**
- Tên, loại (THPT / THPT Chuyên / Quốc tế)
- Tỉnh/thành, địa chỉ, SĐT, chủ quản (operator)
- Tọa độ trên bản đồ (marker xanh 🏫)

### 4.2. Dataset Nemotron-Personas-Vietnam (HuggingFace)

- **Dataset:** [nvidia/Nemotron-Personas-Vietnam](https://huggingface.co/datasets/nvidia/Nemotron-Personas-Vietnam)
- **API:** HuggingFace Datasets Server (`datasets-server.huggingface.co/rows`)
- **File client:** `lib/data/api/nemotron_api_client.dart`
- **Mục đích:** Hiển thị **thống kê trình độ học vấn** (`education_level`: THPT, Đại học, …) theo **6 vùng** trong dataset (Hà Nội, TP.HCM, Hải Phòng, Đà Nẵng, Cần Thơ, Đồng Nai)
- **Cách dùng trong app:** Khi chạm marker trường → popup hiển thị % THPT / % Đại học của vùng (mẫu từ Nemotron), bổ sung ngữ cảnh giáo dục cho Lab

> **Lưu ý:** Nemotron là dữ liệu **persona tổng hợp** (CC BY 4.0), không phải danh sách trường thật. Trường THPT trên bản đồ lấy từ **OSM**; Nemotron dùng để **phân tích/thống kê giáo dục theo vùng**.

### 4.3. Giao diện người dùng

| Màn hình | Mô tả |
|----------|--------|
| **Tab Trường học** | Danh sách + tìm kiếm trường THPT; chạm xem chi tiết |
| **Bản đồ — lớp THPT** | Toggle "THPT" bật/tắt marker; chạm marker → popup |
| **Popup trường** | Thông tin OSM + biểu đồ % giáo dục Nemotron |

---

## 5. Build APK & triển khai thiết bị thật

### 5.1. Build APK (Android)

```powershell
cd vietnam_chronogis
flutter build apk --release --split-per-abi --dart-define-from-file=dart_defines.json
```

**File nộp / cài máy:**  
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (~21 MB)

### 5.2. Cài trên điện thoại Android

1. Copy APK sang điện thoại.
2. **Cài đặt → Cài ứng dụng không rõ nguồn** → bật cho app Files/Zalo.
3. Mở APK → Cài đặt.
4. Lần đầu mở cần **Internet** (tải dữ liệu hành chính, du lịch, **trường THPT**).

### 5.3. Chạy debug trên emulator / máy thật

```powershell
flutter run --dart-define-from-file=dart_defines.json
```

---

## 6. Ảnh chụp màn hình chính

> Chụp từ điện thoại thật hoặc emulator, chèn vào `screenshots/` trước khi xuất PDF.

### 6.1. Màn hình tải dữ liệu (Seeding)

![Màn hình Seeding](screenshots/01_seeding.png)

*Chú thích:* Tải dữ liệu hành chính, du lịch và trường THPT lần đầu.

---

### 6.2. Màn hình Bản đồ + marker THPT

![Màn hình Bản đồ](screenshots/02_map.png)

*Chú thích:* Polygon 34 tỉnh, heatmap, marker trường THPT (xanh), toggle lớp THPT.

---

### 6.3. Tab Trường học

![Tab Trường học](screenshots/05_schools.png)

*Chú thích:* Danh sách trường THPT, tìm kiếm, xem chi tiết từng trường.

---

### 6.4. Popup trường + thống kê Nemotron

![Popup Nemotron](screenshots/06_school_nemotron.png)

*Chú thích:* Thông tin trường (OSM) + % THPT / Đại học từ dataset Nemotron-Personas-VN.

---

### 6.5. Màn hình Khám phá (Explorer)

![Màn hình Explorer](screenshots/03_explorer.png)

*Chú thích:* Tìm kiếm landmark/điểm du lịch.

---

### 6.6. Màn hình AI Chat

![Màn hình AI Chat](screenshots/04_ai_chat.png)

*Chú thích:* Hỏi đáp lịch sử hành chính với Groq AI.

---

## 7. Kết luận

Dự án **Vietnam ChronoGIS** đã:

- Hoàn thiện giao diện mobile (BottomNavigationBar, Drawer, 4 tab chính).
- Tích hợp **trường THPT** trên bản đồ (Overpass) và tab **Trường học**.
- Kết hợp dataset **Nemotron-Personas-Vietnam** (HuggingFace) cho thống kê giáo dục theo vùng — đáp ứng hướng phát triển Lab 2/3.
- Build APK release cài được trên thiết bị Android thật.
- Tuân thủ Clean Architecture, dữ liệu offline (SQLite) + API online (Groq, Overpass, HuggingFace).

---

## Phụ lục: Xuất file PDF

1. Tạo thư mục `screenshots/` và chèn 6 ảnh theo mục 6.
2. Copy sang Word / Google Docs hoặc dùng extension **Markdown PDF**.
3. **File → Xuất PDF** → nộp cùng APK khi chấm Lab 02.
