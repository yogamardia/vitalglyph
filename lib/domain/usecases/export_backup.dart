import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vitalglyph/core/crypto/backup_crypto_service.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

/// Serializes all profiles to JSON, encrypts with PBKDF2+AES-256-CBC,
/// writes to a temp `.medid` file, and returns the file path for sharing.
class ExportBackup {
  final ProfileRepository _repository;
  final BackupCryptoService _crypto;

  ExportBackup(this._repository, this._crypto);

  Future<Either<Failure, String>> call(String passphrase) async {
    try {
      final streamResult = await _repository.watchAllProfiles().first;

      Failure? failure;
      List<Profile>? profiles;
      streamResult.fold(
        (f) => failure = f,
        (p) => profiles = p,
      );
      if (failure != null) return Left(failure!);

      final json = _buildJson(profiles!);
      final encrypted = _crypto.encryptJson(json, passphrase);

      final dir = await getTemporaryDirectory();
      final now = DateTime.now().toUtc();
      final ts = '${now.year}'
          '${now.month.toString().padLeft(2, '0')}'
          '${now.day.toString().padLeft(2, '0')}'
          '_${now.hour.toString().padLeft(2, '0')}'
          '${now.minute.toString().padLeft(2, '0')}';
      final file = File('${dir.path}/medid_backup_$ts.medid');
      await file.writeAsString(encrypted);

      return Right(file.path);
    } catch (e) {
      return Left(BackupFailure('Export failed: $e'));
    }
  }

  // ── Serialization ─────────────────────────────────────────────────────────

  String _buildJson(List<Profile> profiles) {
    final map = <String, dynamic>{
      'medid_version': 1,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'profiles': profiles.map(_profileToJson).toList(),
    };
    return jsonEncode(map);
  }

  Map<String, dynamic> _profileToJson(Profile p) => {
        'id': p.id,
        'name': p.name,
        'date_of_birth': p.dateOfBirth.toIso8601String(),
        'blood_type': p.bloodType?.name,
        'biological_sex': p.biologicalSex?.name,
        'height_cm': p.heightCm,
        'weight_kg': p.weightKg,
        'is_organ_donor': p.isOrganDonor,
        'medical_notes': p.medicalNotes,
        'primary_language': p.primaryLanguage,
        'created_at': p.createdAt.toIso8601String(),
        'updated_at': p.updatedAt.toIso8601String(),
        'allergies': p.allergies.map(_allergyToJson).toList(),
        'medications': p.medications.map(_medicationToJson).toList(),
        'conditions': p.conditions.map(_conditionToJson).toList(),
        'emergency_contacts':
            p.emergencyContacts.map(_contactToJson).toList(),
      };

  Map<String, dynamic> _allergyToJson(Allergy a) => {
        'id': a.id,
        'name': a.name,
        'severity': a.severity.name,
        'reaction': a.reaction,
      };

  Map<String, dynamic> _medicationToJson(Medication m) => {
        'id': m.id,
        'name': m.name,
        'dosage': m.dosage,
        'frequency': m.frequency,
        'prescribed_for': m.prescribedFor,
      };

  Map<String, dynamic> _conditionToJson(MedicalCondition c) => {
        'id': c.id,
        'name': c.name,
        'diagnosed_date': c.diagnosedDate,
        'notes': c.notes,
      };

  Map<String, dynamic> _contactToJson(EmergencyContact ec) => {
        'id': ec.id,
        'name': ec.name,
        'phone': ec.phone,
        'relationship': ec.relationship,
        'priority': ec.priority,
      };
}
