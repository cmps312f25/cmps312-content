import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/todos/models/todo.dart';
import 'package:supabase_app/features/todos/providers/filtered_todos_provider.dart';
import 'package:supabase_app/features/todos/providers/search_query_provider.dart';
import 'package:supabase_app/features/todos/providers/type_filter_provider.dart';
import 'package:supabase_app/features/todos/widgets/todo_editor.dart';
import 'package:supabase_app/features/todos/widgets/todo_tile.dart';
import 'package:supabase_app/features/todos/widgets/todo_toolbar.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(filteredTodosProvider);
    final typeFilter = ref.watch(typeFilterProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          hintText: 'Search todos...',
          leading: const Icon(Icons.search),
          trailing: searchQuery.isNotEmpty
              ? [
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () =>
                        ref.read(searchQueryProvider.notifier).clear(),
                  ),
                ]
              : null,
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).setQuery(value),
          // Styling using WidgetStatePropertyAll to apply the
          // same value across all widget states (e.g., focused, hovered, disabled, selected, etc.)
          elevation: const WidgetStatePropertyAll(0),
          // State-specific values (when you need different styles per state)
          // backgroundColor: const WidgetStatePropertyAll(Colors.white24),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return Colors.deepPurple.shade200; // Light deep purple tone;
            }
            if (states.contains(WidgetState.hovered)) return Colors.amberAccent;
            return Colors.white24; // Default
          }),
          hintStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.white70),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(color: Colors.white),
          ),
          side: const WidgetStatePropertyAll(BorderSide(color: Colors.white70)),
        ),
        backgroundColor: const Color(0xFF5E35B1), // Deep Purple 600
        actions: [
          // Type filter dropdown
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list,
              color: typeFilter != null && typeFilter.isNotEmpty
                  ? Colors.amber
                  : Colors.white,
            ),
            tooltip: 'Filter by type',
            onSelected: (value) {
              ref
                  .read(typeFilterProvider.notifier)
                  .setFilter(value.isEmpty ? null : value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '', child: Text('All Types')),
              ...TodoType.values.map(
                // Use title (capitalized) to match database values
                (type) =>
                    PopupMenuItem(value: type.title, child: Text(type.title)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const TodoEditor(),
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
}
