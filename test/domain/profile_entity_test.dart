import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

void main() {
  final now = DateTime(2025, 1, 1);

  Profile makeProfile({String name = 'Alice'}) => Profile(
        id: 'id-1',
        name: name,
        dateOfBirth: DateTime(1990, 6, 15),
        bloodType: BloodType.oPos,
        isOrganDonor: false,
        createdAt: now,
        updatedAt: now,
      );

  group('Profile entity', () {
    test('equality holds for same data', () {
      final a = makeProfile();
      final b = makeProfile();
      expect(a, equals(b));
    });

    test('copyWith changes only specified fields', () {
      final original = makeProfile();
      final updated = original.copyWith(name: 'Bob');
      expect(updated.name, 'Bob');
      expect(updated.id, original.id);
      expect(updated.bloodType, original.bloodType);
    });

    test('two profiles with different names are not equal', () {
      expect(makeProfile(name: 'Alice'), isNot(equals(makeProfile(name: 'Bob'))));
    });

    test('empty lists default correctly', () {
      final p = makeProfile();
      expect(p.allergies, isEmpty);
      expect(p.medications, isEmpty);
      expect(p.conditions, isEmpty);
      expect(p.emergencyContacts, isEmpty);
    });
  });
}
