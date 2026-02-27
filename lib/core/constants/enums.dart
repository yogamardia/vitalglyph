enum BloodType {
  aPos,
  aNeg,
  bPos,
  bNeg,
  abPos,
  abNeg,
  oPos,
  oNeg;

  String get displayName {
    switch (this) {
      case BloodType.aPos:
        return 'A+';
      case BloodType.aNeg:
        return 'A-';
      case BloodType.bPos:
        return 'B+';
      case BloodType.bNeg:
        return 'B-';
      case BloodType.abPos:
        return 'AB+';
      case BloodType.abNeg:
        return 'AB-';
      case BloodType.oPos:
        return 'O+';
      case BloodType.oNeg:
        return 'O-';
    }
  }

  static BloodType? fromString(String value) {
    for (final type in BloodType.values) {
      if (type.name == value || type.displayName == value) return type;
    }
    return null;
  }
}

enum AllergySeverity {
  mild,
  moderate,
  severe,
  lifeThreatening;

  String get displayName {
    switch (this) {
      case AllergySeverity.mild:
        return 'Mild';
      case AllergySeverity.moderate:
        return 'Moderate';
      case AllergySeverity.severe:
        return 'Severe';
      case AllergySeverity.lifeThreatening:
        return 'Life-Threatening';
    }
  }

  static AllergySeverity? fromString(String value) {
    for (final s in AllergySeverity.values) {
      if (s.name == value) return s;
    }
    return null;
  }
}

enum BiologicalSex {
  male,
  female,
  other;

  String get displayName {
    switch (this) {
      case BiologicalSex.male:
        return 'Male';
      case BiologicalSex.female:
        return 'Female';
      case BiologicalSex.other:
        return 'Other';
    }
  }

  static BiologicalSex? fromString(String value) {
    for (final s in BiologicalSex.values) {
      if (s.name == value) return s;
    }
    return null;
  }
}
