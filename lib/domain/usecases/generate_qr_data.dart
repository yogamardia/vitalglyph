import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

/// Encodes a [Profile] into a compact, versioned QR payload string.
///
/// Format (newlines added for readability — actual payload is one line):
/// ```
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
  final HmacService _hmac;

  GenerateQrData(this._hmac);

  String call(Profile profile) {
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

    // Allergies: name/severity/reaction
    if (profile.allergies.isNotEmpty) {
      final algParts = profile.allergies.map((a) {
        final reaction = a.reaction != null ? _enc(a.reaction!) : '';
        return '${_enc(a.name)}/${_enc(a.severity.name)}/$reaction';
      }).join(',');
      buffer.write('|ALG:$algParts');
    }

    // Medications: name/dosage/frequency
    if (profile.medications.isNotEmpty) {
      final medParts = profile.medications.map((m) {
        final dosage = m.dosage != null ? _enc(m.dosage!) : '';
        final freq = m.frequency != null ? _enc(m.frequency!) : '';
        return '${_enc(m.name)}/$dosage/$freq';
      }).join(',');
      buffer.write('|MED:$medParts');
    }

    // Conditions: name only
    if (profile.conditions.isNotEmpty) {
      final conParts =
          profile.conditions.map((c) => _enc(c.name)).join(',');
      buffer.write('|CON:$conParts');
    }

    // Emergency contacts: name/phone/relationship (ordered by priority)
    final sortedContacts = [...profile.emergencyContacts]
      ..sort((a, b) => a.priority.compareTo(b.priority));
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
