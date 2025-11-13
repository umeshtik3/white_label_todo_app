import 'package:white_label_todo_app/data/config/model/config_model.dart';



/// Contract for the config repository
/// Decides which data source to use (local, remote, cached, etc.)
abstract class ConfigRepository {
  /// Load configuration, with built-in strategy (remote -> local fallback)
  Future<ConfigModel> loadConfig();
}
