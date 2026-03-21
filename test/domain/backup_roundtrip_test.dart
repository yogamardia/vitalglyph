import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/backup_crypto_service.dart';
import 'package:vitalglyph/data/datasources/local_database.dart';
import 'package:vitalglyph/data/repositories/profile_repository_impl.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/import_backup.dart';

/// Integration-style test that exercises the full backup→restore flow:
///   real crypto + real in-memory DB + real file I/O.
///
/// ExportBackup is bypassed (it needs path_provider) — instead we manually
/// serialize + encrypt, write to a temp file, then ImportBackup reads it back.
void main() {
  late BackupCryptoService crypto;
  late Directory tmpDir;

  final now = DateTime(2025, 6, 15, 10, 30);

  Profile buildProfile({
    String id = 'p1',
    String name = 'Alice Smith',
  }) =>
      Profile(
        id: id,
        name: name,
        dateOfBirth: DateTime(1990, 3, 25),
        bloodType: BloodType.aPos,
        biologicalSex: BiologicalSex.female,
        heightCm: 165.5,
        weightKg: 60.2,
        isOrganDonor: true,
        medicalNotes: 'Carries EpiPen',
        primaryLanguage: 'en',
        createdAt: now,
        updatedAt: now,
        allergies: [
          Allergy(
            id: '${id}_a1',
            name: 'Peanuts',
            severity: AllergySeverity.severe,
            reaction: 'Anaphylaxis',
          ),
          Allergy(
            id: '${id}_a2',
            name: 'Penicillin',
            severity: AllergySeverity.moderate,
          ),
        ],
        medications: [
          Medication(
            id: '${id}_m1',
            name: 'Ibuprofen',
            dosage: '200mg',
            frequency: 'twice daily',
            prescribedFor: 'Pain',
          ),
        ],
        conditions: [
          MedicalCondition(
            id: '${id}_c1',
            name: 'Asthma',
            diagnosedDate: '2015-01-01',
            notes: 'Mild intermittent',
          ),
        ],
        emergencyContacts: [
          EmergencyContact(
            id: '${id}_ec1',
            name: 'Bob Smith',
            phone: '555-0100',
            relationship: 'Spouse',
          ),
        ],
      );

  /// Serialize profiles the same way ExportBackup does.
  String serializeProfiles(List<Profile> profiles) {
    return jsonEncode({
      'medid_version': 1,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'profiles': profiles.map((p) => {
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
        'allergies': p.allergies.map((a) => {
          'id': a.id,
          'name': a.name,
          'severity': a.severity.name,
          'reaction': a.reaction,
        }).toList(),
        'medications': p.medications.map((m) => {
          'id': m.id,
          'name': m.name,
          'dosage': m.dosage,
          'frequency': m.frequency,
          'prescribed_for': m.prescribedFor,
        }).toList(),
        'conditions': p.conditions.map((c) => {
          'id': c.id,
          'name': c.name,
          'diagnosed_date': c.diagnosedDate,
          'notes': c.notes,
        }).toList(),
        'emergency_contacts': p.emergencyContacts.map((ec) => {
          'id': ec.id,
          'name': ec.name,
          'phone': ec.phone,
          'relationship': ec.relationship,
          'priority': ec.priority,
        }).toList(),
      }).toList(),
    });
  }

  setUp(() {
    crypto = BackupCryptoService();
    tmpDir = Directory.systemTemp.createTempSync('backup_roundtrip_test_');
  });

  tearDown(() {
    if (tmpDir.existsSync()) {
      tmpDir.deleteSync(recursive: true);
    }
  });

  test('encrypt → write → import roundtrip preserves profile data', () async {
    final original = buildProfile();
    const passphrase = 'test-passphrase-42!';

    // 1. Serialize and encrypt (simulates ExportBackup).
    final json = serializeProfiles([original]);
    final encrypted = crypto.encryptJson(json, passphrase);

    // 2. Write to temp .medid file.
    final backupFile = File('${tmpDir.path}/roundtrip.medid');
    backupFile.writeAsStringSync(encrypted);

    // 3. Import into a fresh in-memory database.
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = ProfileRepositoryImpl(db.profileDao);
    final importBackup = ImportBackup(repo, crypto);

    final result = await importBackup(backupFile.path, passphrase);

    result.match(
      (f) => fail('Import failed: ${f.message}'),
      (importResult) {
        expect(importResult.imported, 1);
        expect(importResult.skipped, 0);
      },
    );

    // 4. Verify the imported profile matches the original.
    final getResult = await repo.getProfile('p1');
    getResult.match(
      (f) => fail('getProfile failed: ${f.message}'),
      (imported) {
        expect(imported.name, original.name);
        expect(imported.dateOfBirth, original.dateOfBirth);
        expect(imported.bloodType, original.bloodType);
        expect(imported.biologicalSex, original.biologicalSex);
        expect(imported.heightCm, original.heightCm);
        expect(imported.weightKg, original.weightKg);
        expect(imported.isOrganDonor, original.isOrganDonor);
        expect(imported.medicalNotes, original.medicalNotes);
        expect(imported.primaryLanguage, original.primaryLanguage);

        // Children
        expect(imported.allergies, hasLength(2));
        expect(imported.allergies[0].name, 'Peanuts');
        expect(imported.allergies[0].severity, AllergySeverity.severe);
        expect(imported.allergies[0].reaction, 'Anaphylaxis');
        expect(imported.allergies[1].name, 'Penicillin');

        expect(imported.medications, hasLength(1));
        expect(imported.medications[0].name, 'Ibuprofen');
        expect(imported.medications[0].dosage, '200mg');

        expect(imported.conditions, hasLength(1));
        expect(imported.conditions[0].name, 'Asthma');
        expect(imported.conditions[0].diagnosedDate, '2015-01-01');

        expect(imported.emergencyContacts, hasLength(1));
        expect(imported.emergencyContacts[0].name, 'Bob Smith');
        expect(imported.emergencyContacts[0].phone, '555-0100');
        expect(imported.emergencyContacts[0].relationship, 'Spouse');
      },
    );

    await db.close();
  });

  test('import skips profiles that already exist in DB', () async {
    final profile1 = buildProfile(id: 'existing', name: 'Existing');
    final profile2 = buildProfile(id: 'new-one', name: 'New');
    const passphrase = 'secret';

    // Set up DB with one pre-existing profile.
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = ProfileRepositoryImpl(db.profileDao);
    await repo.createProfile(profile1);

    // Build backup containing both profiles.
    final json = serializeProfiles([profile1, profile2]);
    final encrypted = crypto.encryptJson(json, passphrase);
    final backupFile = File('${tmpDir.path}/skip_test.medid');
    backupFile.writeAsStringSync(encrypted);

    final importBackup = ImportBackup(repo, crypto);
    final result = await importBackup(backupFile.path, passphrase);

    result.match(
      (f) => fail('Import failed: ${f.message}'),
      (importResult) {
        expect(importResult.imported, 1);
        expect(importResult.skipped, 1);
      },
    );

    // Verify both profiles exist.
    final all = await repo.watchAllProfiles().first;
    all.match(
      (f) => fail('watchAll failed'),
      (profiles) => expect(profiles, hasLength(2)),
    );

    await db.close();
  });

  test('wrong passphrase returns failure', () async {
    const passphrase = 'correct';
    final json = serializeProfiles([buildProfile()]);
    final encrypted = crypto.encryptJson(json, passphrase);

    final backupFile = File('${tmpDir.path}/wrong_pass.medid');
    backupFile.writeAsStringSync(encrypted);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = ProfileRepositoryImpl(db.profileDao);
    final importBackup = ImportBackup(repo, crypto);

    final result = await importBackup(backupFile.path, 'wrong');

    expect(result.isLeft(), true);
    result.match(
      (f) => expect(f.message, contains('Wrong passphrase')),
      (_) => fail('Expected Left'),
    );

    await db.close();
  });

  test('multiple profiles roundtrip', () async {
    final profiles = List.generate(
      5,
      (i) => buildProfile(id: 'p$i', name: 'User $i'),
    );
    const passphrase = 'multi-test';

    final json = serializeProfiles(profiles);
    final encrypted = crypto.encryptJson(json, passphrase);
    final backupFile = File('${tmpDir.path}/multi.medid');
    backupFile.writeAsStringSync(encrypted);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = ProfileRepositoryImpl(db.profileDao);
    final importBackup = ImportBackup(repo, crypto);

    final result = await importBackup(backupFile.path, passphrase);

    result.match(
      (f) => fail('Import failed: ${f.message}'),
      (importResult) {
        expect(importResult.imported, 5);
        expect(importResult.skipped, 0);
      },
    );

    final all = await repo.watchAllProfiles().first;
    all.match(
      (f) => fail('watchAll failed'),
      (list) => expect(list, hasLength(5)),
    );

    await db.close();
  });
}
