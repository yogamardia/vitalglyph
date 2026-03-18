import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

class ProfileCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return MergeSemantics(
      child: Semantics(
        label: '${profile.name}, ${isPrimary ? "Primary" : "Secondary"} Profile'
            '${profile.bloodType != null ? ", Blood type ${profile.bloodType!.displayName}" : ""}'
            '${profile.allergies.isNotEmpty ? ", ${profile.allergies.length} allergies" : ""}',
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'profile_avatar_${profile.id}',
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: colorScheme.surface, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: colorScheme.primaryContainer,
                                  backgroundImage: profile.photoPath != null
                                      ? FileImage(File(profile.photoPath!))
                                      : null,
                                  child: profile.photoPath == null
                                      ? Icon(Icons.person,
                                          size: 40,
                                          color: colorScheme.onPrimaryContainer)
                                      : null,
                                ),
                              ),
                              if (isPrimary)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: ExcludeSemantics(
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: colors.successGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                profile.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                isPrimary
                                    ? 'Primary Profile'
                                    : 'Secondary Profile',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (profile.bloodType != null)
                              Semantics(
                                label:
                                    'Blood type ${profile.bloodType!.displayName}',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.bloodTypeBadgeBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: colors.bloodTypeBadgeBorder,
                                    ),
                                  ),
                                  child: Text(
                                    profile.bloodType!.displayName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: colors.bloodTypeBadge,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert,
                                  color: colorScheme.outline),
                              onSelected: (value) {
                                if (value == 'edit') onEdit();
                                if (value == 'emergency') onEmergencyCard();
                                if (value == 'delete') _confirmDelete(context);
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 20),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'emergency',
                                  child: Row(
                                    children: [
                                      Icon(Icons.credit_card_outlined,
                                          size: 20),
                                      SizedBox(width: 8),
                                      Text('Emergency Card'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline,
                                          size: 20,
                                          color: colorScheme.error),
                                      const SizedBox(width: 8),
                                      Text('Delete',
                                          style: TextStyle(
                                              color: colorScheme.error)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (profile.allergies.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: profile.allergies.map((allergy) {
                          return _AllergyTag(allergy: allergy);
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: onShowQr,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primaryAction,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_2_rounded, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'View Emergency QR',
                              style: TextStyle(
                                fontSize: 18,
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
              Divider(
                  height: 1, thickness: 1, color: colors.dividerSubtle),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock,
                          size: 16,
                          color: colors.successGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Encrypted on-device',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Last updated: ${_formatDate(profile.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (dateOnly == today) return 'Today';
    if (dateOnly == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete profile?'),
        content: Text(
          'This will permanently delete ${profile.name}\'s medical profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              HapticFeedback.mediumImpact();
              onDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AllergyTag extends StatelessWidget {
  final Allergy allergy;

  const _AllergyTag({required this.allergy});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    return Semantics(
      label: 'Allergy: ${allergy.name}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.allergyTagBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.allergyTagBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(allergy.name),
              size: 18,
              color: colors.allergyTag,
            ),
            const SizedBox(width: 8),
            Text(
              allergy.name,
              style: TextStyle(
                color: colors.allergyTag,
                fontWeight: FontWeight.w600,
                fontSize: 14,
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
