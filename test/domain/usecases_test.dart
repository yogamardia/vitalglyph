import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';
import 'package:vitalglyph/domain/usecases/create_profile.dart';
import 'package:vitalglyph/domain/usecases/delete_profile.dart';
import 'package:vitalglyph/domain/usecases/update_profile.dart';
import 'package:vitalglyph/domain/usecases/watch_all_profiles.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepo;

  final now = DateTime(2025);
  final testProfile = Profile(
    id: 'uuid-1',
    name: 'Test User',
    dateOfBirth: DateTime(1990),
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockProfileRepository();
  });

  group('WatchAllProfiles', () {
    test('returns stream from repository', () async {
      when(() => mockRepo.watchAllProfiles()).thenAnswer(
        (_) => Stream.value(Right([testProfile])),
      );
      final usecase = WatchAllProfiles(mockRepo);
      final result = await usecase().first;
      result.match(
        (f) => fail('Expected Right, got Left: $f'),
        (profiles) => expect(profiles, [testProfile]),
      );
    });
  });

  group('CreateProfile', () {
    test('returns id on success', () async {
      when(() => mockRepo.createProfile(testProfile))
          .thenAnswer((_) async => const Right('uuid-1'));
      final usecase = CreateProfile(mockRepo);
      final result = await usecase(testProfile);
      expect(result, const Right<Failure, String>('uuid-1'));
    });

    test('returns failure on error', () async {
      when(() => mockRepo.createProfile(testProfile))
          .thenAnswer((_) async => const Left(DatabaseFailure()));
      final usecase = CreateProfile(mockRepo);
      final result = await usecase(testProfile);
      expect(result, isA<Left<Failure, String>>());
    });
  });

  group('UpdateProfile', () {
    test('calls repository and returns right on success', () async {
      when(() => mockRepo.updateProfile(testProfile))
          .thenAnswer((_) async => const Right(null));
      final usecase = UpdateProfile(mockRepo);
      final result = await usecase(testProfile);
      expect(result.isRight(), isTrue);
    });
  });

  group('DeleteProfile', () {
    test('calls repository with correct id', () async {
      when(() => mockRepo.deleteProfile('uuid-1'))
          .thenAnswer((_) async => const Right(null));
      final usecase = DeleteProfile(mockRepo);
      final result = await usecase('uuid-1');
      expect(result.isRight(), isTrue);
      verify(() => mockRepo.deleteProfile('uuid-1')).called(1);
    });
  });
}
