// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geojson_feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoJsonFeature _$GeoJsonFeatureFromJson(Map<String, dynamic> json) =>
    _GeoJsonFeature(
      type: json['type'] as String,
      properties: json['properties'] as Map<String, dynamic>,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeoJsonFeatureToJson(_GeoJsonFeature instance) =>
    <String, dynamic>{
      'type': instance.type,
      'properties': instance.properties,
      'geometry': instance.geometry,
    };

_Geometry _$GeometryFromJson(Map<String, dynamic> json) => _Geometry(
  type: json['type'] as String,
  coordinates: json['coordinates'] as List<dynamic>,
);

Map<String, dynamic> _$GeometryToJson(_Geometry instance) => <String, dynamic>{
  'type': instance.type,
  'coordinates': instance.coordinates,
};

_FeatureCollection _$FeatureCollectionFromJson(Map<String, dynamic> json) =>
    _FeatureCollection(
      type: json['type'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => GeoJsonFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeatureCollectionToJson(_FeatureCollection instance) =>
    <String, dynamic>{'type': instance.type, 'features': instance.features};
