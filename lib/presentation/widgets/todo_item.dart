import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';
import '../../logic/todos/todos_bloc.dart';
import '../../logic/todos/todos_event.dart';
import 'edit_todo_dialog.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  const TodoItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
          
            Checkbox(
              value: todo.isCompleted,
              onChanged: (_) {
                context.read<TodosBloc>().add(ToggleTodoStatus(todo.id));
              },
            ),

            
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.isCompleted
                      ? theme.disabledColor
                      : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),

        
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: theme.primaryColor,
              tooltip: 'Edit Task',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<TodosBloc>(),
                    child: EditTodoDialog(todo: todo),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.redAccent,
              tooltip: 'Delete Task',
              onPressed: () {
                _confirmDelete(context, todo);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TodoModel todo) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                context.read<TodosBloc>().add(DeleteTodo(todo.id));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleted: ${todo.title}')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
