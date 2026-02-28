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

enum LockTimeout {
  immediately,
  after1Min,
  after5Min,
  never;

  Duration get duration => switch (this) {
        LockTimeout.immediately => Duration.zero,
        LockTimeout.after1Min => const Duration(minutes: 1),
        LockTimeout.after5Min => const Duration(minutes: 5),
        LockTimeout.never => const Duration(days: 999),
      };

  String get displayName => switch (this) {
        LockTimeout.immediately => 'Immediately',
        LockTimeout.after1Min => 'After 1 minute',
        LockTimeout.after5Min => 'After 5 minutes',
        LockTimeout.never => 'Never',
      };

  static LockTimeout fromString(String value) {
    return LockTimeout.values.firstWhere(
      (e) => e.name == value,
      orElse: () => LockTimeout.immediately,
    );
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
