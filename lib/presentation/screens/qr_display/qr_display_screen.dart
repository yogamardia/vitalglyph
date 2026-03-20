import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vitalglyph/core/services/screen_protection_service.dart';
import 'package:vitalglyph/core/theme/app_colors.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';
import 'package:vitalglyph/presentation/widgets/qr_code_widget.dart';

/// Full-screen QR display optimised for emergency scanning.
class QrDisplayScreen extends StatefulWidget {
  final Profile profile;

  const QrDisplayScreen({super.key, required this.profile});

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  late final String _qrData;
  late final bool _truncated;

  @override
  void initState() {
    super.initState();
    final payload = sl<GenerateQrData>()(widget.profile);
    _qrData = payload.data;
    _truncated = payload.truncated;
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Disable screen protection so the QR code can be scanned or screenshotted for emergency use.
    ScreenProtectionService.disable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Re-enable screen protection when leaving the QR display.
    ScreenProtectionService.enable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = (size.width.clamp(0.0, size.height) * 0.75).clamp(200.0, 500.0);
    final colors = Theme.of(context).extension<VitalGlyphColors>()!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is! AuthRequired) {
          // Re-disable protection when unlocked, as we are still on QrDisplayScreen.
          // This handles the case where the app was locked (which enables protection)
          // and then unlocked while this screen was still active.
          ScreenProtectionService.disable();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text(
              widget.profile.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF1A1C1E),
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: colors.emergencyRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.l10n.qrDisplayEmergencyLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.emergencyRed,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Semantics(
              label: context.l10n.qrDisplaySemanticLabel(widget.profile.name),
              child: Center(
                child: _QrFrame(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: QrCodeWidget(data: _qrData, size: qrSize),
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            if (widget.profile.bloodType != null || widget.profile.allergies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (widget.profile.bloodType != null)
                      _StaggeredEntry(
                        index: 0,
                        child: _EmergencyPill(
                          icon: Icons.bloodtype_rounded,
                          label: context.l10n.qrDisplayBloodType(widget.profile.bloodType!.displayName),
                          color: colors.bloodTypeBadge,
                        ),
                      ),
                    if (widget.profile.allergies.isNotEmpty)
                      _StaggeredEntry(
                        index: 1,
                        child: _EmergencyPill(
                          icon: Icons.warning_amber_rounded,
                          label: context.l10n.qrDisplayAllergyCount(widget.profile.allergies.length),
                          color: colors.allergyTag,
                        ),
                      ),
                  ],
                ),
              ),
            if (_truncated) ...[
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: Colors.amber[800]),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        context.l10n.qrDisplayTruncated,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 48),
            _CloseButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
    );
  }
}

class _QrFrame extends StatefulWidget {
  final Widget child;
  const _QrFrame({required this.child});

  @override
  State<_QrFrame> createState() => _QrFrameState();
}

class _QrFrameState extends State<_QrFrame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
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
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _QrFramePainter(
            color: cs.primary.withValues(alpha: _animation.value),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _QrFramePainter extends CustomPainter {
  final Color color;
  _QrFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const armLength = 32.0;
    
    // Top Left
    canvas.drawPath(Path()..moveTo(0, armLength)..lineTo(0, 0)..lineTo(armLength, 0), paint);
    // Top Right
    canvas.drawPath(Path()..moveTo(size.width - armLength, 0)..lineTo(size.width, 0)..lineTo(size.width, armLength), paint);
    // Bottom Left
    canvas.drawPath(Path()..moveTo(0, size.height - armLength)..lineTo(0, size.height)..lineTo(armLength, size.height), paint);
    // Bottom Right
    canvas.drawPath(Path()..moveTo(size.width - armLength, size.height)..lineTo(size.width, size.height)..lineTo(size.width, size.height - armLength), paint);
  }

  @override
  bool shouldRepaint(_QrFramePainter oldDelegate) => oldDelegate.color != color;
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
    return GlassContainer(
      enableBlur: false,
      backgroundColor: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaggeredEntry extends StatefulWidget {
  final Widget child;
  final int index;

  const _StaggeredEntry({required this.child, required this.index});

  @override
  State<_StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<_StaggeredEntry> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    
    Future.delayed(Duration(milliseconds: 400 + (widget.index * 150)), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.a11yCloseQrDisplay,
      button: true,
      child: AnimatedPress(
        onTap: () => Navigator.of(context).pop(),
        child: GlassContainer(
          width: 56,
          height: 56,
          backgroundColor: const Color(0xFFF2F4F7),
          borderColor: const Color(0xFFE8ECF0),
          borderRadius: BorderRadius.circular(28),
          child: const Center(
            child: Icon(Icons.close_rounded, color: Color(0xFF4B5563), size: 24),
          ),
        ),
      ),
    );
  }
}
