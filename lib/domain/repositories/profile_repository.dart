import 'package:dartz/dartz.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';

abstract class ProfileRepository {
  Stream<Either<Failure, List<Profile>>> watchAllProfiles();
  Future<Either<Failure, Profile>> getProfile(String id);
  Future<Either<Failure, String>> createProfile(Profile profile);
  Future<Either<Failure, void>> updateProfile(Profile profile);
  Future<Either<Failure, void>> deleteProfile(String id);
}
