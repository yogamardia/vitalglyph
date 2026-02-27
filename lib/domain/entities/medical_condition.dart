import 'package:equatable/equatable.dart';

class MedicalCondition extends Equatable {
  final String id;
  final String name;
  final String? diagnosedDate;
  final String? notes;

  const MedicalCondition({
    required this.id,
    required this.name,
    this.diagnosedDate,
    this.notes,
  });

  @override
  List<Object?> get props => [id, name, diagnosedDate, notes];
}
