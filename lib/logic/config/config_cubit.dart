import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/data/config/model/config_model.dart';
import '../../../data/config/repositories/config_repository.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final ConfigRepository repository;

  ConfigCubit(this.repository) : super(ConfigInitial());

  Future<void> loadConfig() async {
    emit(ConfigLoading());
    try {
      final config = await repository.loadConfig();
      emit(ConfigLoaded(config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }
}
