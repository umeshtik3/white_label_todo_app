import 'package:white_label_todo_app/data/todos/model/todo_model.dart';


abstract class TodosState {}

class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}



class TodosError extends TodosState {
  final String message;
  TodosError(this.message);
}

class TodosLoaded extends TodosState {
  final List<TodoModel> todos;
  final String filter;
  final String searchQuery;

   TodosLoaded({
    required this.todos,
    this.filter = 'all',
    this.searchQuery = '',
  });

  TodosLoaded copyWith({
    List<TodoModel>? todos,
    String? filter,
    String? searchQuery,
  }) {
    return TodosLoaded(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
