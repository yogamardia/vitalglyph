import 'package:fpdart/fpdart.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

class CreateProfile {
  CreateProfile(this._repository);
  final ProfileRepository _repository;

  Future<Either<Failure, String>> call(Profile profile) {
    return _repository.createProfile(profile);
  }
}
