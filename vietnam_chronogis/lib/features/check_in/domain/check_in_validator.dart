import 'dart:math';

double haversineDistanceMeters({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  const earthRadiusMeters = 6371000.0;
  final dLat = _degToRad(lat2 - lat1);
  final dLon = _degToRad(lon2 - lon1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  return earthRadiusMeters * 2 * atan2(sqrt(a), sqrt(1 - a));
}

bool isInsideRadius({
  required double distanceMeters,
  required double radiusMeters,
}) {
  return distanceMeters <= radiusMeters;
}

bool isValidCoordinate({required double latitude, required double longitude}) {
  return latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}

bool isInsideTimeWindow({
  required DateTime now,
  required DateTime opensAt,
  required DateTime closesAt,
}) {
  return !now.isBefore(opensAt) && !now.isAfter(closesAt);
}

double _degToRad(double value) => value * pi / 180.0;
