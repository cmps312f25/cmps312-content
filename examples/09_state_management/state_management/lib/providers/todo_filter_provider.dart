import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/models/todo.dart';
import 'package:state_management/providers/todo_list_provider.dart';

/// Filter options for todos.
enum TodoFilter {
  all,
  active,
  completed;

  /// Returns the display name for the filter.
  String get displayName => switch (this) {
    TodoFilter.all => 'All',
    TodoFilter.active => 'Active',
    TodoFilter.completed => 'Completed',
  };
}

/// Manages the active todo filter.
class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  /// Sets the filter to the specified value.
  void setFilter(TodoFilter filter) => state = filter;
}

/// Provides the current todo filter state.
final todoFilterProvider = NotifierProvider<TodoFilterNotifier, TodoFilter>(
  TodoFilterNotifier.new,
);

/// Provides todos filtered by the current filter selection.
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoFilterProvider);
  final todos = ref.watch(todoListProvider);
  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((todo) => !todo.completed).toList(),
    TodoFilter.completed => todos.where((todo) => todo.completed).toList(),
  };
});

/// Provides the count of active (uncompleted) todos.
final activeTodosCountProvider = Provider<int>(
  (ref) => ref.watch(todoListProvider).where((todo) => !todo.completed).length,
);

/// Provides the count of completed todos.
final completedTodosCountProvider = Provider<int>(
  (ref) => ref.watch(todoListProvider).where((todo) => todo.completed).length,
);

/// Provides the total count of all todos.
final totalTodosCountProvider = Provider<int>(
  (ref) => ref.watch(todoListProvider).length,
);
