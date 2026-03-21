import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitalglyph/core/error/failures.dart';
import 'package:vitalglyph/domain/usecases/export_backup.dart';
import 'package:vitalglyph/domain/usecases/import_backup.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_cubit.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_state.dart';

class MockExportBackup extends Mock implements ExportBackup {}

class MockImportBackup extends Mock implements ImportBackup {}

void main() {
  late MockExportBackup mockExport;
  late MockImportBackup mockImport;

  setUp(() {
    mockExport = MockExportBackup();
    mockImport = MockImportBackup();
  });

  BackupCubit buildCubit() => BackupCubit(
        exportBackup: mockExport,
        importBackup: mockImport,
      );

  group('initial state', () {
    test('is BackupInitial', () {
      final cubit = buildCubit();
      expect(cubit.state, const BackupInitial());
      cubit.close();
    });
  });

  group('export', () {
    blocTest<BackupCubit, BackupState>(
      'emits [Loading, Error] when export fails',
      setUp: () {
        when(() => mockExport('pass')).thenAnswer(
          (_) async => const Left(BackupFailure('Export failed')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.export('pass'),
      expect: () => [
        const BackupLoading(),
        const BackupError('Export failed'),
      ],
    );

    // Note: testing the success path requires mocking SharePlus.instance
    // which is a static call. We verify the failure path thoroughly.
  });

  group('importFromFile', () {
    blocTest<BackupCubit, BackupState>(
      'emits [Loading, ImportSuccess] when import succeeds',
      setUp: () {
        when(() => mockImport('/path/to/file.medid', 'pass')).thenAnswer(
          (_) async => const Right(ImportResult(imported: 3, skipped: 1)),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.importFromFile('/path/to/file.medid', 'pass'),
      expect: () => [
        const BackupLoading(),
        const BackupImportSuccess(ImportResult(imported: 3, skipped: 1)),
      ],
    );

    blocTest<BackupCubit, BackupState>(
      'emits [Loading, Error] when import fails with wrong passphrase',
      setUp: () {
        when(() => mockImport('/path/to/file.medid', 'wrong')).thenAnswer(
          (_) async =>
              const Left(BackupFailure('Wrong passphrase or corrupted file.')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.importFromFile('/path/to/file.medid', 'wrong'),
      expect: () => [
        const BackupLoading(),
        const BackupError('Wrong passphrase or corrupted file.'),
      ],
    );

    blocTest<BackupCubit, BackupState>(
      'emits [Loading, Error] when file not found',
      setUp: () {
        when(() => mockImport('/missing.medid', 'pass')).thenAnswer(
          (_) async => const Left(BackupFailure('Backup file not found.')),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.importFromFile('/missing.medid', 'pass'),
      expect: () => [
        const BackupLoading(),
        const BackupError('Backup file not found.'),
      ],
    );

    blocTest<BackupCubit, BackupState>(
      'emits [Loading, ImportSuccess] with zero imported / zero skipped',
      setUp: () {
        when(() => mockImport('/empty.medid', 'pass')).thenAnswer(
          (_) async => const Right(ImportResult(imported: 0, skipped: 0)),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.importFromFile('/empty.medid', 'pass'),
      expect: () => [
        const BackupLoading(),
        const BackupImportSuccess(ImportResult(imported: 0, skipped: 0)),
      ],
    );
  });

  group('reset', () {
    blocTest<BackupCubit, BackupState>(
      'emits BackupInitial',
      build: buildCubit,
      seed: () => const BackupError('some error'),
      act: (cubit) => cubit.reset(),
      expect: () => [const BackupInitial()],
    );
  });
}
