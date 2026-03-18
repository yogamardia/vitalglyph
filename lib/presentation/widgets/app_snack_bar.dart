import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';

/// Consistent app-wide SnackBar helpers.
class AppSnackBar {
  AppSnackBar._();

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      colorResolver: (colors, cs) => colors.successGreen,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline,
      colorResolver: (colors, cs) => cs.error,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      colorResolver: (colors, cs) => cs.primary,
    );
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      colorResolver: (colors, cs) => colors.tamperWarning,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color Function(VitalGlyphColors, ColorScheme) colorResolver,
  }) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final cs = Theme.of(context).colorScheme;
    final color = colorResolver(colors, cs);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: cs.inverseSurface,
          content: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: cs.onInverseSurface),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
