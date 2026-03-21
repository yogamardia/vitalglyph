import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

// ── Exceptions ────────────────────────────────────────────────────────────────

class BackupFormatException implements Exception {
  const BackupFormatException(this.message);
  final String message;
  @override
  String toString() => message;
}

class BackupWrongPassphraseException implements Exception {
  @override
  String toString() => 'Wrong passphrase or corrupted backup.';
}

// ── Service ───────────────────────────────────────────────────────────────────

/// Encrypts and decrypts Medical ID backup payloads using:
///   - PBKDF2-HMAC-SHA256 for key derivation (100 000 iterations)
///   - AES-256-CBC for symmetric encryption
///
/// Backup format (single line):
///   MEDID_BACKUP|v1|[salt_base64]|[iv_base64]|[ciphertext_base64]
class BackupCryptoService {
  static const _header = 'MEDID_BACKUP';
  static const _version = 'v1';
  static const _iterations = 100000;
  static const _keyLength = 32; // 256-bit key
  static const _saltLength = 16;

  final Random _rng = Random.secure();

  /// Encrypts [jsonData] with [passphrase] and returns a MEDID_BACKUP string.
  String encryptJson(String jsonData, String passphrase) {
    final salt = Uint8List.fromList(
      List.generate(_saltLength, (_) => _rng.nextInt(256)),
    );
    final keyBytes = _pbkdf2(passphrase, salt);
    final key = enc.Key(keyBytes);
    final iv = enc.IV.fromSecureRandom(16);

    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(utf8.encode(jsonData), iv: iv);

    return '$_header|$_version'
        '|${base64.encode(salt)}'
        '|${base64.encode(iv.bytes)}'
        '|${encrypted.base64}';
  }

  /// Decrypts a MEDID_BACKUP [payload] with [passphrase].
  ///
  /// Throws [BackupFormatException] if the payload format is invalid.
  /// Throws [BackupWrongPassphraseException] if decryption or JSON parsing fails.
  String decryptJson(String payload, String passphrase) {
    final parts = payload.trim().split('|');
    if (parts.length != 5 || parts[0] != _header || parts[1] != _version) {
      throw const BackupFormatException(
        'Not a valid Medical ID backup file.\n'
        'Make sure you selected a .medid file exported from this app.',
      );
    }

    try {
      final salt = base64.decode(parts[2]);
      final iv = enc.IV(base64.decode(parts[3]));
      final ciphertext = enc.Encrypted(base64.decode(parts[4]));

      final keyBytes = _pbkdf2(passphrase, salt);
      final key = enc.Key(keyBytes);

      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final decryptedBytes = encrypter.decryptBytes(ciphertext, iv: iv);
      final json = utf8.decode(decryptedBytes);

      // Verify the decrypted payload is our expected JSON schema.
      // A wrong passphrase will produce garbage that fails here.
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      if (decoded['medid_version'] == null) {
        throw BackupWrongPassphraseException();
      }

      return json;
    } on BackupFormatException {
      rethrow;
    } on BackupWrongPassphraseException {
      rethrow;
    } catch (_) {
      throw BackupWrongPassphraseException();
    }
  }

  // ── PBKDF2-HMAC-SHA256 ──────────────────────────────────────────────────────

  Uint8List _pbkdf2(String passphrase, List<int> salt) {
    final passwordBytes = utf8.encode(passphrase);
    final hmac = Hmac(sha256, passwordBytes);

    final derived = <int>[];
    var blockIndex = 1;

    while (derived.length < _keyLength) {
      // U1 = PRF(Password, Salt || INT(i))
      final saltBlock = [
        ...salt,
        (blockIndex >> 24) & 0xFF,
        (blockIndex >> 16) & 0xFF,
        (blockIndex >> 8) & 0xFF,
        blockIndex & 0xFF,
      ];

      var u = hmac.convert(saltBlock).bytes;
      final block = List<int>.from(u);

      for (var i = 1; i < _iterations; i++) {
        u = hmac.convert(u).bytes;
        for (var j = 0; j < block.length; j++) {
          block[j] ^= u[j];
        }
      }

      derived.addAll(block);
      blockIndex++;
    }

    return Uint8List.fromList(derived.sublist(0, _keyLength));
  }
}
