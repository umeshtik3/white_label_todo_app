import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/presentation/widgets/todo_item.dart';
import '../../logic/todos/todos_bloc.dart';
import '../../logic/todos/todos_state.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodosLoaded) {
          final todos = state.todos;
          if (todos.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet.\nTap + to add your first To-Do!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItemWidget(todo: todo);
            },
          );
        } else if (state is TodosError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
