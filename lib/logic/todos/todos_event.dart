import 'package:white_label_todo_app/data/todos/model/todo_model.dart';


abstract class TodosEvent {}

class LoadTodos extends TodosEvent {}

class AddTodo extends TodosEvent {
  final TodoModel todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodosEvent {
  final TodoModel todo;
  UpdateTodo(this.todo);
}

class DeleteTodo extends TodosEvent {
  final String id;
  DeleteTodo(this.id);
}

class ToggleTodoStatus extends TodosEvent {
  final String id;
  ToggleTodoStatus(this.id);
}

class ClearCompleted extends TodosEvent {}

class FilterTodos extends TodosEvent {
  final String filter; // 'all', 'active', 'completed'
  FilterTodos(this.filter);
}

class SearchTodos extends TodosEvent {
  final String query;
  SearchTodos(this.query);
}

