import 'package:equatable/equatable.dart';
import 'package:vitalglyph/domain/usecases/import_backup.dart';

sealed class BackupState extends Equatable {
  const BackupState();
}

class BackupInitial extends BackupState {
  const BackupInitial();
  @override
  List<Object?> get props => [];
}

class BackupLoading extends BackupState {
  const BackupLoading();
  @override
  List<Object?> get props => [];
}

class BackupExportSuccess extends BackupState {
  const BackupExportSuccess();
  @override
  List<Object?> get props => [];
}

class BackupImportSuccess extends BackupState {
  final ImportResult result;
  const BackupImportSuccess(this.result);
  @override
  List<Object?> get props => [result];
}

class BackupError extends BackupState {
  final String message;
  const BackupError(this.message);
  @override
  List<Object?> get props => [message];
}
