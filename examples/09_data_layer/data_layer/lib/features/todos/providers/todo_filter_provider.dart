import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for type-safe filter options (better than strings).
enum TodoFilter {
  all,
  pending,
  completed;

  /// Switch expression (concise pattern matching) for display text.
  String get displayName => switch (this) {
    TodoFilter.all => 'All',
    TodoFilter.pending => 'Pending',
    TodoFilter.completed => 'Completed',
  };
}

class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) => state = filter;
}

final todoFilterProvider = NotifierProvider<TodoFilterNotifier, TodoFilter>(
  () => TodoFilterNotifier(),
);
