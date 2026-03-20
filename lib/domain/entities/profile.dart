import 'package:equatable/equatable.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';

const _sentinel = Object();

class Profile extends Equatable {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final BloodType? bloodType;
  final BiologicalSex? biologicalSex;
  final double? heightCm;
  final double? weightKg;
  final bool isOrganDonor;
  final String? medicalNotes;
  final String? primaryLanguage;
  final String? photoPath;
  final List<Allergy> allergies;
  final List<MedicalCondition> conditions;
  final List<Medication> medications;
  final List<EmergencyContact> emergencyContacts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    this.bloodType,
    this.biologicalSex,
    this.heightCm,
    this.weightKg,
    this.isOrganDonor = false,
    this.medicalNotes,
    this.primaryLanguage,
    this.photoPath,
    this.allergies = const [],
    this.conditions = const [],
    this.medications = const [],
    this.emergencyContacts = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Profile copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    Object? bloodType = _sentinel,
    Object? biologicalSex = _sentinel,
    Object? heightCm = _sentinel,
    Object? weightKg = _sentinel,
    bool? isOrganDonor,
    Object? medicalNotes = _sentinel,
    Object? primaryLanguage = _sentinel,
    Object? photoPath = _sentinel,
    List<Allergy>? allergies,
    List<MedicalCondition>? conditions,
    List<Medication>? medications,
    List<EmergencyContact>? emergencyContacts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodType: identical(bloodType, _sentinel)
          ? this.bloodType
          : bloodType as BloodType?,
      biologicalSex: identical(biologicalSex, _sentinel)
          ? this.biologicalSex
          : biologicalSex as BiologicalSex?,
      heightCm: identical(heightCm, _sentinel)
          ? this.heightCm
          : heightCm as double?,
      weightKg: identical(weightKg, _sentinel)
          ? this.weightKg
          : weightKg as double?,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      medicalNotes: identical(medicalNotes, _sentinel)
          ? this.medicalNotes
          : medicalNotes as String?,
      primaryLanguage: identical(primaryLanguage, _sentinel)
          ? this.primaryLanguage
          : primaryLanguage as String?,
      photoPath: identical(photoPath, _sentinel)
          ? this.photoPath
          : photoPath as String?,
      allergies: allergies ?? this.allergies,
      conditions: conditions ?? this.conditions,
      medications: medications ?? this.medications,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
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
        allergies,
        conditions,
        medications,
        emergencyContacts,
        createdAt,
        updatedAt,
      ];
}
