import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/presentation/widgets/app_dialog.dart';

class ProfileCard extends StatefulWidget {
  final Profile profile;
  final bool isPrimary;
  final VoidCallback onDelete;
  final VoidCallback onShowQr;
  final VoidCallback onEdit;
  final VoidCallback onEmergencyCard;

  const ProfileCard({
    super.key,
    required this.profile,
    this.isPrimary = false,
    required this.onDelete,
    required this.onShowQr,
    required this.onEdit,
    required this.onEmergencyCard,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return MergeSemantics(
      child: Semantics(
        label:
            '${widget.profile.name}, ${widget.isPrimary ? "Primary" : "Secondary"} Profile'
            '${widget.profile.bloodType != null ? ", Blood type ${widget.profile.bloodType!.displayName}" : ""}'
            '${widget.profile.allergies.isNotEmpty ? ", ${widget.profile.allergies.length} allergies" : ""}',
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onLongPress: () => _showActionsSheet(context),
          onTap: widget.onEdit,
          child: AnimatedScale(
            scale: _pressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Colored accent bar at the top
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: widget.profile.bloodType != null
                          ? colors.bloodTypeBadge.withValues(alpha: 0.7)
                          : colors.primaryAction,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.xxl),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'profile_avatar_${widget.profile.id}',
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor:
                                        colorScheme.primaryContainer,
                                    backgroundImage:
                                        widget.profile.photoPath != null
                                            ? FileImage(
                                                File(widget.profile.photoPath!))
                                            : null,
                                    child: widget.profile.photoPath == null
                                        ? Icon(
                                            Icons.person,
                                            size: 32,
                                            color:
                                                colorScheme.onPrimaryContainer,
                                          )
                                        : null,
                                  ),
                                  if (widget.isPrimary)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: ExcludeSemantics(
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: colors.successGreen,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: colorScheme.surface,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.profile.name,
                                    style:
                                        theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    widget.isPrimary
                                        ? 'Primary Profile'
                                        : 'Secondary Profile',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                if (widget.profile.bloodType != null)
                                  Semantics(
                                    label:
                                        'Blood type ${widget.profile.bloodType!.displayName}',
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.bloodTypeBadgeBackground,
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.sm),
                                        border: Border.all(
                                          color: colors.bloodTypeBadgeBorder,
                                        ),
                                      ),
                                      child: Text(
                                        widget.profile.bloodType!.displayName,
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: colors.bloodTypeBadge,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  onPressed: () => _showActionsSheet(context),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.profile.allergies.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.lg),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: widget.profile.allergies.map((allergy) {
                              return _AllergyTag(allergy: allergy);
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: widget.onShowQr,
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.primaryAction,
                              shape: const StadiumBorder(),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code_2_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'View Emergency QR',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: colors.cardBorder),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 13,
                              color: colors.successGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Encrypted on-device',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Updated ${_formatDate(widget.profile.updatedAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == today) return 'today';
    if (dateOnly == today.subtract(const Duration(days: 1))) return 'yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showActionsSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
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
                  widget.profile.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.of(ctx).pop();
                widget.onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: const Text('Emergency Card'),
              onTap: () {
                Navigator.of(ctx).pop();
                widget.onEmergencyCard();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete Profile',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmDelete(context);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    AppDialog.showDestructive(
      context,
      title: 'Delete profile?',
      message:
          'This will permanently delete ${widget.profile.name}\'s medical profile.',
      confirmLabel: 'Delete',
    ).then((confirmed) {
      if (confirmed == true) {
        HapticFeedback.mediumImpact();
        widget.onDelete();
      }
    });
  }
}

class _AllergyTag extends StatelessWidget {
  final Allergy allergy;

  const _AllergyTag({required this.allergy});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final theme = Theme.of(context);
    return Semantics(
      label: 'Allergy: ${allergy.name}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.allergyTagBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: colors.allergyTagBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(allergy.name),
              size: 14,
              color: colors.allergyTag,
            ),
            const SizedBox(width: 6),
            Text(
              allergy.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.allergyTag,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('penicillin') || lowerName.contains('med')) {
      return Icons.medication_rounded;
    }
    if (lowerName.contains('bee') ||
        lowerName.contains('sting') ||
        lowerName.contains('insect')) {
      return Icons.bug_report_rounded;
    }
    if (lowerName.contains('peanut') ||
        lowerName.contains('nut') ||
        lowerName.contains('food')) {
      return Icons.restaurant_rounded;
    }
    return Icons.warning_amber_rounded;
  }
}
