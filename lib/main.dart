import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/core/utils/theme_manager.dart';
import 'package:white_label_todo_app/data/config/datasource/local_config_datasource.dart';
import 'package:white_label_todo_app/data/config/datasource/remote_config_datasource.dart';
import 'package:white_label_todo_app/data/config/repositories/config_repository.dart';
import 'package:white_label_todo_app/data/config/repositories/config_repository_impl.dart';
import 'package:white_label_todo_app/logic/config/config_cubit.dart';
import 'package:white_label_todo_app/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localDataSource = ConfigLocalDataSource();
  final remoteDataSource = ConfigRemoteDataSource(
    apiUrl: 'https://api.client.com/config',
  );
  final repository = ConfigRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ConfigRepository repository;

  const MyApp({required this.repository, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfigCubit(repository)..loadConfig(),
      child: BlocBuilder<ConfigCubit, ConfigState>(
  builder: (context, state) {
    if (state is ConfigLoading) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    } else if (state is ConfigLoaded) {
      final config = state.config;
      final brightness = WidgetsBinding.instance.window.platformBrightness;

      return MaterialApp(
        title: config.appName,
        theme: ThemeManager.fromConfig(config, brightness),
        home: HomeScreen(),
      );
    } else if (state is ConfigError) {
      return MaterialApp(
        home: Scaffold(body: Center(child: Text('Error: ${state.message}'))),
      );
    }
    return const SizedBox.shrink();
  },
)
 );
  }
}
