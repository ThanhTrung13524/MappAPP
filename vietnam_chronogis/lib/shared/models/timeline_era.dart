import 'package:flutter/material.dart';

enum VietnamEra {
  reunification(1975, 1976),
  postWarConsolidation(1976, 1986),
  doiMoi(1986, 1997),
  provinceExpansion(1997, 2008),
  hanoiExpansion(2008, 2025),
  merger2025(2025, 2025);

  final int startYear;
  final int endYear;

  const VietnamEra(this.startYear, this.endYear);

  bool contains(int year) {
    if (this == merger2025) return year == 2025;
    if (this == hanoiExpansion) return year >= 2008 && year < 2025;
    return year >= startYear && year < endYear;
  }

  static VietnamEra fromYear(int year) {
    return VietnamEra.values.firstWhere((era) => era.contains(year),
        orElse: () => VietnamEra.merger2025);
  }
}

extension VietnamEraExtension on VietnamEra {
  String get label {
    switch (this) {
      case VietnamEra.reunification:
        return 'Reunification';
      case VietnamEra.postWarConsolidation:
        return 'Post-War Consolidation';
      case VietnamEra.doiMoi:
        return 'Doi Moi Reforms';
      case VietnamEra.provinceExpansion:
        return 'Province Expansion';
      case VietnamEra.hanoiExpansion:
        return 'Hanoi Expansion';
      case VietnamEra.merger2025:
        return '2025 Merger';
    }
  }

  String get description {
    switch (this) {
      case VietnamEra.reunification:
        return 'Giải phóng miền Nam, thống nhất đất nước.';
      case VietnamEra.postWarConsolidation:
        return 'Thời kỳ bao cấp, sáp nhập các tỉnh thành quy mô lớn.';
      case VietnamEra.doiMoi:
        return 'Đổi mới kinh tế, bắt đầu quá trình chia tách tỉnh.';
      case VietnamEra.provinceExpansion:
        return 'Tách tỉnh mạnh mẽ để phát triển kinh tế địa phương.';
      case VietnamEra.hanoiExpansion:
        return 'Mở rộng thủ đô Hà Nội, sáp nhập tỉnh Hà Tây.';
      case VietnamEra.merger2025:
        return 'Sáp nhập lớn theo NQ 202, giảm số lượng đơn vị hành chính.';
    }
  }

  Color get color {
    switch (this) {
      case VietnamEra.reunification:
        return const Color(0xFFE53935); // Red
      case VietnamEra.postWarConsolidation:
        return const Color(0xFF8E24AA); // Purple
      case VietnamEra.doiMoi:
        return const Color(0xFF1E88E5); // Blue
      case VietnamEra.provinceExpansion:
        return const Color(0xFF43A047); // Green
      case VietnamEra.hanoiExpansion:
        return const Color(0xFFFDD835); // Yellow
      case VietnamEra.merger2025:
        return const Color(0xFFFB8C00); // Orange
    }
  }
}
