import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;
  late AuthSettingsService service;

  setUp(() {
    storage = MockSecureStorage();
    service = AuthSettingsService(storage);
  });

  group('isAuthEnabled / setAuthEnabled', () {
    test('returns false when key is absent', () async {
      when(() => storage.read(key: 'vitalglyph_auth_enabled'))
          .thenAnswer((_) async => null);

      expect(await service.isAuthEnabled(), isFalse);
    });

    test('returns true when stored value is "true"', () async {
      when(() => storage.read(key: 'vitalglyph_auth_enabled'))
          .thenAnswer((_) async => 'true');

      expect(await service.isAuthEnabled(), isTrue);
    });

    test('setAuthEnabled writes "true"/"false" string', () async {
      when(() => storage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.setAuthEnabled(enabled: true);
      verify(() => storage.write(key: 'vitalglyph_auth_enabled', value: 'true')).called(1);

      await service.setAuthEnabled(enabled: false);
      verify(() => storage.write(key: 'vitalglyph_auth_enabled', value: 'false')).called(1);
    });
  });

  group('isBiometricEnabled / setBiometricEnabled', () {
    test('returns false when key is absent', () async {
      when(() => storage.read(key: 'vitalglyph_biometric_enabled'))
          .thenAnswer((_) async => null);

      expect(await service.isBiometricEnabled(), isFalse);
    });

    test('returns true when stored value is "true"', () async {
      when(() => storage.read(key: 'vitalglyph_biometric_enabled'))
          .thenAnswer((_) async => 'true');

      expect(await service.isBiometricEnabled(), isTrue);
    });

    test('setBiometricEnabled writes correct string', () async {
      when(() => storage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.setBiometricEnabled(enabled: true);
      verify(() => storage.write(
            key: 'vitalglyph_biometric_enabled',
            value: 'true',
          )).called(1);
    });
  });

  group('getLockTimeout / setLockTimeout', () {
    test('returns LockTimeout.immediately when key is absent', () async {
      when(() => storage.read(key: 'vitalglyph_lock_timeout'))
          .thenAnswer((_) async => null);

      expect(await service.getLockTimeout(), LockTimeout.immediately);
    });

    test('returns correct enum value when stored', () async {
      when(() => storage.read(key: 'vitalglyph_lock_timeout'))
          .thenAnswer((_) async => 'after5Min');

      expect(await service.getLockTimeout(), LockTimeout.after5Min);
    });

    test('setLockTimeout writes enum name', () async {
      when(() => storage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await service.setLockTimeout(LockTimeout.after1Min);
      verify(() => storage.write(
            key: 'vitalglyph_lock_timeout',
            value: 'after1Min',
          )).called(1);
    });
  });
}
