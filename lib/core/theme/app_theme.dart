import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF7C4DFF);
  static const Color accentColor = Color(0xFF00E5FF);

  /// LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FD),
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
      ),
      cardColor: Colors.white,
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),
    );
  }

  /// DARK THEME
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F111A),
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
      ),
      cardColor: const Color(0xFF1A1C29),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 12),
      ),
    );
  }
}
