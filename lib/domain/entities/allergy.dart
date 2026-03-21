import 'package:equatable/equatable.dart';
import 'package:vitalglyph/core/constants/enums.dart';

class Allergy extends Equatable {
  const Allergy({
    required this.id,
    required this.name,
    required this.severity,
    this.reaction,
  });
  final String id;
  final String name;
  final AllergySeverity severity;
  final String? reaction;

  @override
  List<Object?> get props => [id, name, severity, reaction];
}
