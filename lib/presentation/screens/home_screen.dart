import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/presentation/screens/dynamic_renderer.dart';
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
                        FilterChip(label: const Text('All'), onSelected: (_) {}),
                        FilterChip(label: const Text('Active'), onSelected: (_) {}),
                        FilterChip(label: const Text('Completed'), onSelected: (_) {}),
                      ],
                    ),
                  ),

                // Dynamic custom buttons
                if (components.customButtons.isNotEmpty)
                  DynamicRenderer(buttons: components.customButtons),

                const Expanded(
                  child: Center(
                    child: Text(
                      'To-Do List will appear here',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: components.showAddButton
                ? FloatingActionButton(
                    onPressed: () {
                      // Add-To-Do dialog will go here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add To-Do tapped')),
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        }

        if (state is ConfigError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
