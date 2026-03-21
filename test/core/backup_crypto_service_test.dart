import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vitalglyph/core/crypto/backup_crypto_service.dart';

void main() {
  late BackupCryptoService crypto;

  setUp(() {
    crypto = BackupCryptoService();
  });

  group('encryptJson', () {
    test('returns MEDID_BACKUP format string', () {
      final result = crypto.encryptJson('{"medid_version":1}', 'pass');
      final parts = result.split('|');

      expect(parts.length, 5);
      expect(parts[0], 'MEDID_BACKUP');
      expect(parts[1], 'v1');
      // parts[2] = salt base64, parts[3] = iv base64, parts[4] = ciphertext base64
      expect(() => base64.decode(parts[2]), returnsNormally);
      expect(() => base64.decode(parts[3]), returnsNormally);
      expect(() => base64.decode(parts[4]), returnsNormally);
    });

    test('different encryptions of same data differ (random salt/IV)', () {
      const json = '{"medid_version":1,"data":"hello"}';
      final a = crypto.encryptJson(json, 'pass');
      final b = crypto.encryptJson(json, 'pass');

      expect(a, isNot(equals(b)));
    });
  });

  group('decryptJson', () {
    test('roundtrip: encrypt then decrypt returns original', () {
      const original = '{"medid_version":1,"profiles":[]}';
      final encrypted = crypto.encryptJson(original, 'mySecret123');
      final decrypted = crypto.decryptJson(encrypted, 'mySecret123');

      expect(decrypted, original);
    });

    test('roundtrip with unicode characters', () {
      const original = '{"medid_version":1,"name":"José García 日本語"}';
      final encrypted = crypto.encryptJson(original, 'p@ss!');
      final decrypted = crypto.decryptJson(encrypted, 'p@ss!');

      expect(decrypted, original);
    });

    test('roundtrip with large payload', () {
      final largeData = jsonEncode({
        'medid_version': 1,
        'profiles': List.generate(50, (i) => {'id': 'profile-$i', 'name': 'User $i'}),
      });
      final encrypted = crypto.encryptJson(largeData, 'secret');
      final decrypted = crypto.decryptJson(encrypted, 'secret');

      expect(decrypted, largeData);
    });

    test('wrong passphrase throws BackupWrongPassphraseException', () {
      const json = '{"medid_version":1}';
      final encrypted = crypto.encryptJson(json, 'correctPass');

      expect(
        () => crypto.decryptJson(encrypted, 'wrongPass'),
        throwsA(isA<BackupWrongPassphraseException>()),
      );
    });

    test('invalid format throws BackupFormatException', () {
      expect(
        () => crypto.decryptJson('not a backup', 'pass'),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('wrong header throws BackupFormatException', () {
      expect(
        () => crypto.decryptJson('WRONG|v1|a|b|c', 'pass'),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('wrong version throws BackupFormatException', () {
      expect(
        () => crypto.decryptJson('MEDID_BACKUP|v99|a|b|c', 'pass'),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('too few parts throws BackupFormatException', () {
      expect(
        () => crypto.decryptJson('MEDID_BACKUP|v1|salt|iv', 'pass'),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('corrupted ciphertext throws BackupWrongPassphraseException', () {
      const json = '{"medid_version":1}';
      final encrypted = crypto.encryptJson(json, 'pass');
      final parts = encrypted.split('|');
      // Corrupt the ciphertext
      parts[4] = base64.encode([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
      final corrupted = parts.join('|');

      expect(
        () => crypto.decryptJson(corrupted, 'pass'),
        throwsA(isA<BackupWrongPassphraseException>()),
      );
    });

    test('valid decrypt but missing medid_version throws BackupWrongPassphraseException', () {
      // Encrypt JSON that doesn't have medid_version
      const json = '{"no_version":true}';
      final encrypted = crypto.encryptJson(json, 'pass');

      expect(
        () => crypto.decryptJson(encrypted, 'pass'),
        throwsA(isA<BackupWrongPassphraseException>()),
      );
    });
  });

  group('BackupFormatException', () {
    test('toString returns message', () {
      const exception = BackupFormatException('test message');
      expect(exception.toString(), 'test message');
      expect(exception.message, 'test message');
    });
  });

  group('BackupWrongPassphraseException', () {
    test('toString returns descriptive message', () {
      final exception = BackupWrongPassphraseException();
      expect(exception.toString(), contains('Wrong passphrase'));
    });
  });
}
