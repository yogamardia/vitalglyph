import 'package:equatable/equatable.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profiles);
  final List<Profile> profiles;

  @override
  List<Object?> get props => [profiles];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileActionSuccess extends ProfileState {
  const ProfileActionSuccess(this.profiles);
  final List<Profile> profiles;

  @override
  List<Object?> get props => [profiles];
}
