import 'package:dartz/dartz.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository _repository;

  UpdateProfile(this._repository);

  Future<Either<Failure, void>> call(Profile profile) {
    return _repository.updateProfile(profile);
  }
}
