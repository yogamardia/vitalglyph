import 'package:equatable/equatable.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfilesWatchStarted extends ProfileEvent {
  const ProfilesWatchStarted();
}

class ProfileCreateRequested extends ProfileEvent {
  final Profile profile;

  const ProfileCreateRequested(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateRequested extends ProfileEvent {
  final Profile profile;

  const ProfileUpdateRequested(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileDeleteRequested extends ProfileEvent {
  final String id;

  const ProfileDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
