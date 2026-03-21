import 'package:equatable/equatable.dart';

class EmergencyContact extends Equatable {

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    this.relationship,
    this.priority = 1,
  });
  final String id;
  final String name;
  final String phone;
  final String? relationship;
  final int priority;

  @override
  List<Object?> get props => [id, name, phone, relationship, priority];
}
