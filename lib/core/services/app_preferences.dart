import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persistent app-level preferences (non-sensitive).
class AppPreferences {
  const AppPreferences(this._storage);
  final FlutterSecureStorage _storage;
  static const _onboardingKey = 'has_seen_onboarding';

  Future<bool> hasSeenOnboarding() async {
    return await _storage.read(key: _onboardingKey) == 'true';
  }

  Future<void> setOnboardingSeen() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }
}
