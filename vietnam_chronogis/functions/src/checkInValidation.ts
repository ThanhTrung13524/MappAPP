export type LatLng = {
  latitude: number;
  longitude: number;
};

export function isValidCoordinate(point: LatLng): boolean {
  return (
    Number.isFinite(point.latitude) &&
    Number.isFinite(point.longitude) &&
    point.latitude >= -90 &&
    point.latitude <= 90 &&
    point.longitude >= -180 &&
    point.longitude <= 180
  );
}

export function haversineDistanceMeters(from: LatLng, to: LatLng): number {
  const earthRadiusMeters = 6371000;
  const toRadians = (degrees: number) => (degrees * Math.PI) / 180;

  const deltaLat = toRadians(to.latitude - from.latitude);
  const deltaLon = toRadians(to.longitude - from.longitude);
  const fromLat = toRadians(from.latitude);
  const toLat = toRadians(to.latitude);

  const a =
    Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
    Math.cos(fromLat) *
      Math.cos(toLat) *
      Math.sin(deltaLon / 2) *
      Math.sin(deltaLon / 2);

  return earthRadiusMeters * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

export function isInsideRadius(
  userLocation: LatLng,
  schoolLocation: LatLng,
  radiusMeters: number,
): boolean {
  if (!isValidCoordinate(userLocation) || !isValidCoordinate(schoolLocation)) {
    return false;
  }

  if (!Number.isFinite(radiusMeters) || radiusMeters <= 0) {
    return false;
  }

  return haversineDistanceMeters(userLocation, schoolLocation) <= radiusMeters;
}

export function isInsideTimeWindow(
  nowMillis: number,
  openAtMillis: number,
  closeAtMillis: number,
): boolean {
  return nowMillis >= openAtMillis && nowMillis <= closeAtMillis;
}
