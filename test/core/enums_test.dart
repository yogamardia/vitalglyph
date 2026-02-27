import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/constants/enums.dart';

void main() {
  group('BloodType', () {
    test('displayName returns correct symbol', () {
      expect(BloodType.oPos.displayName, 'O+');
      expect(BloodType.abNeg.displayName, 'AB-');
      expect(BloodType.aNeg.displayName, 'A-');
    });

    test('fromString returns correct value by name', () {
      expect(BloodType.fromString('oPos'), BloodType.oPos);
      expect(BloodType.fromString('abNeg'), BloodType.abNeg);
    });

    test('fromString returns correct value by display name', () {
      expect(BloodType.fromString('O+'), BloodType.oPos);
      expect(BloodType.fromString('AB-'), BloodType.abNeg);
    });

    test('fromString returns null for unknown value', () {
      expect(BloodType.fromString('unknown'), isNull);
    });
  });

  group('AllergySeverity', () {
    test('displayName is human-readable', () {
      expect(AllergySeverity.lifeThreatening.displayName, 'Life-Threatening');
      expect(AllergySeverity.mild.displayName, 'Mild');
    });

    test('fromString round-trips correctly', () {
      for (final s in AllergySeverity.values) {
        expect(AllergySeverity.fromString(s.name), s);
      }
    });

    test('fromString returns null for unknown value', () {
      expect(AllergySeverity.fromString('critical'), isNull);
    });
  });

  group('BiologicalSex', () {
    test('displayName is human-readable', () {
      expect(BiologicalSex.male.displayName, 'Male');
      expect(BiologicalSex.other.displayName, 'Other');
    });

    test('fromString round-trips correctly', () {
      for (final s in BiologicalSex.values) {
        expect(BiologicalSex.fromString(s.name), s);
      }
    });
  });
}
