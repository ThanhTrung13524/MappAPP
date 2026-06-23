import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../../shared/models/geojson_feature.dart';

class GeoJsonParser {
  // Top-level or static function for Isolate
  static FeatureCollection _parseJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return FeatureCollection.fromJson(jsonMap);
  }

  Future<FeatureCollection> parseFromAssets(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    // Parse JSON in a background isolate to avoid jank on mobile
    return await compute(_parseJsonString, jsonString);
  }

  /// Converts the dynamic coordinates from a GeoJSON geometry into a standard format:
  /// List of Polygons, where each Polygon is a List of Rings, and each Ring is a List of LatLng.
  static List<List<List<LatLng>>> extractCoordinates(Geometry geometry) {
    List<List<List<LatLng>>> result = [];

    if (geometry.type == 'Polygon') {
      List<List<LatLng>> polygon = [];
      for (var ring in geometry.coordinates) {
        List<LatLng> points = [];
        for (var point in ring) {
          // GeoJSON is [longitude, latitude]
          points.add(LatLng(point[1].toDouble(), point[0].toDouble()));
        }
        polygon.add(points);
      }
      result.add(polygon);
    } else if (geometry.type == 'MultiPolygon') {
      for (var poly in geometry.coordinates) {
        List<List<LatLng>> polygon = [];
        for (var ring in poly) {
          List<LatLng> points = [];
          for (var point in ring) {
            points.add(LatLng(point[1].toDouble(), point[0].toDouble()));
          }
          polygon.add(points);
        }
        result.add(polygon);
      }
    }

    return result;
  }
}
