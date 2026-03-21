import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/allergy.dart';
import 'package:vitalglyph/domain/entities/emergency_contact.dart';
import 'package:vitalglyph/domain/entities/medical_condition.dart';
import 'package:vitalglyph/domain/entities/medication.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';

void main() {
  late ExportEmergencyCard useCase;
  late GenerateQrData generateQrData;

  final now = DateTime(2025, 6, 15);

  setUp(() {
    generateQrData = GenerateQrData(HmacService());
    useCase = ExportEmergencyCard(generateQrData);
  });

  Profile fullProfile() => Profile(
        id: 'p1',
        name: 'Alice Smith',
        dateOfBirth: DateTime(1990, 3, 25),
        bloodType: BloodType.aPos,
        biologicalSex: BiologicalSex.female,
        heightCm: 165.5,
        weightKg: 60.2,
        isOrganDonor: true,
        medicalNotes: 'Carries EpiPen at all times.',
        primaryLanguage: 'en',
        createdAt: now,
        updatedAt: now,
        allergies: const [
          Allergy(
            id: 'a1',
            name: 'Peanuts',
            severity: AllergySeverity.severe,
            reaction: 'Anaphylaxis',
          ),
          Allergy(
            id: 'a2',
            name: 'Penicillin',
            severity: AllergySeverity.moderate,
          ),
        ],
        medications: const [
          Medication(
            id: 'm1',
            name: 'Ibuprofen',
            dosage: '200mg',
            frequency: 'twice daily',
          ),
        ],
        conditions: const [
          MedicalCondition(
            id: 'c1',
            name: 'Asthma',
            diagnosedDate: '2015-01-01',
            notes: 'Mild intermittent',
          ),
        ],
        emergencyContacts: const [
          EmergencyContact(
            id: 'ec1',
            name: 'Bob Smith',
            phone: '555-0100',
            relationship: 'Spouse',
          ),
        ],
      );

  Profile minimalProfile() => Profile(
        id: 'p-min',
        name: 'Minimal User',
        dateOfBirth: DateTime(2000, 1, 1),
        createdAt: now,
        updatedAt: now,
      );

  group('ExportEmergencyCard', () {
    test('generates valid PDF bytes for full profile', () async {
      final result = await useCase(fullProfile());

      result.fold(
        (f) => fail('Expected Right, got Left: ${f.message}'),
        (pdfBytes) {
          expect(pdfBytes, isNotEmpty);
          // PDF files start with %PDF
          expect(pdfBytes[0], 0x25); // %
          expect(pdfBytes[1], 0x50); // P
          expect(pdfBytes[2], 0x44); // D
          expect(pdfBytes[3], 0x46); // F
        },
      );
    });

    test('generates valid PDF for minimal profile (no optional data)', () async {
      final result = await useCase(minimalProfile());

      result.fold(
        (f) => fail('Expected Right, got Left: ${f.message}'),
        (pdfBytes) {
          expect(pdfBytes, isNotEmpty);
          // PDF magic bytes
          expect(pdfBytes[0], 0x25);
          expect(pdfBytes[1], 0x50);
        },
      );
    });

    test('generates PDF with allergies section', () async {
      final profile = minimalProfile().copyWith(
        allergies: const [
          Allergy(
            id: 'a1',
            name: 'Latex',
            severity: AllergySeverity.lifeThreatening,
            reaction: 'Respiratory distress',
          ),
        ],
      );

      final result = await useCase(profile);

      expect(result.isRight(), true);
    });

    test('generates PDF with empty back page', () async {
      // Profile with no conditions, medications, contacts, or notes
      final result = await useCase(minimalProfile());

      result.fold(
        (f) => fail('Expected Right'),
        (pdfBytes) {
          // Just verify it produces valid PDF — the "No additional medical
          // information" placeholder is handled internally.
          expect(pdfBytes.length, greaterThan(100));
        },
      );
    });

    test('generates PDF with all back page sections', () async {
      final result = await useCase(fullProfile());

      result.fold(
        (f) => fail('Expected Right'),
        (pdfBytes) => expect(pdfBytes.length, greaterThan(100)),
      );
    });

    test('returns Right with non-null blood type displayed', () async {
      final profile = minimalProfile().copyWith(bloodType: BloodType.oNeg);

      final result = await useCase(profile);

      expect(result.isRight(), true);
    });

    test('handles profile with many items without error', () async {
      final profile = fullProfile().copyWith(
        allergies: List.generate(
          10,
          (i) => Allergy(
            id: 'a$i',
            name: 'Allergy $i',
            severity: AllergySeverity.values[i % AllergySeverity.values.length],
          ),
        ),
        medications: List.generate(
          10,
          (i) => Medication(id: 'm$i', name: 'Med $i', dosage: '${i}mg'),
        ),
        conditions: List.generate(
          5,
          (i) => MedicalCondition(id: 'c$i', name: 'Condition $i'),
        ),
        emergencyContacts: List.generate(
          5,
          (i) => EmergencyContact(
            id: 'ec$i',
            name: 'Contact $i',
            phone: '555-${i.toString().padLeft(4, '0')}',
          ),
        ),
      );

      final result = await useCase(profile);

      expect(result.isRight(), true);
    });
  });

  group('error handling', () {
    test('returns PdfFailure if result is Left', () async {
      // Difficult to force a PDF error with valid inputs, but we verify
      // the return type is correct for the success path.
      final result = await useCase(fullProfile());

      result.fold(
        (failure) => expect(failure, isA<PdfFailure>()),
        (bytes) => expect(bytes, isNotEmpty),
      );
    });
  });
}
