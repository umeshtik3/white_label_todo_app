import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:white_label_todo_app/presentation/screens/dynamic_renderer.dart';
import 'package:white_label_todo_app/presentation/screens/todo_list.dart';
import '../../logic/config/config_cubit.dart';
import '../../logic/todos/todos_bloc.dart';
import '../../logic/todos/todos_event.dart';
import '../widgets/add_todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSearchField = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigCubit, ConfigState>(
      builder: (context, state) {
        // ✅ Handle loading / error states safely
        if (state is ConfigLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ConfigError) {
          return Scaffold(
            body: Center(
              child: Text('Failed to load config: ${state.message}'),
            ),
          );
        }

        if (state is! ConfigLoaded) {
          return const Scaffold(
            body: Center(child: Text('Configuration not found')),
          );
        }

        // ✅ Safe access here
        final config = state.config;
        final components = config.components;

        return Scaffold(
          appBar: AppBar(title: Text(config.appName)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (components.showSearchBar)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedCrossFade(
                          firstChild: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showSearchField = true;
                              });
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Search tasks...',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withValues(alpha: .6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          secondChild: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search tasks...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _showSearchField = false;
                                  });
                                  context.read<TodosBloc>().add(
                                    SearchTodos(''),
                                  );
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (query) {
                              context.read<TodosBloc>().add(SearchTodos(query));
                            },
                          ),
                          crossFadeState: _showSearchField
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ],
                  ),
                ),
              if (components.showFilters)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(context, 'all', 'All'),
                      _buildFilterChip(context, 'active', 'Active'),
                      _buildFilterChip(context, 'completed', 'Completed'),
                    ],
                  ),
                ),
              if (components.customButtons.isNotEmpty)
                DynamicRenderer(buttons: components.customButtons),
              const Expanded(child: TodoListScreen()),
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
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String key, String label) {
    final isSelected = _selectedFilter == key;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedFilter = key);
        context.read<TodosBloc>().add(FilterTodos(key));
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }
}
