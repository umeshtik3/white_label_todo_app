import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:white_label_todo_app/data/config/datasource/config_datasource.dart';

import 'package:white_label_todo_app/data/config/model/config_model.dart';

// Note: Not annotated with @injectable because it requires apiUrl parameter
// Register manually in injection.dart if needed
class ConfigRemoteDataSource implements ConfigDataSource {
  final String apiUrl;

  ConfigRemoteDataSource({required this.apiUrl});

  @override
  Future<ConfigModel> loadConfig() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ConfigModel.fromJson(data);
    } else {
      throw Exception('Failed to load remote config: ${response.statusCode}');
    }
  }
}
