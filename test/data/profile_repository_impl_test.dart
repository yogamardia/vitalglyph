import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/data/datasources/local_database.dart';
import 'package:vitalglyph/data/repositories/profile_repository_impl.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

void main() {
  late AppDatabase db;
  late ProfileRepositoryImpl repo;

  final now = DateTime(2025, 6, 15, 10, 30);

  Profile fullProfile({String id = 'p1'}) => Profile(
        id: id,
        name: 'Alice Smith',
        dateOfBirth: DateTime(1990, 3, 25),
        bloodType: BloodType.aPos,
        biologicalSex: BiologicalSex.female,
        heightCm: 165.5,
        weightKg: 60.2,
        isOrganDonor: true,
        medicalNotes: 'No known issues',
        primaryLanguage: 'en',
        createdAt: now,
        updatedAt: now,
        allergies: const [
          Allergy(
            id: 'a1',
            name: 'Peanuts',
            severity: AllergySeverity.severe,
            reaction: 'Anaphylaxis',
          ),
          Allergy(
            id: 'a2',
            name: 'Penicillin',
            severity: AllergySeverity.moderate,
          ),
        ],
        medications: const [
          Medication(
            id: 'm1',
            name: 'Ibuprofen',
            dosage: '200mg',
            frequency: 'twice daily',
            prescribedFor: 'Pain',
          ),
        ],
        conditions: const [
          MedicalCondition(
            id: 'c1',
            name: 'Asthma',
            diagnosedDate: '2015-01-01',
            notes: 'Mild intermittent',
          ),
        ],
        emergencyContacts: const [
          EmergencyContact(
            id: 'ec1',
            name: 'Bob Smith',
            phone: '555-0100',
            relationship: 'Spouse',
          ),
        ],
      );

  Profile minimalProfile({String id = 'p-min'}) => Profile(
        id: id,
        name: 'Minimal User',
        dateOfBirth: DateTime(2000, 1, 1),
        createdAt: now,
        updatedAt: now,
      );

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ProfileRepositoryImpl(db.profileDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('createProfile', () {
    test('returns Right with profile id on success', () async {
      final result = await repo.createProfile(fullProfile());

      expect(result, const Right<Failure, String>('p1'));
    });

    test('stores profile with all fields', () async {
      await repo.createProfile(fullProfile());
      final result = await repo.getProfile('p1');

      result.fold(
        (f) => fail('Expected Right, got Left: $f'),
        (profile) {
          expect(profile.name, 'Alice Smith');
          expect(profile.bloodType, BloodType.aPos);
          expect(profile.biologicalSex, BiologicalSex.female);
          expect(profile.heightCm, 165.5);
          expect(profile.weightKg, 60.2);
          expect(profile.isOrganDonor, true);
          expect(profile.medicalNotes, 'No known issues');
          expect(profile.primaryLanguage, 'en');
        },
      );
    });

    test('stores child records (allergies, meds, conditions, contacts)', () async {
      await repo.createProfile(fullProfile());
      final result = await repo.getProfile('p1');

      result.fold(
        (f) => fail('Expected Right, got Left: $f'),
        (profile) {
          expect(profile.allergies, hasLength(2));
          expect(profile.allergies[0].name, 'Peanuts');
          expect(profile.allergies[0].severity, AllergySeverity.severe);
          expect(profile.allergies[0].reaction, 'Anaphylaxis');
          expect(profile.allergies[1].name, 'Penicillin');
          expect(profile.allergies[1].severity, AllergySeverity.moderate);

          expect(profile.medications, hasLength(1));
          expect(profile.medications[0].name, 'Ibuprofen');
          expect(profile.medications[0].dosage, '200mg');
          expect(profile.medications[0].frequency, 'twice daily');

          expect(profile.conditions, hasLength(1));
          expect(profile.conditions[0].name, 'Asthma');
          expect(profile.conditions[0].diagnosedDate, '2015-01-01');

          expect(profile.emergencyContacts, hasLength(1));
          expect(profile.emergencyContacts[0].name, 'Bob Smith');
          expect(profile.emergencyContacts[0].phone, '555-0100');
          expect(profile.emergencyContacts[0].relationship, 'Spouse');
          expect(profile.emergencyContacts[0].priority, 1);
        },
      );
    });

    test('stores minimal profile with no children', () async {
      await repo.createProfile(minimalProfile());
      final result = await repo.getProfile('p-min');

      result.fold(
        (f) => fail('Expected Right, got Left: $f'),
        (profile) {
          expect(profile.name, 'Minimal User');
          expect(profile.bloodType, isNull);
          expect(profile.biologicalSex, isNull);
          expect(profile.heightCm, isNull);
          expect(profile.weightKg, isNull);
          expect(profile.isOrganDonor, false);
          expect(profile.allergies, isEmpty);
          expect(profile.medications, isEmpty);
          expect(profile.conditions, isEmpty);
          expect(profile.emergencyContacts, isEmpty);
        },
      );
    });
  });

  group('getProfile', () {
    test('returns NotFoundFailure for non-existent id', () async {
      final result = await repo.getProfile('non-existent');

      expect(result, const Left<Failure, Profile>(NotFoundFailure()));
    });

    test('returns hydrated profile with all children', () async {
      await repo.createProfile(fullProfile());
      final result = await repo.getProfile('p1');

      expect(result.isRight(), true);
      result.fold(
        (f) => fail('Expected Right'),
        (profile) {
          expect(profile.allergies, hasLength(2));
          expect(profile.medications, hasLength(1));
          expect(profile.conditions, hasLength(1));
          expect(profile.emergencyContacts, hasLength(1));
        },
      );
    });
  });

  group('watchAllProfiles', () {
    test('streams empty list when no profiles exist', () async {
      final result = await repo.watchAllProfiles().first;

      result.fold(
        (f) => fail('Expected Right, got Left: $f'),
        (profiles) => expect(profiles, isEmpty),
      );
    });

    test('streams updated list after create', () async {
      await repo.createProfile(fullProfile(id: 'p1'));

      final result = await repo.watchAllProfiles().first;

      result.fold(
        (f) => fail('Expected Right, got Left: $f'),
        (profiles) {
          expect(profiles, hasLength(1));
          expect(profiles[0].name, 'Alice Smith');
          expect(profiles[0].allergies, hasLength(2));
        },
      );
    });

    test('includes multiple profiles', () async {
      await repo.createProfile(fullProfile(id: 'p1'));
      await repo.createProfile(minimalProfile(id: 'p2'));

      final result = await repo.watchAllProfiles().first;

      result.fold(
        (f) => fail('Expected Right, got Left: $f'),
        (profiles) => expect(profiles, hasLength(2)),
      );
    });
  });

  group('updateProfile', () {
    test('updates profile fields', () async {
      await repo.createProfile(fullProfile());

      final updated = fullProfile().copyWith(
        name: 'Alice Jones',
        bloodType: BloodType.bNeg,
        updatedAt: DateTime(2025, 7, 1),
      );
      await repo.updateProfile(updated);

      final result = await repo.getProfile('p1');
      result.fold(
        (f) => fail('Expected Right'),
        (profile) {
          expect(profile.name, 'Alice Jones');
          expect(profile.bloodType, BloodType.bNeg);
        },
      );
    });

    test('replaces child records on update', () async {
      await repo.createProfile(fullProfile());

      final updated = fullProfile().copyWith(
        allergies: const [
          Allergy(id: 'a3', name: 'Shellfish', severity: AllergySeverity.mild),
        ],
        medications: const [],
        conditions: const [],
        emergencyContacts: const [],
      );
      await repo.updateProfile(updated);

      final result = await repo.getProfile('p1');
      result.fold(
        (f) => fail('Expected Right'),
        (profile) {
          expect(profile.allergies, hasLength(1));
          expect(profile.allergies[0].name, 'Shellfish');
          expect(profile.medications, isEmpty);
          expect(profile.conditions, isEmpty);
          expect(profile.emergencyContacts, isEmpty);
        },
      );
    });
  });

  group('deleteProfile', () {
    test('removes profile and all children', () async {
      await repo.createProfile(fullProfile());
      await repo.deleteProfile('p1');

      final result = await repo.getProfile('p1');
      expect(result, const Left<Failure, Profile>(NotFoundFailure()));
    });

    test('does not affect other profiles', () async {
      await repo.createProfile(fullProfile(id: 'p1'));
      await repo.createProfile(minimalProfile(id: 'p2'));
      await repo.deleteProfile('p1');

      final result = await repo.getProfile('p2');
      expect(result.isRight(), true);
    });
  });

  group('enum hydration', () {
    test('parses all blood types correctly', () async {
      for (final bt in BloodType.values) {
        final id = 'bt-${bt.name}';
        await repo.createProfile(
          minimalProfile(id: id).copyWith(bloodType: bt),
        );
        final result = await repo.getProfile(id);
        result.fold(
          (f) => fail('Expected Right'),
          (profile) => expect(profile.bloodType, bt),
        );
      }
    });

    test('parses all biological sex values correctly', () async {
      for (final sex in BiologicalSex.values) {
        final id = 'sex-${sex.name}';
        await repo.createProfile(
          minimalProfile(id: id).copyWith(biologicalSex: sex),
        );
        final result = await repo.getProfile(id);
        result.fold(
          (f) => fail('Expected Right'),
          (profile) => expect(profile.biologicalSex, sex),
        );
      }
    });

    test('parses all allergy severity values correctly', () async {
      for (final sev in AllergySeverity.values) {
        final id = 'sev-${sev.name}';
        await repo.createProfile(
          minimalProfile(id: id).copyWith(
            allergies: [
              Allergy(id: 'a-${sev.name}', name: 'Test', severity: sev),
            ],
          ),
        );
        final result = await repo.getProfile(id);
        result.fold(
          (f) => fail('Expected Right'),
          (profile) => expect(profile.allergies[0].severity, sev),
        );
      }
    });
  });
}
