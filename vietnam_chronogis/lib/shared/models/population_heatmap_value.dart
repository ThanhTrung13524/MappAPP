import 'package:flutter/material.dart';

class PopulationHeatmapValue {
  final String provinceCode;
  final double population;
  final double areaKm2;
  final double? densityOverride;

  const PopulationHeatmapValue({
    required this.provinceCode,
    required this.population,
    required this.areaKm2,
    this.densityOverride,
  });

  double get density {
    if (densityOverride != null && densityOverride! > 0) {
      return densityOverride!;
    }
    if (areaKm2 <= 0) return 0;
    return population / areaKm2;
  }
}

double normalizeDensity({
  required double value,
  required double min,
  required double max,
}) {
  if (max == min) return 0;
  return ((value - min) / (max - min)).clamp(0.0, 1.0);
}

Color heatmapColor(double t) {
  return Color.lerp(
    const Color(0xFFFFF8E1),
    const Color(0xFFB71C1C),
    t.clamp(0.0, 1.0),
  )!.withValues(alpha: 0.65);
}
