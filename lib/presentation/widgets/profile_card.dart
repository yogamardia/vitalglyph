import 'package:flutter/material.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback onDelete;
  final VoidCallback onShowQr;
  final VoidCallback onEdit;
  final VoidCallback onEmergencyCard;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onDelete,
    required this.onShowQr,
    required this.onEdit,
    required this.onEmergencyCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (profile.bloodType != null)
                        Text(
                          'Blood type: ${profile.bloodType!.displayName}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit profile',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete profile',
                  color: colorScheme.error,
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            if (profile.allergies.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: profile.allergies.map((a) {
                  return Chip(
                    label: Text(a.name),
                    backgroundColor:
                        colorScheme.errorContainer.withValues(alpha: 0.6),
                    labelStyle:
                        TextStyle(color: colorScheme.onErrorContainer),
                    avatar: const Icon(Icons.warning_amber_rounded,
                        size: 16),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.medication_outlined,
                  label: '${profile.medications.length} meds',
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.monitor_heart_outlined,
                  label: '${profile.conditions.length} conditions',
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: onEmergencyCard,
                  icon: const Icon(Icons.credit_card_outlined, size: 18),
                  label: const Text('Card'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: onShowQr,
                  icon: const Icon(Icons.qr_code, size: 18),
                  label: const Text('QR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
