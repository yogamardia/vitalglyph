import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/crypto/hmac_service.dart';

void main() {
  late HmacService svc;

  setUp(() => svc = HmacService());

  group('HmacService', () {
    test('sign returns 16-character hex string', () {
      final sig = svc.sign('MEDID|v1|N:Alice');
      expect(sig.length, 16);
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(sig), isTrue);
    });

    test('same payload always produces same signature (deterministic)', () {
      const payload = 'MEDID|v1|N:John Doe|DOB:1985-03-15';
      expect(svc.sign(payload), svc.sign(payload));
    });

    test('different payloads produce different signatures', () {
      expect(svc.sign('payload-a'), isNot(svc.sign('payload-b')));
    });

    test('verify returns true for valid signature', () {
      const payload = 'MEDID|v1|N:Alice|DOB:1990-01-01';
      final sig = svc.sign(payload);
      expect(svc.verify(payload, sig), isTrue);
    });

    test('verify returns false for tampered payload', () {
      const payload = 'MEDID|v1|N:Alice|DOB:1990-01-01';
      final sig = svc.sign(payload);
      expect(svc.verify('MEDID|v1|N:Mallory|DOB:1990-01-01', sig), isFalse);
    });

    test('verify returns false for truncated signature', () {
      const payload = 'MEDID|v1|N:Alice';
      expect(svc.verify(payload, 'badc0ffee'), isFalse);
    });
  });
}
