import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/logic/todos/todos_bloc.dart';
import 'package:white_label_todo_app/presentation/screens/dynamic_renderer.dart';
import 'package:white_label_todo_app/presentation/screens/todo_list.dart';
import 'package:white_label_todo_app/presentation/widgets/add_todo_dialog.dart';
import '../../../logic/config/config_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, state) {
        if (state is ConfigLoaded) {
          final config = state.config;
          final components = config.components;

          return Scaffold(
            appBar: AppBar(
              title: Text(config.appName),
              actions: [
                if (components.showSearchBar)
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // handle search later
                    },
                  ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (components.showFilters)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text('Active'),
                          onSelected: (_) {},
                        ),
                        FilterChip(
                          label: const Text('Completed'),
                          onSelected: (_) {},
                        ),
                      ],
                    ),
                  ),

                // Dynamic custom buttons
                if (components.customButtons.isNotEmpty)
                  DynamicRenderer(buttons: components.customButtons),

                Expanded(child: const TodoListScreen()),
              ],
            ),
            floatingActionButton: components.showAddButton
                ? FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: context.read<TodosBloc>(),
                          child: const AddTodoDialog(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        }

        if (state is ConfigError) {
          return Scaffold(body: Center(child: Text('Error: ${state.message}')));
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
