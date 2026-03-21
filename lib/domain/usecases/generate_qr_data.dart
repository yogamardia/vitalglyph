import 'dart:convert';

import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

/// Result of QR data generation, including whether data was truncated to fit.
class QrPayload {

  const QrPayload(this.data, {this.truncated = false});
  /// The QR payload string.
  final String data;

  /// Whether the payload was truncated to fit within QR capacity limits.
  final bool truncated;
}

/// Encodes a [Profile] into a compact, versioned QR payload string.
///
/// If the full payload exceeds [maxPayloadBytes], data is progressively
/// truncated (allergy reactions → medication details → low-priority
/// contacts → conditions) until it fits. The [QrPayload.truncated] flag
/// indicates when this has occurred.
///
/// Format (newlines added for readability — actual payload is one line):
/// ```text
/// MEDID|v1|N:<name>|DOB:<date>|BT:<blood_type>|SEX:<sex>|
/// HT:<height>|WT:<weight>|
/// ALG:<name/severity/reaction>,<...>|
/// MED:<name/dosage/frequency>,<...>|
/// CON:<name>,<...>|
/// EC:<name/phone/relationship>,<...>|
/// DONOR:<Y|N>|LANG:<lang>|SIG:<hmac16>
/// ```
///
/// Special characters `,`, `/`, and `|` inside text values are
/// percent-encoded to avoid delimiter collisions.
class GenerateQrData {

  GenerateQrData(this._hmac);
  final HmacService _hmac;

  /// Maximum QR payload size in bytes. QR Version 40 with Error Correction
  /// Level L supports 2,953 bytes; we use 2,900 as a safety margin.
  static const maxPayloadBytes = 2900;

  QrPayload call(Profile profile) {
    // Try full payload first.
    var payload = _buildPayload(profile);
    if (_fits(payload)) return QrPayload(payload);

    // Progressive truncation — drop least-critical data first.

    // 1. Drop allergy reactions (keep name + severity).
    payload = _buildPayload(profile, includeReactions: false);
    if (_fits(payload)) return QrPayload(payload, truncated: true);

    // 2. Drop medication dosage/frequency (keep name).
    payload = _buildPayload(
      profile,
      includeReactions: false,
      includeMedDetails: false,
    );
    if (_fits(payload)) return QrPayload(payload, truncated: true);

    // 3. Drop emergency contacts one at a time, lowest priority first.
    final contactCount = profile.emergencyContacts.length;
    for (var max = contactCount - 1; max >= 0; max--) {
      payload = _buildPayload(
        profile,
        includeReactions: false,
        includeMedDetails: false,
        maxContacts: max,
      );
      if (_fits(payload)) return QrPayload(payload, truncated: true);
    }

    // 4. Drop conditions one at a time.
    final conditionCount = profile.conditions.length;
    for (var max = conditionCount - 1; max >= 0; max--) {
      payload = _buildPayload(
        profile,
        includeReactions: false,
        includeMedDetails: false,
        maxContacts: 0,
        maxConditions: max,
      );
      if (_fits(payload)) return QrPayload(payload, truncated: true);
    }

    // Even the minimal payload doesn't fit — return it anyway.
    return QrPayload(payload, truncated: true);
  }

  bool _fits(String payload) => utf8.encode(payload).length <= maxPayloadBytes;

  String _buildPayload(
    Profile profile, {
    bool includeReactions = true,
    bool includeMedDetails = true,
    int? maxContacts,
    int? maxConditions,
  }) {
    final buffer = StringBuffer('MEDID|v1');

    buffer.write('|N:${_enc(profile.name)}');
    buffer.write('|DOB:${_fmtDate(profile.dateOfBirth)}');

    if (profile.bloodType != null) {
      buffer.write('|BT:${_enc(profile.bloodType!.displayName)}');
    }
    if (profile.biologicalSex != null) {
      final sex = switch (profile.biologicalSex!) {
        _ => profile.biologicalSex!.name[0].toUpperCase(), // M / F / O
      };
      buffer.write('|SEX:$sex');
    }
    if (profile.heightCm != null) {
      buffer.write('|HT:${profile.heightCm}');
    }
    if (profile.weightKg != null) {
      buffer.write('|WT:${profile.weightKg}');
    }

    // Allergies: name/severity[/reaction]
    if (profile.allergies.isNotEmpty) {
      final algParts = profile.allergies.map((a) {
        final reaction =
            includeReactions && a.reaction != null ? _enc(a.reaction!) : '';
        return '${_enc(a.name)}/${_enc(a.severity.name)}/$reaction';
      }).join(',');
      buffer.write('|ALG:$algParts');
    }

    // Medications: name[/dosage/frequency]
    if (profile.medications.isNotEmpty) {
      final medParts = profile.medications.map((m) {
        final dosage =
            includeMedDetails && m.dosage != null ? _enc(m.dosage!) : '';
        final freq =
            includeMedDetails && m.frequency != null ? _enc(m.frequency!) : '';
        return '${_enc(m.name)}/$dosage/$freq';
      }).join(',');
      buffer.write('|MED:$medParts');
    }

    // Conditions (limited if truncating)
    var conditions = profile.conditions;
    if (maxConditions != null) {
      conditions = conditions.take(maxConditions).toList();
    }
    if (conditions.isNotEmpty) {
      final conParts = conditions.map((c) => _enc(c.name)).join(',');
      buffer.write('|CON:$conParts');
    }

    // Emergency contacts: ordered by priority, limited if truncating
    var sortedContacts = [...profile.emergencyContacts]
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (maxContacts != null) {
      sortedContacts = sortedContacts.take(maxContacts).toList();
    }
    if (sortedContacts.isNotEmpty) {
      final ecParts = sortedContacts.map((ec) {
        final rel = ec.relationship != null ? _enc(ec.relationship!) : '';
        return '${_enc(ec.name)}/${_enc(ec.phone)}/$rel';
      }).join(',');
      buffer.write('|EC:$ecParts');
    }

    buffer.write('|DONOR:${profile.isOrganDonor ? 'Y' : 'N'}');

    if (profile.primaryLanguage != null) {
      buffer.write('|LANG:${_enc(profile.primaryLanguage!)}');
    }

    // Sign everything up to this point
    final payload = buffer.toString();
    final sig = _hmac.sign(payload);
    return '$payload|SIG:$sig';
  }

  static String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Percent-encodes the three delimiters used in the QR format.
  static String _enc(String value) => value
      .replaceAll('%', '%25')
      .replaceAll('|', '%7C')
      .replaceAll(',', '%2C')
      .replaceAll('/', '%2F');
}
