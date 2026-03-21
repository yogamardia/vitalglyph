import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Renders a QR code for [data] at [size] × [size] pixels.
/// The QR is always rendered in black on white for maximum scanner contrast.
class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({required this.data, super.key, this.size = 200});
  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      size: size,
      backgroundColor: Colors.white,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );
  }
}
