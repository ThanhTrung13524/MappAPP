// lib/data/api/wikipedia_service.dart
//
// Wikipedia REST API — lấy mô tả tiếng Anh cho địa danh.
// Không cần API key. Dùng khi user mở popup chi tiết địa điểm.

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wikipediaServiceProvider = Provider<WikipediaService>((ref) {
  return WikipediaService();
});

class WikipediaSummary {
  final String title;
  final String extract;
  final String? thumbnailUrl;
  final String pageUrl;

  const WikipediaSummary({
    required this.title,
    required this.extract,
    this.thumbnailUrl,
    required this.pageUrl,
  });
}

class WikipediaService {
  final Dio _dio;

  WikipediaService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
            ));

  /// Lấy summary từ Wikipedia tiếng Anh.
  /// [titleOrWikidata]: có thể là tên trang (VD: "Ha_Long_Bay")
  /// hoặc wikidata ID (VD: "Q106400") — sẽ resolve tên trang tự động.
  Future<WikipediaSummary?> getSummary(String titleOrWikidata) async {
    try {
      // Nếu là Wikidata ID, resolve sang Wikipedia title trước
      String wpTitle = titleOrWikidata;
      if (titleOrWikidata.startsWith('Q') &&
          int.tryParse(titleOrWikidata.substring(1)) != null) {
        wpTitle = await _resolveWikidataToTitle(titleOrWikidata) ?? titleOrWikidata;
      }

      final encoded = Uri.encodeComponent(wpTitle.replaceAll(' ', '_'));
      final response = await _dio.get(
        'https://en.wikipedia.org/api/rest_v1/page/summary/$encoded',
      );

      final data = response.data as Map<String, dynamic>;
      final extract = data['extract'] as String? ?? '';
      if (extract.isEmpty) return null;

      return WikipediaSummary(
        title: data['title'] as String? ?? wpTitle,
        extract: _truncateExtract(extract, 400),
        thumbnailUrl: data['thumbnail']?['source'] as String?,
        pageUrl: data['content_urls']?['desktop']?['page'] as String? ??
            'https://en.wikipedia.org/wiki/$encoded',
      );
    } catch (e) {
      debugPrint('WikipediaService: getSummary error for "$titleOrWikidata": $e');
      return null;
    }
  }

  /// Resolve Wikidata QID → Wikipedia EN page title
  Future<String?> _resolveWikidataToTitle(String qid) async {
    try {
      final response = await _dio.get(
        'https://www.wikidata.org/w/api.php',
        queryParameters: {
          'action': 'wbgetentities',
          'ids': qid,
          'props': 'sitelinks',
          'sitefilter': 'enwiki',
          'format': 'json',
        },
      );
      final sitelinks = response.data['entities']?[qid]?['sitelinks'];
      return sitelinks?['enwiki']?['title'] as String?;
    } catch (_) {
      return null;
    }
  }

  String _truncateExtract(String text, int maxChars) {
    if (text.length <= maxChars) return text;
    // Cắt tại cuối câu gần nhất
    final cutIndex = text.lastIndexOf('. ', maxChars);
    return cutIndex > 0 ? '${text.substring(0, cutIndex)}.' : '${text.substring(0, maxChars)}...';
  }
}