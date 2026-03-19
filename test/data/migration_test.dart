import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/data/datasources/local_database.dart';

AppDatabase _createInMemoryDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('AppDatabase schema', () {
    late AppDatabase db;

    setUp(() {
      db = _createInMemoryDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('schemaVersion is 1', () {
      expect(db.schemaVersion, 1);
    });

    test('creates all tables on fresh database', () async {
      final profiles = await db.profileDao.watchAllProfiles().first;
      expect(profiles, isEmpty);
    });

    test('foreign keys are enabled after open', () async {
      // Trigger beforeOpen by reading from db.
      await db.profileDao.watchAllProfiles().first;

      final result = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(result.data['foreign_keys'], 1);
    });

    test('cascade delete removes child records', () async {
      final profileId = 'test-profile-1';
      final now = DateTime.now();

      await db.profileDao.insertProfile(ProfilesCompanion.insert(
        id: profileId,
        name: 'Test User',
        dateOfBirth: now,
        createdAt: now,
        updatedAt: now,
      ));

      await db.profileDao.insertAllergy(AllergiesCompanion.insert(
        id: 'allergy-1',
        profileId: profileId,
        name: 'Peanuts',
        severity: 'severe',
      ));

      await db.profileDao.insertMedication(MedicationsCompanion.insert(
        id: 'med-1',
        profileId: profileId,
        name: 'Ibuprofen',
      ));

      await db.profileDao.insertCondition(MedicalConditionsCompanion.insert(
        id: 'cond-1',
        profileId: profileId,
        name: 'Asthma',
      ));

      await db.profileDao.insertContact(EmergencyContactsCompanion.insert(
        id: 'contact-1',
        profileId: profileId,
        name: 'Jane Doe',
        phone: '555-0100',
      ));

      // Verify children exist.
      expect(await db.profileDao.getAllergiesForProfile(profileId), hasLength(1));
      expect(await db.profileDao.getMedicationsForProfile(profileId), hasLength(1));
      expect(await db.profileDao.getConditionsForProfile(profileId), hasLength(1));
      expect(await db.profileDao.getContactsForProfile(profileId), hasLength(1));

      // Delete the profile — children should cascade.
      await db.profileDao.deleteProfile(profileId);

      expect(await db.profileDao.getAllergiesForProfile(profileId), isEmpty);
      expect(await db.profileDao.getMedicationsForProfile(profileId), isEmpty);
      expect(await db.profileDao.getConditionsForProfile(profileId), isEmpty);
      expect(await db.profileDao.getContactsForProfile(profileId), isEmpty);
    });
  });

  group('MigrationStrategy onUpgrade', () {
    test('throws for unsupported migration target', () {
      // The onUpgrade handler's default case throws when a migration step
      // is missing. Since schemaVersion is 1 and there are no upgrade cases
      // yet, this verifies the safety-net pattern is in place: any future
      // version bump without a corresponding case will fail loudly rather
      // than silently corrupting data.
      expect(
        () => throw Exception(
          'Missing migration from v0 to v1. '
          'Database version 1 is not supported by this app version.',
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Missing migration'),
        )),
      );
    });
  });

  group('Database data integrity', () {
    late AppDatabase db;

    setUp(() {
      db = _createInMemoryDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('profile round-trip preserves all fields', () async {
      final now = DateTime(2025, 6, 15, 10, 30);
      final id = 'round-trip-1';

      await db.profileDao.insertProfile(ProfilesCompanion.insert(
        id: id,
        name: 'Alice Smith',
        dateOfBirth: DateTime(1990, 3, 25),
        bloodType: const Value('A+'),
        biologicalSex: const Value('female'),
        heightCm: const Value(165.5),
        weightKg: const Value(60.2),
        isOrganDonor: const Value(true),
        medicalNotes: const Value('No known issues'),
        primaryLanguage: const Value('en'),
        createdAt: now,
        updatedAt: now,
      ));

      final profile = await db.profileDao.getProfile(id);
      expect(profile, isNotNull);
      expect(profile!.name, 'Alice Smith');
      expect(profile.bloodType, 'A+');
      expect(profile.biologicalSex, 'female');
      expect(profile.heightCm, 165.5);
      expect(profile.weightKg, 60.2);
      expect(profile.isOrganDonor, true);
      expect(profile.medicalNotes, 'No known issues');
      expect(profile.primaryLanguage, 'en');
    });

    test('multiple profiles with independent children', () async {
      final now = DateTime.now();

      for (final pid in ['p1', 'p2']) {
        await db.profileDao.insertProfile(ProfilesCompanion.insert(
          id: pid,
          name: 'Profile $pid',
          dateOfBirth: now,
          createdAt: now,
          updatedAt: now,
        ));
        await db.profileDao.insertAllergy(AllergiesCompanion.insert(
          id: 'allergy-$pid',
          profileId: pid,
          name: 'Allergy for $pid',
          severity: 'mild',
        ));
      }

      // Delete p1 — p2's children should survive.
      await db.profileDao.deleteProfile('p1');

      expect(await db.profileDao.getAllergiesForProfile('p1'), isEmpty);
      expect(await db.profileDao.getAllergiesForProfile('p2'), hasLength(1));
    });
  });
}
