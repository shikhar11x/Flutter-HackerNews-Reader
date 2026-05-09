import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF0D0D0D);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color neonGreenDim = Color(0xFF00CC33);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color textPrimary = Color(0xFFEAEAEA);
  static const Color textSecondary = Color(0xFF666666);
  static const Color hnOrange = Color(0xFFFF6600);

  // Glass box decoration
  static BoxDecoration glassDecoration({
    Color borderColor = neonGreen,
    double borderOpacity = 0.3,
  }) {
    return BoxDecoration(
      color: glassWhite,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: borderColor.withOpacity(borderOpacity),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: neonGreen.withOpacity(0.04),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Card with left accent bar
  static BoxDecoration cardWithAccent({Color accentColor = neonGreen}) {
    return BoxDecoration(
      color: const Color(0xFF0D0D0D),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: accentColor.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: accentColor.withOpacity(0.04),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Neon glowing text style
  static TextStyle neonText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = neonGreen,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'monospace',
      shadows: [
        Shadow(
          color: color.withOpacity(0.8),
          blurRadius: 8,
        ),
      ],
    );
  }

  // Main app theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'monospace',
      colorScheme: const ColorScheme.dark(
        primary: neonGreen,
        secondary: hnOrange,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: neonGreen,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}