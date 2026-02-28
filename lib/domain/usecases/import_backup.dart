import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/backup_crypto_service.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

/// Result of a successful import operation.
class ImportResult extends Equatable {
  final int imported;
  final int skipped;

  const ImportResult({required this.imported, required this.skipped});

  @override
  List<Object?> get props => [imported, skipped];
}

/// Decrypts a `.medid` backup file and merges its profiles into the database.
///
/// Merge strategy: profiles whose ID already exists in the database are
/// skipped; all others are created as new profiles.
class ImportBackup {
  final ProfileRepository _repository;
  final BackupCryptoService _crypto;

  ImportBackup(this._repository, this._crypto);

  Future<Either<Failure, ImportResult>> call(
    String filePath,
    String passphrase,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const Left(BackupFailure('Backup file not found.'));
      }

      final payload = await file.readAsString();
      final json = _crypto.decryptJson(payload, passphrase);
      final map = jsonDecode(json) as Map<String, dynamic>;
      final profilesList = (map['profiles'] as List<dynamic>?) ?? [];

      int imported = 0;
      int skipped = 0;

      for (final raw in profilesList) {
        final profile = _profileFromJson(raw as Map<String, dynamic>);

        // Check if this profile ID already exists in the database.
        final existing = await _repository.getProfile(profile.id);
        if (existing.isRight()) {
          skipped++;
          continue;
        }

        final createResult = await _repository.createProfile(profile);
        createResult.fold(
          (_) {/* silent: individual failure doesn't abort the whole import */},
          (_) => imported++,
        );
      }

      return Right(ImportResult(imported: imported, skipped: skipped));
    } on BackupFormatException catch (e) {
      return Left(BackupFailure(e.toString()));
    } on BackupWrongPassphraseException {
      return const Left(BackupFailure('Wrong passphrase or corrupted file.'));
    } catch (e) {
      return Left(BackupFailure('Import failed: $e'));
    }
  }

  // ── Deserialization ───────────────────────────────────────────────────────

  Profile _profileFromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      bloodType: json['blood_type'] != null
          ? BloodType.fromString(json['blood_type'] as String)
          : null,
      biologicalSex: json['biological_sex'] != null
          ? BiologicalSex.fromString(json['biological_sex'] as String)
          : null,
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      isOrganDonor: json['is_organ_donor'] as bool? ?? false,
      medicalNotes: json['medical_notes'] as String?,
      primaryLanguage: json['primary_language'] as String?,
      allergies: _parseAllergies(json['allergies']),
      medications: _parseMedications(json['medications']),
      conditions: _parseConditions(json['conditions']),
      emergencyContacts: _parseContacts(json['emergency_contacts']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  List<Allergy> _parseAllergies(dynamic raw) {
    if (raw == null) return [];
    return (raw as List<dynamic>).map((a) {
      final m = a as Map<String, dynamic>;
      return Allergy(
        id: m['id'] as String,
        name: m['name'] as String,
        severity: AllergySeverity.fromString(m['severity'] as String) ??
            AllergySeverity.mild,
        reaction: m['reaction'] as String?,
      );
    }).toList();
  }

  List<Medication> _parseMedications(dynamic raw) {
    if (raw == null) return [];
    return (raw as List<dynamic>).map((m) {
      final mm = m as Map<String, dynamic>;
      return Medication(
        id: mm['id'] as String,
        name: mm['name'] as String,
        dosage: mm['dosage'] as String?,
        frequency: mm['frequency'] as String?,
        prescribedFor: mm['prescribed_for'] as String?,
      );
    }).toList();
  }

  List<MedicalCondition> _parseConditions(dynamic raw) {
    if (raw == null) return [];
    return (raw as List<dynamic>).map((c) {
      final cm = c as Map<String, dynamic>;
      return MedicalCondition(
        id: cm['id'] as String,
        name: cm['name'] as String,
        diagnosedDate: cm['diagnosed_date'] as String?,
        notes: cm['notes'] as String?,
      );
    }).toList();
  }

  List<EmergencyContact> _parseContacts(dynamic raw) {
    if (raw == null) return [];
    return (raw as List<dynamic>).map((ec) {
      final em = ec as Map<String, dynamic>;
      return EmergencyContact(
        id: em['id'] as String,
        name: em['name'] as String,
        phone: em['phone'] as String,
        relationship: em['relationship'] as String?,
        priority: em['priority'] as int? ?? 1,
      );
    }).toList();
  }
}
