# White-Label Configurable To-Do App

A Flutter To-Do application with dynamic UI configuration driven by API JSON responses, enabling white-label customization through themes, component visibility, and custom actions. The app uses the BLoC pattern for state management with a clean architecture separating UI, business logic, and data layers.

## API-Driven Configuration

The app loads configuration from either a remote API or local JSON file (`assets/configs/app_config.json`). The configuration includes: **color schemes** (primary, secondary, background colors for light/dark themes), **theme mode** (light, dark, or system), **component visibility** (show/hide add button, search bar, filters), and **custom buttons** with configurable actions. The repository pattern automatically falls back to local config if the remote API is unavailable. Configuration is loaded at app startup via `ConfigCubit` and applied throughout the app using `BlocBuilder` widgets.

## Extending for White-Labeling

To customize the app for different clients: **1) Update the JSON config** - Modify `app_config.json` with client-specific colors, app name, and component visibility. **2) Add custom actions** - Extend `DynamicRenderer._handleAction()` in `lib/presentation/screens/dynamic_renderer.dart` to handle new action types (e.g., navigation, API calls). **3) Customize themes** - Add or modify theme colors in the `themes` object (supports both `light` and `dark` modes). **4) Enable remote config** - Uncomment the `remoteDataSource` in `main.dart` and set your API URL to fetch configs dynamically per client. The modular architecture makes it easy to add new features, customize components, and support multiple white-label configurations without code duplication.

## Configuration Schema

The JSON config structure: `appName` (string) - displayed in app bar, `appId` (string) - application identifier, `themeMode` ("light" | "dark" | "system") - theme preference, `themes` (object) - color schemes for light/dark modes with keys: `primary`, `secondary`, `background`, `surface`, `onPrimary`, `onBackground` (all hex colors), `components` (object) - UI component flags: `showAddButton` (boolean), `showSearchBar` (boolean), `showFilters` (boolean), `customButtons` (array) - dynamic buttons with `id`, `label`, and `action` fields. All CRUD operations (add, edit, delete, toggle completion) are fully functional, and the UI adapts based on the configuration values provided in the JSON.
