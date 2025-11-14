import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:white_label_todo_app/data/config/datasource/config_datasource.dart';
import 'package:white_label_todo_app/data/config/datasource/local_config_datasource.dart';
// import 'package:white_label_todo_app/data/config/datasource/remote_config_datasource.dart';
import 'package:white_label_todo_app/data/config/repositories/config_repository.dart';
import 'package:white_label_todo_app/data/config/repositories/config_repository_impl.dart';
import 'package:white_label_todo_app/data/todos/datasource/todos_datasource.dart';
import 'package:white_label_todo_app/data/todos/datasource/todos_local_datasource.dart';
// import 'package:white_label_todo_app/data/todos/datasource/todos_remote_datasource.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository_impl.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Uncomment this code and run build runner to you work with remote datasource

// const String _defaultConfigApiUrl = String.fromEnvironment(
//   'CONFIG_API_URL',
//   defaultValue: 'https://demo4131683.mockable.io/mockable_json',
// );

// const String _defaultTodoApiBaseUrl = String.fromEnvironment(
//   'TODO_API_URL',
//   defaultValue: 'https://demo4131683.mockable.io',
// );

@InjectableInit()
void configureDependencies() {
  getIt.init();

  // Register local datasources manually (they have default parameters)
  getIt.registerLazySingleton<ConfigDataSource>(
    () => ConfigLocalDataSource(),
    instanceName: 'local',
  );

  /// Uncomment this code and run build runner to you work with remote datasource

  // getIt.registerLazySingleton<ConfigDataSource>(
  //   () => ConfigRemoteDataSource(apiUrl: _defaultConfigApiUrl),
  //   instanceName: 'remote',
  // );

  getIt.registerLazySingleton<TodoDataSource>(
    () => TodoLocalDataSource(),
    instanceName: 'local',
  );

  /// Uncomment this code and run build runner to you work with remote datasource

  // getIt.registerLazySingleton<TodoDataSource>(
  //   () => TodoRemoteDataSource(apiBaseUrl: _defaultTodoApiBaseUrl),
  //   instanceName: 'remote',
  // );

  getIt.registerLazySingleton<ConfigRepository>(
    () => ConfigRepositoryImpl(
      localDataSource: getIt<ConfigDataSource>(instanceName: 'local'),

      /// Uncomment this code and run build runner to you work with remote datasource

      // remoteDataSource: getIt<ConfigDataSource>(instanceName: 'remote'),
    ),
  );

  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      localDataSource: getIt<TodoDataSource>(instanceName: 'local'),

      /// Uncomment this code and run build runner to you work with remote datasource

      // remoteDataSource: getIt<TodoDataSource>(instanceName: 'remote'),
    ),
  );
}
