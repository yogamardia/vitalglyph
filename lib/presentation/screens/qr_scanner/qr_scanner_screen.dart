import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/domain/usecases/parse_qr_data.dart';
import 'package:vitalglyph/injection.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
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
      _showError('This QR code is not a Medical ID.');
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
      appBar: AppBar(
        title: const Text('Scan Medical ID'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                );
              },
            ),
            tooltip: 'Toggle torch',
            onPressed: _controller.toggleTorch,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Viewfinder overlay
          Center(
            child: Semantics(
              label: 'Camera viewfinder',
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  // Keep white — needed for contrast against dark camera feed
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              'Point at a Medical ID QR code',
              textAlign: TextAlign.center,
              // Keep white70 — text overlays camera feed (dark background)
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          if (_processing)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
