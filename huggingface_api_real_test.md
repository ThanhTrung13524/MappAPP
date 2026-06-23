# HuggingFace API — Kết quả test thực tế
**Dataset:** `tmquan/sapnhap-bando-vn`  
**Tested:** 19/05/2026 — web_fetch trực tiếp, không mock

---

## API 2 — `/splits` ✅

```
GET https://datasets-server.huggingface.co/splits?dataset=tmquan%2Fsapnhap-bando-vn
```

### Response thực tế
```json
{
  "splits": [
    { "dataset": "tmquan/sapnhap-bando-vn", "config": "all",        "split": "train" },
    { "dataset": "tmquan/sapnhap-bando-vn", "config": "committees", "split": "train" },
    { "dataset": "tmquan/sapnhap-bando-vn", "config": "communes",   "split": "train" },
    { "dataset": "tmquan/sapnhap-bando-vn", "config": "provinces",  "split": "train" }
  ],
  "pending": [],
  "failed": []
}
```

### Kết luận
| Config | Mô tả |
|---|---|
| `all` | Tất cả: provinces + communes + committees |
| `provinces` | 34 tỉnh/thành sau sáp nhập 2025 |
| `communes` | Xã/phường/thị trấn |
| `committees` | Cấp ủy |

**Flutter code:**
```dart
// Dùng để verify dataset còn hoạt động khi app khởi động
Future<bool> checkDatasetAvailable() async {
  final r = await dio.get('$_base/splits?dataset=$_dataset');
  final splits = r.data['splits'] as List;
  return splits.isNotEmpty && r.data['failed'].isEmpty;
}
```

---

## API 3 — `/parquet` ✅

```
GET https://huggingface.co/api/datasets/tmquan/sapnhap-bando-vn/parquet/all/train
```

### Response thực tế
```json
[
  "https://huggingface.co/api/datasets/tmquan/sapnhap-bando-vn/parquet/all/train/0.parquet"
]
```

### Kết luận
- **Chỉ có 1 shard duy nhất** (`0.parquet`) — không cần loop nhiều file
- URL pattern: `.../parquet/{config}/train/0.parquet`
- Filename là `0.parquet` (không phải `0000.parquet` như tôi estimate trước)

**Flutter code đúng:**
```dart
// ✅ ĐÚNG
final urls = await getParquetUrls(); // → ["...0.parquet"]
final file = await downloadShard(url: urls[0], filename: 'all_train_0.parquet');

// ❌ SAI (code cũ của tôi dùng 0000.parquet)
```

---

## API 1 — `/rows` ✅

```
GET https://datasets-server.huggingface.co/rows
  ?dataset=tmquan%2Fsapnhap-bando-vn
  &config=all
  &split=train
  &offset=0
  &length=100
```

---

### Schema — 28 columns thực tế (từ `features` array)

| idx | name | type | Flutter type |
|---|---|---|---|
| 0 | `id` | large_string | `String` |
| 1 | `kind` | large_string | `String` — "province"/"commune"/"committee" |
| 2 | `ma` | large_string | `String` |
| 3 | `ten` | large_string | `String` |
| 4 | `type` | large_string | `String` — "Thành phố"/"Tỉnh"/"Thủ đô"/"Phường"/"Xã" |
| 5 | `ten_short` | large_string | `String` |
| 6 | `area_km2` | float64 | `double?` |
| 7 | `population` | float64 | `double?` |
| 8 | `density` | float64 | `double?` |
| 9 | `capital` | large_string | `String?` |
| 10 | `address` | large_string | `String?` |
| 11 | `phone` | large_string | `String?` |
| 12 | `decree` | large_string | `String` |
| 13 | `decree_url` | large_string | `String` |
| 14 | `predecessors` | large_string | `String?` |
| 15 | `parent_ma` | large_string | `String?` — null với provinces |
| 16 | `parent_ten` | large_string | `String?` — null với provinces |
| 17 | `centroid_lon` | float64 | `double?` |
| 18 | `centroid_lat` | float64 | `double?` |
| 19 | `bbox` | List\<float64\> | `List<double>` — 4 phần tử |
| 20 | `geom_type` | large_string | `String?` — "Polygon"/"MultiPolygon" |
| 21 | `n_vertices` | int64 | `int?` |
| 22 | `macro_region` | large_string | `String` |
| 23 | `predecessors_list` | List\<string\> | `List<String>` |
| 24 | `n_predecessors` | int64 | `int` |
| 25 | `embed_text` | large_string | `String` |
| 26 | `keywords` | List\<string\> | `List<String>` |
| 27 | `parent_ten_xa` | large_string | `String?` |

