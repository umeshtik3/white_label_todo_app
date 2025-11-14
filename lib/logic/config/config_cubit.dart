import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:white_label_todo_app/data/config/model/config_model.dart';
import '../../../data/config/repositories/config_repository.dart';

part 'config_state.dart';

@injectable
class ConfigCubit extends Cubit<ConfigState> {
  final ConfigRepository repository;

  ConfigCubit(this.repository) : super(ConfigInitial());

  Future<void> loadConfig() async {
    emit(ConfigLoading());
    try {
      final config = await repository.loadConfig();

      ThemeMode initialTheme = ThemeMode.system;

      if (config.themeMode == "dark") initialTheme = ThemeMode.dark;
      if (config.themeMode == "light") initialTheme = ThemeMode.light;
      if (config.themeMode == "system") initialTheme = ThemeMode.system;

      emit(ConfigLoaded(config, themeMode: initialTheme));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }

  void toggleTheme() {
    if (state is ConfigLoaded) {
      final current = state as ConfigLoaded;
      final newMode = current.themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;

      emit(current.copyWith(themeMode: newMode));
    }
  }

  void setLightTheme() {
    if (state is ConfigLoaded) {
      final current = state as ConfigLoaded;
      emit(current.copyWith(themeMode: ThemeMode.light));
    }
  }

  void setDarkTheme() {
    if (state is ConfigLoaded) {
      final current = state as ConfigLoaded;
      emit(current.copyWith(themeMode: ThemeMode.dark));
    }
  }

  void setSystemTheme() {
    if (state is ConfigLoaded) {
      final current = state as ConfigLoaded;
      emit(current.copyWith(themeMode: ThemeMode.system));
    }
  }
}
