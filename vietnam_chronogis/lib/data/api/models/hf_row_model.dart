import 'package:freezed_annotation/freezed_annotation.dart';

part 'hf_row_model.freezed.dart';
part 'hf_row_model.g.dart';

@freezed
abstract class HfRowModel with _$HfRowModel {
  const factory HfRowModel({
    required String id,
    required String kind,
    required String ma,
    required String ten,
    required String type,
    @JsonKey(name: 'ten_short') required String tenShort,
    @JsonKey(name: 'area_km2') double? areaKm2,
    double? population,
    double? density,
    String? capital,
    String? address,
    String? phone,
    required String decree,
    @JsonKey(name: 'decree_url') required String decreeUrl,
    String? predecessors,
    @JsonKey(name: 'parent_ma') String? parentMa,
    @JsonKey(name: 'parent_ten') String? parentTen,
    @JsonKey(name: 'centroid_lon') double? centroidLon,
    @JsonKey(name: 'centroid_lat') double? centroidLat,
    @Default([]) List<double> bbox,
    @JsonKey(name: 'geom_type') String? geomType,
    @JsonKey(name: 'n_vertices') int? nVertices,
    @JsonKey(name: 'macro_region') required String macroRegion,
    @JsonKey(name: 'predecessors_list') @Default([]) List<String> predecessorsList,
    @JsonKey(name: 'n_predecessors') required int nPredecessors,
    @JsonKey(name: 'embed_text') required String embedText,
    @Default([]) List<String> keywords,
    @JsonKey(name: 'parent_ten_xa') String? parentTenXa,
  }) = _HfRowModel;

  factory HfRowModel.fromJson(Map<String, dynamic> json) =>
      _$HfRowModelFromJson(json);
}

@freezed
abstract class HuggingFaceResponse with _$HuggingFaceResponse {
  const factory HuggingFaceResponse({
    required List<HuggingFaceRowWrapper> rows,
    @JsonKey(name: 'num_rows_total') required int numRowsTotal,
    @JsonKey(name: 'num_rows_per_page') required int numRowsPerPage,
  }) = _HuggingFaceResponse;

  factory HuggingFaceResponse.fromJson(Map<String, dynamic> json) =>
      _$HuggingFaceResponseFromJson(json);
}

@freezed
abstract class HuggingFaceRowWrapper with _$HuggingFaceRowWrapper {
  const factory HuggingFaceRowWrapper({
    @JsonKey(name: 'row_idx') required int rowIdx,
    required HfRowModel row,
  }) = _HuggingFaceRowWrapper;

  factory HuggingFaceRowWrapper.fromJson(Map<String, dynamic> json) =>
      _$HuggingFaceRowWrapperFromJson(json);
}