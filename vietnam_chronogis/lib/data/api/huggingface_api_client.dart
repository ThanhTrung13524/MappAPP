import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'models/hf_row_model.dart';

class HuggingFaceApiClient {
  final Dio _dio;
  static const String _baseUrl = 'https://datasets-server.huggingface.co';
  static const String _dataset = 'tmquan/sapnhap-bando-vn';

  HuggingFaceApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<HuggingFaceResponse> fetchRows({
    required String config,
    required String split,
    int offset = 0,
    int length = 100,
  }) async {
    int retries = 3;
    while (retries > 0) {
      try {
        final response = await _dio.get(
          '/rows',
          queryParameters: {
            'dataset': _dataset,
            'config': config,
            'split': split,
            'offset': offset,
            'length': length,
          },
        );
        
        return HuggingFaceResponse.fromJson(response.data);
      } catch (e) {
        retries--;
        if (retries == 0) rethrow;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('Failed to fetch after retries');
  }

  Future<List<HfRowModel>> fetchAll({required String config}) async {
    List<HfRowModel> allRows = [];
    int offset = 0;
    const int limit = 100;
    bool hasMore = true;

    while (hasMore) {
      debugPrint('Fetching $config offset $offset...');
      final response = await fetchRows(config: config, split: 'train', offset: offset, length: limit);
      
      allRows.addAll(response.rows.map((r) => r.row));
      
      offset += limit;
      if (allRows.length >= response.numRowsTotal) {
        hasMore = false;
      }
    }
    return allRows;
  }
}
