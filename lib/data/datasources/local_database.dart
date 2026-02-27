import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vitalglyph.db'));
    return NativeDatabase.createInBackground(file);
  });
}
