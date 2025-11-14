import 'package:white_label_todo_app/data/config/model/config_model.dart';


/// Base contract for all config data sources (local, remote, etc.)
abstract class ConfigDataSource {
  /// Loads configuration data from the data source.
  Future<ConfigModel> loadConfig();
}
