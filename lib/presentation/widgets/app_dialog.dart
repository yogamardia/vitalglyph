import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';

/// Custom dialog that replaces AlertDialog throughout the app.
class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });

  /// Show a standard confirmation dialog. Returns true if confirmed.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => AppDialog(
        title: title,
        message: message,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  /// Show a destructive confirmation dialog. Returns true if confirmed.
  static Future<bool?> showDestructive(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (_) => AppDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: true,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: colors.glassSurface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: colors.cardBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ],
            if (content != null) ...[
              const SizedBox(height: AppSpacing.xl),
              content!,
            ],
            const SizedBox(height: AppSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                  child: Text(cancelLabel),
                ),
                const SizedBox(width: AppSpacing.md),
                AppButton.primary(
                  label: confirmLabel,
                  onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A modern bottom sheet widget for actions and forms.
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.padding,
  });

  /// Show as a modal bottom sheet. Returns the result value T.
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    bool isScrollControlled = true,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (_) => AppBottomSheet(
        title: title,
        padding: padding,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return GlassContainer(
      blurSigma: 25,
      backgroundColor: colors.glassSurface,
      borderColor: colors.glassBorder.withValues(alpha: 0.5),
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxxl),
      ),
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top gradient edge
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.sm,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title!,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
            Padding(
              padding: padding ??
                  const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// A selectable row inside an AppBottomSheet (e.g., for option pickers).
class BottomSheetOption<T> extends StatelessWidget {
  final T value;
  final String label;
  final IconData? icon;
  final bool isSelected;
  final bool isDestructive;
  final ValueChanged<T> onTap;

  const BottomSheetOption({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final color = isDestructive
        ? cs.error
        : isSelected
            ? cs.primary
            : cs.onSurface;

    return AnimatedPress(
      onTap: () {
        Navigator.of(context).pop(value);
        onTap(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: isSelected ? cs.primary.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 22),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: cs.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
