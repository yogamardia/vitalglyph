import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/usecases/create_profile.dart';
import 'package:vitalglyph/domain/usecases/delete_profile.dart';
import 'package:vitalglyph/domain/usecases/update_profile.dart';
import 'package:vitalglyph/domain/usecases/watch_all_profiles.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_event.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_state.dart';

class MockWatchAllProfiles extends Mock implements WatchAllProfiles {}

class MockCreateProfile extends Mock implements CreateProfile {}

class MockUpdateProfile extends Mock implements UpdateProfile {}

class MockDeleteProfile extends Mock implements DeleteProfile {}

void main() {
  late MockWatchAllProfiles mockWatch;
  late MockCreateProfile mockCreate;
  late MockUpdateProfile mockUpdate;
  late MockDeleteProfile mockDelete;

  final now = DateTime(2025);
  final testProfile = Profile(
    id: 'id-1',
    name: 'Alice',
    dateOfBirth: DateTime(1990),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockWatch = MockWatchAllProfiles();
    mockCreate = MockCreateProfile();
    mockUpdate = MockUpdateProfile();
    mockDelete = MockDeleteProfile();
  });

  ProfileBloc buildBloc() => ProfileBloc(
    watchAllProfiles: mockWatch,
    createProfile: mockCreate,
    updateProfile: mockUpdate,
    deleteProfile: mockDelete,
  );

  group('ProfilesWatchStarted', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [Loading, Loaded] when watch returns profiles',
      setUp: () {
        when(
          () => mockWatch(),
        ).thenAnswer((_) => Stream.value(Right([testProfile])));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProfilesWatchStarted()),
      expect: () => [
        const ProfileLoading(),
        ProfileLoaded([testProfile]),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [Loading, Error] when watch returns failure',
      setUp: () {
        when(() => mockWatch()).thenAnswer(
          (_) => Stream.value(const Left(DatabaseFailure('db error'))),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProfilesWatchStarted()),
      expect: () => [const ProfileLoading(), const ProfileError('db error')],
    );
  });

  group('ProfileCreateRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'calls createProfile use case and does not emit on success',
      setUp: () {
        when(
          () => mockCreate(testProfile),
        ).thenAnswer((_) async => const Right('id-1'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(ProfileCreateRequested(testProfile)),
      expect: () => <ProfileState>[],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits ProfileError when create fails',
      setUp: () {
        when(
          () => mockCreate(testProfile),
        ).thenAnswer((_) async => const Left(DatabaseFailure('create failed')));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(ProfileCreateRequested(testProfile)),
      expect: () => [const ProfileError('create failed')],
    );
  });

  group('ProfileDeleteRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'calls deleteProfile and does not emit on success',
      setUp: () {
        when(
          () => mockDelete('id-1'),
        ).thenAnswer((_) async => const Right(null));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const ProfileDeleteRequested('id-1')),
      expect: () => <ProfileState>[],
    );
  });
}
