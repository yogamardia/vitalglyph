// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProfilesTable get profiles => attachedDatabase.profiles;
  $AllergiesTable get allergies => attachedDatabase.allergies;
  $MedicationsTable get medications => attachedDatabase.medications;
  $MedicalConditionsTable get medicalConditions =>
      attachedDatabase.medicalConditions;
  $EmergencyContactsTable get emergencyContacts =>
      attachedDatabase.emergencyContacts;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db.attachedDatabase, _db.profiles);
  $$AllergiesTableTableManager get allergies =>
      $$AllergiesTableTableManager(_db.attachedDatabase, _db.allergies);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db.attachedDatabase, _db.medications);
  $$MedicalConditionsTableTableManager get medicalConditions =>
      $$MedicalConditionsTableTableManager(
        _db.attachedDatabase,
        _db.medicalConditions,
      );
  $$EmergencyContactsTableTableManager get emergencyContacts =>
      $$EmergencyContactsTableTableManager(
        _db.attachedDatabase,
        _db.emergencyContacts,
      );
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloodTypeMeta = const VerificationMeta(
    'bloodType',
  );
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
    'blood_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _biologicalSexMeta = const VerificationMeta(
    'biologicalSex',
  );
  @override
  late final GeneratedColumn<String> biologicalSex = GeneratedColumn<String>(
    'biological_sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOrganDonorMeta = const VerificationMeta(
    'isOrganDonor',
  );
  @override
  late final GeneratedColumn<bool> isOrganDonor = GeneratedColumn<bool>(
    'is_organ_donor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_organ_donor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _medicalNotesMeta = const VerificationMeta(
    'medicalNotes',
  );
  @override
  late final GeneratedColumn<String> medicalNotes = GeneratedColumn<String>(
    'medical_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryLanguageMeta = const VerificationMeta(
    'primaryLanguage',
  );
  @override
  late final GeneratedColumn<String> primaryLanguage = GeneratedColumn<String>(
    'primary_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    dateOfBirth,
    bloodType,
    biologicalSex,
    heightCm,
    weightKg,
    isOrganDonor,
    medicalNotes,
    primaryLanguage,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfBirthMeta);
    }
    if (data.containsKey('blood_type')) {
      context.handle(
        _bloodTypeMeta,
        bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta),
      );
    }
    if (data.containsKey('biological_sex')) {
      context.handle(
        _biologicalSexMeta,
        biologicalSex.isAcceptableOrUnknown(
          data['biological_sex']!,
          _biologicalSexMeta,
        ),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('is_organ_donor')) {
      context.handle(
        _isOrganDonorMeta,
        isOrganDonor.isAcceptableOrUnknown(
          data['is_organ_donor']!,
          _isOrganDonorMeta,
        ),
      );
    }
    if (data.containsKey('medical_notes')) {
      context.handle(
        _medicalNotesMeta,
        medicalNotes.isAcceptableOrUnknown(
          data['medical_notes']!,
          _medicalNotesMeta,
        ),
      );
    }
    if (data.containsKey('primary_language')) {
      context.handle(
        _primaryLanguageMeta,
        primaryLanguage.isAcceptableOrUnknown(
          data['primary_language']!,
          _primaryLanguageMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      )!,
      bloodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_type'],
      ),
      biologicalSex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}biological_sex'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      isOrganDonor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_organ_donor'],
      )!,
      medicalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_notes'],
      ),
      primaryLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_language'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRecord extends DataClass implements Insertable<ProfileRecord> {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String? bloodType;
  final String? biologicalSex;
  final double? heightCm;
  final double? weightKg;
  final bool isOrganDonor;
  final String? medicalNotes;
  final String? primaryLanguage;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProfileRecord({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    this.bloodType,
    this.biologicalSex,
    this.heightCm,
    this.weightKg,
    required this.isOrganDonor,
    this.medicalNotes,
    this.primaryLanguage,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    if (!nullToAbsent || bloodType != null) {
      map['blood_type'] = Variable<String>(bloodType);
    }
    if (!nullToAbsent || biologicalSex != null) {
      map['biological_sex'] = Variable<String>(biologicalSex);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    map['is_organ_donor'] = Variable<bool>(isOrganDonor);
    if (!nullToAbsent || medicalNotes != null) {
      map['medical_notes'] = Variable<String>(medicalNotes);
    }
    if (!nullToAbsent || primaryLanguage != null) {
      map['primary_language'] = Variable<String>(primaryLanguage);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      dateOfBirth: Value(dateOfBirth),
      bloodType: bloodType == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodType),
      biologicalSex: biologicalSex == null && nullToAbsent
          ? const Value.absent()
          : Value(biologicalSex),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      isOrganDonor: Value(isOrganDonor),
      medicalNotes: medicalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalNotes),
      primaryLanguage: primaryLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryLanguage),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dateOfBirth: serializer.fromJson<DateTime>(json['dateOfBirth']),
      bloodType: serializer.fromJson<String?>(json['bloodType']),
      biologicalSex: serializer.fromJson<String?>(json['biologicalSex']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      isOrganDonor: serializer.fromJson<bool>(json['isOrganDonor']),
      medicalNotes: serializer.fromJson<String?>(json['medicalNotes']),
      primaryLanguage: serializer.fromJson<String?>(json['primaryLanguage']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dateOfBirth': serializer.toJson<DateTime>(dateOfBirth),
      'bloodType': serializer.toJson<String?>(bloodType),
      'biologicalSex': serializer.toJson<String?>(biologicalSex),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'isOrganDonor': serializer.toJson<bool>(isOrganDonor),
      'medicalNotes': serializer.toJson<String?>(medicalNotes),
      'primaryLanguage': serializer.toJson<String?>(primaryLanguage),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileRecord copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    Value<String?> bloodType = const Value.absent(),
    Value<String?> biologicalSex = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    bool? isOrganDonor,
    Value<String?> medicalNotes = const Value.absent(),
    Value<String?> primaryLanguage = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProfileRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    bloodType: bloodType.present ? bloodType.value : this.bloodType,
    biologicalSex: biologicalSex.present
        ? biologicalSex.value
        : this.biologicalSex,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    isOrganDonor: isOrganDonor ?? this.isOrganDonor,
    medicalNotes: medicalNotes.present ? medicalNotes.value : this.medicalNotes,
    primaryLanguage: primaryLanguage.present
        ? primaryLanguage.value
        : this.primaryLanguage,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRecord copyWithCompanion(ProfilesCompanion data) {
    return ProfileRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      biologicalSex: data.biologicalSex.present
          ? data.biologicalSex.value
          : this.biologicalSex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      isOrganDonor: data.isOrganDonor.present
          ? data.isOrganDonor.value
          : this.isOrganDonor,
      medicalNotes: data.medicalNotes.present
          ? data.medicalNotes.value
          : this.medicalNotes,
      primaryLanguage: data.primaryLanguage.present
          ? data.primaryLanguage.value
          : this.primaryLanguage,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('bloodType: $bloodType, ')
          ..write('biologicalSex: $biologicalSex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('isOrganDonor: $isOrganDonor, ')
          ..write('medicalNotes: $medicalNotes, ')
          ..write('primaryLanguage: $primaryLanguage, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    dateOfBirth,
    bloodType,
    biologicalSex,
    heightCm,
    weightKg,
    isOrganDonor,
    medicalNotes,
    primaryLanguage,
    photoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.dateOfBirth == this.dateOfBirth &&
          other.bloodType == this.bloodType &&
          other.biologicalSex == this.biologicalSex &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.isOrganDonor == this.isOrganDonor &&
          other.medicalNotes == this.medicalNotes &&
          other.primaryLanguage == this.primaryLanguage &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> dateOfBirth;
  final Value<String?> bloodType;
  final Value<String?> biologicalSex;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<bool> isOrganDonor;
  final Value<String?> medicalNotes;
  final Value<String?> primaryLanguage;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.biologicalSex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.isOrganDonor = const Value.absent(),
    this.medicalNotes = const Value.absent(),
    this.primaryLanguage = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    required DateTime dateOfBirth,
    this.bloodType = const Value.absent(),
    this.biologicalSex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.isOrganDonor = const Value.absent(),
    this.medicalNotes = const Value.absent(),
    this.primaryLanguage = const Value.absent(),
    this.photoPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       dateOfBirth = Value(dateOfBirth),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? bloodType,
    Expression<String>? biologicalSex,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<bool>? isOrganDonor,
    Expression<String>? medicalNotes,
    Expression<String>? primaryLanguage,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (bloodType != null) 'blood_type': bloodType,
      if (biologicalSex != null) 'biological_sex': biologicalSex,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (isOrganDonor != null) 'is_organ_donor': isOrganDonor,
      if (medicalNotes != null) 'medical_notes': medicalNotes,
      if (primaryLanguage != null) 'primary_language': primaryLanguage,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? dateOfBirth,
    Value<String?>? bloodType,
    Value<String?>? biologicalSex,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<bool>? isOrganDonor,
    Value<String?>? medicalNotes,
    Value<String?>? primaryLanguage,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodType: bloodType ?? this.bloodType,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      primaryLanguage: primaryLanguage ?? this.primaryLanguage,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (biologicalSex.present) {
      map['biological_sex'] = Variable<String>(biologicalSex.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (isOrganDonor.present) {
      map['is_organ_donor'] = Variable<bool>(isOrganDonor.value);
    }
    if (medicalNotes.present) {
      map['medical_notes'] = Variable<String>(medicalNotes.value);
    }
    if (primaryLanguage.present) {
      map['primary_language'] = Variable<String>(primaryLanguage.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('bloodType: $bloodType, ')
          ..write('biologicalSex: $biologicalSex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('isOrganDonor: $isOrganDonor, ')
          ..write('medicalNotes: $medicalNotes, ')
          ..write('primaryLanguage: $primaryLanguage, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllergiesTable extends Allergies
    with TableInfo<$AllergiesTable, AllergyRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllergiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactionMeta = const VerificationMeta(
    'reaction',
  );
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
    'reaction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    severity,
    reaction,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allergies';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllergyRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('reaction')) {
      context.handle(
        _reactionMeta,
        reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllergyRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllergyRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      reaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reaction'],
      ),
    );
  }

  @override
  $AllergiesTable createAlias(String alias) {
    return $AllergiesTable(attachedDatabase, alias);
  }
}

class AllergyRecord extends DataClass implements Insertable<AllergyRecord> {
  final String id;
  final String profileId;
  final String name;
  final String severity;
  final String? reaction;
  const AllergyRecord({
    required this.id,
    required this.profileId,
    required this.name,
    required this.severity,
    this.reaction,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || reaction != null) {
      map['reaction'] = Variable<String>(reaction);
    }
    return map;
  }

  AllergiesCompanion toCompanion(bool nullToAbsent) {
    return AllergiesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      severity: Value(severity),
      reaction: reaction == null && nullToAbsent
          ? const Value.absent()
          : Value(reaction),
    );
  }

  factory AllergyRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllergyRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      severity: serializer.fromJson<String>(json['severity']),
      reaction: serializer.fromJson<String?>(json['reaction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'severity': serializer.toJson<String>(severity),
      'reaction': serializer.toJson<String?>(reaction),
    };
  }

  AllergyRecord copyWith({
    String? id,
    String? profileId,
    String? name,
    String? severity,
    Value<String?> reaction = const Value.absent(),
  }) => AllergyRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    severity: severity ?? this.severity,
    reaction: reaction.present ? reaction.value : this.reaction,
  );
  AllergyRecord copyWithCompanion(AllergiesCompanion data) {
    return AllergyRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      severity: data.severity.present ? data.severity.value : this.severity,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllergyRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('severity: $severity, ')
          ..write('reaction: $reaction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, name, severity, reaction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllergyRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.severity == this.severity &&
          other.reaction == this.reaction);
}

class AllergiesCompanion extends UpdateCompanion<AllergyRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String> severity;
  final Value<String?> reaction;
  final Value<int> rowid;
  const AllergiesCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.severity = const Value.absent(),
    this.reaction = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllergiesCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    required String severity,
    this.reaction = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       name = Value(name),
       severity = Value(severity);
  static Insertable<AllergyRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? severity,
    Expression<String>? reaction,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (severity != null) 'severity': severity,
      if (reaction != null) 'reaction': reaction,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllergiesCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? name,
    Value<String>? severity,
    Value<String?>? reaction,
    Value<int>? rowid,
  }) {
    return AllergiesCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      severity: severity ?? this.severity,
      reaction: reaction ?? this.reaction,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllergiesCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('severity: $severity, ')
          ..write('reaction: $reaction, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
    'dosage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prescribedForMeta = const VerificationMeta(
    'prescribedFor',
  );
  @override
  late final GeneratedColumn<String> prescribedFor = GeneratedColumn<String>(
    'prescribed_for',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    dosage,
    frequency,
    prescribedFor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('prescribed_for')) {
      context.handle(
        _prescribedForMeta,
        prescribedFor.isAcceptableOrUnknown(
          data['prescribed_for']!,
          _prescribedForMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      ),
      prescribedFor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prescribed_for'],
      ),
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationRecord extends DataClass
    implements Insertable<MedicationRecord> {
  final String id;
  final String profileId;
  final String name;
  final String? dosage;
  final String? frequency;
  final String? prescribedFor;
  const MedicationRecord({
    required this.id,
    required this.profileId,
    required this.name,
    this.dosage,
    this.frequency,
    this.prescribedFor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<String>(frequency);
    }
    if (!nullToAbsent || prescribedFor != null) {
      map['prescribed_for'] = Variable<String>(prescribedFor);
    }
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      dosage: dosage == null && nullToAbsent
          ? const Value.absent()
          : Value(dosage),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      prescribedFor: prescribedFor == null && nullToAbsent
          ? const Value.absent()
          : Value(prescribedFor),
    );
  }

  factory MedicationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      frequency: serializer.fromJson<String?>(json['frequency']),
      prescribedFor: serializer.fromJson<String?>(json['prescribedFor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
      'frequency': serializer.toJson<String?>(frequency),
      'prescribedFor': serializer.toJson<String?>(prescribedFor),
    };
  }

  MedicationRecord copyWith({
    String? id,
    String? profileId,
    String? name,
    Value<String?> dosage = const Value.absent(),
    Value<String?> frequency = const Value.absent(),
    Value<String?> prescribedFor = const Value.absent(),
  }) => MedicationRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    dosage: dosage.present ? dosage.value : this.dosage,
    frequency: frequency.present ? frequency.value : this.frequency,
    prescribedFor: prescribedFor.present
        ? prescribedFor.value
        : this.prescribedFor,
  );
  MedicationRecord copyWithCompanion(MedicationsCompanion data) {
    return MedicationRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      prescribedFor: data.prescribedFor.present
          ? data.prescribedFor.value
          : this.prescribedFor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('prescribedFor: $prescribedFor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, name, dosage, frequency, prescribedFor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.frequency == this.frequency &&
          other.prescribedFor == this.prescribedFor);
}

class MedicationsCompanion extends UpdateCompanion<MedicationRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<String?> frequency;
  final Value<String?> prescribedFor;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.prescribedFor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.prescribedFor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       name = Value(name);
  static Insertable<MedicationRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? frequency,
    Expression<String>? prescribedFor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (frequency != null) 'frequency': frequency,
      if (prescribedFor != null) 'prescribed_for': prescribedFor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? name,
    Value<String?>? dosage,
    Value<String?>? frequency,
    Value<String?>? prescribedFor,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      prescribedFor: prescribedFor ?? this.prescribedFor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (prescribedFor.present) {
      map['prescribed_for'] = Variable<String>(prescribedFor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('prescribedFor: $prescribedFor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalConditionsTable extends MedicalConditions
    with TableInfo<$MedicalConditionsTable, MedicalConditionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diagnosedDateMeta = const VerificationMeta(
    'diagnosedDate',
  );
  @override
  late final GeneratedColumn<String> diagnosedDate = GeneratedColumn<String>(
    'diagnosed_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    diagnosedDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalConditionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('diagnosed_date')) {
      context.handle(
        _diagnosedDateMeta,
        diagnosedDate.isAcceptableOrUnknown(
          data['diagnosed_date']!,
          _diagnosedDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalConditionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalConditionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      diagnosedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diagnosed_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $MedicalConditionsTable createAlias(String alias) {
    return $MedicalConditionsTable(attachedDatabase, alias);
  }
}

class MedicalConditionRecord extends DataClass
    implements Insertable<MedicalConditionRecord> {
  final String id;
  final String profileId;
  final String name;
  final String? diagnosedDate;
  final String? notes;
  const MedicalConditionRecord({
    required this.id,
    required this.profileId,
    required this.name,
    this.diagnosedDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || diagnosedDate != null) {
      map['diagnosed_date'] = Variable<String>(diagnosedDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MedicalConditionsCompanion toCompanion(bool nullToAbsent) {
    return MedicalConditionsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      diagnosedDate: diagnosedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(diagnosedDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory MedicalConditionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalConditionRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      diagnosedDate: serializer.fromJson<String?>(json['diagnosedDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'diagnosedDate': serializer.toJson<String?>(diagnosedDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MedicalConditionRecord copyWith({
    String? id,
    String? profileId,
    String? name,
    Value<String?> diagnosedDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => MedicalConditionRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    diagnosedDate: diagnosedDate.present
        ? diagnosedDate.value
        : this.diagnosedDate,
    notes: notes.present ? notes.value : this.notes,
  );
  MedicalConditionRecord copyWithCompanion(MedicalConditionsCompanion data) {
    return MedicalConditionRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      diagnosedDate: data.diagnosedDate.present
          ? data.diagnosedDate.value
          : this.diagnosedDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalConditionRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('diagnosedDate: $diagnosedDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, name, diagnosedDate, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalConditionRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.diagnosedDate == this.diagnosedDate &&
          other.notes == this.notes);
}

class MedicalConditionsCompanion
    extends UpdateCompanion<MedicalConditionRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String?> diagnosedDate;
  final Value<String?> notes;
  final Value<int> rowid;
  const MedicalConditionsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.diagnosedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalConditionsCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    this.diagnosedDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       name = Value(name);
  static Insertable<MedicalConditionRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? diagnosedDate,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (diagnosedDate != null) 'diagnosed_date': diagnosedDate,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalConditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? name,
    Value<String?>? diagnosedDate,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return MedicalConditionsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      diagnosedDate: diagnosedDate ?? this.diagnosedDate,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (diagnosedDate.present) {
      map['diagnosed_date'] = Variable<String>(diagnosedDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalConditionsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('diagnosedDate: $diagnosedDate, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmergencyContactsTable extends EmergencyContacts
    with TableInfo<$EmergencyContactsTable, EmergencyContactRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationshipMeta = const VerificationMeta(
    'relationship',
  );
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
    'relationship',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    name,
    phone,
    relationship,
    priority,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyContactRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('relationship')) {
      context.handle(
        _relationshipMeta,
        relationship.isAcceptableOrUnknown(
          data['relationship']!,
          _relationshipMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyContactRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyContactRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      relationship: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
    );
  }

  @override
  $EmergencyContactsTable createAlias(String alias) {
    return $EmergencyContactsTable(attachedDatabase, alias);
  }
}

class EmergencyContactRecord extends DataClass
    implements Insertable<EmergencyContactRecord> {
  final String id;
  final String profileId;
  final String name;
  final String phone;
  final String? relationship;
  final int priority;
  const EmergencyContactRecord({
    required this.id,
    required this.profileId,
    required this.name,
    required this.phone,
    this.relationship,
    required this.priority,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || relationship != null) {
      map['relationship'] = Variable<String>(relationship);
    }
    map['priority'] = Variable<int>(priority);
    return map;
  }

  EmergencyContactsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyContactsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: Value(name),
      phone: Value(phone),
      relationship: relationship == null && nullToAbsent
          ? const Value.absent()
          : Value(relationship),
      priority: Value(priority),
    );
  }

  factory EmergencyContactRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyContactRecord(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      relationship: serializer.fromJson<String?>(json['relationship']),
      priority: serializer.fromJson<int>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'relationship': serializer.toJson<String?>(relationship),
      'priority': serializer.toJson<int>(priority),
    };
  }

  EmergencyContactRecord copyWith({
    String? id,
    String? profileId,
    String? name,
    String? phone,
    Value<String?> relationship = const Value.absent(),
    int? priority,
  }) => EmergencyContactRecord(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    relationship: relationship.present ? relationship.value : this.relationship,
    priority: priority ?? this.priority,
  );
  EmergencyContactRecord copyWithCompanion(EmergencyContactsCompanion data) {
    return EmergencyContactRecord(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      priority: data.priority.present ? data.priority.value : this.priority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactRecord(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('relationship: $relationship, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, profileId, name, phone, relationship, priority);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyContactRecord &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.relationship == this.relationship &&
          other.priority == this.priority);
}

class EmergencyContactsCompanion
    extends UpdateCompanion<EmergencyContactRecord> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> relationship;
  final Value<int> priority;
  final Value<int> rowid;
  const EmergencyContactsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.relationship = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyContactsCompanion.insert({
    required String id,
    required String profileId,
    required String name,
    required String phone,
    this.relationship = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       name = Value(name),
       phone = Value(phone);
  static Insertable<EmergencyContactRecord> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? relationship,
    Expression<int>? priority,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (relationship != null) 'relationship': relationship,
      if (priority != null) 'priority': priority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? name,
    Value<String>? phone,
    Value<String?>? relationship,
    Value<int>? priority,
    Value<int>? rowid,
  }) {
    return EmergencyContactsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      priority: priority ?? this.priority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('relationship: $relationship, ')
          ..write('priority: $priority, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $AllergiesTable allergies = $AllergiesTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicalConditionsTable medicalConditions =
      $MedicalConditionsTable(this);
  late final $EmergencyContactsTable emergencyContacts =
      $EmergencyContactsTable(this);
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    allergies,
    medications,
    medicalConditions,
    emergencyContacts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('allergies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medications', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('medical_conditions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('emergency_contacts', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      required String id,
      required String name,
      required DateTime dateOfBirth,
      Value<String?> bloodType,
      Value<String?> biologicalSex,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<bool> isOrganDonor,
      Value<String?> medicalNotes,
      Value<String?> primaryLanguage,
      Value<String?> photoPath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> dateOfBirth,
      Value<String?> bloodType,
      Value<String?> biologicalSex,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<bool> isOrganDonor,
      Value<String?> medicalNotes,
      Value<String?> primaryLanguage,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRecord> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AllergiesTable, List<AllergyRecord>>
  _allergiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.allergies,
    aliasName: $_aliasNameGenerator(db.profiles.id, db.allergies.profileId),
  );

  $$AllergiesTableProcessedTableManager get allergiesRefs {
    final manager = $$AllergiesTableTableManager(
      $_db,
      $_db.allergies,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_allergiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MedicationsTable, List<MedicationRecord>>
  _medicationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medications,
    aliasName: $_aliasNameGenerator(db.profiles.id, db.medications.profileId),
  );

  $$MedicationsTableProcessedTableManager get medicationsRefs {
    final manager = $$MedicationsTableTableManager(
      $_db,
      $_db.medications,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MedicalConditionsTable,
    List<MedicalConditionRecord>
  >
  _medicalConditionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicalConditions,
        aliasName: $_aliasNameGenerator(
          db.profiles.id,
          db.medicalConditions.profileId,
        ),
      );

  $$MedicalConditionsTableProcessedTableManager get medicalConditionsRefs {
    final manager = $$MedicalConditionsTableTableManager(
      $_db,
      $_db.medicalConditions,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicalConditionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EmergencyContactsTable,
    List<EmergencyContactRecord>
  >
  _emergencyContactsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.emergencyContacts,
        aliasName: $_aliasNameGenerator(
          db.profiles.id,
          db.emergencyContacts.profileId,
        ),
      );

  $$EmergencyContactsTableProcessedTableManager get emergencyContactsRefs {
    final manager = $$EmergencyContactsTableTableManager(
      $_db,
      $_db.emergencyContacts,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emergencyContactsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get biologicalSex => $composableBuilder(
    column: $table.biologicalSex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOrganDonor => $composableBuilder(
    column: $table.isOrganDonor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalNotes => $composableBuilder(
    column: $table.medicalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryLanguage => $composableBuilder(
    column: $table.primaryLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> allergiesRefs(
    Expression<bool> Function($$AllergiesTableFilterComposer f) f,
  ) {
    final $$AllergiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allergies,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergiesTableFilterComposer(
            $db: $db,
            $table: $db.allergies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicationsRefs(
    Expression<bool> Function($$MedicationsTableFilterComposer f) f,
  ) {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableFilterComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> medicalConditionsRefs(
    Expression<bool> Function($$MedicalConditionsTableFilterComposer f) f,
  ) {
    final $$MedicalConditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicalConditions,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalConditionsTableFilterComposer(
            $db: $db,
            $table: $db.medicalConditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> emergencyContactsRefs(
    Expression<bool> Function($$EmergencyContactsTableFilterComposer f) f,
  ) {
    final $$EmergencyContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emergencyContacts,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmergencyContactsTableFilterComposer(
            $db: $db,
            $table: $db.emergencyContacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get biologicalSex => $composableBuilder(
    column: $table.biologicalSex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOrganDonor => $composableBuilder(
    column: $table.isOrganDonor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalNotes => $composableBuilder(
    column: $table.medicalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryLanguage => $composableBuilder(
    column: $table.primaryLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get biologicalSex => $composableBuilder(
    column: $table.biologicalSex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<bool> get isOrganDonor => $composableBuilder(
    column: $table.isOrganDonor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicalNotes => $composableBuilder(
    column: $table.medicalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryLanguage => $composableBuilder(
    column: $table.primaryLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> allergiesRefs<T extends Object>(
    Expression<T> Function($$AllergiesTableAnnotationComposer a) f,
  ) {
    final $$AllergiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allergies,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergiesTableAnnotationComposer(
            $db: $db,
            $table: $db.allergies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicationsRefs<T extends Object>(
    Expression<T> Function($$MedicationsTableAnnotationComposer a) f,
  ) {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medications,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.medications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> medicalConditionsRefs<T extends Object>(
    Expression<T> Function($$MedicalConditionsTableAnnotationComposer a) f,
  ) {
    final $$MedicalConditionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.medicalConditions,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicalConditionsTableAnnotationComposer(
                $db: $db,
                $table: $db.medicalConditions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> emergencyContactsRefs<T extends Object>(
    Expression<T> Function($$EmergencyContactsTableAnnotationComposer a) f,
  ) {
    final $$EmergencyContactsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.emergencyContacts,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmergencyContactsTableAnnotationComposer(
                $db: $db,
                $table: $db.emergencyContacts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRecord,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (ProfileRecord, $$ProfilesTableReferences),
          ProfileRecord,
          PrefetchHooks Function({
            bool allergiesRefs,
            bool medicationsRefs,
            bool medicalConditionsRefs,
            bool emergencyContactsRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> dateOfBirth = const Value.absent(),
                Value<String?> bloodType = const Value.absent(),
                Value<String?> biologicalSex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<bool> isOrganDonor = const Value.absent(),
                Value<String?> medicalNotes = const Value.absent(),
                Value<String?> primaryLanguage = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                bloodType: bloodType,
                biologicalSex: biologicalSex,
                heightCm: heightCm,
                weightKg: weightKg,
                isOrganDonor: isOrganDonor,
                medicalNotes: medicalNotes,
                primaryLanguage: primaryLanguage,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime dateOfBirth,
                Value<String?> bloodType = const Value.absent(),
                Value<String?> biologicalSex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<bool> isOrganDonor = const Value.absent(),
                Value<String?> medicalNotes = const Value.absent(),
                Value<String?> primaryLanguage = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                dateOfBirth: dateOfBirth,
                bloodType: bloodType,
                biologicalSex: biologicalSex,
                heightCm: heightCm,
                weightKg: weightKg,
                isOrganDonor: isOrganDonor,
                medicalNotes: medicalNotes,
                primaryLanguage: primaryLanguage,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                allergiesRefs = false,
                medicationsRefs = false,
                medicalConditionsRefs = false,
                emergencyContactsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (allergiesRefs) db.allergies,
                    if (medicationsRefs) db.medications,
                    if (medicalConditionsRefs) db.medicalConditions,
                    if (emergencyContactsRefs) db.emergencyContacts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (allergiesRefs)
                        await $_getPrefetchedData<
                          ProfileRecord,
                          $ProfilesTable,
                          AllergyRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._allergiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).allergiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicationsRefs)
                        await $_getPrefetchedData<
                          ProfileRecord,
                          $ProfilesTable,
                          MedicationRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._medicationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (medicalConditionsRefs)
                        await $_getPrefetchedData<
                          ProfileRecord,
                          $ProfilesTable,
                          MedicalConditionRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._medicalConditionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).medicalConditionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (emergencyContactsRefs)
                        await $_getPrefetchedData<
                          ProfileRecord,
                          $ProfilesTable,
                          EmergencyContactRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._emergencyContactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).emergencyContactsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRecord,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRecord, $$ProfilesTableReferences),
      ProfileRecord,
      PrefetchHooks Function({
        bool allergiesRefs,
        bool medicationsRefs,
        bool medicalConditionsRefs,
        bool emergencyContactsRefs,
      })
    >;
typedef $$AllergiesTableCreateCompanionBuilder =
    AllergiesCompanion Function({
      required String id,
      required String profileId,
      required String name,
      required String severity,
      Value<String?> reaction,
      Value<int> rowid,
    });
typedef $$AllergiesTableUpdateCompanionBuilder =
    AllergiesCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> name,
      Value<String> severity,
      Value<String?> reaction,
      Value<int> rowid,
    });

final class $$AllergiesTableReferences
    extends BaseReferences<_$AppDatabase, $AllergiesTable, AllergyRecord> {
  $$AllergiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
        $_aliasNameGenerator(db.allergies.profileId, db.profiles.id),
      );

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AllergiesTableFilterComposer
    extends Composer<_$AppDatabase, $AllergiesTable> {
  $$AllergiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergiesTableOrderingComposer
    extends Composer<_$AppDatabase, $AllergiesTable> {
  $$AllergiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllergiesTable> {
  $$AllergiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllergiesTable,
          AllergyRecord,
          $$AllergiesTableFilterComposer,
          $$AllergiesTableOrderingComposer,
          $$AllergiesTableAnnotationComposer,
          $$AllergiesTableCreateCompanionBuilder,
          $$AllergiesTableUpdateCompanionBuilder,
          (AllergyRecord, $$AllergiesTableReferences),
          AllergyRecord,
          PrefetchHooks Function({bool profileId})
        > {
  $$AllergiesTableTableManager(_$AppDatabase db, $AllergiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllergiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllergiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllergiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<String?> reaction = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllergiesCompanion(
                id: id,
                profileId: profileId,
                name: name,
                severity: severity,
                reaction: reaction,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String name,
                required String severity,
                Value<String?> reaction = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllergiesCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                severity: severity,
                reaction: reaction,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AllergiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$AllergiesTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$AllergiesTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AllergiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllergiesTable,
      AllergyRecord,
      $$AllergiesTableFilterComposer,
      $$AllergiesTableOrderingComposer,
      $$AllergiesTableAnnotationComposer,
      $$AllergiesTableCreateCompanionBuilder,
      $$AllergiesTableUpdateCompanionBuilder,
      (AllergyRecord, $$AllergiesTableReferences),
      AllergyRecord,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String profileId,
      required String name,
      Value<String?> dosage,
      Value<String?> frequency,
      Value<String?> prescribedFor,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> name,
      Value<String?> dosage,
      Value<String?> frequency,
      Value<String?> prescribedFor,
      Value<int> rowid,
    });

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRecord> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
        $_aliasNameGenerator(db.medications.profileId, db.profiles.id),
      );

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prescribedFor => $composableBuilder(
    column: $table.prescribedFor,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prescribedFor => $composableBuilder(
    column: $table.prescribedFor,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get prescribedFor => $composableBuilder(
    column: $table.prescribedFor,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          MedicationRecord,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (MedicationRecord, $$MedicationsTableReferences),
          MedicationRecord,
          PrefetchHooks Function({bool profileId})
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> dosage = const Value.absent(),
                Value<String?> frequency = const Value.absent(),
                Value<String?> prescribedFor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                dosage: dosage,
                frequency: frequency,
                prescribedFor: prescribedFor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String name,
                Value<String?> dosage = const Value.absent(),
                Value<String?> frequency = const Value.absent(),
                Value<String?> prescribedFor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                dosage: dosage,
                frequency: frequency,
                prescribedFor: prescribedFor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable: $$MedicationsTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$MedicationsTableReferences
                                    ._profileIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      MedicationRecord,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (MedicationRecord, $$MedicationsTableReferences),
      MedicationRecord,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$MedicalConditionsTableCreateCompanionBuilder =
    MedicalConditionsCompanion Function({
      required String id,
      required String profileId,
      required String name,
      Value<String?> diagnosedDate,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$MedicalConditionsTableUpdateCompanionBuilder =
    MedicalConditionsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> name,
      Value<String?> diagnosedDate,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$MedicalConditionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicalConditionsTable,
          MedicalConditionRecord
        > {
  $$MedicalConditionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
        $_aliasNameGenerator(db.medicalConditions.profileId, db.profiles.id),
      );

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicalConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalConditionsTable> {
  $$MedicalConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diagnosedDate => $composableBuilder(
    column: $table.diagnosedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalConditionsTable> {
  $$MedicalConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diagnosedDate => $composableBuilder(
    column: $table.diagnosedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalConditionsTable> {
  $$MedicalConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get diagnosedDate => $composableBuilder(
    column: $table.diagnosedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicalConditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalConditionsTable,
          MedicalConditionRecord,
          $$MedicalConditionsTableFilterComposer,
          $$MedicalConditionsTableOrderingComposer,
          $$MedicalConditionsTableAnnotationComposer,
          $$MedicalConditionsTableCreateCompanionBuilder,
          $$MedicalConditionsTableUpdateCompanionBuilder,
          (MedicalConditionRecord, $$MedicalConditionsTableReferences),
          MedicalConditionRecord,
          PrefetchHooks Function({bool profileId})
        > {
  $$MedicalConditionsTableTableManager(
    _$AppDatabase db,
    $MedicalConditionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalConditionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> diagnosedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalConditionsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                diagnosedDate: diagnosedDate,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String name,
                Value<String?> diagnosedDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalConditionsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                diagnosedDate: diagnosedDate,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicalConditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$MedicalConditionsTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$MedicalConditionsTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicalConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalConditionsTable,
      MedicalConditionRecord,
      $$MedicalConditionsTableFilterComposer,
      $$MedicalConditionsTableOrderingComposer,
      $$MedicalConditionsTableAnnotationComposer,
      $$MedicalConditionsTableCreateCompanionBuilder,
      $$MedicalConditionsTableUpdateCompanionBuilder,
      (MedicalConditionRecord, $$MedicalConditionsTableReferences),
      MedicalConditionRecord,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$EmergencyContactsTableCreateCompanionBuilder =
    EmergencyContactsCompanion Function({
      required String id,
      required String profileId,
      required String name,
      required String phone,
      Value<String?> relationship,
      Value<int> priority,
      Value<int> rowid,
    });
typedef $$EmergencyContactsTableUpdateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<String> name,
      Value<String> phone,
      Value<String?> relationship,
      Value<int> priority,
      Value<int> rowid,
    });

final class $$EmergencyContactsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContactRecord
        > {
  $$EmergencyContactsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias(
        $_aliasNameGenerator(db.emergencyContacts.profileId, db.profiles.id),
      );

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmergencyContactsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmergencyContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmergencyContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
    column: $table.relationship,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmergencyContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContactRecord,
          $$EmergencyContactsTableFilterComposer,
          $$EmergencyContactsTableOrderingComposer,
          $$EmergencyContactsTableAnnotationComposer,
          $$EmergencyContactsTableCreateCompanionBuilder,
          $$EmergencyContactsTableUpdateCompanionBuilder,
          (EmergencyContactRecord, $$EmergencyContactsTableReferences),
          EmergencyContactRecord,
          PrefetchHooks Function({bool profileId})
        > {
  $$EmergencyContactsTableTableManager(
    _$AppDatabase db,
    $EmergencyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> relationship = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyContactsCompanion(
                id: id,
                profileId: profileId,
                name: name,
                phone: phone,
                relationship: relationship,
                priority: priority,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required String name,
                required String phone,
                Value<String?> relationship = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyContactsCompanion.insert(
                id: id,
                profileId: profileId,
                name: name,
                phone: phone,
                relationship: relationship,
                priority: priority,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmergencyContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$EmergencyContactsTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$EmergencyContactsTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmergencyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyContactsTable,
      EmergencyContactRecord,
      $$EmergencyContactsTableFilterComposer,
      $$EmergencyContactsTableOrderingComposer,
      $$EmergencyContactsTableAnnotationComposer,
      $$EmergencyContactsTableCreateCompanionBuilder,
      $$EmergencyContactsTableUpdateCompanionBuilder,
      (EmergencyContactRecord, $$EmergencyContactsTableReferences),
      EmergencyContactRecord,
      PrefetchHooks Function({bool profileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$AllergiesTableTableManager get allergies =>
      $$AllergiesTableTableManager(_db, _db.allergies);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicalConditionsTableTableManager get medicalConditions =>
      $$MedicalConditionsTableTableManager(_db, _db.medicalConditions);
  $$EmergencyContactsTableTableManager get emergencyContacts =>
      $$EmergencyContactsTableTableManager(_db, _db.emergencyContacts);
}
