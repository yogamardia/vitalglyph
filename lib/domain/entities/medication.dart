import 'package:equatable/equatable.dart';

class Medication extends Equatable {

  const Medication({
    required this.id,
    required this.name,
    this.dosage,
    this.frequency,
    this.prescribedFor,
  });
  final String id;
  final String name;
  final String? dosage;
  final String? frequency;
  final String? prescribedFor;

  @override
  List<Object?> get props => [id, name, dosage, frequency, prescribedFor];
}
