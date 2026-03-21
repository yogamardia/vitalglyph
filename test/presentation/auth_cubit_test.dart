import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';

class MockPinService extends Mock implements PinService {}

class MockAuthSettingsService extends Mock implements AuthSettingsService {}

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late MockPinService pin;
  late MockAuthSettingsService settings;
  late MockLocalAuthentication localAuth;

  setUp(() {
    pin = MockPinService();
    settings = MockAuthSettingsService();
    localAuth = MockLocalAuthentication();
  });

  AuthCubit buildCubit() =>
      AuthCubit(pin: pin, settings: settings, localAuth: localAuth);

  // ──────────────────────────────────────────────
  // checkAuthRequired
  // ──────────────────────────────────────────────

  group('checkAuthRequired', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthNotRequired when auth is disabled',
      setUp: () {
        when(() => settings.isAuthEnabled()).thenAnswer((_) async => false);
      },
      build: buildCubit,
      act: (c) => c.checkAuthRequired(),
      expect: () => [const AuthNotRequired()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthRequired with biometric=false, hasPin=true when bio disabled',
      setUp: () {
        when(() => settings.isAuthEnabled()).thenAnswer((_) async => true);
        when(
          () => settings.isBiometricEnabled(),
        ).thenAnswer((_) async => false);
        when(() => localAuth.isDeviceSupported()).thenAnswer((_) async => true);
        when(() => localAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(() => pin.hasPin()).thenAnswer((_) async => true);
      },
      build: buildCubit,
      act: (c) => c.checkAuthRequired(),
      expect: () => [
        const AuthRequired(canUseBiometric: false, hasPinSet: true),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthRequired with biometric=true when all bio checks pass',
      setUp: () {
        when(() => settings.isAuthEnabled()).thenAnswer((_) async => true);
        when(() => settings.isBiometricEnabled()).thenAnswer((_) async => true);
        when(() => localAuth.isDeviceSupported()).thenAnswer((_) async => true);
        when(() => localAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(() => pin.hasPin()).thenAnswer((_) async => false);
      },
      build: buildCubit,
      act: (c) => c.checkAuthRequired(),
      expect: () => [
        const AuthRequired(canUseBiometric: true, hasPinSet: false),
      ],
    );
  });

  // ──────────────────────────────────────────────
  // authenticateWithPin
  // ──────────────────────────────────────────────

  group('authenticateWithPin', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when PIN is correct',
      setUp: () {
        when(() => pin.verifyPin('123456')).thenAnswer((_) async => true);
      },
      build: buildCubit,
      act: (c) => c.authenticateWithPin('123456'),
      expect: () => [const AuthAuthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthFailure when PIN is incorrect',
      setUp: () {
        when(() => pin.verifyPin('000000')).thenAnswer((_) async => false);
      },
      build: buildCubit,
      act: (c) => c.authenticateWithPin('000000'),
      expect: () => [
        const AuthFailure(
          'Incorrect PIN. 4 attempts remaining before lockout.',
        ),
      ],
    );
  });

  // ──────────────────────────────────────────────
  // authenticateWithBiometric
  // ──────────────────────────────────────────────

  group('authenticateWithBiometric', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when biometric succeeds',
      setUp: () {
        when(
          () => localAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenAnswer((_) async => true);
      },
      build: buildCubit,
      act: (c) => c.authenticateWithBiometric(),
      expect: () => [const AuthAuthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthFailure when biometric returns false',
      setUp: () {
        when(
          () => localAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenAnswer((_) async => false);
      },
      build: buildCubit,
      act: (c) => c.authenticateWithBiometric(),
      expect: () => [const AuthFailure('Biometric authentication cancelled.')],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthFailure when biometric throws',
      setUp: () {
        when(
          () => localAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenThrow(Exception('hardware not available'));
      },
      build: buildCubit,
      act: (c) => c.authenticateWithBiometric(),
      expect: () => [
        isA<AuthFailure>().having(
          (s) => s.message,
          'message',
          contains('Biometric error'),
        ),
      ],
    );
  });

  // ──────────────────────────────────────────────
  // disable
  // ──────────────────────────────────────────────

  group('disable', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthNotRequired',
      build: buildCubit,
      act: (c) => c.disable(),
      expect: () => [const AuthNotRequired()],
    );
  });

  // ──────────────────────────────────────────────
  // onResumed
  // ──────────────────────────────────────────────

  group('onResumed', () {
    blocTest<AuthCubit, AuthState>(
      'does nothing when current state is not AuthAuthenticated',
      build: buildCubit,
      // Initial state is AuthInitial, not AuthAuthenticated
      act: (c) => c.onResumed(const Duration(minutes: 10)),
      expect: () => <AuthState>[],
    );

    blocTest<AuthCubit, AuthState>(
      'does nothing when auth is disabled',
      setUp: () {
        when(() => settings.isAuthEnabled()).thenAnswer((_) async => false);
        when(() => pin.verifyPin(any())).thenAnswer((_) async => true);
      },
      build: buildCubit,
      seed: () => const AuthAuthenticated(),
      act: (c) => c.onResumed(const Duration(minutes: 10)),
      expect: () => <AuthState>[],
    );

    blocTest<AuthCubit, AuthState>(
      'does nothing when timeout is never',
      setUp: () {
        when(() => settings.isAuthEnabled()).thenAnswer((_) async => true);
        when(
          () => settings.getLockTimeout(),
        ).thenAnswer((_) async => LockTimeout.never);
      },
      build: buildCubit,
      seed: () => const AuthAuthenticated(),
      act: (c) => c.onResumed(const Duration(hours: 1)),
      expect: () => <AuthState>[],
    );

    blocTest<AuthCubit, AuthState>(
      'locks when elapsed exceeds timeout',
      setUp: () {
        when(() => settings.isAuthEnabled()).thenAnswer((_) async => true);
        when(
          () => settings.getLockTimeout(),
        ).thenAnswer((_) async => LockTimeout.immediately);
        when(
          () => settings.isBiometricEnabled(),
        ).thenAnswer((_) async => false);
        when(
          () => localAuth.isDeviceSupported(),
        ).thenAnswer((_) async => false);
        when(() => localAuth.canCheckBiometrics).thenAnswer((_) async => false);
        when(() => pin.hasPin()).thenAnswer((_) async => true);
      },
      build: buildCubit,
      seed: () => const AuthAuthenticated(),
      act: (c) => c.onResumed(const Duration(seconds: 5)),
      expect: () => [
        const AuthRequired(canUseBiometric: false, hasPinSet: true),
      ],
    );
  });
}
