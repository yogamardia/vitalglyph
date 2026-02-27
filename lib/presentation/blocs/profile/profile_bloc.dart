import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalglyph/domain/usecases/create_profile.dart';
import 'package:vitalglyph/domain/usecases/delete_profile.dart';
import 'package:vitalglyph/domain/usecases/update_profile.dart';
import 'package:vitalglyph/domain/usecases/watch_all_profiles.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_event.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final WatchAllProfiles _watchAllProfiles;
  final CreateProfile _createProfile;
  final UpdateProfile _updateProfile;
  final DeleteProfile _deleteProfile;

  ProfileBloc({
    required WatchAllProfiles watchAllProfiles,
    required CreateProfile createProfile,
    required UpdateProfile updateProfile,
    required DeleteProfile deleteProfile,
  })  : _watchAllProfiles = watchAllProfiles,
        _createProfile = createProfile,
        _updateProfile = updateProfile,
        _deleteProfile = deleteProfile,
        super(const ProfileInitial()) {
    on<ProfilesWatchStarted>(_onWatchStarted);
    on<ProfileCreateRequested>(_onCreateRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onWatchStarted(
    ProfilesWatchStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    await emit.forEach(
      _watchAllProfiles(),
      onData: (result) => result.fold(
        (failure) => ProfileError(failure.message),
        (profileList) => ProfileLoaded(profileList),
      ),
      onError: (error, _) => const ProfileError('Unexpected error'),
    );
  }

  Future<void> _onCreateRequested(
    ProfileCreateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _createProfile(event.profile);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) {}, // stream watch will push updated list
    );
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _updateProfile(event.profile);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) {},
    );
  }

  Future<void> _onDeleteRequested(
    ProfileDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _deleteProfile(event.id);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) {},
    );
  }
}
