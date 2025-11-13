import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';
import '../../logic/todos/todos_bloc.dart';
import '../../logic/todos/todos_event.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter task title...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _controller.text.trim();
            if (title.isNotEmpty) {
              final todo = TodoModel(id: const Uuid().v4(), title: title);
              context.read<TodosBloc>().add(AddTodo(todo));
            }
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
