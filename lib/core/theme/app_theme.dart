import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Premium Dark Fantasy Palette
  static const Color background = Color(0xFF090D16);
  static const Color backgroundSecondary = Color(0xFF0F1524);
  static const Color surface = Color(0xFF131B2E);
  static const Color surfaceLight = Color(0xFF1C2742);
  static const Color surfaceAccent = Color(0xFF253457);
  static const Color borderLight = Color(0xFF28395B);
  static const Color borderGlow = Color(0xFF3B5282);

  // RPG Accent Colors
  static const Color primary = Color(0xFF8B5CF6); // Arcane Purple
  static const Color primaryGlow = Color(0xFFA78BFA);
  static const Color secondary = Color(0xFF06B6D4); // Neon Cyan
  static const Color accentCyan = Color(0xFF06B6D4);

  static const Color hpRed = Color(0xFFEF4444); // Crimson Health
  static const Color hpRedDark = Color(0xFF991B1B);
  static const Color hpRedBg = Color(0xFF381216);

  static const Color expBlue = Color(0xFF38BDF8); // Astral Mana / EXP
  static const Color expBlueDark = Color(0xFF0369A1);
  static const Color expBlueBg = Color(0xFF082F49);

  static const Color gold = Color(0xFFFBBF24); // Minted Gold
  static const Color goldDark = Color(0xFFB45309);
  static const Color goldBg = Color(0xFF451A03);

  static const Color success = Color(0xFF10B981);
  static const Color epic = Color(0xFFA855F7);
  static const Color legendary = Color(0xFFF97316);

  // Typography Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradients for tactile RPG Depth
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF162138), Color(0xFF0F1728)],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2640), Color(0xFF10182A), Color(0xFF0A101C)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
  );

  static const LinearGradient hpGradient = LinearGradient(
    colors: [Color(0xFFF87171), Color(0xFFDC2626)],
  );

  static const LinearGradient expGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: hpRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderLight, width: 1.2),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: borderGlow, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: const TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderLight, width: 1),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
