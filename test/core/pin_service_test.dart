import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockSecureStorage storage;
  late PinService pinService;

  setUp(() {
    storage = MockSecureStorage();
    pinService = PinService(storage);
  });

  group('hasPin', () {
    test('returns true when hash key exists', () async {
      when(
        () => storage.containsKey(key: 'vitalglyph_pin_hash'),
      ).thenAnswer((_) async => true);

      expect(await pinService.hasPin(), isTrue);
    });

    test('returns false when hash key does not exist', () async {
      when(
        () => storage.containsKey(key: 'vitalglyph_pin_hash'),
      ).thenAnswer((_) async => false);

      expect(await pinService.hasPin(), isFalse);
    });
  });

  group('setPin / verifyPin', () {
    late String capturedSalt;
    late String capturedHash;

    setUp(() {
      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((invocation) async {
        final key = invocation.namedArguments[#key] as String;
        final value = invocation.namedArguments[#value] as String;
        if (key == 'vitalglyph_pin_salt') capturedSalt = value;
        if (key == 'vitalglyph_pin_hash') capturedHash = value;
      });
    });

    test('verifyPin returns true for correct PIN after setPin', () async {
      await pinService.setPin('123456');

      when(
        () => storage.read(key: 'vitalglyph_pin_salt'),
      ).thenAnswer((_) async => capturedSalt);
      when(
        () => storage.read(key: 'vitalglyph_pin_hash'),
      ).thenAnswer((_) async => capturedHash);

      expect(await pinService.verifyPin('123456'), isTrue);
    });

    test('verifyPin returns false for wrong PIN', () async {
      await pinService.setPin('123456');

      when(
        () => storage.read(key: 'vitalglyph_pin_salt'),
      ).thenAnswer((_) async => capturedSalt);
      when(
        () => storage.read(key: 'vitalglyph_pin_hash'),
      ).thenAnswer((_) async => capturedHash);

      expect(await pinService.verifyPin('000000'), isFalse);
    });

    test('different PINs produce different hashes', () async {
      String? hash1;
      String? hash2;

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((invocation) async {
        final key = invocation.namedArguments[#key] as String;
        final value = invocation.namedArguments[#value] as String;
        if (key == 'vitalglyph_pin_hash') hash1 = value;
      });
      await pinService.setPin('111111');

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((invocation) async {
        final key = invocation.namedArguments[#key] as String;
        final value = invocation.namedArguments[#value] as String;
        if (key == 'vitalglyph_pin_hash') hash2 = value;
      });
      await pinService.setPin('222222');

      expect(hash1, isNotNull);
      expect(hash2, isNotNull);
      expect(hash1, isNot(equals(hash2)));
    });
  });

  group('verifyPin', () {
    test('returns false when no PIN is stored', () async {
      when(
        () => storage.read(key: 'vitalglyph_pin_salt'),
      ).thenAnswer((_) async => null);
      when(
        () => storage.read(key: 'vitalglyph_pin_hash'),
      ).thenAnswer((_) async => null);

      expect(await pinService.verifyPin('123456'), isFalse);
    });
  });

  group('clearPin', () {
    test('deletes both hash and salt keys', () async {
      when(
        () => storage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      await pinService.clearPin();

      verify(() => storage.delete(key: 'vitalglyph_pin_hash')).called(1);
      verify(() => storage.delete(key: 'vitalglyph_pin_salt')).called(1);
    });
  });
}
