import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/backup_crypto_service.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';
import 'package:vitalglyph/domain/usecases/import_backup.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockBackupCryptoService extends Mock implements BackupCryptoService {}

void main() {
  late MockProfileRepository mockRepo;
  late MockBackupCryptoService mockCrypto;
  late ImportBackup useCase;
  late Directory tmpDir;

  final now = DateTime(2025, 6, 15);

  final testProfile = Profile(
    id: 'p1',
    name: 'Alice',
    dateOfBirth: DateTime(1990, 3, 25),
    bloodType: BloodType.aPos,
    createdAt: now,
    updatedAt: now,
    allergies: const [
      Allergy(id: 'a1', name: 'Peanuts', severity: AllergySeverity.severe),
    ],
    medications: const [
      Medication(id: 'm1', name: 'Ibuprofen'),
    ],
    conditions: const [
      MedicalCondition(id: 'c1', name: 'Asthma'),
    ],
    emergencyContacts: const [
      EmergencyContact(id: 'ec1', name: 'Bob', phone: '555-0100'),
    ],
  );

  String buildBackupJson(List<Map<String, dynamic>> profiles) {
    return jsonEncode({
      'medid_version': 1,
      'exported_at': now.toIso8601String(),
      'profiles': profiles,
    });
  }

  Map<String, dynamic> profileToJson(Profile p) => {
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
        'allergies': p.allergies
            .map((a) => {
                  'id': a.id,
                  'name': a.name,
                  'severity': a.severity.name,
                  'reaction': a.reaction,
                })
            .toList(),
        'medications': p.medications
            .map((m) => {
                  'id': m.id,
                  'name': m.name,
                  'dosage': m.dosage,
                  'frequency': m.frequency,
                  'prescribed_for': m.prescribedFor,
                })
            .toList(),
        'conditions': p.conditions
            .map((c) => {
                  'id': c.id,
                  'name': c.name,
                  'diagnosed_date': c.diagnosedDate,
                  'notes': c.notes,
                })
            .toList(),
        'emergency_contacts': p.emergencyContacts
            .map((ec) => {
                  'id': ec.id,
                  'name': ec.name,
                  'phone': ec.phone,
                  'relationship': ec.relationship,
                  'priority': ec.priority,
                })
            .toList(),
      };

  File writeBackupFile(String content) {
    final file = File('${tmpDir.path}/test.medid');
    file.writeAsStringSync(content);
    return file;
  }

  setUpAll(() {
    registerFallbackValue(testProfile);
  });

  setUp(() {
    mockRepo = MockProfileRepository();
    mockCrypto = MockBackupCryptoService();
    useCase = ImportBackup(mockRepo, mockCrypto);
    tmpDir = Directory.systemTemp.createTempSync('import_backup_test_');
  });

  tearDown(() {
    if (tmpDir.existsSync()) {
      tmpDir.deleteSync(recursive: true);
    }
  });

  group('successful import', () {
    test('imports new profiles and returns count', () async {
      final json = buildBackupJson([profileToJson(testProfile)]);
      final file = writeBackupFile('encrypted_content');

      when(() => mockCrypto.decryptJson('encrypted_content', 'pass'))
          .thenReturn(json);
      when(() => mockRepo.getProfile('p1')).thenAnswer(
        (_) async => const Left(NotFoundFailure()),
      );
      when(() => mockRepo.createProfile(any())).thenAnswer(
        (_) async => const Right('p1'),
      );

      final result = await useCase(file.path, 'pass');

      result.fold(
        (f) => fail('Expected Right, got Left: ${f.message}'),
        (importResult) {
          expect(importResult.imported, 1);
          expect(importResult.skipped, 0);
        },
      );
    });

    test('skips profiles whose ID already exists', () async {
      final json = buildBackupJson([profileToJson(testProfile)]);
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'pass'))
          .thenReturn(json);
      when(() => mockRepo.getProfile('p1')).thenAnswer(
        (_) async => Right(testProfile),
      );

      final result = await useCase(file.path, 'pass');

      result.fold(
        (f) => fail('Expected Right'),
        (importResult) {
          expect(importResult.imported, 0);
          expect(importResult.skipped, 1);
        },
      );
      verifyNever(() => mockRepo.createProfile(any()));
    });

    test('handles mix of new and existing profiles', () async {
      final profile2 = testProfile.copyWith(id: 'p2', name: 'Bob');
      final json = buildBackupJson([
        profileToJson(testProfile),
        profileToJson(profile2),
      ]);
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'pass'))
          .thenReturn(json);
      when(() => mockRepo.getProfile('p1')).thenAnswer(
        (_) async => Right(testProfile),
      );
      when(() => mockRepo.getProfile('p2')).thenAnswer(
        (_) async => const Left(NotFoundFailure()),
      );
      when(() => mockRepo.createProfile(any())).thenAnswer(
        (_) async => const Right('p2'),
      );

      final result = await useCase(file.path, 'pass');

      result.fold(
        (f) => fail('Expected Right'),
        (importResult) {
          expect(importResult.imported, 1);
          expect(importResult.skipped, 1);
        },
      );
    });

    test('continues import when individual create fails', () async {
      final profile2 = testProfile.copyWith(id: 'p2', name: 'Bob');
      final json = buildBackupJson([
        profileToJson(testProfile),
        profileToJson(profile2),
      ]);
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'pass'))
          .thenReturn(json);
      when(() => mockRepo.getProfile(any())).thenAnswer(
        (_) async => const Left(NotFoundFailure()),
      );
      // First create fails, second succeeds.
      var callCount = 0;
      when(() => mockRepo.createProfile(any())).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) {
          return const Left(DatabaseFailure('insert failed'));
        }
        return const Right('p2');
      });

      final result = await useCase(file.path, 'pass');

      result.fold(
        (f) => fail('Expected Right'),
        (importResult) {
          // First failed silently (not counted), second succeeded.
          expect(importResult.imported, 1);
          expect(importResult.skipped, 0);
        },
      );
    });

    test('handles empty profiles list', () async {
      final json = buildBackupJson([]);
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'pass'))
          .thenReturn(json);

      final result = await useCase(file.path, 'pass');

      result.fold(
        (f) => fail('Expected Right'),
        (importResult) {
          expect(importResult.imported, 0);
          expect(importResult.skipped, 0);
        },
      );
    });

    test('handles JSON with null/missing lists gracefully', () async {
      final json = jsonEncode({
        'medid_version': 1,
        'exported_at': now.toIso8601String(),
        'profiles': [
          {
            'id': 'p-null',
            'name': 'Null Lists',
            'date_of_birth': '1990-01-01T00:00:00.000',
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
            // allergies, medications, conditions, contacts all missing
          },
        ],
      });
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'pass'))
          .thenReturn(json);
      when(() => mockRepo.getProfile('p-null')).thenAnswer(
        (_) async => const Left(NotFoundFailure()),
      );
      when(() => mockRepo.createProfile(any())).thenAnswer(
        (_) async => const Right('p-null'),
      );

      final result = await useCase(file.path, 'pass');

      result.fold(
        (f) => fail('Expected Right, got: ${f.message}'),
        (importResult) => expect(importResult.imported, 1),
      );
    });
  });

  group('error handling', () {
    test('returns BackupFailure when file does not exist', () async {
      final result = await useCase('/nonexistent/file.medid', 'pass');

      result.fold(
        (failure) {
          expect(failure, isA<BackupFailure>());
          expect(failure.message, 'Backup file not found.');
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns BackupFailure on wrong passphrase', () async {
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'wrong'))
          .thenThrow(BackupWrongPassphraseException());

      final result = await useCase(file.path, 'wrong');

      result.fold(
        (failure) {
          expect(failure, isA<BackupFailure>());
          expect(failure.message, contains('Wrong passphrase'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns BackupFailure on invalid format', () async {
      final file = writeBackupFile('not a backup');

      when(() => mockCrypto.decryptJson('not a backup', 'pass'))
          .thenThrow(const BackupFormatException('Invalid format'));

      final result = await useCase(file.path, 'pass');

      result.fold(
        (failure) {
          expect(failure, isA<BackupFailure>());
          expect(failure.message, contains('Invalid format'));
        },
        (_) => fail('Expected Left'),
      );
    });

    test('returns BackupFailure on unexpected error', () async {
      final file = writeBackupFile('encrypted');

      when(() => mockCrypto.decryptJson('encrypted', 'pass'))
          .thenThrow(Exception('unexpected'));

      final result = await useCase(file.path, 'pass');

      result.fold(
        (failure) => expect(failure, isA<BackupFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('ImportResult', () {
    test('equality', () {
      const a = ImportResult(imported: 3, skipped: 1);
      const b = ImportResult(imported: 3, skipped: 1);
      const c = ImportResult(imported: 2, skipped: 1);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });

    test('props', () {
      const result = ImportResult(imported: 5, skipped: 2);
      expect(result.props, [5, 2]);
    });
  });
}
