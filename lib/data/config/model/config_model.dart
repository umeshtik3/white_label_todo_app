import 'dart:ui';

/// Represents the entire configuration for the app.
/// Supports multiple themes, UI component toggles, and white-label parameters.
class ConfigModel {
  final String appName;
  final String appId;
  final String themeMode; // "light", "dark", or "system"
  final Map<String, dynamic> themes; // contains both light and dark
  final ComponentsConfig components;

  ConfigModel({
    required this.appName,
    required this.appId,
    required this.themeMode,
    required this.themes,
    required this.components,
  });

  /// Factory constructor to parse JSON into ConfigModel
  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      appName: json['appName'] ?? 'Unnamed App',
      appId: json['appId'] ?? 'com.example.app',
      themeMode: json['themeMode'] ?? 'system',
      themes: json['themes'] ?? {},
      components: ComponentsConfig.fromJson(json['components'] ?? {}),
    );
  }

  /// Returns the active theme map depending on themeMode or system brightness.
  Map<String, dynamic> getActiveTheme(Brightness systemBrightness) {
    String activeKey = themeMode == 'system'
        ? (systemBrightness == Brightness.dark ? 'dark' : 'light')
        : themeMode;

    return themes[activeKey] ?? themes['light'] ?? {};
  }

  /// Convenience getter: whether dark mode is active
  bool isDarkMode(Brightness systemBrightness) {
    return themeMode == 'dark' ||
        (themeMode == 'system' && systemBrightness == Brightness.dark);
  }
}

/// Represents dynamic UI component toggles and custom button actions.
class ComponentsConfig {
  final bool showAddButton;
  final bool showSearchBar;
  final bool showFilters;
  final List<CustomButton> customButtons;

  ComponentsConfig({
    required this.showAddButton,
    required this.showSearchBar,
    required this.showFilters,
    required this.customButtons,
  });

  factory ComponentsConfig.fromJson(Map<String, dynamic> json) {
    return ComponentsConfig(
      showAddButton: json['showAddButton'] ?? true,
      showSearchBar: json['showSearchBar'] ?? true,
      showFilters: json['showFilters'] ?? true,
      customButtons: (json['customButtons'] as List<dynamic>? ?? [])
          .map((e) => CustomButton.fromJson(e))
          .toList(),
    );
  }
}

/// Represents each dynamic custom button (e.g., Export, Clear Completed)
class CustomButton {
  final String id;
  final String label;
  final String action;

  CustomButton({
    required this.id,
    required this.label,
    required this.action,
  });

  factory CustomButton.fromJson(Map<String, dynamic> json) {
    return CustomButton(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      action: json['action'] ?? '',
    );
  }
}
