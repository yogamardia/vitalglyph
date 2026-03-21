import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';

/// A consistent, architected section card for forms and settings.
class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.title,
    required this.icon,
    required this.children,
    super.key,
    this.margin,
    this.padding,
    this.iconColor,
    this.showDividers = false,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? iconColor;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Container(
        decoration: BoxDecoration(
          color: colors.glassSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: BoxDecoration(
                color: colors.surfaceSubtle,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
                border: Border(bottom: BorderSide(color: colors.cardBorder)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: iconColor ?? cs.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Section Content
            Padding(
              padding:
                  padding ??
                  (showDividers
                      ? EdgeInsets.zero
                      : const EdgeInsets.fromLTRB(20, 20, 20, 24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildChildren(colors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChildren(VitalGlyphColors colors) {
    if (children.isEmpty) return [];
    if (!showDividers) return children;

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 1,
            color: colors.cardBorder.withValues(alpha: 0.5),
            indent: 20,
          ),
        );
      }
    }
    return result;
  }
}
