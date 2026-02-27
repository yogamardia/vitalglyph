import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';
import 'package:vitalglyph/domain/usecases/parse_qr_data.dart';

void main() {
  late HmacService hmac;
  late GenerateQrData generate;
  late ParseQrData parse;

  setUp(() {
    hmac = HmacService();
    generate = GenerateQrData(hmac);
    parse = ParseQrData(hmac);
  });

  Profile makeProfile({
    String name = 'Alice Smith',
    BloodType? bloodType = BloodType.oPos,
    List<Allergy> allergies = const [],
    List<Medication> medications = const [],
    List<MedicalCondition> conditions = const [],
    List<EmergencyContact> emergencyContacts = const [],
    bool isOrganDonor = false,
    BiologicalSex? biologicalSex,
    double? heightCm,
    double? weightKg,
    String? primaryLanguage,
  }) {
    final now = DateTime(2025, 1, 1);
    return Profile(
      id: 'id-1',
      name: name,
      dateOfBirth: DateTime(1990, 6, 15),
      bloodType: bloodType,
      biologicalSex: biologicalSex,
      heightCm: heightCm,
      weightKg: weightKg,
      isOrganDonor: isOrganDonor,
      primaryLanguage: primaryLanguage,
      allergies: allergies,
      medications: medications,
      conditions: conditions,
      emergencyContacts: emergencyContacts,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('GenerateQrData', () {
    test('output starts with MEDID|v1', () {
      final qr = generate(makeProfile());
      expect(qr.startsWith('MEDID|v1'), isTrue);
    });

    test('output contains name field', () {
      final qr = generate(makeProfile(name: 'Bob Jones'));
      expect(qr.contains('N:Bob Jones'), isTrue);
    });

    test('output contains blood type in display format', () {
      final qr = generate(makeProfile(bloodType: BloodType.abNeg));
      expect(qr.contains('BT:AB-'), isTrue);
    });

    test('output ends with SIG field', () {
      final qr = generate(makeProfile());
      expect(qr.contains('|SIG:'), isTrue);
    });

    test('organ donor flag encoded as Y/N', () {
      expect(generate(makeProfile(isOrganDonor: true)).contains('DONOR:Y'),
          isTrue);
      expect(generate(makeProfile(isOrganDonor: false)).contains('DONOR:N'),
          isTrue);
    });

    test('special chars in name are percent-encoded', () {
      final qr = generate(makeProfile(name: 'O\'Brien, Jr.'));
      // commas must be encoded
      expect(qr.contains('N:O\'Brien%2C Jr.'), isTrue);
    });

    test('QR payload fits within 2953 bytes for typical profile', () {
      final allergy = Allergy(
        id: 'a1',
        name: 'Penicillin',
        severity: AllergySeverity.severe,
        reaction: 'Anaphylaxis',
      );
      final med = Medication(
        id: 'm1',
        name: 'Metformin',
        dosage: '500mg',
        frequency: '2x daily',
      );
      final cond = MedicalCondition(id: 'c1', name: 'Type 2 Diabetes');
      final contact = EmergencyContact(
        id: 'ec1',
        name: 'Jane Smith',
        phone: '+15551234567',
        relationship: 'Spouse',
        priority: 1,
      );

      final profile = makeProfile(
        allergies: [allergy],
        medications: [med],
        conditions: [cond],
        emergencyContacts: [contact],
      );

      final qr = generate(profile);
      expect(qr.length, lessThanOrEqualTo(2953));
    });
  });

  group('ParseQrData', () {
    test('returns ValidationFailure for non-MEDID string', () {
      final result = parse('https://example.com');
      expect(result.isLeft(), isTrue);
    });

    test('returns ValidationFailure for MEDID without name', () {
      final result = parse('MEDID|v1|DOB:1990-01-01');
      expect(result.isLeft(), isTrue);
    });

    test('parses name correctly', () {
      final qr = generate(makeProfile(name: 'Test User'));
      final result = parse(qr);
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should be Right'),
        (p) => expect(p.name, 'Test User'),
      );
    });

    test('roundtrip: all fields survive encode → decode', () {
      final allergy = Allergy(
        id: 'a1',
        name: 'Shellfish',
        severity: AllergySeverity.moderate,
        reaction: 'Hives',
      );
      final med = Medication(
        id: 'm1',
        name: 'Lisinopril',
        dosage: '10mg',
        frequency: '1x daily',
      );
      final cond = MedicalCondition(id: 'c1', name: 'Hypertension');
      final contact = EmergencyContact(
        id: 'ec1',
        name: 'Bob Smith',
        phone: '+15559876543',
        relationship: 'Brother',
        priority: 1,
      );

      final profile = makeProfile(
        name: 'Alice Smith',
        bloodType: BloodType.oPos,
        biologicalSex: BiologicalSex.female,
        heightCm: 165.0,
        weightKg: 60.0,
        isOrganDonor: true,
        primaryLanguage: 'en',
        allergies: [allergy],
        medications: [med],
        conditions: [cond],
        emergencyContacts: [contact],
      );

      final qr = generate(profile);
      final result = parse(qr);

      result.fold(
        (f) => fail('Expected Right, got: $f'),
        (scanned) {
          expect(scanned.name, 'Alice Smith');
          expect(scanned.bloodType, 'O+');
          expect(scanned.heightCm, 165.0);
          expect(scanned.weightKg, 60.0);
          expect(scanned.isOrganDonor, isTrue);
          expect(scanned.language, 'en');
          expect(scanned.signatureValid, isTrue);

          expect(scanned.allergies.length, 1);
          expect(scanned.allergies.first.name, 'Shellfish');
          expect(scanned.allergies.first.severity, 'moderate');
          expect(scanned.allergies.first.reaction, 'Hives');

          expect(scanned.medications.length, 1);
          expect(scanned.medications.first, contains('Lisinopril'));

          expect(scanned.conditions.length, 1);
          expect(scanned.conditions.first, 'Hypertension');

          expect(scanned.emergencyContacts.length, 1);
          expect(scanned.emergencyContacts.first.name, 'Bob Smith');
          expect(scanned.emergencyContacts.first.phone, '+15559876543');
          expect(scanned.emergencyContacts.first.relationship, 'Brother');
        },
      );
    });

    test('signatureValid is false when payload is tampered', () {
      final qr = generate(makeProfile(name: 'Alice'));
      // Tamper by replacing name in the raw string
      final tampered = qr.replaceFirst('N:Alice', 'N:Mallory');
      final result = parse(tampered);
      result.fold(
        (f) => fail('Should parse but with invalid sig'),
        (scanned) {
          expect(scanned.name, 'Mallory');
          expect(scanned.signatureValid, isFalse);
        },
      );
    });

    test('special chars in name roundtrip correctly', () {
      final profile = makeProfile(name: "O'Brien, Jr.");
      final qr = generate(profile);
      final result = parse(qr);
      result.fold(
        (f) => fail('Expected Right: $f'),
        (scanned) => expect(scanned.name, "O'Brien, Jr."),
      );
    });

    test('profile with no optional fields parses correctly', () {
      final now = DateTime(2025);
      final profile = Profile(
        id: 'x',
        name: 'Minimal User',
        dateOfBirth: DateTime(2000),
        isOrganDonor: false,
        createdAt: now,
        updatedAt: now,
      );
      final result = parse(generate(profile));
      result.fold(
        (f) => fail('Expected Right: $f'),
        (scanned) {
          expect(scanned.name, 'Minimal User');
          expect(scanned.bloodType, isNull);
          expect(scanned.allergies, isEmpty);
          expect(scanned.medications, isEmpty);
        },
      );
    });
  });
}
