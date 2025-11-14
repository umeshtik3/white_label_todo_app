import 'package:white_label_todo_app/data/todos/model/todo_model.dart';


abstract class TodoRepository {
  Future<List<TodoModel>> fetchTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}
