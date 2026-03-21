import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores and verifies a user PIN using SHA-256 with a random salt.
///
/// The PIN is never stored in plaintext. Only the salt and the derived hash
/// are persisted in secure storage.
class PinService {
  PinService(this._storage);
  static const _pinHashKey = 'vitalglyph_pin_hash';
  static const _pinSaltKey = 'vitalglyph_pin_salt';

  final FlutterSecureStorage _storage;

  /// Returns true if a PIN has been configured.
  Future<bool> hasPin() async {
    return _storage.containsKey(key: _pinHashKey);
  }

  /// Hashes and stores [pin]. Overwrites any existing PIN.
  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _storage.write(key: _pinSaltKey, value: salt);
    await _storage.write(key: _pinHashKey, value: hash);
  }

  /// Returns true if [pin] matches the stored hash.
  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _pinSaltKey);
    final storedHash = await _storage.read(key: _pinHashKey);
    if (salt == null || storedHash == null) return false;
    return _hashPin(pin, salt) == storedHash;
  }

  /// Removes the stored PIN hash and salt.
  Future<void> clearPin() async {
    await _storage.delete(key: _pinHashKey);
    await _storage.delete(key: _pinSaltKey);
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  static String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  static String _hashPin(String pin, String salt) {
    final input = utf8.encode('$salt:$pin');
    return sha256.convert(input).toString();
  }
}
