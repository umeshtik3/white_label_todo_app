import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:white_label_todo_app/data/config/datasource/config_datasource.dart';

import 'package:white_label_todo_app/data/config/model/config_model.dart';


class ConfigLocalDataSource implements ConfigDataSource {
  final String assetPath;

  ConfigLocalDataSource({this.assetPath = 'assets/configs/app_config.json'});

  @override
  Future<ConfigModel> loadConfig() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final data = json.decode(jsonString);
    return ConfigModel.fromJson(data);
  }
}
