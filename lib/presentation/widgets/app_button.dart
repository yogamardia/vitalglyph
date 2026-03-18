import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, ghost }

/// Standardized button widget with loading state support.
/// Variants: primary (filled pill), secondary (outlined pill), ghost (text only).
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonVariant variant;

  const AppButton._primary({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton._secondary({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton._ghost({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.ghost;

  /// Filled pill button (primary action).
  static AppButton primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) =>
      AppButton._primary(
        key: key,
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        fullWidth: fullWidth,
      );

  /// Outlined pill button (secondary action).
  static AppButton secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) =>
      AppButton._secondary(
        key: key,
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        fullWidth: fullWidth,
      );

  /// Text-only button (ghost action).
  static AppButton ghost({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    bool fullWidth = false,
  }) =>
      AppButton._ghost(
        key: key,
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
        fullWidth: fullWidth,
      );

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);
    late Widget button;

    switch (variant) {
      case AppButtonVariant.primary:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case AppButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.primary
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
