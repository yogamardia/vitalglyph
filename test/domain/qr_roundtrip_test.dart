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
    final now = DateTime(2025);
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
      final result = generate(makeProfile());
      expect(result.data.startsWith('MEDID|v1'), isTrue);
      expect(result.truncated, isFalse);
    });

    test('output contains name field', () {
      final result = generate(makeProfile(name: 'Bob Jones'));
      expect(result.data.contains('N:Bob Jones'), isTrue);
    });

    test('output contains blood type in display format', () {
      final result = generate(makeProfile(bloodType: BloodType.abNeg));
      expect(result.data.contains('BT:AB-'), isTrue);
    });

    test('output ends with SIG field', () {
      final result = generate(makeProfile());
      expect(result.data.contains('|SIG:'), isTrue);
    });

    test('organ donor flag encoded as Y/N', () {
      expect(
        generate(makeProfile(isOrganDonor: true)).data.contains('DONOR:Y'),
        isTrue,
      );
      expect(
        generate(makeProfile()).data.contains('DONOR:N'),
        isTrue,
      );
    });

    test('special chars in name are percent-encoded', () {
      final result = generate(makeProfile(name: "O'Brien, Jr."));
      expect(result.data.contains("N:O'Brien%2C Jr."), isTrue);
    });

    test('typical profile fits within QR capacity without truncation', () {
      const allergy = Allergy(
        id: 'a1',
        name: 'Penicillin',
        severity: AllergySeverity.severe,
        reaction: 'Anaphylaxis',
      );
      const med = Medication(
        id: 'm1',
        name: 'Metformin',
        dosage: '500mg',
        frequency: '2x daily',
      );
      const cond = MedicalCondition(id: 'c1', name: 'Type 2 Diabetes');
      const contact = EmergencyContact(
        id: 'ec1',
        name: 'Jane Smith',
        phone: '+15551234567',
        relationship: 'Spouse',
      );

      final result = generate(makeProfile(
        allergies: [allergy],
        medications: [med],
        conditions: [cond],
        emergencyContacts: [contact],
      ));

      expect(result.data.length, lessThanOrEqualTo(2953));
      expect(result.truncated, isFalse);
    });

    test('oversized profile is truncated to fit QR capacity', () {
      final allergies = List.generate(
        20,
        (i) => Allergy(
          id: 'a$i',
          name: 'Allergy Number $i With A Very Long Name',
          severity: AllergySeverity.severe,
          reaction: 'Very severe reaction requiring immediate treatment $i',
        ),
      );
      final medications = List.generate(
        20,
        (i) => Medication(
          id: 'm$i',
          name: 'Medication Number $i With Extended Name',
          dosage: '${(i + 1) * 100}mg extended release',
          frequency: 'Every $i hours with food and water',
        ),
      );
      final conditions = List.generate(
        15,
        (i) => MedicalCondition(
          id: 'c$i',
          name: 'Medical Condition Number $i Description',
        ),
      );
      final contacts = List.generate(
        10,
        (i) => EmergencyContact(
          id: 'ec$i',
          name: 'Emergency Contact Person $i',
          phone: '+1555000${i.toString().padLeft(4, '0')}',
          relationship: 'Family Member',
          priority: i + 1,
        ),
      );

      final result = generate(makeProfile(
        name: 'Patient With A Reasonably Long Full Name',
        allergies: allergies,
        medications: medications,
        conditions: conditions,
        emergencyContacts: contacts,
      ));

      expect(result.truncated, isTrue);
      expect(
        result.data.length,
        lessThanOrEqualTo(GenerateQrData.maxPayloadBytes),
      );
      // Core identity fields are always preserved
      expect(
        result.data.contains('N:Patient With A Reasonably Long Full Name'),
        isTrue,
      );
      expect(result.data.startsWith('MEDID|v1'), isTrue);
      expect(result.data.contains('|SIG:'), isTrue);
    });

    test('truncated payload is still parseable', () {
      final allergies = List.generate(
        25,
        (i) => Allergy(
          id: 'a$i',
          name: 'Allergy$i',
          severity: AllergySeverity.moderate,
          reaction: 'A moderately long reaction description for allergy $i',
        ),
      );
      final medications = List.generate(
        25,
        (i) => Medication(
          id: 'm$i',
          name: 'Medication$i',
          dosage: '${(i + 1) * 50}mg',
          frequency: 'Every $i hours',
        ),
      );
      final contacts = List.generate(
        10,
        (i) => EmergencyContact(
          id: 'ec$i',
          name: 'Contact$i',
          phone: '+1555${i.toString().padLeft(7, '0')}',
          relationship: 'Family',
          priority: i + 1,
        ),
      );

      final result = generate(makeProfile(
        allergies: allergies,
        medications: medications,
        emergencyContacts: contacts,
      ));

      // Payload should still parse successfully
      final parsed = parse(result.data);
      expect(parsed.isRight(), isTrue);
      parsed.match(
        (_) => fail('Should parse'),
        (scanned) {
          expect(scanned.name, 'Alice Smith');
          // Allergy names survive truncation (only reactions are dropped)
          for (final a in scanned.allergies) {
            expect(a.name, startsWith('Allergy'));
          }
        },
      );
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
      final qr = generate(makeProfile(name: 'Test User')).data;
      final result = parse(qr);
      expect(result.isRight(), isTrue);
      result.match(
        (_) => fail('Should be Right'),
        (p) => expect(p.name, 'Test User'),
      );
    });

    test('roundtrip: all fields survive encode → decode', () {
      const allergy = Allergy(
        id: 'a1',
        name: 'Shellfish',
        severity: AllergySeverity.moderate,
        reaction: 'Hives',
      );
      const med = Medication(
        id: 'm1',
        name: 'Lisinopril',
        dosage: '10mg',
        frequency: '1x daily',
      );
      const cond = MedicalCondition(id: 'c1', name: 'Hypertension');
      const contact = EmergencyContact(
        id: 'ec1',
        name: 'Bob Smith',
        phone: '+15559876543',
        relationship: 'Brother',
      );

      final profile = makeProfile(
        biologicalSex: BiologicalSex.female,
        heightCm: 165,
        weightKg: 60,
        isOrganDonor: true,
        primaryLanguage: 'en',
        allergies: [allergy],
        medications: [med],
        conditions: [cond],
        emergencyContacts: [contact],
      );

      final qr = generate(profile).data;
      final result = parse(qr);

      result.match(
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
      final qr = generate(makeProfile(name: 'Alice')).data;
      // Tamper by replacing name in the raw string
      final tampered = qr.replaceFirst('N:Alice', 'N:Mallory');
      final result = parse(tampered);
      result.match(
        (f) => fail('Should parse but with invalid sig'),
        (scanned) {
          expect(scanned.name, 'Mallory');
          expect(scanned.signatureValid, isFalse);
        },
      );
    });

    test('special chars in name roundtrip correctly', () {
      final profile = makeProfile(name: "O'Brien, Jr.");
      final qr = generate(profile).data;
      final result = parse(qr);
      result.match(
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
        createdAt: now,
        updatedAt: now,
      );
      final result = parse(generate(profile).data);
      result.match(
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