---

### Dữ liệu thực tế — 34 Provinces (row_idx 0–33)

| row_idx | ma | ten | type | n_pred | macro_region | predecessors_list |
|---|---|---|---|---|---|---|
| 0 | 92 | Thành phố Cần Thơ | Thành phố | 3 | mekong_delta | Cần Thơ, Sóc Trăng, Hậu Giang |
| 1 | 48 | Thành phố Đà Nẵng | Thành phố | 2 | central_coast | Đà Nẵng, Quảng Nam |
| 2 | 31 | Thành phố Hải Phòng | Thành phố | 2 | red_river_delta | Hải Phòng, Hải Dương |
| 3 | 79 | Thành phố Hồ Chí Minh | Thành phố | 3 | southeast | TPHCM, Bà Rịa-VT, Bình Dương |
| 4 | 46 | Thành phố Huế | Thành phố | 1 | central_coast | giữ nguyên |
| 5 | 01 | Thủ đô Hà Nội | Thủ đô | 1 | red_river_delta | giữ nguyên |
| 6 | 91 | Tỉnh An Giang | Tỉnh | 2 | mekong_delta | Kiên Giang, An Giang |
| 7 | 24 | Tỉnh Bắc Ninh | Tỉnh | 2 | northern_midlands | Bắc Giang, Bắc Ninh |
| 8 | 96 | Tỉnh Cà Mau | Tỉnh | 2 | mekong_delta | Bạc Liêu, Cà Mau |
| 9 | 04 | Tỉnh Cao Bằng | Tỉnh | 1 | northern_midlands | giữ nguyên |
| 10 | 66 | Tỉnh Đắk Lắk | Tỉnh | 2 | central_highlands | Phú Yên, Đắk Lắk |
| 11 | 11 | Tỉnh Điện Biên | Tỉnh | 1 | northern_midlands | giữ nguyên |
| 12 | 75 | **Thành phố Đồng Nai** | Thành phố | 4 | southeast | Bình Phước, Đồng Nai... |
| 13 | 82 | Tỉnh Đồng Tháp | Tỉnh | 2 | mekong_delta | Tiền Giang, Đồng Tháp |
| 14 | 52 | Tỉnh Gia Lai | Tỉnh | 2 | central_highlands | Bình Định, Gia Lai |
| 15 | 42 | Tỉnh Hà Tĩnh | Tỉnh | 1 | central_coast | giữ nguyên |
| 16 | 33 | Tỉnh Hưng Yên | Tỉnh | 2 | red_river_delta | Thái Bình, Hưng Yên |
| 17 | 56 | Tỉnh Khánh Hòa | Tỉnh | 2 | central_coast | Ninh Thuận, Khánh Hòa |
| 18 | 12 | Tỉnh Lai Châu | Tỉnh | 1 | northern_midlands | giữ nguyên |
| 19 | 68 | Tỉnh Lâm Đồng | Tỉnh | 3 | central_highlands | Đắk Nông, Bình Thuận, Lâm Đồng |
| 20 | 20 | Tỉnh Lạng Sơn | Tỉnh | 1 | northern_midlands | giữ nguyên |
| 21 | 15 | Tỉnh Lào Cai | Tỉnh | 2 | northern_midlands | Yên Bái, Lào Cai |
| 22 | 40 | Tỉnh Nghệ An | Tỉnh | 1 | central_coast | giữ nguyên |
| 23 | 37 | Tỉnh Ninh Bình | Tỉnh | 3 | red_river_delta | Hà Nam, Nam Định, Ninh Bình |
| 24 | 25 | Tỉnh Phú Thọ | Tỉnh | 3 | northern_midlands | Vĩnh Phúc, Hòa Bình, Phú Thọ |
| 25 | 51 | Tỉnh Quảng Ngãi | Tỉnh | 2 | central_coast | Kon Tum, Quảng Ngãi |
| 26 | 22 | Tỉnh Quảng Ninh | Tỉnh | 1 | red_river_delta | giữ nguyên |
| 27 | 44 | Tỉnh Quảng Trị | Tỉnh | 2 | central_coast | Quảng Bình, Quảng Trị |
| 28 | 14 | Tỉnh Sơn La | Tỉnh | 1 | northern_midlands | giữ nguyên |
| 29 | 80 | Tỉnh Tây Ninh | Tỉnh | 2 | southeast | Long An, Tây Ninh |
| 30 | 19 | Tỉnh Thái Nguyên | Tỉnh | 2 | northern_midlands | Bắc Kạn, Thái Nguyên |
| 31 | 38 | Tỉnh Thanh Hóa | Tỉnh | 1 | central_coast | giữ nguyên |
| 32 | 08 | Tỉnh Tuyên Quang | Tỉnh | 2 | northern_midlands | Hà Giang, Tuyên Quang |
| 33 | 86 | Tỉnh Vĩnh Long | Tỉnh | 3 | mekong_delta | Bến Tre, Trà Vinh, Vĩnh Long |

