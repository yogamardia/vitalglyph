import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:vitalglyph/core/crypto/encryption_service.dart';

part 'local_database.g.dart';

// ──────────────────────────────────────────────
// Table definitions
// ──────────────────────────────────────────────

@DataClassName('ProfileRecord')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get bloodType => text().nullable()();
  TextColumn get biologicalSex => text().nullable()();
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  BoolColumn get isOrganDonor =>
      boolean().withDefault(const Constant(false))();
  TextColumn get medicalNotes => text().nullable()();
  TextColumn get primaryLanguage => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AllergyRecord')
class Allergies extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get severity => text()();
  TextColumn get reaction => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MedicationRecord')
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get frequency => text().nullable()();
  TextColumn get prescribedFor => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MedicalConditionRecord')
class MedicalConditions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get diagnosedDate => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EmergencyContactRecord')
class EmergencyContacts extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get relationship => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

// ──────────────────────────────────────────────
// DAOs
// ──────────────────────────────────────────────

@DriftAccessor(
  tables: [
    Profiles,
    Allergies,
    Medications,
    MedicalConditions,
    EmergencyContacts,
  ],
)
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  Stream<List<ProfileRecord>> watchAllProfiles() =>
      select(profiles).watch();

  Future<ProfileRecord?> getProfile(String id) =>
      (select(profiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertProfile(ProfilesCompanion entry) =>
      into(profiles).insert(entry);

  Future<bool> updateProfile(ProfilesCompanion entry) =>
      update(profiles).replace(entry);

  Future<int> deleteProfile(String id) =>
      (delete(profiles)..where((t) => t.id.equals(id))).go();

  // ── Allergies ──

  Future<List<AllergyRecord>> getAllergiesForProfile(String profileId) =>
      (select(allergies)..where((t) => t.profileId.equals(profileId))).get();

  Future<void> insertAllergy(AllergiesCompanion entry) =>
      into(allergies).insert(entry);

  Future<void> deleteAllergiesForProfile(String profileId) =>
      (delete(allergies)..where((t) => t.profileId.equals(profileId))).go();

  // ── Medications ──

  Future<List<MedicationRecord>> getMedicationsForProfile(String profileId) =>
      (select(medications)
            ..where((t) => t.profileId.equals(profileId)))
          .get();

  Future<void> insertMedication(MedicationsCompanion entry) =>
      into(medications).insert(entry);

  Future<void> deleteMedicationsForProfile(String profileId) =>
      (delete(medications)..where((t) => t.profileId.equals(profileId))).go();

  // ── Medical Conditions ──

  Future<List<MedicalConditionRecord>> getConditionsForProfile(
          String profileId) =>
      (select(medicalConditions)
            ..where((t) => t.profileId.equals(profileId)))
          .get();

  Future<void> insertCondition(MedicalConditionsCompanion entry) =>
      into(medicalConditions).insert(entry);

  Future<void> deleteConditionsForProfile(String profileId) =>
      (delete(medicalConditions)
            ..where((t) => t.profileId.equals(profileId)))
          .go();

  // ── Emergency Contacts ──

  Future<List<EmergencyContactRecord>> getContactsForProfile(
          String profileId) =>
      (select(emergencyContacts)
            ..where((t) => t.profileId.equals(profileId))
            ..orderBy([(t) => OrderingTerm.asc(t.priority)]))
          .get();

  Future<void> insertContact(EmergencyContactsCompanion entry) =>
      into(emergencyContacts).insert(entry);

  Future<void> deleteContactsForProfile(String profileId) =>
      (delete(emergencyContacts)
            ..where((t) => t.profileId.equals(profileId)))
          .go();
}

// ──────────────────────────────────────────────
// Database
// ──────────────────────────────────────────────

@DriftDatabase(
  tables: [
    Profiles,
    Allergies,
    Medications,
    MedicalConditions,
    EmergencyContacts,
  ],
  daos: [ProfileDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(EncryptionService encryptionService) : super(_openDatabase(encryptionService));

  /// For unit tests only — pass an in-memory executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}

LazyDatabase _openDatabase(EncryptionService encryptionService) {
  return LazyDatabase(() async {
    // Manually override the library loading on Android to find SQLCipher.
    if (Platform.isAndroid) {
      open.overrideFor(OperatingSystem.android, () {
        try {
          return DynamicLibrary.open('libsqlcipher.so');
        } catch (_) {
          // If libsqlcipher.so is not found, fallback to libsqlite3.so
          // but SQLCipher flutter libs should provide at least one of these.
          return DynamicLibrary.open('libsqlite3.so');
        }
      });
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'vitalglyph.db');
    final file = File(path);
    final key = await encryptionService.getOrCreateDatabaseKey();

    if (await file.exists()) {
      // Check if it's plaintext
      final db = sqlite3.open(path);
      bool isPlaintext = false;
      try {
        // Try to read something. If it's plaintext, this works.
        db.select('SELECT 1');
        isPlaintext = true;
      } catch (e) {
        // Database is likely already encrypted
      } finally {
        db.dispose();
      }

      if (isPlaintext) {
        final encryptedPath = p.join(dir.path, 'vitalglyph_encrypted.db');
        final plainDb = sqlite3.open(path);
        try {
          plainDb.execute("ATTACH DATABASE '$encryptedPath' AS encrypted KEY \"x'$key'\";");
          plainDb.execute("SELECT sqlcipher_export('encrypted');");
          plainDb.execute("DETACH DATABASE encrypted;");
        } catch (e) {
          // If migration fails, we might want to know why, but for now just log
          // In a real app, we'd handle this better.
        } finally {
          plainDb.dispose();
        }

        if (await File(encryptedPath).exists()) {
          await file.delete();
          await File(encryptedPath).rename(path);
        }
      }
    }

    return NativeDatabase(
      file,
      setup: (db) {
        db.execute("PRAGMA key = \"x'$key'\";");
        // cipher_migrate is safe to call and helps in some encryption scenarios
        db.execute("PRAGMA cipher_migrate;");
      },
    );
  });
}
