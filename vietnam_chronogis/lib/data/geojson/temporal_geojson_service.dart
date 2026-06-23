// lib/data/geojson/temporal_geojson_service.dart
// FIX: unused import (flutter_riverpod) → xoá
// FIX: unintended_html_in_doc_comment → dùng backtick thay vì angle brackets

import 'dart:convert';
import 'package:flutter/foundation.dart';
// FIX: xoá import flutter_riverpod không dùng

import '../../core/database/daos/administrative_unit_dao.dart';
import '../../core/database/daos/geojson_dao.dart';

// ──────────────────────────────────────────────────────────────
// Model
// ──────────────────────────────────────────────────────────────

class TemporalPolygon {
  final String key;
  final String displayName;
  final String geoJsonData;
  final String macroRegion;

  /// true → dữ liệu từ GADM (63 tỉnh trước 2025)
  /// false → dữ liệu từ Hugging Face (34 siêu tỉnh 2025+)
  final bool isPreMerger;

  const TemporalPolygon({
    required this.key,
    required this.displayName,
    required this.geoJsonData,
    required this.macroRegion,
    required this.isPreMerger,
  });
}

// ──────────────────────────────────────────────────────────────
// Service
// ──────────────────────────────────────────────────────────────

class TemporalGeoJsonService {
  final GeoJsonDao _geoJsonDao;
  final AdministrativeUnitDao _unitDao;

  TemporalGeoJsonService(this._geoJsonDao, this._unitDao);

  static const List<String> gadmProvinceNames = [
    'An Giang',
    'Ba Ria - Vung Tau',
    'Bac Giang',
    'Bac Kan',
    'Bac Lieu',
    'Bac Ninh',
    'Ben Tre',
    'Binh Dinh',
    'Binh Duong',
    'Binh Phuoc',
    'Binh Thuan',
    'Ca Mau',
    'Can Tho',
    'Cao Bang',
    'Da Nang',
    'Dak Lak',
    'Dak Nong',
    'Dien Bien',
    'Dong Nai',
    'Dong Thap',
    'Gia Lai',
    'Ha Giang',
    'Ha Nam',
    'Ha Noi',
    'Ha Tinh',
    'Hai Duong',
    'Hai Phong',
    'Hau Giang',
    'Hoa Binh',
    'Hung Yen',
    'Khanh Hoa',
    'Kien Giang',
    'Kon Tum',
    'Lai Chau',
    'Lam Dong',
    'Lang Son',
    'Lao Cai',
    'Long An',
    'Nam Dinh',
    'Nghe An',
    'Ninh Binh',
    'Ninh Thuan',
    'Phu Tho',
    'Phu Yen',
    'Quang Binh',
    'Quang Nam',
    'Quang Ngai',
    'Quang Ninh',
    'Quang Tri',
    'Soc Trang',
    'Son La',
    'Tay Ninh',
    'Thai Binh',
    'Thai Nguyen',
    'Thanh Hoa',
    'Thua Thien Hue',
    'Tien Giang',
    'TP Ho Chi Minh',
    'Tra Vinh',
    'Tuyen Quang',
    'Vinh Long',
    'Vinh Phuc',
    'Yen Bai',
  ];