**Thống kê provinces:**
- Giữ nguyên (n=1): Huế, Hà Nội, Cao Bằng, Điện Biên, Hà Tĩnh, Lai Châu, Lạng Sơn, Nghệ An, Quảng Ninh, Sơn La, Thanh Hóa = **11 tỉnh**
- Sáp nhập 2 đơn vị: **14 tỉnh**
- Sáp nhập 3 đơn vị: Cần Thơ, HCM, Lâm Đồng, Ninh Bình, Phú Thọ, Vĩnh Long = **6 tỉnh**
- Sáp nhập 4 đơn vị: Đồng Nai = **1 tỉnh** (đặc biệt có NQ riêng 30/2026/QH16)
- Tổng: **34 tỉnh/thành**

---

### ⚠️ Phát hiện quan trọng từ data thực tế

#### 1. `bbox` — SAI với từng tỉnh riêng lẻ
```
Tất cả 34 tỉnh đều có bbox GIỐNG HỆT NHAU:
[102.14148411, 8.41365242, 109.45949279, 23.39331094]
```
Đây là bbox của **toàn bộ Việt Nam**, không phải bbox riêng từng tỉnh.  
→ **Không dùng `bbox` để `fitBounds()` cho tỉnh đơn lẻ được.**  
→ Dùng `centroid_lon/lat` + zoom cố định, hoặc tính bbox từ GeoJSON polygon.

#### 2. Thành phố Đồng Nai — NQ khác (2026)
```
ma: "75"
decree: "Nghị quyết số 30/2026/QH16"   ← NQ năm 2026, khác với 202/2025
n_predecessors: 4
predecessors_list: ["tỉnh Bình Phước", "tỉnh Đồng Nai. Từ ngày 30/04/2026", 
                    "Tỉnh Đồng Nai mới (sau sáp nhập) chuyển thành Thành phố Đồng Nai",
                    "thêm 10 xã chuyển thành phường"]
```
→ `predecessors_list` bị parse sai — thực ra chỉ có 2 tỉnh gốc (Bình Phước + Đồng Nai).  
→ Cần filter `predecessors_list` trong Flutter: bỏ các phần tử là câu văn, giữ lại tên tỉnh thực.

#### 3. `config=all` trả về mixed — provinces trước, communes sau
- Row 0–33: provinces (34 tỉnh)
- Row 34+: communes (bắt đầu là Phường Ba Đình - Hà Nội)
- Phân biệt bằng field `kind`: `"province"` vs `"commune"` vs `"committee"`

