import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository.dart';
import 'todos_event.dart';
import 'todos_state.dart';

@injectable
class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoRepository repository;
  List<TodoModel> _allTodos = [];

  TodosBloc(this.repository) : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<FilterTodos>(_onFilterTodos);
    on<SearchTodos>(_onSearchTodos);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    emit(TodosLoading());
    final todos = await repository.fetchTodos();
    _allTodos = todos;
    emit(TodosLoaded(todos: todos));
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodosState> emit) async {
    await repository.addTodo(event.todo);
    _allTodos.add(event.todo);
    _applyFilters(emit);
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) async {
    await repository.updateTodo(event.todo);
    _allTodos = _allTodos
        .map((t) => t.id == event.todo.id ? event.todo : t)
        .toList();
    _applyFilters(emit);
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit) async {
    await repository.deleteTodo(event.id);
    _allTodos.removeWhere((t) => t.id == event.id);
    _applyFilters(emit);
  }

  Future<void> _onToggleTodoStatus(
    ToggleTodoStatus event,
    Emitter<TodosState> emit,
  ) async {
    final todo = _allTodos.firstWhere((t) => t.id == event.id);
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    await repository.updateTodo(updated);
    _allTodos = _allTodos.map((t) => t.id == event.id ? updated : t).toList();
    _applyFilters(emit);
  }


  void _onFilterTodos(FilterTodos event, Emitter<TodosState> emit) {
    if (state is TodosLoaded) {
      final current = state as TodosLoaded;
      emit(current.copyWith(filter: event.filter));
      _applyFilters(emit);
    }
  }

  void _onSearchTodos(SearchTodos event, Emitter<TodosState> emit) {
    if (state is TodosLoaded) {
      final current = state as TodosLoaded;
      emit(current.copyWith(searchQuery: event.query));
      _applyFilters(emit);
    }
  }

  void _applyFilters(Emitter<TodosState> emit) {
    if (state is! TodosLoaded) return;
    final current = state as TodosLoaded;

    List<TodoModel> filtered = List.from(_allTodos);

    // Filter by status
    if (current.filter == 'active') {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (current.filter == 'completed') {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }

    // Search by query
    if (current.searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (t) => t.title.toLowerCase().contains(
              current.searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    emit(current.copyWith(todos: filtered));
  }
}
