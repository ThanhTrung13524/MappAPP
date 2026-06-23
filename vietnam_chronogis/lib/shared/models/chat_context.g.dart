// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatContext _$ChatContextFromJson(Map<String, dynamic> json) => _ChatContext(
  currentYear: (json['currentYear'] as num).toInt(),
  selectedProvinceMa: json['selectedProvinceMa'] as String?,
  selectedProvinceEmbedText: json['selectedProvinceEmbedText'] as String?,
  provinceCount: (json['provinceCount'] as num).toInt(),
  currentEra: json['currentEra'] as String,
);

Map<String, dynamic> _$ChatContextToJson(_ChatContext instance) =>
    <String, dynamic>{
      'currentYear': instance.currentYear,
      'selectedProvinceMa': instance.selectedProvinceMa,
      'selectedProvinceEmbedText': instance.selectedProvinceEmbedText,
      'provinceCount': instance.provinceCount,
      'currentEra': instance.currentEra,
    };
