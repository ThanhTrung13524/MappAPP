import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/chat_context.dart';

final groqServiceProvider = Provider<GroqService>((ref) {
  const apiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );

  if (apiKey.isEmpty) {
    throw Exception('GROQ_API_KEY is not set');
  }

  return GroqService(apiKey);
});

class GroqService {
  final String _apiKey;
  final Dio _dio;
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _model = 'llama-3.3-70b-versatile';

  GroqService(this._apiKey, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  Stream<String> sendMessage(
    String message, {
    required ChatContext context,
  }) async* {
    final systemPrompt = '''
Bạn là một chuyên gia lịch sử địa lý hành chính Việt Nam cho ứng dụng Vietnam ChronoGIS.

Kiến thức nền:
- Việt Nam thống nhất năm 1975, tái cấu trúc hành chính 1976 (61→38 tỉnh)
- Đổi Mới 1986: chuyển sang kinh tế thị trường
- 1991-1997: Tách tỉnh để quản lý phân cấp (38→61 tỉnh)
- 2008: Hà Nội sáp nhập Hà Tây, mở rộng gấp đôi
- 2025: Nghị quyết 202/2025/QH15 sáp nhập 63→34 tỉnh/thành

Trả lời ngắn gọn, chính xác, bằng ngôn ngữ người dùng hỏi.
Khi đề cập sự kiện, nêu rõ năm và số hiệu nghị quyết nếu có.
''';

    final prompt = _buildPrompt(message, context);

    try {
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
          'stream': true,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Accept': 'text/event-stream',
          },
          responseType: ResponseType.stream,
        ),
      );

      final stream = response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') {
            break;
          }
          try {
            final decoded = jsonDecode(data) as Map<String, dynamic>;
            final choices = decoded['choices'] as List;
            if (choices.isNotEmpty) {
              final delta = choices[0]['delta'] as Map<String, dynamic>;
              final content = delta['content'] as String?;
              if (content != null) {
                yield content;
              }
            }
          } catch (e) {
            // Ignore format errors or partial chunks
          }
        }
      }
    } catch (e) {
      debugPrint('GroqService Error: $e');
      rethrow;
    }
  }

  Future<List<String>> generateSuggestedQuestions(ChatContext context) async {
    final systemPrompt = '''
Bạn là một chuyên gia lịch sử địa lý hành chính Việt Nam cho ứng dụng Vietnam ChronoGIS.
''';

    final prompt =
        '''
Tạo 4 câu hỏi gợi ý ngắn gọn cho người dùng về lịch sử hành chính Việt Nam.
Context hiện tại:
- Năm đang xem: ${context.currentYear} (${context.currentEra})
- Số tỉnh: ${context.provinceCount}
${context.selectedProvinceEmbedText != null ? '- Đang chọn: ${context.selectedProvinceEmbedText}' : ''}

Trả lời dưới dạng JSON object với định dạng: {"questions": ["Câu 1", "Câu 2", "Câu 3", "Câu 4"]}
Chỉ trả về JSON, không thêm bất kỳ văn bản giải thích nào khác.
''';

    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'response_format': {'type': 'json_object'},
        },
        options: Options(headers: {'Authorization': 'Bearer $_apiKey'}),
      );

      final responseData = response.data;
      String text = '';
      if (responseData is Map<String, dynamic>) {
        final choices = responseData['choices'] as List;
        if (choices.isNotEmpty) {
          text = choices[0]['message']['content'] as String? ?? '[]';
        }
      }

      final cleanText = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      try {
        final parsed = jsonDecode(cleanText);
        if (parsed is Map && parsed.containsKey('questions')) {
          final questionsList = parsed['questions'];
          if (questionsList is List) {
            return questionsList.map((e) => e.toString()).toList();
          }
        }
      } catch (e) {
        // Fall back to regex parser
      }

      final regex = RegExp(r'"([^"]*)"');
      final matches = regex.allMatches(cleanText);
      final questions = matches.map((m) => m.group(1)!).take(4).toList();

      if (questions.isNotEmpty) return questions;
    } catch (e) {
      debugPrint('GroqService generateSuggestedQuestions Error: $e');
    }

    // Default suggestions if API fails
    return [
      if (context.selectedProvinceMa != null)
        'Quá trình sáp nhập của tỉnh này diễn ra như thế nào?',
      'Năm ${context.currentYear} có sự kiện hành chính nào nổi bật?',
      'Tại sao có sự thay đổi số lượng tỉnh thành vào thời điểm này?',
      'Giai đoạn ${context.currentEra} mang ý nghĩa gì?',
    ];
  }

  String _buildPrompt(String userMessage, ChatContext context) {
    return '''
Context hệ thống hiện tại:
- Năm đang xem trên bản đồ: ${context.currentYear}
- Giai đoạn: ${context.currentEra}
- Số lượng tỉnh thành: ${context.provinceCount}
${context.selectedProvinceEmbedText != null ? '- Tỉnh đang được chọn:\n${context.selectedProvinceEmbedText}' : '- Không có tỉnh nào được chọn.'}

Câu hỏi của người dùng:
$userMessage
''';
  }
}
