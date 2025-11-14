import 'package:flutter/foundation.dart';
import 'package:white_label_todo_app/data/todos/datasource/todos_datasource.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';
import 'package:white_label_todo_app/data/todos/repository/todos_repository.dart';

// Note: Registered manually in injection.dart to handle optional remoteDataSource
class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource localDataSource;
  final TodoDataSource? remoteDataSource;

  TodoRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<List<TodoModel>> fetchTodos() async {
    try {
      if (remoteDataSource != null) {
        return await remoteDataSource!.fetchTodos();
      }
    } catch (e) {
      debugPrint('Remote fetch failed, fallback to local: $e');
    }
    return await localDataSource.fetchTodos();
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    try {
      if (remoteDataSource != null) await remoteDataSource!.addTodo(todo);
    } catch (_) {}
    await localDataSource.addTodo(todo);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    try {
      if (remoteDataSource != null) await remoteDataSource!.updateTodo(todo);
    } catch (_) {}
    await localDataSource.updateTodo(todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      if (remoteDataSource != null) await remoteDataSource!.deleteTodo(id);
    } catch (_) {}
    await localDataSource.deleteTodo(id);
  }

  @override
  Future<void> clearCompleted() async {
    try {
      if (remoteDataSource != null) await remoteDataSource!.clearCompleted();
    } catch (_) {}
    await localDataSource.clearCompleted();
  }
}
