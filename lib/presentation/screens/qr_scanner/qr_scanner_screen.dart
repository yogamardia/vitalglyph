import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/domain/usecases/parse_qr_data.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/l10n/l10n.dart';
import 'package:vitalglyph/presentation/widgets/animated_press.dart';
import 'package:vitalglyph/presentation/widgets/glass_container.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processing) return;
    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;
    if (raw == null) return;

    if (!raw.startsWith('MEDID|')) {
      _showError(context.l10n.qrScannerNotMedicalId);
      return;
    }

    setState(() => _processing = true);

    final result = sl<ParseQrData>()(raw);
    result.fold(
      (failure) {
        setState(() => _processing = false);
        _showError(failure.message);
      },
      (scanned) {
        setState(() => _processing = false);
        context.push(AppRouter.scanResult, extra: scanned);
      },
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.l10n.qrScannerTitle),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, state, child) {
                return _CircleActionButton(
                  icon: state.torchState == TorchState.on
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  onPressed: _controller.toggleTorch,
                  active: state.torchState == TorchState.on,
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          
          // Viewfinder with animations
          const _ScannerOverlay(),

          // Instruction pill
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: GlassContainer(
                blurSigma: 10,
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                borderColor: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.qr_code_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.qrScannerInstruction,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Processing overlay
          if (_processing)
            Semantics(
              label: context.l10n.a11yProcessingQr,
              liveRegion: true,
              child: Positioned.fill(
                child: GlassContainer(
                  blurSigma: 15,
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.zero,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 24),
                        Text(
                          context.l10n.qrScannerProcessing,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {

  const _CircleActionButton({
    required this.icon,
    required this.onPressed,
    this.active = false,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.a11yToggleTorch,
      button: true,
      toggled: active,
      child: AnimatedPress(
        onTap: onPressed,
        child: GlassContainer(
          width: 48,
          height: 48,
          blurSigma: 10,
          backgroundColor: active
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.3),
          borderColor: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(24),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatefulWidget {
  const _ScannerOverlay();

  @override
  State<_ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<_ScannerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(
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
    const size = 260.0;
    return Stack(
      children: [
        // Semi-transparent background with a hole for the viewfinder
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Animated scan line and corners
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                const _ViewfinderCorners(),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      top: size * _animation.value,
                      left: 10,
                      right: 10,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white,
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewfinderCorners extends StatelessWidget {
  const _ViewfinderCorners();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ViewfinderPainter(),
      size: const Size(260, 260),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    const armLength = 30.0;
    
    void drawCorner(Path path) {
      canvas.drawPath(path, shadowPaint);
      canvas.drawPath(path, paint);
    }

    drawCorner(Path()..moveTo(0, armLength)..lineTo(0, 0)..lineTo(armLength, 0));
    drawCorner(Path()..moveTo(size.width - armLength, 0)..lineTo(size.width, 0)..lineTo(size.width, armLength));
    drawCorner(Path()..moveTo(0, size.height - armLength)..lineTo(0, size.height)..lineTo(armLength, size.height));
    drawCorner(Path()..moveTo(size.width - armLength, size.height)..lineTo(size.width, size.height)..lineTo(size.width, size.height - armLength));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
