import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0E27),
      cardColor: const Color(0xFF1A1F3A),
    );
  }

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      cardColor: const Color(0xFFFFFFFF),
    );
  }

  static Color getDisplayBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF0A0E27) : const Color(0xFFF5F5F5);
  }

  static Color getGraphBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF1A1F3A) : const Color(0xFFE8E8E8);
  }

  static Color getKeyboardBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF0A0E27) : const Color(0xFFF5F5F5);
  }

  static Color getTextColor(bool isDark) {
    return isDark ? Colors.white : Colors.black87;
  }

  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? Colors.grey : Colors.grey[700]!;
  }

  static Color getButtonColor(bool isDark, Color? customColor) {
    if (customColor != null) return customColor;
    return isDark ? Colors.grey[800]! : Colors.grey[300]!;
  }
}
