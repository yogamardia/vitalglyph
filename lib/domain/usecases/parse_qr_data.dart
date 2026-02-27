import 'package:dartz/dartz.dart';
import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/scanned_profile.dart';

/// Parses a [MEDID|v1|...] QR payload into a [ScannedProfile].
///
/// Returns [Left(ValidationFailure)] if the payload is not a recognised
/// MEDID format. HMAC verification failure is surfaced via
/// [ScannedProfile.signatureValid] = false (not a hard error, because
/// first responders still need to read the data even if tampered).
class ParseQrData {
  final HmacService _hmac;

  ParseQrData(this._hmac);

  Either<Failure, ScannedProfile> call(String rawQr) {
    if (!rawQr.startsWith('MEDID|v1|')) {
      return const Left(ValidationFailure('Not a recognised MEDID QR code.'));
    }

    // Strip signature for verification
    bool sigValid = false;
    String payload = rawQr;
    String dataWithoutSig = rawQr;

    final sigIdx = rawQr.lastIndexOf('|SIG:');
    if (sigIdx != -1) {
      dataWithoutSig = rawQr.substring(0, sigIdx);
      final sig = rawQr.substring(sigIdx + 5); // after '|SIG:'
      sigValid = _hmac.verify(dataWithoutSig, sig);
      payload = dataWithoutSig;
    }

    // Build field map from the segments after 'MEDID|v1|'
    final segments = payload.split('|');
    final fields = <String, String>{};
    for (final seg in segments) {
      final colonIdx = seg.indexOf(':');
      if (colonIdx == -1) continue;
      fields[seg.substring(0, colonIdx)] = seg.substring(colonIdx + 1);
    }

    final name = _dec(fields['N'] ?? '');
    if (name.isEmpty) {
      return const Left(ValidationFailure('QR missing required NAME field.'));
    }

    // Parse allergies: comma-separated, each name/severity/reaction
    final allergies = _parseList(fields['ALG']).map((item) {
      final parts = item.split('/');
      return ScannedAllergy(
        name: _dec(parts[0]),
        severity: parts.length > 1 ? _dec(parts[1]) : '',
        reaction: parts.length > 2 && parts[2].isNotEmpty
            ? _dec(parts[2])
            : null,
      );
    }).toList();

    // Parse medications: comma-separated, each name/dosage/frequency
    final medications = _parseList(fields['MED']).map((item) {
      final parts = item.split('/');
      final name = _dec(parts[0]);
      final dosage = parts.length > 1 && parts[1].isNotEmpty
          ? ' ${_dec(parts[1])}'
          : '';
      final freq = parts.length > 2 && parts[2].isNotEmpty
          ? ' ${_dec(parts[2])}'
          : '';
      return '$name$dosage$freq'.trim();
    }).toList();

    // Parse conditions: comma-separated names
    final conditions =
        _parseList(fields['CON']).map((c) => _dec(c)).toList();

    // Parse emergency contacts: comma-separated, each name/phone/relationship
    final contacts = _parseList(fields['EC']).map((item) {
      final parts = item.split('/');
      return ScannedContact(
        name: _dec(parts[0]),
        phone: parts.length > 1 ? _dec(parts[1]) : '',
        relationship: parts.length > 2 && parts[2].isNotEmpty
            ? _dec(parts[2])
            : null,
      );
    }).toList();

    double? heightCm;
    double? weightKg;
    if (fields['HT'] != null) heightCm = double.tryParse(fields['HT']!);
    if (fields['WT'] != null) weightKg = double.tryParse(fields['WT']!);

    return Right(ScannedProfile(
      name: name,
      dateOfBirth: fields['DOB'],
      bloodType: fields['BT'] != null ? _dec(fields['BT']!) : null,
      biologicalSex: fields['SEX'],
      heightCm: heightCm,
      weightKg: weightKg,
      allergies: allergies,
      medications: medications,
      conditions: conditions,
      emergencyContacts: contacts,
      isOrganDonor: fields['DONOR'] == 'Y',
      language: fields['LANG'] != null ? _dec(fields['LANG']!) : null,
      signatureValid: sigValid,
    ));
  }

  /// Splits a comma-separated field value into parts, skipping empties.
  List<String> _parseList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    return raw.split(',').where((s) => s.isNotEmpty).toList();
  }

  static String _dec(String value) => Uri.decodeComponent(value);
}
