import 'package:flutter/material.dart';
import 'package:vitalglyph/domain/entities/scanned_profile.dart';

/// Emergency-optimised read-only view of a scanned Medical ID.
/// Large fonts, high contrast, colour-coded allergy severity.
class ScannedProfileView extends StatelessWidget {
  final ScannedProfile profile;

  const ScannedProfileView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical ID'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!profile.signatureValid) _TamperWarning(),
          _HeaderCard(profile: profile),
          if (profile.allergies.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'ALLERGIES',
              titleColor: Colors.red.shade700,
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.red.shade700,
              children: profile.allergies
                  .map((a) => _AllergyRow(allergy: a))
                  .toList(),
            ),
          ],
          if (profile.medications.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'MEDICATIONS',
              icon: Icons.medication_outlined,
              children: profile.medications
                  .map((m) => _BulletRow(text: m))
                  .toList(),
            ),
          ],
          if (profile.conditions.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'CONDITIONS',
              icon: Icons.monitor_heart_outlined,
              children: profile.conditions
                  .map((c) => _BulletRow(text: c))
                  .toList(),
            ),
          ],
          if (profile.emergencyContacts.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: 'EMERGENCY CONTACTS',
              icon: Icons.call_outlined,
              children: profile.emergencyContacts
                  .map((ec) => _ContactRow(contact: ec))
                  .toList(),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TamperWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        border: Border.all(color: Colors.orange.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Signature invalid — data may have been tampered with. Verify with patient directly.',
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ScannedProfile profile;

  const _HeaderCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (profile.dateOfBirth != null)
              _InfoRow(label: 'Date of Birth', value: profile.dateOfBirth!),
            if (profile.bloodType != null)
              _InfoRow(
                label: 'Blood Type',
                value: profile.bloodType!,
                valueStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            if (profile.biologicalSex != null)
              _InfoRow(
                label: 'Sex',
                value: _sexLabel(profile.biologicalSex!),
              ),
            if (profile.heightCm != null)
              _InfoRow(label: 'Height', value: '${profile.heightCm} cm'),
            if (profile.weightKg != null)
              _InfoRow(label: 'Weight', value: '${profile.weightKg} kg'),
            _InfoRow(
              label: 'Organ Donor',
              value: profile.isOrganDonor ? 'YES' : 'NO',
              valueStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: profile.isOrganDonor ? Colors.green : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sexLabel(String code) => switch (code.toUpperCase()) {
        'M' => 'Male',
        'F' => 'Female',
        'O' => 'Other',
        _ => code,
      };
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? titleColor;
  final Color? iconColor;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    this.titleColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: iconColor ?? Colors.black54),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: titleColor ?? Colors.black54,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AllergyRow extends StatelessWidget {
  final ScannedAllergy allergy;

  const _AllergyRow({required this.allergy});

  @override
  Widget build(BuildContext context) {
    final severityColor = switch (allergy.severity.toLowerCase()) {
      'lifethreatening' => Colors.red.shade900,
      'severe' => Colors.red,
      'moderate' => Colors.orange,
      _ => Colors.yellow.shade800,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: severityColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              allergy.severity.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: severityColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allergy.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (allergy.reaction != null)
                  Text(
                    allergy.reaction!,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;

  const _BulletRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final ScannedContact contact;

  const _ContactRow({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  contact.relationship != null
                      ? '${contact.phone} · ${contact.relationship}'
                      : contact.phone,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
