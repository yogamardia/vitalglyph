import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

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
  AppDatabase(String encryptionKey) : super(_openDatabase(encryptionKey));

  /// For unit tests only — pass an in-memory executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}

LazyDatabase _openDatabase(String encryptionKey) {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'vitalglyph.db');
    final file = File(path);

    // Migrate existing unencrypted database to encrypted format.
    if (await file.exists()) {
      await _migrateToEncrypted(path, encryptionKey);
    }

    return NativeDatabase(
      file,
      setup: (db) {
        db.execute("PRAGMA key = \"x'$encryptionKey'\";");
      },
    );
  });
}

/// Converts an existing plaintext database to SQLCipher-encrypted format.
/// If the database is already encrypted, this is a no-op.
Future<void> _migrateToEncrypted(String dbPath, String hexKey) async {
  final db = raw.sqlite3.open(dbPath);
  try {
    // If this succeeds, the database is plaintext and needs encryption.
    db.execute('SELECT count(*) FROM sqlite_master;');
  } on raw.SqliteException {
    // Not plaintext — already encrypted or empty. Nothing to do.
    db.dispose();
    return;
  }

  // Export plaintext data into a new encrypted database file.
  final encryptedPath = '$dbPath.encrypted';
  try {
    db.execute(
      "ATTACH DATABASE '$encryptedPath' AS encrypted KEY \"x'$hexKey'\";",
    );
    db.execute("SELECT sqlcipher_export('encrypted');");
    db.execute('DETACH DATABASE encrypted;');
  } finally {
    db.dispose();
  }

  // Swap: replace plaintext file with encrypted file.
  final encryptedFile = File(encryptedPath);
  if (await encryptedFile.exists()) {
    await File(dbPath).delete();
    await encryptedFile.rename(dbPath);
  }
}
