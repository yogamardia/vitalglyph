import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

/// Initial state — auth check not yet performed.
class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object?> get props => [];
}

/// Auth is disabled; no lock screen needed.
class AuthNotRequired extends AuthState {
  const AuthNotRequired();
  @override
  List<Object?> get props => [];
}

/// Auth is required — show the lock screen.
class AuthRequired extends AuthState {
  final bool canUseBiometric;
  final bool hasPinSet;

  const AuthRequired({
    required this.canUseBiometric,
    required this.hasPinSet,
  });

  @override
  List<Object?> get props => [canUseBiometric, hasPinSet];
}

/// User successfully authenticated.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
  @override
  List<Object?> get props => [];
}

/// An auth attempt failed.
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}

/// Too many failed attempts — locked out for [remaining] duration.
class AuthLockedOut extends AuthState {
  final Duration remaining;

  const AuthLockedOut(this.remaining);
  @override
  List<Object?> get props => [remaining];
}
