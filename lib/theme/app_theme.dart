import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark Theme Palette (Obsidian / Neon Accent)
  static const Color darkBg = Color(0xFF0A0E17);
  static const Color darkSurface = Color(0xFF141C2E);
  static const Color darkSurfaceLight = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF2E3D56);

  // Light Theme Palette (Sleek Clean Modern)
  static const Color lightBg = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSecondary = Color(0xFFEFF3FA);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Premium Brand & Macro Accents
  static const Color primaryNeon = Color(0xFF00E676); // Emerald Neon
  static const Color primaryCyan = Color(0xFF00E5FF); // Electric Cyan
  static const Color primaryCoral = Color(0xFFFF5252); // Sunset Coral
  static const Color accentPurple = Color(0xFF7C4DFF); // Royal Violet
  static const Color accentAmber = Color(0xFFFFB300); // Solar Amber

  // Macro Specific Colors
  static const Color proteinColor = Color(0xFFFF5252); // Protein Red/Coral
  static const Color carbsColor = Color(0xFF00E5FF); // Carbs Cyan
  static const Color fatColor = Color(0xFFFFB300); // Fat Amber/Gold
  static const Color waterColor = Color(0xFF29B6F6); // Water Blue

  // BMI Category Colors
  static const Color bmiUnderweight = Color(0xFF29B6F6);
  static const Color bmiNormal = Color(0xFF00E676);
  static const Color bmiOverweight = Color(0xFFFFB300);
  static const Color bmiObese = Color(0xFFFF5252);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fireGradient = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFFF7A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0288D1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.primaryNeon,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryNeon,
      secondary: AppColors.primaryCyan,
      surface: AppColors.darkSurface,
      error: AppColors.primaryCoral,
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 32),
      headlineMedium: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
      titleLarge: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 18),
      titleMedium: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70, fontSize: 15),
      bodyLarge: const TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 16),
      bodyMedium: const TextStyle(fontWeight: FontWeight.w400, color: Colors.white70, fontSize: 14),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBg,
    primaryColor: AppColors.primaryNeon,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF00C853),
      secondary: Color(0xFF00B0FF),
      surface: AppColors.lightSurface,
      error: AppColors.primaryCoral,
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
      headlineLarge: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontSize: 32),
      headlineMedium: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 24),
      titleLarge: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A), fontSize: 18),
      titleMedium: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569), fontSize: 15),
      bodyLarge: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF0F172A), fontSize: 16),
      bodyMedium: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xFF64748B), fontSize: 14),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.lightBorder, width: 1),
      ),
    ),
  );
}
