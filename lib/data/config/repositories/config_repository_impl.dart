import 'package:flutter/foundation.dart';
import 'package:white_label_todo_app/data/config/datasource/config_datasource.dart';
import 'package:white_label_todo_app/data/config/model/config_model.dart';

import 'config_repository.dart';

class ConfigRepositoryImpl implements ConfigRepository {
  final ConfigDataSource localDataSource;
  final ConfigDataSource? remoteDataSource;

  ConfigRepositoryImpl({required this.localDataSource, this.remoteDataSource});

  @override
  Future<ConfigModel> loadConfig() async {
    try {
      if (remoteDataSource != null) {
        // Try remote first
        final remoteConfig = await remoteDataSource!.loadConfig();
        return remoteConfig;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Remote config fetch failed: $e');
      }
    }

    // Fallback to local if remote not available or failed
    return await localDataSource.loadConfig();
  }
}
