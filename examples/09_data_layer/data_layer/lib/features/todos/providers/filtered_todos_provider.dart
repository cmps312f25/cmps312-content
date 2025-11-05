import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/providers/status_filter_provider.dart';
import 'package:data_layer/features/todos/providers/search_query_provider.dart';
import 'package:data_layer/features/todos/providers/type_filter_provider.dart';
import 'package:data_layer/features/todos/providers/todo_repository_provider.dart';

/// AsyncNotifier that performs database-level filtering
/// Combines search query, type filter, and completion status filter
/// Benefits: Efficient database queries instead of client-side filtering
class FilteredTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Watch all filter criteria - rebuilds when any changes
    final searchQuery = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(typeFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);

    final todoRepository = await ref.watch(todoRepositoryProvider.future);

    // Perform database search with all filters
    // Empty/null filters are ignored by the SQL query
    return await todoRepository.searchTodos(
      searchQuery: searchQuery,
      typeFilter: typeFilter,
      statusFilter: statusFilter,
    );
  }

  // Refresh data - useful after updates/deletes
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    // Re-run build to fetch fresh data and update state
    // .guard handles errors and sets state accordingly
    state = await AsyncValue.guard(() => build());
  }
}

final filteredTodosProvider =
    AsyncNotifierProvider<FilteredTodosNotifier, List<Todo>>(
      () => FilteredTodosNotifier(),
    );
