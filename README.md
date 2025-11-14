# White-Label Configurable To-Do App

A Flutter To-Do application with dynamic UI configuration driven by API JSON responses, enabling white-label customization through themes, component visibility, and custom actions. The app uses the BLoC pattern for state management with a clean architecture separating UI, business logic, and data layers.

## API-Driven Configuration

The app loads configuration from either a remote API or local JSON file (`assets/configs/app_config.json`). The configuration includes: **color schemes** (primary, secondary, background colors for light/dark themes), **theme mode** (light, dark, or system), **component visibility** (show/hide add button, search bar, filters), and **custom buttons** with configurable actions. The repository pattern automatically falls back to local config if the remote API is unavailable. Configuration is loaded at app startup via `ConfigCubit` and applied throughout the app using `BlocBuilder` widgets.

## Extending for White-Labeling

To customize the app for different clients: **1) Update the JSON config** - Modify `app_config.json` with client-specific colors, app name, and component visibility. **2) Add custom actions** - Extend `DynamicRenderer._handleAction()` in `lib/presentation/screens/dynamic_renderer.dart` to handle new action types (e.g., navigation, API calls). **3) Customize themes** - Add or modify theme colors in the `themes` object (supports both `light` and `dark` modes). **4) Enable remote config** - Uncomment the `remoteDataSource` in `main.dart` and set your API URL to fetch configs dynamically per client. The modular architecture makes it easy to add new features, customize components, and support multiple white-label configurations without code duplication.

## Configuration Schema

The JSON config structure: `appName` (string) - displayed in app bar, `appId` (string) - application identifier, `themeMode` ("light" | "dark" | "system") - theme preference, `themes` (object) - color schemes for light/dark modes with keys: `primary`, `secondary`, `background`, `surface`, `onPrimary`, `onBackground` (all hex colors), `components` (object) - UI component flags: `showAddButton` (boolean), `showSearchBar` (boolean), `showFilters` (boolean), `customButtons` (array) - dynamic buttons with `id`, `label`, and `action` fields. All CRUD operations (add, edit, delete, toggle completion) are fully functional, and the UI adapts based on the configuration values provided in the JSON.

## Running the App

**Local-only mode (default)**
- Ensure Flutter is set up and dependencies are fetched via your IDE’s standard `pub get` workflow.
- Start the app from your IDE or the Flutter tooling; it will load todos from `assets/todos/todos.json` and configuration from `assets/configs/app_config.json`.
- No extra setup is required because dependency injection is already wired to the local data sources.

**Remote REST mode**
1. Open `lib/core/injection/injection.dart`.
2. Locate the `@module` or registration section for `TodoDataSource` and uncomment the remote bindings while commenting out the local ones (the file already contains the required code, just toggle the comments as indicated).
3. Make sure the remote base URL is set to your REST endpoint (for testing you can reuse the Mockable.io URL described below).
4. Run build runner in your preferred workflow (for example, the IDE build task) to regenerate `lib/core/injection/injection.config.dart` so the new bindings take effect.
5. Rebuild/restart the Flutter app; the todo repository will now call the REST API instead of the bundled JSON.

## Mockable.io Setup for Remote Testing

1. Visit `https://www.mockable.io` and select **Try Now** (no login required).
2. Choose **New REST Mock**.
3. Find a app configuration json and todo list mock json in `assets/` directory.
4. Provide a path (e.g., `/todos`) and paste the JSON response you want the app to consume (match the todo model fields).
5. Save the mock, then press the **Started** button so the endpoint goes live.
6. Copy the generated Mockable URL and use it as the remote base URL in `injection.dart` or wherever the REST endpoint is configured.

Once these steps are complete, the remote mode instructions above will fetch todos from your Mockable mock.

## Future Enhancement

Detect the device’s connectivity status and automatically switch between the local JSON data source and the remote REST API. When the app detects no internet connection it should fall back to local storage, and when connectivity is restored it can resume remote sync without requiring manual changes in `injection.dart`.
