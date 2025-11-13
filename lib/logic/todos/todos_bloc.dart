import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository.dart';
import 'todos_event.dart';
import 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoRepository repository;

  TodosBloc(this.repository) : super(TodosInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoStatus>(_onToggleStatus);
    on<ClearCompleted>(_onClearCompleted);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodosState> emit) async {
    emit(TodosLoading());
    final todos = await repository.fetchTodos();
    emit(TodosLoaded(todos));
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodosState> emit) async {
    await repository.addTodo(event.todo);
    final todos = await repository.fetchTodos();
    emit(TodosLoaded(todos));
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodosState> emit) async {
    await repository.updateTodo(event.todo);
    final todos = await repository.fetchTodos();
    emit(TodosLoaded(todos));
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodosState> emit) async {
    await repository.deleteTodo(event.id);
    final todos = await repository.fetchTodos();
    emit(TodosLoaded(todos));
  }

  Future<void> _onToggleStatus(ToggleTodoStatus event, Emitter<TodosState> emit) async {
    final todos = await repository.fetchTodos();
    final updated = todos.map((t) {
      if (t.id == event.id) return t.copyWith(isCompleted: !t.isCompleted);
      return t;
    }).toList();
    for (var todo in updated) {
      await repository.updateTodo(todo);
    }
    emit(TodosLoaded(updated));
  }

  Future<void> _onClearCompleted(ClearCompleted event, Emitter<TodosState> emit) async {
    await repository.clearCompleted();
    final todos = await repository.fetchTodos();
    emit(TodosLoaded(todos));
  }
}
