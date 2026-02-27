import 'package:dartz/dartz.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';

class WatchAllProfiles {
  final ProfileRepository _repository;

  WatchAllProfiles(this._repository);

  Stream<Either<Failure, List<Profile>>> call() {
    return _repository.watchAllProfiles();
  }
}
