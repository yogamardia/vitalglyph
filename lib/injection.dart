import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:home_widget/home_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vitalglyph/core/crypto/auth_settings_service.dart';
import 'package:vitalglyph/core/crypto/backup_crypto_service.dart';
import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/core/crypto/pin_service.dart';
import 'package:vitalglyph/data/datasources/local_database.dart';
import 'package:vitalglyph/data/repositories/profile_repository_impl.dart';
import 'package:vitalglyph/data/services/widget_service.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';
import 'package:vitalglyph/domain/usecases/create_profile.dart';
import 'package:vitalglyph/domain/usecases/delete_profile.dart';
import 'package:vitalglyph/domain/usecases/export_backup.dart';
import 'package:vitalglyph/domain/usecases/export_emergency_card.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';
import 'package:vitalglyph/domain/usecases/import_backup.dart';
import 'package:vitalglyph/domain/usecases/parse_qr_data.dart';
import 'package:vitalglyph/domain/usecases/update_profile.dart';
import 'package:vitalglyph/domain/usecases/watch_all_profiles.dart';
import 'package:vitalglyph/presentation/blocs/auth/auth_cubit.dart';
import 'package:vitalglyph/presentation/blocs/backup/backup_cubit.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/theme/theme_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Secure Storage ────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // ── Crypto Services ───────────────────────────
  sl.registerLazySingleton<HmacService>(() => HmacService());
  sl.registerLazySingleton<PinService>(
      () => PinService(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<AuthSettingsService>(
      () => AuthSettingsService(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());

  // ── Database ──────────────────────────────────
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // ── DAOs ──────────────────────────────────────
  sl.registerSingleton<ProfileDao>(sl<AppDatabase>().profileDao);

  // ── Repositories ──────────────────────────────
  sl.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(sl<ProfileDao>()),
  );

  // ── Use Cases ─────────────────────────────────
  sl.registerFactory(() => WatchAllProfiles(sl<ProfileRepository>()));
  sl.registerFactory(() => CreateProfile(sl<ProfileRepository>()));
  sl.registerFactory(() => UpdateProfile(sl<ProfileRepository>()));
  sl.registerFactory(() => DeleteProfile(sl<ProfileRepository>()));
  sl.registerFactory(() => GenerateQrData(sl<HmacService>()));
  sl.registerFactory(() => ParseQrData(sl<HmacService>()));
  sl.registerFactory(() => ExportEmergencyCard(sl<GenerateQrData>()));

  // ── Backup ────────────────────────────────────
  sl.registerLazySingleton<BackupCryptoService>(() => BackupCryptoService());
  sl.registerFactory(() => ExportBackup(sl<ProfileRepository>(), sl<BackupCryptoService>()));
  sl.registerFactory(() => ImportBackup(sl<ProfileRepository>(), sl<BackupCryptoService>()));
  sl.registerFactory(
    () => BackupCubit(
      exportBackup: sl<ExportBackup>(),
      importBackup: sl<ImportBackup>(),
    ),
  );

  // ── Widget ────────────────────────────────────
  // Initialize app group for iOS widget data sharing.
  await HomeWidget.setAppGroupId('group.com.yogamardia.vitalglyph');
  sl.registerLazySingleton<WidgetService>(
    () => WidgetService(sl<GenerateQrData>()),
  );

  // ── BLoCs ─────────────────────────────────────
  sl.registerFactory(
    () => ProfileBloc(
      watchAllProfiles: sl<WatchAllProfiles>(),
      createProfile: sl<CreateProfile>(),
      updateProfile: sl<UpdateProfile>(),
      deleteProfile: sl<DeleteProfile>(),
    ),
  );

  sl.registerFactory(
    () => AuthCubit(
      pin: sl<PinService>(),
      settings: sl<AuthSettingsService>(),
      localAuth: sl<LocalAuthentication>(),
    ),
  );

  sl.registerFactory(() => ThemeCubit(sl<FlutterSecureStorage>()));
}
