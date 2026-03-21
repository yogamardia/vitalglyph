import 'package:dartz/dartz.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

class DeleteProfile {

  DeleteProfile(this._repository);
  final ProfileRepository _repository;

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteProfile(id);
  }
}
