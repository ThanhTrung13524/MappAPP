import 'package:freezed_annotation/freezed_annotation.dart';

part 'geojson_feature.freezed.dart';
part 'geojson_feature.g.dart';

@freezed
abstract class GeoJsonFeature with _$GeoJsonFeature {
  const factory GeoJsonFeature({
    required String type,
    required Map<String, dynamic> properties,
    required Geometry geometry,
  }) = _GeoJsonFeature;

  factory GeoJsonFeature.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonFeatureFromJson(json);
}

@freezed
abstract class Geometry with _$Geometry {
  const factory Geometry({
    required String type,
    // FIX: dynamic → List<dynamic>
    // json_serializable không generate được cho 'dynamic' thuần túy.
    // GeoJSON coordinates luôn là List (Polygon hoặc MultiPolygon),
    // nên List<dynamic> là đúng và serializable.
    required List<dynamic> coordinates,
  }) = _Geometry;

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
}

@freezed
abstract class FeatureCollection with _$FeatureCollection {
  const factory FeatureCollection({
    required String type,
    required List<GeoJsonFeature> features,
  }) = _FeatureCollection;

  factory FeatureCollection.fromJson(Map<String, dynamic> json) =>
      _$FeatureCollectionFromJson(json);
}