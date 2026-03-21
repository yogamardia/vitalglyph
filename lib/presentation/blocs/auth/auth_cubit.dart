import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitalglyph/core/constants/enums.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit({
    required PinService pin,
    required AuthSettingsService settings,
    required LocalAuthentication localAuth,
  })  : _pin = pin,
        _settings = settings,
        _localAuth = localAuth,
        super(const AuthInitial());
  final PinService _pin;
  final AuthSettingsService _settings;
  final LocalAuthentication _localAuth;

  int _failedAttempts = 0;
  DateTime? _lockoutUntil;

  static const int _softLockThreshold = 5;
  static const int _hardLockThreshold = 10;
  static const Duration _softLockDuration = Duration(seconds: 30);
  static const Duration _hardLockDuration = Duration(minutes: 5);

  /// Call on app start. Emits [AuthNotRequired] or [AuthRequired].
  Future<void> checkAuthRequired() async {
    final enabled = await _settings.isAuthEnabled();
    if (!enabled) {
      emit(const AuthNotRequired());
      return;
    }

    final canBio = await _isBiometricAvailable();
    final hasPin = await _pin.hasPin();
    emit(AuthRequired(canUseBiometric: canBio, hasPinSet: hasPin));
  }

  /// Called when the app resumes from background.
  Future<void> onResumed(Duration elapsed) async {
    if (state is! AuthAuthenticated) return;

    final enabled = await _settings.isAuthEnabled();
    if (!enabled) return;

    final timeout = await _settings.getLockTimeout();
    if (timeout == LockTimeout.never) return;

    if (elapsed >= timeout.duration) {
      await checkAuthRequired();
    }
  }

  /// Prompt biometric authentication.
  Future<void> authenticateWithBiometric() async {
    try {
      final success = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access your Medical ID',
        persistAcrossBackgrounding: true,
      );
      if (success) {
        emit(const AuthAuthenticated());
      } else {
        emit(const AuthFailure('Biometric authentication cancelled.'));
      }
    } catch (e) {
      emit(AuthFailure('Biometric error: $e'));
    }
  }

  /// Validate a PIN the user has entered.
  Future<void> authenticateWithPin(String pin) async {
    // Check if currently locked out.
    if (_lockoutUntil != null) {
      final remaining = _lockoutUntil!.difference(DateTime.now());
      if (remaining > Duration.zero) {
        emit(AuthLockedOut(remaining));
        return;
      } else {
        _lockoutUntil = null;
        _failedAttempts = 0;
      }
    }

    final correct = await _pin.verifyPin(pin);
    if (correct) {
      _failedAttempts = 0;
      _lockoutUntil = null;
      emit(const AuthAuthenticated());
    } else {
      _failedAttempts++;
      if (_failedAttempts >= _hardLockThreshold) {
        _lockoutUntil = DateTime.now().add(_hardLockDuration);
        emit(const AuthLockedOut(_hardLockDuration));
      } else if (_failedAttempts >= _softLockThreshold) {
        _lockoutUntil = DateTime.now().add(_softLockDuration);
        emit(const AuthLockedOut(_softLockDuration));
      } else {
        emit(AuthFailure(
          'Incorrect PIN. ${_softLockThreshold - _failedAttempts} attempts remaining before lockout.',
        ));
      }
    }
  }

  /// Returns the current lockout remaining duration, or null if not locked out.
  Duration? get lockoutRemaining {
    if (_lockoutUntil == null) return null;
    final remaining = _lockoutUntil!.difference(DateTime.now());
    return remaining > Duration.zero ? remaining : null;
  }

  /// Manually lock the app (e.g., from settings or after timeout).
  Future<void> lock() async {
    final enabled = await _settings.isAuthEnabled();
    if (enabled) await checkAuthRequired();
  }

  /// Called when auth is disabled from settings.
  void disable() => emit(const AuthNotRequired());

  Future<bool> _isBiometricAvailable() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      final bioEnabled = await _settings.isBiometricEnabled();
      return supported && canCheck && bioEnabled;
    } catch (_) {
      return false;
    }
  }
}
