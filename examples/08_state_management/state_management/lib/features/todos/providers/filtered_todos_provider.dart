import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/models/todo.dart';
import 'package:state_management/features/todos/providers/todo_list_provider.dart';
import 'package:state_management/features/todos/providers/todo_filter_provider.dart';

/// Computed provider combining filter and todo list.
/// Rebuilds efficiently when either dependency changes.
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todos = ref.watch(todoListProvider);

  // Switch expression provides exhaustive pattern matching
  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.pending => todos.where((todo) => !todo.completed).toList(),
    TodoFilter.completed => todos.where((todo) => todo.completed).toList(),
  };
});
