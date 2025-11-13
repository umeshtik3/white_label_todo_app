import 'package:white_label_todo_app/data/todos/model/todo_model.dart';


abstract class TodosState {}

class TodosInitial extends TodosState {}

class TodosLoading extends TodosState {}

class TodosLoaded extends TodosState {
  final List<TodoModel> todos;
  TodosLoaded(this.todos);
}

class TodosError extends TodosState {
  final String message;
  TodosError(this.message);
}