#### 4. Communes có `parent_ma` và `parent_ten`
```json
// Ví dụ Phường Ba Đình (commune):
"parent_ma": "01",
"parent_ten": "Thủ đô Hà Nội"
```
→ Dùng để filter communes theo tỉnh: `WHERE parent_ma = '01'`

#### 5. `n_predecessors` communes rất cao (6–11)
```
Phường Ba Đình:    n_predecessors = 11
Phường Bạch Mai:   n_predecessors = 10
Phường Cầu Giấy:  n_predecessors = 6
```
→ Không nên dùng n_predecessors để xác định "MERGED" badge ở cấp commune — sẽ thấy hầu hết là merged.

#### 6. `predecessors_list` của communes bị parse thô
```json
// Phường Bồ Đề:
"predecessors_list": [
  "Phường Ngọc Lâm",
  "TN",   ← Fragment của câu "diện tích TN"
  "quy mô dân số của các phường Đức Giang",  ← Câu văn
  ...
]
```
→ `predecessors_list` ở cấp commune KHÔNG đáng tin dùng trực tiếp.  
→ Chỉ dùng field `predecessors` (text gốc) để display, không parse.

#### 7. Commune `decree` khác với province
```
Provinces: "Nghị quyết số 202/2025/QH15"
Communes:  "Nghị quyết số 1656/NQ-UBTVQH15"  ← NQ của UBTVQH, cấp thấp hơn
```
→ Cần lưu riêng, không giả định tất cả cùng 1 decree.

---

### Dữ liệu Commune sample (row 34–46, Hà Nội)

| ma | ten | type | n_pred | centroid |
|---|---|---|---|---|
| 00004 | Phường Ba Đình | Phường | 11 | (105.838, 21.039) |
| 00292 | Phường Bạch Mai | Phường | 10 | (105.852, 21.002) |
| 00118 | Phường Bồ Đề | Phường | 10 | (105.871, 21.051) |
| 00166 | Phường Cầu Giấy | Phường | 6 | (105.788, 21.031) |
| 10015 | Phường Chương Mỹ | Phường | 8 | (105.699, 20.925) |
| 00082 | Phường Cửa Nam | Phường | 10 | (105.851, 21.023) |
| 00637 | Phường Đại Mỗ | Phường | 10 | (105.775, 20.994) |
| 00316 | Phường Định Công | Phường | 9 | (105.825, 20.977) |
| 00235 | Phường Đống Đa | Phường | 7 | (105.822, 21.012) |
| 00602 | Phường Đông Ngạc | Phường | 8 | (105.776, 21.075) |
| 09886 | Phường Dương Nội | Phường | 9 | (105.749, 20.975) |
| 00025 | Phường Giảng Võ | Phường | 9 | (105.814, 21.028) |
| 09556 | Phường Hà Đông | Phường | ? | (105.?, 21.?) |

---

### `embed_text` format thực tế

**Province format:**
```
"{ten} ; loại: {type} ; sáp nhập từ: {predecessors} ; trung tâm hành chính: {capital} ; căn cứ: {decree}"
```
Ví dụ:
```
"Thành phố Hồ Chí Minh ; loại: Thành phố ; sáp nhập từ: TPHCM, tỉnh Bà Rịa - Vũng Tàu và tỉnh Bình Dương ; trung tâm hành chính: Tp. HCM (cũ) ; căn cứ: Nghị quyết số 202/2025/QH15"
```

**Commune format:**
```
"{ten} ; (thuộc {parent_ten}) ; loại: {type} ; sáp nhập từ: {predecessors} ; trung tâm hành chính: {capital} ; căn cứ: {decree}"
```
Ví dụ:
```
"Phường Ba Đình ; (thuộc Thủ đô Hà Nội) ; loại: Phường ; sáp nhập từ: Phường Quán Thánh, Phường Trúc Bạch... ; trung tâm hành chính: Số 2, phố Trúc Bạch, phường Ba Đình ; căn cứ: Nghị quyết số 1656/NQ-UBTVQH15"
```

