import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';

/// A modern settings row that replaces stock ListTile.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.destructive = false,
  });
  final String title;
  final String? subtitle;
  final IconData? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    final titleColor = destructive ? cs.error : cs.onSurface;
    final iconColor = destructive ? cs.error : cs.primary;

    return Semantics(
      label: subtitle != null ? '$title, $subtitle' : title,
      button: onTap != null,
      child: AnimatedPress(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                ExcludeSemantics(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      color: destructive
                          ? cs.error.withValues(alpha: 0.1)
                          : colors.surfaceSubtle,
                      border: Border.all(
                        color: destructive
                            ? cs.error.withValues(alpha: 0.1)
                            : colors.cardBorder,
                      ),
                    ),
                    child: Icon(leading, size: 20, color: iconColor),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: titleColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ] else if (onTap != null) ...[
                const SizedBox(width: AppSpacing.sm),
                ExcludeSemantics(
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A settings row with an integrated toggle switch.
/// Replaces SwitchListTile.
class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.leading,
  });
  final String title;
  final String? subtitle;
  final IconData? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Semantics(
      label: subtitle != null ? '$title, $subtitle' : title,
      toggled: value,
      child: AnimatedPress(
        onTap: onChanged != null
            ? () {
                HapticFeedback.selectionClick();
                onChanged!(!value);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                ExcludeSemantics(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      color: colors.surfaceSubtle,
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Icon(leading, size: 20, color: cs.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ExcludeSemantics(
                child: Switch(
                  value: value,
                  onChanged: onChanged != null
                      ? (v) {
                          HapticFeedback.selectionClick();
                          onChanged!(v);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
