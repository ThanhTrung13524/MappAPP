import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'models/nemotron_row_model.dart';

/// Client for nvidia/Nemotron-Personas-Vietnam on HuggingFace Datasets Server.
/// Used to show regional education statistics alongside THPT schools on the map.
class NemotronApiClient {
  final Dio _dio;
  static const String _baseUrl = 'https://datasets-server.huggingface.co';
  static const String _dataset = 'nvidia/Nemotron-Personas-Vietnam';

  NemotronApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<List<NemotronRowModel>> fetchRows({
    int offset = 0,
    int length = 100,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/rows',
      queryParameters: {
        'dataset': _dataset,
        'config': 'default',
        'split': 'train',
        'offset': offset,
        'length': length,
      },
    );

    final data = response.data;
    if (data == null) return [];

    final rows = data['rows'] as List<dynamic>? ?? [];
    return rows
        .map((wrapper) {
          final row = (wrapper as Map<String, dynamic>)['row'];
          if (row is! Map<String, dynamic>) return null;
          return NemotronRowModel.fromJson(row);
        })
        .whereType<NemotronRowModel>()
        .toList();
  }

  /// Aggregate education_level distribution for a Nemotron region (6 major areas).
  Future<EducationStats> fetchEducationStatsForRegion(String region) async {
    final normalizedTarget = _normalizeRegion(region);
    final levelCounts = <String, int>{};
    var sampleSize = 0;

    // Sample 500 rows across dataset to estimate regional education mix.
    for (var offset = 0; offset < 5000; offset += 100) {
      try {
        final batch = await fetchRows(offset: offset, length: 100);
        if (batch.isEmpty) break;

        for (final row in batch) {
          if (_normalizeRegion(row.region) != normalizedTarget) continue;
          sampleSize++;
          final level = row.educationLevel.trim();
          if (level.isEmpty) continue;
          levelCounts[level] = (levelCounts[level] ?? 0) + 1;
        }
      } catch (e) {
        debugPrint('NemotronApiClient batch error at $offset: $e');
        break;
      }
    }

    return EducationStats(
      region: region,
      sampleSize: sampleSize,
      levelCounts: levelCounts,
    );
  }

  String _normalizeRegion(String value) {
    return value
        .toLowerCase()
        .replaceAll('thành phố', 'tp')
        .replaceAll('thủ đô', 'tp')
        .replaceAll('tỉnh', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

/// Map province name/code to Nemotron region label (6 areas in dataset).
String? nemotronRegionForProvince(String? provinceName, String? provinceMa) {
  final text = '${provinceName ?? ''} ${provinceMa ?? ''}'.toLowerCase();
  if (text.contains('ha noi') ||
      text.contains('hà nội') ||
      text.contains('01')) {
    return 'Thủ Đô Hà Nội';
  }
  if (text.contains('ho chi minh') ||
      text.contains('hồ chí minh') ||
      text.contains('79')) {
    return 'Thành Phố Hồ Chí Minh';
  }
  if (text.contains('hai phong') || text.contains('hải phòng')) {
    return 'Thành Phố Hải Phòng';
  }
  if (text.contains('da nang') || text.contains('đà nẵng')) {
    return 'Thành Phố Đà Nẵng';
  }
  if (text.contains('can tho') || text.contains('cần thơ')) {
    return 'Thành Phố Cần Thơ';
  }
  if (text.contains('dong nai') || text.contains('đồng nai')) {
    return 'Tỉnh Đồng Nai';
  }
  return null;
}
