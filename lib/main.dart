import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/core/injection/injection.dart';
import 'package:white_label_todo_app/core/utils/theme_manager.dart';
import 'package:white_label_todo_app/logic/config/config_cubit.dart';
import 'package:white_label_todo_app/logic/todos/todos_bloc.dart';
import 'package:white_label_todo_app/logic/todos/todos_event.dart';
import 'package:white_label_todo_app/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConfigCubit>()..loadConfig(),
      child: BlocBuilder<ConfigCubit, ConfigState>(
        builder: (context, state) {
          if (state is ConfigLoading) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          } else if (state is ConfigLoaded) {
            final config = state.config;
            final themeMode = state.themeMode;
            final systemBrightness = PlatformDispatcher.instance.platformBrightness;
            
            // Determine the actual brightness based on themeMode
            final brightness = themeMode == ThemeMode.dark
                ? Brightness.dark
                : themeMode == ThemeMode.light
                    ? Brightness.light
                    : systemBrightness;

            return BlocProvider<TodosBloc>(
              create: (_) => getIt<TodosBloc>()..add(LoadTodos()),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: config.appName,
                theme: ThemeManager.fromConfig(config, brightness),
                home: HomeScreen(),
              ),
            );
          } else if (state is ConfigError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error: ${state.message}')),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
