import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/app_dialog.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';

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

class _ProfileCardState extends State<ProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return MergeSemantics(
      child: Semantics(
        label:
            '${widget.profile.name}, ${widget.isPrimary ? context.l10n.profileCardPrimary : context.l10n.profileCardSecondary} Profile'
            '${widget.profile.bloodType != null ? ", Blood type ${widget.profile.bloodType!.displayName}" : ""}'
            '${widget.profile.allergies.isNotEmpty ? ", ${widget.profile.allergies.length} allergies" : ""}',
        child: AnimatedPress(
          onTap: widget.onEdit,
          onLongPress: () => _showActionsSheet(context),
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: colors.glassSurface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: colors.cardBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Visual accent: Subtle top bar
                _TopAccentBar(profile: widget.profile),

                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(
                        profile: widget.profile,
                        isPrimary: widget.isPrimary,
                        onActionsPressed: () => _showActionsSheet(context),
                      ),
                      
                      if (widget.profile.allergies.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _AllergyList(allergies: widget.profile.allergies),
                      ],

                      const SizedBox(height: AppSpacing.xxl),
                      
                      _EmergencyActionButton(
                        pulseAnimation: _pulseAnimation,
                        onPressed: widget.onShowQr,
                      ),
                    ],
                  ),
                ),

                _FooterInfo(profile: widget.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActionsSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    AppBottomSheet.show(
      context,
      title: widget.profile.name,
      child: Column(
        children: [
          BottomSheetOption(
            value: 'edit',
            label: context.l10n.profileCardEditProfile,
            icon: Icons.edit_rounded,
            onTap: (_) => widget.onEdit(),
          ),
          const SizedBox(height: AppSpacing.sm),
          BottomSheetOption(
            value: 'card',
            label: context.l10n.profileCardEmergencyCard,
            icon: Icons.badge_rounded,
            onTap: (_) => widget.onEmergencyCard(),
          ),
          const SizedBox(height: AppSpacing.sm),
          BottomSheetOption(
            value: 'delete',
            label: context.l10n.profileCardDeleteProfile,
            icon: Icons.delete_rounded,
            isDestructive: true,
            onTap: (_) => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    AppDialog.showDestructive(
      context,
      title: context.l10n.profileCardDeleteTitle,
      message: context.l10n.profileCardDeleteMessage(widget.profile.name),
      confirmLabel: context.l10n.delete,
    ).then((confirmed) {
      if (confirmed == true) {
        HapticFeedback.mediumImpact();
        widget.onDelete();
      }
    });
  }
}

class _TopAccentBar extends StatelessWidget {
  final Profile profile;

  const _TopAccentBar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: profile.bloodType != null
            ? colors.bloodTypeBadge
            : cs.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Profile profile;
  final bool isPrimary;
  final VoidCallback onActionsPressed;

  const _ProfileHeader({
    required this.profile,
    required this.isPrimary,
    required this.onActionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProfileAvatar(
          profileId: profile.id,
          photoPath: profile.photoPath,
          isPrimary: isPrimary,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                profile.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _StatusBadge(
                    label: isPrimary ? context.l10n.profileCardPrimary : context.l10n.profileCardSecondary,
                    isPrimary: isPrimary,
                  ),
                  if (profile.bloodType != null) ...[
                    const SizedBox(width: 8),
                    _BloodTypeBadge(bloodType: profile.bloodType!.displayName),
                  ],
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_horiz_rounded,
            color: cs.onSurfaceVariant.withValues(alpha: 0.6),
            size: 24,
          ),
          onPressed: onActionsPressed,
          tooltip: context.l10n.a11yMoreActions,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String profileId;
  final String? photoPath;
  final bool isPrimary;

  const _ProfileAvatar({
    required this.profileId,
    this.photoPath,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Hero(
      tag: 'profile_avatar_$profileId',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: colors.glowPrimary.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
          border: Border.all(
            color: isPrimary ? cs.primary.withValues(alpha: 0.5) : cs.outlineVariant.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: cs.surfaceContainerHigh,
              backgroundImage: photoPath != null
                  ? FileImage(File(photoPath!))
                  : null,
              child: photoPath == null
                  ? Icon(
                      Icons.person_rounded,
                      size: 32,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    )
                  : null,
            ),
            if (isPrimary)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colors.successGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isPrimary;

  const _StatusBadge({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isPrimary 
            ? cs.primaryContainer.withValues(alpha: 0.5)
            : cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isPrimary ? cs.primary : cs.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _BloodTypeBadge extends StatelessWidget {
  final String bloodType;

  const _BloodTypeBadge({required this.bloodType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<VitalGlyphColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.bloodTypeBadgeBackground.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: colors.bloodTypeBadgeBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop_rounded, size: 10, color: colors.bloodTypeBadge),
          const SizedBox(width: 4),
          Text(
            bloodType,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.bloodTypeBadge,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllergyList extends StatelessWidget {
  final List<Allergy> allergies;

  const _AllergyList({required this.allergies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 14,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              context.l10n.profileCardCriticalAllergies,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: allergies.map((allergy) {
            return _AllergyTag(allergy: allergy);
          }).toList(),
        ),
      ],
    );
  }
}

class _EmergencyActionButton extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final VoidCallback onPressed;

  const _EmergencyActionButton({
    required this.pulseAnimation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    return ScaleTransition(
      scale: pulseAnimation,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_scanner_rounded, size: 22),
              const SizedBox(width: 12),
              Text(
                context.l10n.profileCardViewQr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  final Profile profile;

  const _FooterInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_rounded,
                size: 14,
                color: colors.successGreen.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.profileCardEncrypted,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            context.l10n.profileCardUpdated(_formatDate(context.l10n, profile.updatedAt)),
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(AppLocalizations l10n, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == today) return l10n.profileCardToday;
    if (dateOnly == today.subtract(const Duration(days: 1))) return l10n.profileCardYesterday;
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _AllergyTag extends StatelessWidget {
  final Allergy allergy;

  const _AllergyTag({required this.allergy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<VitalGlyphColors>()!;

    return Semantics(
      label: context.l10n.a11yAllergyWithSeverity(allergy.name, allergy.severity.displayName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colors.allergyTagBackground.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: colors.allergyTagBorder.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(allergy.name),
              size: 14,
              color: colors.allergyTag,
            ),
            const SizedBox(width: 8),
            Text(
              allergy.name,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.allergyTag,
                fontWeight: FontWeight.w700,
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
