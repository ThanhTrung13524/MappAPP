import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../data/services/osrm_service.dart';

final osrmServiceProvider = Provider((ref) => OsrmService());

enum TravelMode { driving, walking }

extension TravelModeExtension on TravelMode {
  String get label {
    switch (this) {
      case TravelMode.walking:
        return 'Đi bộ';
      case TravelMode.driving:
        return 'Xe';
    }
  }

  String get osrmProfile {
    switch (this) {
      case TravelMode.walking:
        return 'walking';
      case TravelMode.driving:
        return 'driving';
    }
  }
}

class IsRoutingMode extends Notifier<bool> {
  @override
  bool build() => false;

  void updateMode(bool value) {
    state = value;
  }
}

// Trạng thái routing mode: true nếu đang trong chế độ chỉ đường
final isRoutingModeProvider = NotifierProvider<IsRoutingMode, bool>(
  IsRoutingMode.new,
);

class RoutePoint extends Notifier<LatLng?> {
  @override
  LatLng? build() => null;

  void updatePoint(LatLng? value) {
    state = value;
  }
}

// Điểm bắt đầu
final routeStartPointProvider = NotifierProvider<RoutePoint, LatLng?>(
  RoutePoint.new,
);

// Điểm kết thúc (thường là địa điểm du lịch)
final routeEndPointProvider = NotifierProvider<RoutePoint, LatLng?>(
  RoutePoint.new,
);

class RouteTravelMode extends Notifier<TravelMode> {
  @override
  TravelMode build() => TravelMode.driving;

  void updateMode(TravelMode mode) {
    state = mode;
  }
}

final routeTravelModeProvider = NotifierProvider<RouteTravelMode, TravelMode>(
  RouteTravelMode.new,
);

// Provider gọi API và lấy RouteData
final routeDataProvider = FutureProvider<RouteData?>((ref) async {
  final start = ref.watch(routeStartPointProvider);
  final end = ref.watch(routeEndPointProvider);
  final mode = ref.watch(routeTravelModeProvider);

  if (start == null || end == null) return null;

  final osrmService = ref.read(osrmServiceProvider);
  return await osrmService.getRoute(start, end, profile: mode.osrmProfile);
});
