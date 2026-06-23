import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/timeline_era.dart';

part 'timeline_provider.g.dart';

@riverpod
class SelectedYear extends _$SelectedYear {
  @override
  int build() => 2025;

  void setYear(int year) {
    if (year >= 1975 && year <= 2025) {
      state = year;
    }
  }
}

@riverpod
class IsPlaying extends _$IsPlaying {
  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    return false;
  }

  void toggle() {
    state = !state;
    if (state) {
      _startPlayback();
    } else {
      _stopPlayback();
    }
  }

  void _startPlayback() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final currentYear = ref.read(selectedYearProvider);
      if (currentYear >= 2025) {
        _stopPlayback();
        state = false;
      } else {
        ref.read(selectedYearProvider.notifier).setYear(currentYear + 1);
      }
    });
  }

  void _stopPlayback() {
    _timer?.cancel();
    _timer = null;
  }
}

// FIX: dùng Ref thay vì CurrentEraRef / CurrentProvinceCountRef
// Riverpod generator v2 dùng Ref trực tiếp — các typed Ref như CurrentEraRef
// chỉ tồn tại trong generated .g.dart, không cần khai báo trong source
@riverpod
VietnamEra currentEra(Ref ref) {
  final year = ref.watch(selectedYearProvider);
  return VietnamEra.fromYear(year);
}

@riverpod
int currentProvinceCount(Ref ref) {
  final year = ref.watch(selectedYearProvider);
  return getProvinceCountForYear(year);
}

int getProvinceCountForYear(int year) {
  if (year == 1975) return 66;
  if (year >= 1976 && year < 1991) return 38;

  if (year >= 1991 && year < 1997) {
    // FIX: thêm curly braces — fix warning curly_braces_in_flow_control_structures
    final int base = 38;
    final int progress = year - 1991;
    return base + (progress * 3);
  }

  if (year >= 1997 && year < 2004) return 61;
  if (year >= 2004 && year < 2008) return 64;
  if (year >= 2008 && year < 2025) return 63;
  if (year == 2025) return 34;

  return 34;
}