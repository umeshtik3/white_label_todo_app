// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:white_label_todo_app/data/config/repositories/config_repository.dart'
    as _i1039;
import 'package:white_label_todo_app/data/todos/repository/todos_repository.dart'
    as _i742;
import 'package:white_label_todo_app/logic/config/config_cubit.dart' as _i587;
import 'package:white_label_todo_app/logic/todos/todos_bloc.dart' as _i118;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i587.ConfigCubit>(
      () => _i587.ConfigCubit(gh<_i1039.ConfigRepository>()),
    );
    gh.factory<_i118.TodosBloc>(
      () => _i118.TodosBloc(gh<_i742.TodoRepository>()),
    );
    return this;
  }
}
