import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
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

    return Scaffold(
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
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: QrCodeWidget(data: _qrData, size: qrSize),
              ),
            ),
            const SizedBox(height: 24),
            if (widget.profile.bloodType != null) ...[
              _EmergencyPill(
                icon: Icons.bloodtype,
                label:
                    'Blood Type: ${widget.profile.bloodType!.displayName}',
                color: Colors.red,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.profile.allergies.isNotEmpty)
              _EmergencyPill(
                icon: Icons.warning_amber_rounded,
                label:
                    '⚠ ${widget.profile.allergies.length} Allerg${widget.profile.allergies.length == 1 ? 'y' : 'ies'}',
                color: Colors.orange,
              ),
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
              style: TextButton.styleFrom(foregroundColor: Colors.black54),
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

  const _EmergencyPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
