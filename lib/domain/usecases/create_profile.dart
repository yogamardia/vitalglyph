import 'package:dartz/dartz.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

class CreateProfile {
  final ProfileRepository _repository;

  CreateProfile(this._repository);

  Future<Either<Failure, String>> call(Profile profile) {
    return _repository.createProfile(profile);
  }
}
