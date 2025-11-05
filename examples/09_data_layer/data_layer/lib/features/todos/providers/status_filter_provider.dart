import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum for todo status options (better than strings).
enum TodoStatus {
  all,
  pending,
  completed;

  /// Switch expression (concise pattern matching) for display text.
  String get displayName => switch (this) {
    TodoStatus.all => 'All',
    TodoStatus.pending => 'Pending',
    TodoStatus.completed => 'Completed',
  };
}

class StatusFilterNotifier extends Notifier<TodoStatus> {
  @override
  TodoStatus build() => TodoStatus.pending;

  void setFilter(TodoStatus todoStatus) => state = todoStatus;
}

final statusFilterProvider = NotifierProvider<StatusFilterNotifier, TodoStatus>(
  () => StatusFilterNotifier(),
);
