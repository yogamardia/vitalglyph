import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vitalglyph/core/constants/enums.dart';

/// Persists user preferences for the app-lock feature.
class AuthSettingsService {

  AuthSettingsService(this._storage);
  static const _authEnabledKey = 'vitalglyph_auth_enabled';
  static const _biometricEnabledKey = 'vitalglyph_biometric_enabled';
  static const _lockTimeoutKey = 'vitalglyph_lock_timeout';

  final FlutterSecureStorage _storage;

  Future<bool> isAuthEnabled() async {
    return await _storage.read(key: _authEnabledKey) == 'true';
  }

  Future<void> setAuthEnabled({required bool enabled}) async {
    await _storage.write(key: _authEnabledKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    return await _storage.read(key: _biometricEnabledKey) == 'true';
  }

  Future<void> setBiometricEnabled({required bool enabled}) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  Future<LockTimeout> getLockTimeout() async {
    final raw = await _storage.read(key: _lockTimeoutKey);
    return raw != null ? LockTimeout.fromString(raw) : LockTimeout.immediately;
  }

  Future<void> setLockTimeout(LockTimeout timeout) async {
    await _storage.write(key: _lockTimeoutKey, value: timeout.name);
  }
}
