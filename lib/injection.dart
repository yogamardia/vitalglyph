import 'package:get_it/get_it.dart';
import 'package:vitalglyph/core/crypto/hmac_service.dart';
import 'package:vitalglyph/data/datasources/local_database.dart';
import 'package:vitalglyph/data/repositories/profile_repository_impl.dart';
import 'package:vitalglyph/domain/repositories/profile_repository.dart';
import 'package:vitalglyph/domain/usecases/create_profile.dart';
import 'package:vitalglyph/domain/usecases/delete_profile.dart';
import 'package:vitalglyph/domain/usecases/generate_qr_data.dart';
import 'package:vitalglyph/domain/usecases/parse_qr_data.dart';
import 'package:vitalglyph/domain/usecases/update_profile.dart';
import 'package:vitalglyph/domain/usecases/watch_all_profiles.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Database ──────────────────────────────────
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // ── DAOs ──────────────────────────────────────
  sl.registerSingleton<ProfileDao>(sl<AppDatabase>().profileDao);

  // ── Repositories ──────────────────────────────
  sl.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(sl<ProfileDao>()),
  );

  // ── Crypto ────────────────────────────────────
  sl.registerLazySingleton<HmacService>(() => HmacService());

  // ── Use Cases ─────────────────────────────────
  sl.registerFactory(() => WatchAllProfiles(sl<ProfileRepository>()));
  sl.registerFactory(() => CreateProfile(sl<ProfileRepository>()));
  sl.registerFactory(() => UpdateProfile(sl<ProfileRepository>()));
  sl.registerFactory(() => DeleteProfile(sl<ProfileRepository>()));
  sl.registerFactory(() => GenerateQrData(sl<HmacService>()));
  sl.registerFactory(() => ParseQrData(sl<HmacService>()));

  // ── BLoCs ─────────────────────────────────────
  sl.registerFactory(
    () => ProfileBloc(
      watchAllProfiles: sl<WatchAllProfiles>(),
      createProfile: sl<CreateProfile>(),
      updateProfile: sl<UpdateProfile>(),
      deleteProfile: sl<DeleteProfile>(),
    ),
  );
}
