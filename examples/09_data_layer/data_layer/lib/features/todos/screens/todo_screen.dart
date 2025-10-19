import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/providers/filtered_todos_provider.dart';
import 'package:data_layer/features/todos/providers/search_provider.dart';
import 'package:data_layer/features/todos/widgets/add_todo_field.dart';
import 'package:data_layer/features/todos/widgets/todo_tile.dart';
import 'package:data_layer/features/todos/widgets/todo_toolbar.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(filteredTodosProvider);
    final typeFilter = ref.watch(searchTypeFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: const Color(0xFF5E35B1), // Deep Purple 600
        foregroundColor: Colors.white,
        // Search actions in app bar for easy access
        actions: [
          // Type filter dropdown - filters todos by category
          PopupMenuButton<String?>(
            icon: Icon(
              Icons.filter_list,
              color: typeFilter != null ? Colors.amber : Colors.white,
            ),
            tooltip: 'Filter by type',
            onSelected: (value) {
              // Use notifier method for type-safe state updates
              ref.read(searchTypeFilterProvider.notifier).setFilter(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Types')),
              ...TodoType.values.map(
                (type) =>
                    PopupMenuItem(value: type.name, child: Text(type.title)),
              ),
            ],
          ),
          // Search button opens search bar
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search todos',
            onPressed: () => _showSearchBar(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          const AddTodoField(),
          const TodoToolbar(),
          const Divider(height: 1),
          Expanded(
            child: todosAsync.when(
              data: (todos) {
                if (todos.isEmpty) {
                  return Center(
                    child: Text(
                      'No todos',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: todos.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (_, index) => TodoTile(todo: todos[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show search bar using showSearch with custom delegate
  void _showSearchBar(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Todos'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter search query...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // Update search query on every keystroke
            // Provider watches this and triggers database search
            ref.read(searchQueryProvider.notifier).setQuery(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Clear search when closing
              ref.read(searchQueryProvider.notifier).clear();
              Navigator.pop(context);
            },
            child: const Text('Clear & Close'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
