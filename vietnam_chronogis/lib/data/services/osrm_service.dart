import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class RouteData {
  final List<LatLng> points;
  final double distance; // in meters
  final double duration; // in seconds

  RouteData({
    required this.points,
    required this.distance,
    required this.duration,
  });
}

class OsrmService {
  final Dio _dio;

  OsrmService({Dio? dio}) : _dio = dio ?? Dio();

  Future<RouteData?> getRoute(
    LatLng start,
    LatLng end, {
    String profile = 'driving',
  }) async {
    try {
      final response = await _dio.get(
        'https://router.project-osrm.org/route/v1/$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}',
        queryParameters: {'geometries': 'geojson', 'overview': 'full'},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final coordinates = geometry['coordinates'] as List;

          final List<LatLng> points = coordinates.map((coord) {
            return LatLng(coord[1].toDouble(), coord[0].toDouble());
          }).toList();

          return RouteData(
            points: points,
            distance: route['distance'].toDouble(),
            duration: route['duration'].toDouble(),
          );
        }
      }
    } catch (e) {
      debugPrint('OSRM Routing Error: $e');
    }
    return null;
  }
}
