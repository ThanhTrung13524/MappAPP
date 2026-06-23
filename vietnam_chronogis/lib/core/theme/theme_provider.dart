import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main');
});

// FIX: StateNotifier<T> đã bị xóa trong Riverpod 3.x
// Migration: StateNotifier<T> → Notifier<T>
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // ref có sẵn trong Notifier, không cần inject qua constructor
    final prefs = ref.read(sharedPreferencesProvider);
    return _loadThemeMode(prefs);
  }

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final index = prefs.getInt('themeMode');
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.dark;
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    ref.read(sharedPreferencesProvider).setInt('themeMode', state.index);
  }
}

// FIX: StateNotifierProvider → NotifierProvider
final themeProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);