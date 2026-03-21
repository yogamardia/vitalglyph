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

  const ProfileCreateRequested(this.profile);
  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdateRequested extends ProfileEvent {

  const ProfileUpdateRequested(this.profile);
  final Profile profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileDeleteRequested extends ProfileEvent {

  const ProfileDeleteRequested(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
