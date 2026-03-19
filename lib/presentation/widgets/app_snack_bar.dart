import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';

/// Consistent app-wide SnackBar helpers with premium glassmorphism styling.
class AppSnackBar {
  AppSnackBar._();

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: Theme.of(context).extension<VitalGlyphColors>()!.successGreen,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_rounded,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_rounded,
      iconColor: Theme.of(context).colorScheme.primary,
    );
  }

  static void warning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.warning_rounded,
      iconColor: Theme.of(context).extension<VitalGlyphColors>()!.tamperWarning,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final glassBg = isDark 
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textColor = isDark ? const Color(0xFF020617) : Colors.white;
    final borderColor = isDark 
        ? Colors.black.withValues(alpha: 0.1) 
        : Colors.white.withValues(alpha: 0.1);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: glassBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) => Transform.scale(
                    scale: value,
                    child: child,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
