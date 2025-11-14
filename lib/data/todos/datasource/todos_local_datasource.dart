import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:white_label_todo_app/data/todos/datasource/todos_datasource.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';

// Note: Not using @injectable annotation because of default parameter
// Registered manually in injection.dart
class TodoLocalDataSource implements TodoDataSource {
  final String assetPath;
  final List<TodoModel> _todos = [];

  TodoLocalDataSource({this.assetPath = 'assets/todos/todos.json'});

  Future<void> _initialize() async {
    if (_todos.isEmpty) {
      final jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> data = json.decode(jsonString);
      _todos.addAll(data.map((e) => TodoModel.fromJson(e)));
    }
  }

  @override
  Future<List<TodoModel>> fetchTodos() async {
    await _initialize();
    return List<TodoModel>.from(_todos);
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    _todos.add(todo);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) _todos[index] = todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
  }

}
