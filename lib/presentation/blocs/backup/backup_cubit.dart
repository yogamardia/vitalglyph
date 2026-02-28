import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vitalglyph/domain/usecases/export_backup.dart';
import 'package:vitalglyph/domain/usecases/import_backup.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_state.dart';


class BackupCubit extends Cubit<BackupState> {
  final ExportBackup _exportBackup;
  final ImportBackup _importBackup;

  BackupCubit({
    required ExportBackup exportBackup,
    required ImportBackup importBackup,
  })  : _exportBackup = exportBackup,
        _importBackup = importBackup,
        super(const BackupInitial());

  /// Exports all profiles to an encrypted `.medid` file and triggers the
  /// system share sheet so the user can save or send the file.
  Future<void> export(String passphrase) async {
    emit(const BackupLoading());

    final result = await _exportBackup(passphrase);
    await result.fold(
      (failure) async => emit(BackupError(failure.message)),
      (filePath) async {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            subject: 'Medical ID Backup',
          ),
        );
        emit(const BackupExportSuccess());
      },
    );
  }

  /// Decrypts the backup at [filePath] and merges its profiles into the DB.
  Future<void> importFromFile(String filePath, String passphrase) async {
    emit(const BackupLoading());

    final result = await _importBackup(filePath, passphrase);
    result.fold(
      (failure) => emit(BackupError(failure.message)),
      (importResult) => emit(BackupImportSuccess(importResult)),
    );
  }

  void reset() => emit(const BackupInitial());
}
