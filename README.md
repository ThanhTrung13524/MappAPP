# 🗺️ Vietnam ChronoGIS — Hướng Dẫn Cài Đặt & Vận Hành

> Ứng dụng bản đồ lịch sử hành chính Việt Nam, pha trộn dữ liệu địa lý, Overpass POI và AI chat Groq.

---

## 📋 Mục Lục

1. [Yêu cầu hệ thống](#1-yêu-cầu-hệ-thống)
2. [Cài đặt lần đầu](#2-cài-đặt-lần-đầu)
3. [Cấu hình API Key](#3-cấu-hình-api-key)
4. [Chạy ứng dụng](#4-chạy-ứng-dụng)
5. [Cấu trúc dự án](#5-cấu-trúc-dự-án)
6. [Quá trình Seed dữ liệu](#6-quá-trình-seed-dữ-liệu)
7. [Tính năng chính](#7-tính-năng-chính)
8. [Lưu ý khi chạy](#8-lưu-ý-khi-chạy)

---

## 1. Yêu Cầu Hệ Thống

| Thành phần | Phiên bản tối thiểu |
|---|---|
| Flutter SDK | ≥ 3.12.0 |
| Dart SDK | ≥ 3.12.0 |
| Windows | 10 64-bit trở lên |
| RAM | 8 GB (khuyến nghị 16 GB) |
| Dung lượng trống | 2 GB |
| Kết nối Internet | Cần thiết khi seed lần đầu |

Kiểm tra phiên bản Flutter:

```bash
flutter --version
flutter doctor
```

---

## 2. Cài Đặt Lần Đầu

### 2.1 Clone và cài dependencies

```bash
git clone <your-repo-url>
cd vietnam_chronogis
flutter pub get
```

### 2.2 Chạy code generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ Nếu gặp lỗi conflict, chạy:
> ```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

---

## 3. Cấu Hình API Key

App cần một key cho AI chat Groq.

### 3.1 Groq API Key

- Biến môi trường Dart define: `GROQ_API_KEY`
- App đọc giá trị từ `String.fromEnvironment('GROQ_API_KEY')`
- Nếu không đặt key, app sẽ không khởi tạo được Groq chat.

> 💡 Dự án hiện sử dụng `lib/data/api/groq_service.dart` để gọi Groq OpenAI API.

---

## 4. Chạy Ứng Dụng

### Chạy trực tiếp (Windows)

```bash
cd vietnam_chronogis
flutter run -d windows --dart-define=GROQ_API_KEY=your_groq_key
```

### Chạy trên thiết bị khác hoặc web

```bash
cd vietnam_chronogis
flutter run --dart-define=GROQ_API_KEY=your_groq_key
```

### Build release (Windows)

```bash
cd vietnam_chronogis
flutter build windows --dart-define=GROQ_API_KEY=your_groq_key
```

### VS Code launch config

Tạo `.vscode/launch.json` với cấu hình:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Vietnam ChronoGIS",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=GROQ_API_KEY=your_groq_key"
      ]
    }
  ]
}
```

---

## 5. Cấu Trúc Dự Án

```
vietnam_chronogis/
├── lib/
│   ├── core/
│   │   ├── database/
│   │   │   ├── app_database.dart
│   │   │   ├── tables/
│   │   │   │   ├── administrative_units_table.dart
│   │   │   │   ├── chat_history_table.dart
│   │   │   │   ├── geojson_cache_table.dart
│   │   │   │   ├── historical_events_table.dart
│   │   │   │   └── tourism_places_table.dart
│   │   │   └── daos/
│   │   │       ├── administrative_unit_dao.dart
│   │   │       ├── chat_dao.dart
│   │   │       ├── geojson_dao.dart
│   │   │       └── tourism_dao.dart
│   │   ├── router/app_router.dart
│   │   └── theme/
│   │
│   ├── data/
│   │   ├── api/
│   │   │   ├── groq_service.dart
│   │   │   ├── overpass_api_client.dart
│   │   │   └── ...
│   │   ├── geojson/
│   │   │   └── ...
│   │   └── repositories/
│   │       ├── chat_repository.dart
│   │       ├── administrative_unit_repository.dart
│   │       └── tourism_repository.dart
│   │
│   ├── features/
│   │   ├── ai_chat/
│   │   ├── explorer/
│   │   ├── map/
│   │   └── shell/
│   │
│   ├── shared/
│   │   ├── models/
│   │   └── providers/
│   │       ├── seed_provider.dart
│   │       ├── database_provider.dart
│   │       ├── chat_provider.dart
│   │       ├── tourism_provider.dart
│   │       └── map_provider.dart
│   │
│   └── main.dart
│
├── assets/
│   └── geojson/gadm41_VNM_1.json
├── bin/
│   └── check_db.dart
├── scripts/
│   └── server_seeder.dart
└── pubspec.yaml
```

---

## 6. Quá Trình Seed Dữ Liệu

App seed dữ liệu theo hai giai đoạn chính:

### Phase 1 — Core Data

- `lib/features/shell/presentation/seeding_screen.dart` hiển thị tiến trình.
- `lib/shared/providers/seed_provider.dart` điều phối seed.
- Dữ liệu admin được tải qua nguồn hiện tại và lưu vào SQLite Drift.
- GeoJSON ranh giới tỉnh/nội tỉnh lấy từ `assets/geojson/gadm41_VNM_1.json`.

### Phase 2 — Du lịch / POI

- `lib/data/api/overpass_api_client.dart` gọi Overpass API công khai.
- `lib/data/repositories/tourism_repository.dart` xử lý truy vấn vùng và cache.
- Dữ liệu POI lưu vào bảng `tourism_places_table.dart`.

> 💡 Overpass không cần API key, nhưng có thể bị giới hạn request. App dùng cache và retry để giảm tải.

---

## 7. Tính Năng Chính

- Bản đồ GIS lịch sử hành chính Việt Nam
- Seeding dữ liệu admin + GeoJSON ranh giới tỉnh
- Du lịch/POI từ Overpass API
- AI chat dựa trên Groq stream API
- Riverpod + Drift + Flutter Map + GoRouter

---

## 8. Lưu Ý Khi Chạy

- Khởi chạy từ thư mục `vietnam_chronogis`.
- Đặt `GROQ_API_KEY` qua `--dart-define` nếu muốn dùng chức năng chat.
