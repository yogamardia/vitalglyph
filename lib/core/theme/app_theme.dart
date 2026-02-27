import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryColor = Color(0xFF1565C0);
  static const Color _errorColor = Color(0xFFD32F2F);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        error: _errorColor,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
    );
  }
}
