import 'package:flutter/material.dart';
import 'package:white_label_todo_app/data/config/model/config_model.dart';
import '../utils/color_parser.dart';

class ThemeManager {
  /// Generates a ThemeData object based on the ConfigModel and system brightness
  static ThemeData fromConfig(ConfigModel config, Brightness systemBrightness) {
    final isDark = config.isDarkMode(systemBrightness);
    final activeTheme = config.getActiveTheme(systemBrightness);

    // Extract colors safely from JSON theme map
    final primary = parseHexColor(activeTheme['primary'] ?? '#2196F3');
    final secondary = parseHexColor(activeTheme['secondary'] ?? '#FF9800');
    final background = parseHexColor(activeTheme['background'] ?? '#FFFFFF');
    final surface = parseHexColor(activeTheme['surface'] ?? '#F4F6F8');
    final onPrimary = parseHexColor(activeTheme['onPrimary'] ?? '#FFFFFF');
    final onBackground = parseHexColor(activeTheme['onBackground'] ?? '#000000');

    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        brightness: brightness,
        surface: surface,
        // background: background,
        onPrimary: onPrimary,
        onSurface: onBackground,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: onBackground),
        bodyMedium: TextStyle(color: onBackground.withValues(alpha:0.9)),
      ),
    );
  }
}
