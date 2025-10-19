import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/providers/database_provider.dart';
import 'package:data_layer/features/todos/providers/todo_filter_provider.dart';
import 'package:data_layer/features/todos/providers/search_provider.dart';

/// AsyncNotifier that performs database-level filtering
/// Combines search query, type filter, and completion status filter
/// Benefits: Efficient database queries instead of client-side filtering
class FilteredTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Watch all filter criteria - rebuilds when any changes
    final searchQuery = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(searchTypeFilterProvider);
    final completionFilter = ref.watch(todoFilterProvider);

    final repository = ref.watch(todoRepositoryProvider);

    // Perform database search with type filter
    final todos = await repository.searchTodos(
      searchQuery: searchQuery,
      typeFilter: typeFilter,
    );

    // Apply completion filter (all/pending/completed)
    // This is done client-side as it's a simple boolean check
    return switch (completionFilter) {
      TodoFilter.all => todos,
      TodoFilter.pending => todos.where((todo) => !todo.completed).toList(),
      TodoFilter.completed => todos.where((todo) => todo.completed).toList(),
    };
  }

  // Refresh data - useful after updates/deletes
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final filteredTodosProvider =
    AsyncNotifierProvider<FilteredTodosNotifier, List<Todo>>(
      () => FilteredTodosNotifier(),
    );