---

## Cập nhật Flutter Implementation

### 1. Parser fix cho `predecessors_list` commune

```dart
/// Filter bỏ các phần tử là fragment câu văn, chỉ giữ tên đơn vị thực
static List<String> cleanPredecessorsList(List<String> raw, String kind) {
  if (kind != 'commune') return raw; // province list đã ok

  return raw.where((item) {
    // Bỏ nếu là fragment viết tắt
    if (item.trim() == 'TN') return false;
    if (item.trim() == 'giữ nguyên') return false;
    // Bỏ nếu là câu văn dài (>50 ký tự và chứa "của", "theo", "sau khi")
    if (item.length > 50 &&
        (item.contains('của') || item.contains('sau khi') || item.contains('quy mô'))) {
      return false;
    }
    return true;
  }).toList();
}
```

### 2. Fix bbox không dùng được cho fitBounds

```dart
// ❌ SAI — bbox là toàn VN, không phải tỉnh riêng
mapController.fitBounds(LatLngBounds.fromPoints([
  LatLng(unit.bbox[1], unit.bbox[0]),
  LatLng(unit.bbox[3], unit.bbox[2]),
]));

// ✅ ĐÚNG — dùng centroid + zoom phù hợp theo type
double zoom = unit.kind == 'province' ? 9.0 : 12.0;
mapController.move(LatLng(unit.centroidLat!, unit.centroidLon!), zoom);
```

### 3. Badge logic đúng cho provinces

```dart
String getBadge(AdministrativeUnit unit) {
  // Dùng ma để xác định đặc biệt
  if (unit.ma == '01') return 'CAPITAL';    // Hà Nội - Thủ đô
  if (unit.ma == '79') return 'CURRENT';    // TP HCM - trung tâm kinh tế
  
  // Dùng capital field để xác định "cũ" hay không
  if (unit.capital == 'giữ nguyên') return 'UNCHANGED'; // n_predecessors == 1
  return 'MERGED';  // n_predecessors > 1
}
```

### 4. Pagination đúng cho config=all

```dart
// config=all có 6712 rows
// config=provinces chỉ có 34 rows → 1 request là xong
// config=communes có ~3320 rows → 34 requests (100/page)

// Strategy tốt nhất cho app:
// 1. Lấy provinces riêng (1 request, nhanh)
// 2. Lấy communes theo từng tỉnh khi user click (lazy load theo parent_ma)

Future<List<AdministrativeUnit>> fetchCommunesByProvince(String parentMa) async {
  // Không có server-side filter → fetch all communes, filter client-side
  // Hoặc: cache toàn bộ communes sau lần đầu
  final all = await fetchAll(config: DatasetConfig.communes);
  return all.where((u) => u.parentMa == parentMa).toList();
}
```

### 5. Detect Đồng Nai đặc biệt

```dart
// Đồng Nai có NQ 2026, predecessors_list parse sai
// Hard-code fix hoặc dùng decree để detect
bool isSpecialCase(AdministrativeUnit unit) {
  return unit.ma == '75'; // Thành phố Đồng Nai
}

List<String> getRealPredecessors(AdministrativeUnit unit) {
  if (unit.ma == '75') {
    return ['tỉnh Bình Phước', 'tỉnh Đồng Nai']; // Hard-code đúng
  }
  return unit.predecessorsList;
}
```

---

## Tóm tắt cho Flutter app

| Vấn đề | Giải pháp |
|---|---|
| bbox sai cho từng tỉnh | Dùng centroid + zoom cố định |
| predecessors_list commune bị parse thô | Chỉ display `predecessors` text gốc |
| Đồng Nai có NQ 2026, parse sai | Hard-code predecessors cho ma=75 |
| config=all mix provinces+communes | Phân biệt bằng field `kind` |
| commune n_predecessors cao (6-11) | Không dùng n_pred để badge ở commune |
| 1 shard parquet duy nhất | Download thẳng `0.parquet`, không loop |
| Commune decree khác province | Lưu `decree` field riêng, không assume |
