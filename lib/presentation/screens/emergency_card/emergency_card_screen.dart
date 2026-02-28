import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';

class EmergencyCardScreen extends StatelessWidget {
  final Profile profile;
  final ExportEmergencyCard exportEmergencyCard;

  const EmergencyCardScreen({
    super.key,
    required this.profile,
    required this.exportEmergencyCard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${profile.name} — Emergency Card'),
      ),
      body: PdfPreview(
        build: _buildPdf,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        pdfFileName: _pdfFileName(),
        initialPageFormat: PdfPageFormat(
          8.56 * PdfPageFormat.cm,
          5.398 * PdfPageFormat.cm,
        ),
      ),
    );
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final result = await exportEmergencyCard(profile);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (bytes) => bytes,
    );
  }

  String _pdfFileName() {
    final safeName = profile.name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .toLowerCase();
    return 'emergency_card_$safeName.pdf';
  }
}
