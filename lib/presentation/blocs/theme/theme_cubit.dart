import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {

  ThemeCubit(this._storage) : super(ThemeMode.system);
  final FlutterSecureStorage _storage;
  static const _key = 'theme_mode';

  Future<void> load() async {
    final value = await _storage.read(key: _key);
    switch (value) {
      case 'light':
        emit(ThemeMode.light);
      case 'dark':
        emit(ThemeMode.dark);
      default:
        emit(ThemeMode.system);
    }
  }

  Future<void> setLight() => _set(ThemeMode.light);
  Future<void> setDark() => _set(ThemeMode.dark);
  Future<void> setSystem() => _set(ThemeMode.system);

  Future<void> _set(ThemeMode mode) async {
    emit(mode);
    await _storage.write(key: _key, value: mode.name);
  }
}
