import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:white_label_todo_app/data/config/datasource/config_datasource.dart';
import 'package:white_label_todo_app/data/config/datasource/local_config_datasource.dart';
import 'package:white_label_todo_app/data/config/repositories/config_repository.dart';
import 'package:white_label_todo_app/data/config/repositories/config_repository_impl.dart';
import 'package:white_label_todo_app/data/todos/datasource/todos_datasource.dart';
import 'package:white_label_todo_app/data/todos/datasource/todos_local_datasource.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository_impl.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
  
  // Register local datasources manually (they have default parameters)
  getIt.registerLazySingleton<ConfigDataSource>(
    () => ConfigLocalDataSource(),
    instanceName: 'local',
  );
  
  getIt.registerLazySingleton<TodoDataSource>(
    () => TodoLocalDataSource(),
    instanceName: 'local',
  );
  
  // Register repositories manually to handle optional remoteDataSource
  getIt.registerLazySingleton<ConfigRepository>(
    () => ConfigRepositoryImpl(
      localDataSource: getIt<ConfigDataSource>(instanceName: 'local'),
      // remoteDataSource: null, // Optional - uncomment and set when needed
    ),
  );
  
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      localDataSource: getIt<TodoDataSource>(instanceName: 'local'),
      // remoteDataSource: null, // Optional - uncomment and set when needed
    ),
  );
  
  // Register remote datasources manually since they require parameters
  // Uncomment and configure when needed:
  // getIt.registerLazySingleton<ConfigRemoteDataSource>(
  //   () => ConfigRemoteDataSource(apiUrl: 'https://api.client.com/config'),
  // );
  // getIt.registerLazySingleton<TodoRemoteDataSource>(
  //   () => TodoRemoteDataSource(apiBaseUrl: 'https://api.example.com'),
  // );
  // Then update the repositories above to use the remote datasources
}

