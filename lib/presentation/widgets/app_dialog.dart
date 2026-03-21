import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';
import 'package:vitalglyph/presentation/widgets/app_button.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';

/// Custom dialog that replaces AlertDialog throughout the app.
class AppDialog extends StatelessWidget {

  const AppDialog({
    required this.title, super.key,
    this.message,
    this.content,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
    this.onConfirm,
    this.onCancel,
  });
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Show a standard confirmation dialog. Returns true if confirmed.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String? confirmLabel,
    String? cancelLabel,
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
    String? confirmLabel,
    String? cancelLabel,
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
    final l10n = context.l10n;
    final resolvedConfirmLabel = confirmLabel ??
        (isDestructive ? l10n.dialogDelete : l10n.dialogConfirm);
    final resolvedCancelLabel = cancelLabel ?? l10n.dialogCancel;

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
                  child: Text(resolvedCancelLabel),
                ),
                const SizedBox(width: AppSpacing.md),
                AppButton.primary(
                  label: resolvedConfirmLabel,
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

  const AppBottomSheet({
    required this.child, super.key,
    this.title,
    this.padding,
  });
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// Show as a modal bottom sheet. Returns the result value T.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child, String? title,
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

  const BottomSheetOption({
    required this.value, required this.label, required this.onTap, super.key,
    this.icon,
    this.isSelected = false,
    this.isDestructive = false,
  });
  final T value;
  final String label;
  final IconData? icon;
  final bool isSelected;
  final bool isDestructive;
  final ValueChanged<T> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final color = isDestructive
        ? cs.error
        : isSelected
            ? cs.primary
            : cs.onSurface;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: AnimatedPress(
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
                ExcludeSemantics(
                  child: Icon(Icons.check_rounded, color: cs.primary, size: 22),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
