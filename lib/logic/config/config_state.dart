part of 'config_cubit.dart';

abstract class ConfigState {}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final ConfigModel config;
  final ThemeMode themeMode;

  ConfigLoaded(this.config, {this.themeMode = ThemeMode.system});

  ConfigLoaded copyWith({
    ConfigModel? config,
    ThemeMode? themeMode,
  }) {
    return ConfigLoaded(
      config ?? this.config,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
class ConfigError extends ConfigState {
  final String message;

  ConfigError(this.message);
}
