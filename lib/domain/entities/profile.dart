import 'package:equatable/equatable.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';

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
    BloodType? bloodType,
    BiologicalSex? biologicalSex,
    double? heightCm,
    double? weightKg,
    bool? isOrganDonor,
    String? medicalNotes,
    String? primaryLanguage,
    String? photoPath,
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
      bloodType: bloodType ?? this.bloodType,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      primaryLanguage: primaryLanguage ?? this.primaryLanguage,
      photoPath: photoPath ?? this.photoPath,
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