  static const Map<String, String> _gadmToRegion = {
    'Ha Noi': 'red_river_delta',
    'Hai Phong': 'red_river_delta',
    'Hung Yen': 'red_river_delta',
    'Hai Duong': 'red_river_delta',
    'Ha Nam': 'red_river_delta',
    'Nam Dinh': 'red_river_delta',
    'Ninh Binh': 'red_river_delta',
    'Thai Binh': 'red_river_delta',
    'Vinh Phuc': 'red_river_delta',
    'Bac Ninh': 'red_river_delta',
    'Ha Giang': 'northern_midlands',
    'Cao Bang': 'northern_midlands',
    'Bac Kan': 'northern_midlands',
    'Tuyen Quang': 'northern_midlands',
    'Thai Nguyen': 'northern_midlands',
    'Lang Son': 'northern_midlands',
    'Bac Giang': 'northern_midlands',
    'Phu Tho': 'northern_midlands',
    'Yen Bai': 'northern_midlands',
    'Hoa Binh': 'northern_midlands',
    'Lao Cai': 'northern_midlands',
    'Dien Bien': 'northern_midlands',
    'Lai Chau': 'northern_midlands',
    'Son La': 'northern_midlands',
    'Quang Ninh': 'northern_midlands',
    'Thanh Hoa': 'central_coast',
    'Nghe An': 'central_coast',
    'Ha Tinh': 'central_coast',
    'Quang Binh': 'central_coast',
    'Quang Tri': 'central_coast',
    'Thua Thien Hue': 'central_coast',
    'Da Nang': 'central_coast',
    'Quang Nam': 'central_coast',
    'Quang Ngai': 'central_coast',
    'Binh Dinh': 'central_coast',
    'Phu Yen': 'central_coast',
    'Khanh Hoa': 'central_coast',
    'Ninh Thuan': 'central_coast',
    'Binh Thuan': 'central_coast',
    'Kon Tum': 'central_highlands',
    'Gia Lai': 'central_highlands',
    'Dak Lak': 'central_highlands',
    'Dak Nong': 'central_highlands',
    'Lam Dong': 'central_highlands',
    'TP Ho Chi Minh': 'southeast',
    'Binh Phuoc': 'southeast',
    'Tay Ninh': 'southeast',
    'Binh Duong': 'southeast',
    'Dong Nai': 'southeast',
    'Ba Ria - Vung Tau': 'southeast',
    'Long An': 'mekong_delta',
    'Tien Giang': 'mekong_delta',
    'Ben Tre': 'mekong_delta',
    'Tra Vinh': 'mekong_delta',
    'Vinh Long': 'mekong_delta',
    'Dong Thap': 'mekong_delta',
    'An Giang': 'mekong_delta',
    'Kien Giang': 'mekong_delta',
    'Can Tho': 'mekong_delta',
    'Hau Giang': 'mekong_delta',
    'Soc Trang': 'mekong_delta',
    'Bac Lieu': 'mekong_delta',
    'Ca Mau': 'mekong_delta',
  };

  /// Trả về danh sách [TemporalPolygon] phù hợp với [year]:
  /// - `year < 2025`  → 63 tỉnh GADM (ranh giới lịch sử)
  /// - `year >= 2025` → 34 siêu tỉnh Hugging Face (sau sáp nhập NQ 202)
  Future<List<TemporalPolygon>> getPolygonsForYear(int year) async {
    if (year < 2025) {
      return _getHistoricalPolygons63();
    } else {
      return _getMergedPolygons34();
    }
  }

  Future<List<TemporalPolygon>> _getHistoricalPolygons63() async {
    final result = <TemporalPolygon>[];
    for (final name in gadmProvinceNames) {
      final cache = await _geoJsonDao.getGeoJsonByMa('gadm_$name');
      if (cache == null) {
        debugPrint('TemporalGeoJsonService: cache miss for gadm_$name');
        continue;
      }
      result.add(
        TemporalPolygon(
          key: 'gadm_$name',
          displayName: name,
          geoJsonData: cache.geoJsonData,
          macroRegion: _gadmToRegion[name] ?? 'unknown',
          isPreMerger: true,
        ),
      );
    }
    debugPrint(
      'TemporalGeoJsonService: loaded ${result.length}/63 GADM polygons',
    );
    return result;
  }

  Future<List<TemporalPolygon>> _getMergedPolygons34() async {
    final provinces = await _unitDao.getAllProvinces();
    final result = <TemporalPolygon>[];
    for (final p in provinces) {
      final cache = await _geoJsonDao.getGeoJsonByMa(p.ma);
      if (cache == null) continue;
      result.add(
        TemporalPolygon(
          key: p.ma,
          displayName: p.ten,
          geoJsonData: cache.geoJsonData,
          macroRegion: p.macroRegion,
          isPreMerger: false,
        ),
      );
    }
    debugPrint(
      'TemporalGeoJsonService: loaded ${result.length}/34 HF merged polygons',
    );
    return result;
  }

  Future<bool> hasGadmCacheReady() async {
    const probes = ['Ha Noi', 'TP Ho Chi Minh', 'Can Tho'];
    for (final name in probes) {
      final c = await _geoJsonDao.getGeoJsonByMa('gadm_$name');
      if (c == null) return false;
    }
    return true;
  }

  // FIX: unintended_html_in_doc_comment
  // → dùng backtick thay vì angle brackets trong comment
  /// Xây dựng displayName từ key `gadm_NAME` cho popup.
  static String displayNameFromKey(String key) {
    if (key.startsWith('gadm_')) {
      return key.substring(5);
    }
    return key;
  }

  /// Chuyển đổi JSON string → `List<dynamic>` để parse polygon.
  static List<dynamic> decodeGeoJsonData(String geoJsonData) {
    return jsonDecode(geoJsonData) as List<dynamic>;
  }
}
