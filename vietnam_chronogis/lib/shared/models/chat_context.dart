import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_context.freezed.dart';
part 'chat_context.g.dart';

@freezed
abstract class ChatContext with _$ChatContext {
  const factory ChatContext({
    required int currentYear,
    String? selectedProvinceMa,
    String? selectedProvinceEmbedText,
    required int provinceCount,
    required String currentEra,
  }) = _ChatContext;

  factory ChatContext.fromJson(Map<String, dynamic> json) =>
      _$ChatContextFromJson(json);
}