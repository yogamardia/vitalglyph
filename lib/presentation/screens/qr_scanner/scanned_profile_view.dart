import 'package:flutter/material.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/core/theme/app_spacing.dart';
import 'package:vitalglyph/domain/entities/scanned_profile.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';
import 'package:vitalglyph/presentation/widgets/gradient_scaffold.dart';

/// Emergency-optimised read-only view of a scanned Medical ID.
class ScannedProfileView extends StatelessWidget {

  const ScannedProfileView({required this.profile, super.key});
  final ScannedProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return GradientScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.l10n.scannedProfileTitle),
        backgroundColor: colors.emergencyRed.withValues(alpha: 0.9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.emergencyRed.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
          children: [
            if (!profile.signatureValid) _TamperWarning(),
            _HeaderCard(profile: profile),
            if (profile.allergies.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: context.l10n.scannedProfileAllergies,
                titleColor: colors.emergencyRed,
                icon: Icons.warning_amber_rounded,
                iconColor: colors.emergencyRed,
                children: profile.allergies
                    .map((a) => _AllergyRow(allergy: a))
                    .toList(),
              ),
            ],
            if (profile.medications.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: context.l10n.scannedProfileMedications,
                icon: Icons.medication_rounded,
                children: profile.medications
                    .map((m) => _BulletRow(text: m))
                    .toList(),
              ),
            ],
            if (profile.conditions.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: context.l10n.scannedProfileConditions,
                icon: Icons.monitor_heart_rounded,
                children: profile.conditions
                    .map((c) => _BulletRow(text: c))
                    .toList(),
              ),
            ],
            if (profile.emergencyContacts.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: context.l10n.scannedProfileContacts,
                icon: Icons.contact_phone_rounded,
                children: profile.emergencyContacts
                    .map((ec) => _ContactRow(contact: ec))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TamperWarning extends StatefulWidget {
  @override
  State<_TamperWarning> createState() => _TamperWarningState();
}

class _TamperWarningState extends State<_TamperWarning> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GlassContainer(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          backgroundColor: colors.tamperWarningBackground.withValues(alpha: 0.4),
          borderColor: colors.tamperWarning.withValues(alpha: _animation.value),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.gpp_maybe_rounded, color: colors.tamperWarning),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.scannedProfileTamperTitle,
                        style: TextStyle(
                          color: colors.tamperWarning,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.scannedProfileTamperMessage,
                        style: TextStyle(
                          color: colors.tamperWarning.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {

  const _HeaderCard({required this.profile});
  final ScannedProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (profile.dateOfBirth != null)
              _InfoRow(label: context.l10n.scannedProfileBorn, value: profile.dateOfBirth!),
            if (profile.bloodType != null)
              _InfoRow(
                label: context.l10n.scannedProfileBloodType,
                value: profile.bloodType!,
                valueStyle: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.bloodTypeBadge,
                ),
              ),
            if (profile.biologicalSex != null)
              _InfoRow(
                label: context.l10n.scannedProfileSex,
                value: _sexLabel(profile.biologicalSex!, context.l10n),
              ),
            if (profile.heightCm != null)
              _InfoRow(label: context.l10n.scannedProfileHeight, value: '${profile.heightCm} cm'),
            if (profile.weightKg != null)
              _InfoRow(label: context.l10n.scannedProfileWeight, value: '${profile.weightKg} kg'),
            _InfoRow(
              label: context.l10n.scannedProfileOrganDonor,
              value: profile.isOrganDonor ? context.l10n.scannedProfileYes : context.l10n.scannedProfileNo,
              valueStyle: TextStyle(
                fontWeight: FontWeight.w900,
                color: profile.isOrganDonor
                    ? colors.successGreen
                    : cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sexLabel(String code, AppLocalizations l10n) => switch (code.toUpperCase()) {
        'M' => l10n.biologicalSexMale,
        'F' => l10n.biologicalSexFemale,
        'O' => l10n.biologicalSexOther,
        _ => code,
      };
}

class _InfoRow extends StatelessWidget {

  const _InfoRow({required this.label, required this.value, this.valueStyle});
  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.titleColor,
    this.iconColor,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final colors = theme.extension<VitalGlyphColors>()!;
    final defaultColor = cs.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: colors.glassSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: colors.cardBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: (titleColor ?? defaultColor).withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
              border: Border(
                bottom: BorderSide(
                  color: (titleColor ?? defaultColor).withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: iconColor ?? defaultColor),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: titleColor ?? defaultColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _AllergyRow extends StatelessWidget {

  const _AllergyRow({required this.allergy});
  final ScannedAllergy allergy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    final severityColor = switch (allergy.severity.toLowerCase()) {
      'lifethreatening' => colors.lifeThreatening,
      'severe' => colors.severe,
      'moderate' => colors.moderate,
      _ => colors.mild,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SeverityBadge(label: allergy.severity, color: severityColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allergy.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
                if (allergy.reaction != null)
                  Text(
                    allergy.reaction!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {

  const _SeverityBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {

  const _BulletRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {

  const _ContactRow({required this.contact});
  final ScannedContact contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, size: 20, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  contact.relationship != null
                      ? '${contact.phone} · ${contact.relationship}'
                      : contact.phone,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
