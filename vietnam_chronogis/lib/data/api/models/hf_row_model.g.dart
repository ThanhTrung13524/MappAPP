// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hf_row_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HfRowModel _$HfRowModelFromJson(Map<String, dynamic> json) => _HfRowModel(
  id: json['id'] as String,
  kind: json['kind'] as String,
  ma: json['ma'] as String,
  ten: json['ten'] as String,
  type: json['type'] as String,
  tenShort: json['ten_short'] as String,
  areaKm2: (json['area_km2'] as num?)?.toDouble(),
  population: (json['population'] as num?)?.toDouble(),
  density: (json['density'] as num?)?.toDouble(),
  capital: json['capital'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  decree: json['decree'] as String,
  decreeUrl: json['decree_url'] as String,
  predecessors: json['predecessors'] as String?,
  parentMa: json['parent_ma'] as String?,
  parentTen: json['parent_ten'] as String?,
  centroidLon: (json['centroid_lon'] as num?)?.toDouble(),
  centroidLat: (json['centroid_lat'] as num?)?.toDouble(),
  bbox:
      (json['bbox'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      const [],
  geomType: json['geom_type'] as String?,
  nVertices: (json['n_vertices'] as num?)?.toInt(),
  macroRegion: json['macro_region'] as String,
  predecessorsList:
      (json['predecessors_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  nPredecessors: (json['n_predecessors'] as num).toInt(),
  embedText: json['embed_text'] as String,
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  parentTenXa: json['parent_ten_xa'] as String?,
);

Map<String, dynamic> _$HfRowModelToJson(_HfRowModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'ma': instance.ma,
      'ten': instance.ten,
      'type': instance.type,
      'ten_short': instance.tenShort,
      'area_km2': instance.areaKm2,
      'population': instance.population,
      'density': instance.density,
      'capital': instance.capital,
      'address': instance.address,
      'phone': instance.phone,
      'decree': instance.decree,
      'decree_url': instance.decreeUrl,
      'predecessors': instance.predecessors,
      'parent_ma': instance.parentMa,
      'parent_ten': instance.parentTen,
      'centroid_lon': instance.centroidLon,
      'centroid_lat': instance.centroidLat,
      'bbox': instance.bbox,
      'geom_type': instance.geomType,
      'n_vertices': instance.nVertices,
      'macro_region': instance.macroRegion,
      'predecessors_list': instance.predecessorsList,
      'n_predecessors': instance.nPredecessors,
      'embed_text': instance.embedText,
      'keywords': instance.keywords,
      'parent_ten_xa': instance.parentTenXa,
    };

_HuggingFaceResponse _$HuggingFaceResponseFromJson(Map<String, dynamic> json) =>
    _HuggingFaceResponse(
      rows: (json['rows'] as List<dynamic>)
          .map((e) => HuggingFaceRowWrapper.fromJson(e as Map<String, dynamic>))
          .toList(),
      numRowsTotal: (json['num_rows_total'] as num).toInt(),
      numRowsPerPage: (json['num_rows_per_page'] as num).toInt(),
    );

Map<String, dynamic> _$HuggingFaceResponseToJson(
  _HuggingFaceResponse instance,
) => <String, dynamic>{
  'rows': instance.rows,
  'num_rows_total': instance.numRowsTotal,
  'num_rows_per_page': instance.numRowsPerPage,
};

_HuggingFaceRowWrapper _$HuggingFaceRowWrapperFromJson(
  Map<String, dynamic> json,
) => _HuggingFaceRowWrapper(
  rowIdx: (json['row_idx'] as num).toInt(),
  row: HfRowModel.fromJson(json['row'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HuggingFaceRowWrapperToJson(
  _HuggingFaceRowWrapper instance,
) => <String, dynamic>{'row_idx': instance.rowIdx, 'row': instance.row};
