import 'package:flutter/material.dart';
import 'package:white_label_todo_app/data/config/model/config_model.dart';

class DynamicRenderer extends StatelessWidget {
  final List<CustomButton> buttons;

  const DynamicRenderer({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: buttons.map((btn) {
          return ElevatedButton(
            onPressed: () => _handleAction(context, btn.action),
            child: Text(btn.label),
          );
        }).toList(),
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'export_todos':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export To-Dos triggered')),
        );
        break;
      case 'clear_completed':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clear completed triggered')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown action: $action')),
        );
    }
  }
}
