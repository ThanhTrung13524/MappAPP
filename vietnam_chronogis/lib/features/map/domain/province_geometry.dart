import 'package:latlong2/latlong.dart';

import '../../../core/database/app_database.dart';

class ProvinceGeometry {
  final AdministrativeUnit province;
  final List<List<List<LatLng>>> polygons;

  const ProvinceGeometry(this.province, this.polygons);
}

class HeatmapStats {
  final int provinceCount;
  final int valueCount;
  final double minDensity;
  final double maxDensity;

  const HeatmapStats({
    required this.provinceCount,
    required this.valueCount,
    required this.minDensity,
    required this.maxDensity,
  });

  bool get hasValues => valueCount > 0;
}
