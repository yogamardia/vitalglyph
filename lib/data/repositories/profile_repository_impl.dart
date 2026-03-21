import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/data/datasources/local_database.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {

  ProfileRepositoryImpl(this._dao);
  final ProfileDao _dao;

  @override
  Stream<Either<Failure, List<Profile>>> watchAllProfiles() {
    return _dao.watchAllProfiles().asyncMap((rows) async {
      try {
        final profileList = await Future.wait(rows.map(_hydrateProfile));
        return Right<Failure, List<Profile>>(profileList);
      } catch (e) {
        return Left<Failure, List<Profile>>(DatabaseFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    try {
      final row = await _dao.getProfile(id);
      if (row == null) return const Left(NotFoundFailure());
      return Right(await _hydrateProfile(row));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createProfile(Profile profile) async {
    try {
      await _dao.transaction(() async {
        await _dao.insertProfile(_toProfileCompanion(profile));
        await _insertRelated(profile);
      });
      return Right(profile.id);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      await _dao.transaction(() async {
        await _dao.updateProfile(_toProfileCompanion(profile));
        await _dao.deleteAllergiesForProfile(profile.id);
        await _dao.deleteMedicationsForProfile(profile.id);
        await _dao.deleteConditionsForProfile(profile.id);
        await _dao.deleteContactsForProfile(profile.id);
        await _insertRelated(profile);
      });
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String id) async {
    try {
      await _dao.deleteProfile(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  Future<void> _insertRelated(Profile profile) async {
    for (final a in profile.allergies) {
      await _dao.insertAllergy(AllergiesCompanion(
        id: Value(a.id),
        profileId: Value(profile.id),
        name: Value(a.name),
        severity: Value(a.severity.name),
        reaction: Value(a.reaction),
      ));
    }
    for (final m in profile.medications) {
      await _dao.insertMedication(MedicationsCompanion(
        id: Value(m.id),
        profileId: Value(profile.id),
        name: Value(m.name),
        dosage: Value(m.dosage),
        frequency: Value(m.frequency),
        prescribedFor: Value(m.prescribedFor),
      ));
    }
    for (final c in profile.conditions) {
      await _dao.insertCondition(MedicalConditionsCompanion(
        id: Value(c.id),
        profileId: Value(profile.id),
        name: Value(c.name),
        diagnosedDate: Value(c.diagnosedDate),
        notes: Value(c.notes),
      ));
    }
    for (final ec in profile.emergencyContacts) {
      await _dao.insertContact(EmergencyContactsCompanion(
        id: Value(ec.id),
        profileId: Value(profile.id),
        name: Value(ec.name),
        phone: Value(ec.phone),
        relationship: Value(ec.relationship),
        priority: Value(ec.priority),
      ));
    }
  }

  Future<Profile> _hydrateProfile(ProfileRecord row) async {
    final allergyRows = await _dao.getAllergiesForProfile(row.id);
    final medicationRows = await _dao.getMedicationsForProfile(row.id);
    final conditionRows = await _dao.getConditionsForProfile(row.id);
    final contactRows = await _dao.getContactsForProfile(row.id);

    return Profile(
      id: row.id,
      name: row.name,
      dateOfBirth: row.dateOfBirth,
      bloodType:
          row.bloodType != null ? BloodType.fromString(row.bloodType!) : null,
      biologicalSex: row.biologicalSex != null
          ? BiologicalSex.fromString(row.biologicalSex!)
          : null,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      isOrganDonor: row.isOrganDonor,
      medicalNotes: row.medicalNotes,
      primaryLanguage: row.primaryLanguage,
      photoPath: row.photoPath,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      allergies: allergyRows.map(_toAllergyEntity).toList(),
      medications: medicationRows.map(_toMedicationEntity).toList(),
      conditions: conditionRows.map(_toConditionEntity).toList(),
      emergencyContacts: contactRows.map(_toContactEntity).toList(),
    );
  }

  ProfilesCompanion _toProfileCompanion(Profile p) => ProfilesCompanion(
        id: Value(p.id),
        name: Value(p.name),
        dateOfBirth: Value(p.dateOfBirth),
        bloodType: Value(p.bloodType?.name),
        biologicalSex: Value(p.biologicalSex?.name),
        heightCm: Value(p.heightCm),
        weightKg: Value(p.weightKg),
        isOrganDonor: Value(p.isOrganDonor),
        medicalNotes: Value(p.medicalNotes),
        primaryLanguage: Value(p.primaryLanguage),
        photoPath: Value(p.photoPath),
        createdAt: Value(p.createdAt),
        updatedAt: Value(p.updatedAt),
      );

  Allergy _toAllergyEntity(AllergyRecord r) => Allergy(
        id: r.id,
        name: r.name,
        severity:
            AllergySeverity.fromString(r.severity) ?? AllergySeverity.mild,
        reaction: r.reaction,
      );

  Medication _toMedicationEntity(MedicationRecord r) => Medication(
        id: r.id,
        name: r.name,
        dosage: r.dosage,
        frequency: r.frequency,
        prescribedFor: r.prescribedFor,
      );

  MedicalCondition _toConditionEntity(MedicalConditionRecord r) =>
      MedicalCondition(
        id: r.id,
        name: r.name,
        diagnosedDate: r.diagnosedDate,
        notes: r.notes,
      );

  EmergencyContact _toContactEntity(EmergencyContactRecord r) =>
      EmergencyContact(
        id: r.id,
        name: r.name,
        phone: r.phone,
        relationship: r.relationship,
        priority: r.priority,
      );
}
