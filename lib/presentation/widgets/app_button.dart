import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// Standardized button widget with loading state support and premium animations.
class AppButton extends StatelessWidget {
  const AppButton._({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    required this.variant,
    super.key,
    this.icon,
    this.fullWidth = false,
  });

  /// Filled pill button with gradient (primary action).
  const AppButton.primary({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         icon: icon,
         fullWidth: fullWidth,
         variant: AppButtonVariant.primary,
       );

  /// Outlined pill button with glass border (secondary action).
  const AppButton.secondary({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         icon: icon,
         fullWidth: fullWidth,
         variant: AppButtonVariant.secondary,
       );

  /// Text-only button (ghost action).
  const AppButton.ghost({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         icon: icon,
         fullWidth: fullWidth,
         variant: AppButtonVariant.ghost,
       );

  /// Red gradient button (destructive action).
  const AppButton.danger({
    required String label,
    Key? key,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         isLoading: isLoading,
         icon: icon,
         fullWidth: fullWidth,
         variant: AppButtonVariant.danger,
       );

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    final isEnabled = onPressed != null && !isLoading;

    return Semantics(
      label: isLoading ? context.l10n.a11yLoadingButton : label,
      button: true,
      enabled: isEnabled,
      child: AnimatedPress(
        onTap: isEnabled ? onPressed : null,
        enableGlow: variant == AppButtonVariant.primary && isEnabled,
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: 52,
          decoration: _buildDecoration(cs, colors, isEnabled),
          child: Center(child: _buildChild(context, cs, colors)),
        ),
      ),
    );
  }

  Decoration _buildDecoration(
    ColorScheme cs,
    VitalGlyphColors colors,
    bool isEnabled,
  ) {
    final borderRadius = BorderRadius.circular(AppRadius.lg);

    switch (variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          borderRadius: borderRadius,
          color: isEnabled ? cs.primary : cs.primary.withValues(alpha: 0.5),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ]
              : null,
        );
      case AppButtonVariant.danger:
        return BoxDecoration(
          borderRadius: borderRadius,
          color: isEnabled
              ? colors.emergencyRed
              : colors.emergencyRed.withValues(alpha: 0.5),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: colors.emergencyRed.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ]
              : null,
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: isEnabled
                ? colors.cardBorder
                : colors.cardBorder.withValues(alpha: 0.5),
            width: 1.5,
          ),
          color: isEnabled ? colors.surfaceSubtle : null,
        );
      case AppButtonVariant.ghost:
        return const BoxDecoration();
    }
  }

  Widget _buildChild(
    BuildContext context,
    ColorScheme cs,
    VitalGlyphColors colors,
  ) {
    final textColor = _getTextColor(cs, colors);

    if (isLoading) {
      // Shimmer loading state placeholder - using a simple fade for now
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.4, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Container(
            width: 80,
            height: 8,
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        onEnd: () {}, // Simple loop effect can be added if stateful
      );
    }

    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w700,
    );

    if (icon != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: textStyle),
          ],
        ),
      );
    }

    return Text(label, style: textStyle);
  }

  Color _getTextColor(ColorScheme cs, VitalGlyphColors colors) {
    if (onPressed == null && !isLoading) {
      return cs.onSurface.withValues(alpha: 0.38);
    }
    switch (variant) {
      case AppButtonVariant.primary:
        return cs.onPrimary;
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.ghost:
        return variant == AppButtonVariant.danger
            ? colors.emergencyRed
            : cs.primary;
    }
  }
}
