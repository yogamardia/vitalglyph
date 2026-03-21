import 'package:equatable/equatable.dart';

class MedicalCondition extends Equatable {

  const MedicalCondition({
    required this.id,
    required this.name,
    this.diagnosedDate,
    this.notes,
  });
  final String id;
  final String name;
  final String? diagnosedDate;
  final String? notes;

  @override
  List<Object?> get props => [id, name, diagnosedDate, notes];
}
