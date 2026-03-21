import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';

class ExportEmergencyCard {

  ExportEmergencyCard(this._generateQrData);
  final GenerateQrData _generateQrData;

  // Credit-card dimensions (ISO/IEC 7810 ID-1)
  static const _cardFormat = PdfPageFormat(
    8.56 * PdfPageFormat.cm,
    5.398 * PdfPageFormat.cm,
  );

  Future<Either<Failure, Uint8List>> call(Profile profile) async {
    try {
      final qrData = _generateQrData(profile).data;
      final doc = pw.Document(
        creator: 'VitalGlyph',
        author: profile.name,
        title: 'Emergency Medical Card — ${profile.name}',
      );

      doc.addPage(pw.Page(
        pageFormat: _cardFormat,
        margin: const pw.EdgeInsets.all(6),
        build: (ctx) => _buildFront(profile, qrData),
      ));

      doc.addPage(pw.Page(
        pageFormat: _cardFormat,
        margin: const pw.EdgeInsets.all(6),
        build: (ctx) => _buildBack(profile),
      ));

      return Right(await doc.save());
    } catch (e) {
      return Left(PdfFailure('Failed to generate emergency card: $e'));
    }
  }

  pw.Widget _buildFront(Profile profile, String qrData) {
    const titleSize = 8.5;
    const nameSize = 9.0;
    const bodySize = 7.0;
    const smallSize = 6.0;

    final dob = _formatDate(profile.dateOfBirth);
    final bloodType = profile.bloodType?.displayName ?? '—';
    final sex = profile.biologicalSex?.displayName;
    final donor = profile.isOrganDonor ? 'YES' : 'NO';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // ── Header row: info + QR ──
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '⚕  MEDICAL ID',
                    style: pw.TextStyle(
                      fontSize: titleSize,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey900,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    profile.name,
                    style: pw.TextStyle(
                      fontSize: nameSize,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'DOB: $dob   Blood: $bloodType',
                    style: const pw.TextStyle(fontSize: bodySize),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    '${sex != null ? "Sex: $sex   " : ""}Organ Donor: $donor',
                    style: const pw.TextStyle(fontSize: bodySize),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 6),
            pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: qrData,
              width: 55,
              height: 55,
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 0.5, color: PdfColors.grey600),
        pw.SizedBox(height: 3),

        // ── Allergies ──
        if (profile.allergies.isNotEmpty) ...[
          pw.Text(
            '⚠  ALLERGIES',
            style: pw.TextStyle(
              fontSize: bodySize,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red900,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Wrap(
            spacing: 3,
            runSpacing: 2,
            children: profile.allergies.map((a) {
              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 1,
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.red700, width: 0.5),
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                ),
                child: pw.Text(
                  '${a.name} (${a.severity.displayName})',
                  style: const pw.TextStyle(
                    fontSize: smallSize,
                    color: PdfColors.red900,
                  ),
                ),
              );
            }).toList(),
          ),
        ] else ...[
          pw.Text(
            'No known allergies',
            style: const pw.TextStyle(fontSize: bodySize, color: PdfColors.grey600),
          ),
        ],
      ],
    );
  }

  pw.Widget _buildBack(Profile profile) {
    const sectionSize = 7.5;
    const bodySize = 6.5;

    final rows = <pw.Widget>[];

    if (profile.conditions.isNotEmpty) {
      rows.addAll([
        _sectionHeader('CONDITIONS', sectionSize),
        pw.SizedBox(height: 1),
        ...profile.conditions.map(
          (c) => _bulletText(
            '${c.name}${c.diagnosedDate != null ? " (${c.diagnosedDate})" : ""}',
            bodySize,
          ),
        ),
        pw.SizedBox(height: 4),
      ]);
    }

    if (profile.medications.isNotEmpty) {
      rows.addAll([
        _sectionHeader('MEDICATIONS', sectionSize),
        pw.SizedBox(height: 1),
        ...profile.medications.map((m) {
          final detail = [m.dosage, m.frequency]
              .where((s) => s != null && s.isNotEmpty)
              .join(' ');
          return _bulletText(
            '${m.name}${detail.isNotEmpty ? " — $detail" : ""}',
            bodySize,
          );
        }),
        pw.SizedBox(height: 4),
      ]);
    }

    if (profile.emergencyContacts.isNotEmpty) {
      rows.addAll([
        _sectionHeader('EMERGENCY CONTACTS', sectionSize),
        pw.SizedBox(height: 1),
        ...profile.emergencyContacts.map((c) {
          final rel = c.relationship != null ? ' (${c.relationship})' : '';
          return _bulletText('${c.name}$rel: ${c.phone}', bodySize);
        }),
        pw.SizedBox(height: 4),
      ]);
    }

    if (profile.medicalNotes != null && profile.medicalNotes!.isNotEmpty) {
      rows.addAll([
        _sectionHeader('NOTES', sectionSize),
        pw.SizedBox(height: 1),
        pw.Text(
          profile.medicalNotes!,
          style: const pw.TextStyle(fontSize: bodySize),
        ),
      ]);
    }

    if (rows.isEmpty) {
      rows.add(
        pw.Text(
          'No additional medical information.',
          style: const pw.TextStyle(fontSize: bodySize, color: PdfColors.grey600),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: rows,
    );
  }

  pw.Widget _sectionHeader(String text, double size) => pw.Text(
        text,
        style: pw.TextStyle(fontSize: size, fontWeight: pw.FontWeight.bold),
      );

  pw.Widget _bulletText(String text, double size) => pw.Text(
        '• $text',
        style: pw.TextStyle(fontSize: size),
      );

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
