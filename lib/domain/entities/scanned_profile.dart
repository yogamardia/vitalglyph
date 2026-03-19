import 'package:equatable/equatable.dart';

class ScannedAllergy extends Equatable {
  final String name;
  final String severity;
  final String? reaction;

  const ScannedAllergy({
    required this.name,
    required this.severity,
    this.reaction,
  });

  @override
  List<Object?> get props => [name, severity, reaction];
}

class ScannedContact extends Equatable {
  final String name;
  final String phone;
  final String? relationship;

  const ScannedContact({
    required this.name,
    required this.phone,
    this.relationship,
  });

  @override
  List<Object?> get props => [name, phone, relationship];
}

/// Read-only view of a profile parsed from a QR code.
/// Intentionally separate from [Profile] — it has no database ID
/// and is only displayed, never persisted.
class ScannedProfile extends Equatable {
  final String name;
  final String? dateOfBirth;
  final String? bloodType;
  final String? biologicalSex;
  final double? heightCm;
  final double? weightKg;
  final List<ScannedAllergy> allergies;
  final List<String> medications;
  final List<String> conditions;
  final List<ScannedContact> emergencyContacts;
  final bool isOrganDonor;
  final String? language;
  /// Whether the HMAC format-integrity check passed. A `false` value means
  /// the QR data may be corrupted or generated outside VitalGlyph — it does
  /// NOT imply cryptographic tamper-proofing (the key is public).
  final bool signatureValid;

  const ScannedProfile({
    required this.name,
    this.dateOfBirth,
    this.bloodType,
    this.biologicalSex,
    this.heightCm,
    this.weightKg,
    this.allergies = const [],
    this.medications = const [],
    this.conditions = const [],
    this.emergencyContacts = const [],
    this.isOrganDonor = false,
    this.language,
    required this.signatureValid,
  });

  @override
  List<Object?> get props => [
        name,
        dateOfBirth,
        bloodType,
        biologicalSex,
        heightCm,
        weightKg,
        allergies,
        medications,
        conditions,
        emergencyContacts,
        isOrganDonor,
        language,
        signatureValid,
      ];
}
