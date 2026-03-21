import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the database master encryption key.
///
/// On first launch, a 32-byte random key is generated and stored in the
/// OS-level secure storage (iOS Keychain / Android Keystore via
/// EncryptedSharedPreferences). Subsequent launches retrieve the same key.
///
/// The key is stored as a 64-character hex string and passed directly to
/// SQLCipher via PRAGMA key. This is intentionally separate from the PIN —
/// the key protects the database file at rest, even if the device is seized
/// without unlocking the app.
class EncryptionService {

  EncryptionService(this._storage);
  static const _dbKeyStorageKey = 'vitalglyph_db_master_key';

  final FlutterSecureStorage _storage;

  /// Returns the existing database key or creates a new one.
  Future<String> getOrCreateDatabaseKey() async {
    var key = await _storage.read(key: _dbKeyStorageKey);
    if (key == null) {
      key = _generateHexKey(32);
      await _storage.write(key: _dbKeyStorageKey, value: key);
    }
    return key;
  }

  /// Generates [byteLength] cryptographically random bytes as a hex string.
  static String _generateHexKey(int byteLength) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteLength, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
