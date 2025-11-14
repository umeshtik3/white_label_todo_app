import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/data/todos/model/todo_model.dart';
import '../../logic/todos/todos_bloc.dart';
import '../../logic/todos/todos_event.dart';

class EditTodoDialog extends StatefulWidget {
  final TodoModel todo;
  const EditTodoDialog({super.key, required this.todo});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.title);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter new task title...',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTitle = _controller.text.trim();
            if (updatedTitle.isNotEmpty && updatedTitle != widget.todo.title) {
              final updatedTodo = widget.todo.copyWith(title: updatedTitle);
              context.read<TodosBloc>().add(UpdateTodo(updatedTodo));
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
