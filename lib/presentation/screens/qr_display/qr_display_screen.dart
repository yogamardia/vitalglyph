import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/widgets/qr_code_widget.dart';

/// Full-screen QR display optimised for emergency scanning.
///
/// On open: maximises brightness, enables wakelock.
/// On close: restores brightness, releases wakelock.
class QrDisplayScreen extends StatefulWidget {
  final Profile profile;

  const QrDisplayScreen({super.key, required this.profile});

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  late final String _qrData;

  @override
  void initState() {
    super.initState();
    _qrData = sl<GenerateQrData>()(widget.profile);
    // Maximise brightness and prevent screen timeout
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = (size.width.clamp(0.0, size.height) * 0.8).clamp(200.0, 600.0);
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Keep white background — required for QR code readability
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              widget.profile.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                // Keep black87 — QR screen always has white background
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'SCAN FOR MEDICAL INFORMATION',
              style: TextStyle(
                fontSize: 13,
                color: colors.emergencyRed,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              label: 'QR code with medical info for ${widget.profile.name}',
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // Keep white — QR modules must be black on white
                    color: Colors.white,
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrCodeWidget(data: _qrData, size: qrSize),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (widget.profile.bloodType != null) ...[
              _EmergencyPill(
                icon: Icons.bloodtype,
                label: 'Blood Type: ${widget.profile.bloodType!.displayName}',
                color: colors.bloodTypeBadge,
                background: colors.bloodTypeBadgeBackground,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.profile.allergies.isNotEmpty)
              _EmergencyPill(
                icon: Icons.warning_amber_rounded,
                label:
                    '⚠ ${widget.profile.allergies.length} Allerg${widget.profile.allergies.length == 1 ? 'y' : 'ies'}',
                color: colors.allergyTag,
                background: colors.allergyTagBackground,
              ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
              style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  const _EmergencyPill({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
