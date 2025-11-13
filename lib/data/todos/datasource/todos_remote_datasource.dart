import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:white_label_todo_app/data/todos/datasource/todos_datasource.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';

class TodoRemoteDataSource implements TodoDataSource {
  final String apiBaseUrl;
  TodoRemoteDataSource({required this.apiBaseUrl});

  @override
  Future<List<TodoModel>> fetchTodos() async {
    final response = await http.get(Uri.parse('$apiBaseUrl/todos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => TodoModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch todos from remote');
    }
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await http.post(
      Uri.parse('$apiBaseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await http.put(
      Uri.parse('$apiBaseUrl/todos/${todo.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    await http.delete(Uri.parse('$apiBaseUrl/todos/$id'));
  }

  @override
  Future<void> clearCompleted() async {
    await http.delete(Uri.parse('$apiBaseUrl/todos/clear_completed'));
  }
}
