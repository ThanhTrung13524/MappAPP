import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF2D5A8E), // blue
        secondary: Color(0xFF1D9E75), // teal/green
        surface: Color(0xFF252830),
        error: Color(0xFFE24B4A),
      ),
      scaffoldBackgroundColor: const Color(0xFF12151C), // Background primary
      cardColor: const Color(0xFF1E2128), // Background card
      textTheme: GoogleFonts.beVietnamProTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          displayMedium: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          displaySmall: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          headlineLarge: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          headlineMedium: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          headlineSmall: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          titleLarge: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          titleMedium: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          titleSmall: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE8EAF0)),
          bodyLarge: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFE8EAF0)),
          bodyMedium: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFFE8EAF0)),
          bodySmall: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF9AA0B0)),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2D5A8E),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.beVietnamProTextTheme(),
    );
  }
}
