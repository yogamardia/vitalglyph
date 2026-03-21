import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';

class AppTheme {
  AppTheme._();

  static const String _headingFont = 'PlusJakartaSans';
  static const String _bodyFont = 'Inter';

  static const Color _seedColorLight = Color(0xFF0F172A);
  static const Color _seedColorDark = Color(0xFFF8FAFC);
  static const Color _errorColor = Color(0xFFB91C1C);

  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor: _seedColorLight,
      primary: _seedColorLight,
      onPrimary: Colors.white,
      surface: Colors.white,
      onSurface: _seedColorLight,
      error: _errorColor,
    );
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: cs,
      extensions: const [VitalGlyphColors.light],
      textTheme: _buildTextTheme().apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      appBarTheme: AppBarThemeData(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: _headingFont,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: _seedColorLight,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: _errorColor, width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontWeight: FontWeight.w500,
          color: Color(0xFF64748B),
        ),
        hintStyle: const TextStyle(
          fontFamily: _bodyFont,
          color: Color(0xFF94A3B8),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _seedColorLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: _headingFont,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          foregroundColor: _seedColorLight,
          textStyle: const TextStyle(
            fontFamily: _headingFont,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: const Size(0, 48),
          foregroundColor: _seedColorLight,
          textStyle: const TextStyle(
            fontFamily: _headingFont,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: _seedColorLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 1,
        color: Color(0xFFF1F5F9),
      ),
    );
  }

  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor: _seedColorDark,
      primary: _seedColorDark,
      onPrimary: const Color(0xFF020617),
      surface: const Color(0xFF020617),
      onSurface: const Color(0xFFF8FAFC),
      error: const Color(0xFFEF4444),
      brightness: Brightness.dark,
    );
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: cs,
      extensions: const [VitalGlyphColors.dark],
      textTheme: _buildTextTheme().apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
      scaffoldBackgroundColor: const Color(0xFF020617),
      appBarTheme: AppBarThemeData(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: _headingFont,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: const Color(0xFF0F172A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFF1E293B)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFF1E293B)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(
            color: _seedColorDark,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        labelStyle: const TextStyle(
          fontFamily: _bodyFont,
          fontWeight: FontWeight.w500,
          color: Color(0xFF94A3B8),
        ),
        hintStyle: const TextStyle(
          fontFamily: _bodyFont,
          color: Color(0xFF475569),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _seedColorDark,
          foregroundColor: const Color(0xFF020617),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: _headingFont,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: Color(0xFF334155), width: 1.5),
          foregroundColor: _seedColorDark,
          textStyle: const TextStyle(
            fontFamily: _headingFont,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: const Size(0, 48),
          foregroundColor: _seedColorDark,
          textStyle: const TextStyle(
            fontFamily: _headingFont,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: _seedColorDark,
        foregroundColor: const Color(0xFF020617),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 1,
        color: Color(0xFF1E293B),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: _headingFont,
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        height: 1.1,
      ),
      headlineMedium: TextStyle(
        fontFamily: _headingFont,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        height: 1.2,
      ),
      headlineSmall: TextStyle(
        fontFamily: _headingFont,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontFamily: _headingFont,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontFamily: _headingFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleSmall: TextStyle(
        fontFamily: _headingFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelMedium: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: _bodyFont,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}
