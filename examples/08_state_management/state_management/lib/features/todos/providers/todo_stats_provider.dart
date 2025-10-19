import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/providers/todo_list_provider.dart';

/// Derived providers for todo statistics.
/// These automatically recalculate when todoListProvider changes.
/// Separate providers allow widgets to subscribe only to what they need.

final activeTodosCountProvider = Provider<int>(
  (ref) => ref.watch(todoListProvider).where((todo) => !todo.completed).length,
);

final completedTodosCountProvider = Provider<int>(
  (ref) => ref.watch(todoListProvider).where((todo) => todo.completed).length,
);

final totalTodosCountProvider = Provider<int>(
  (ref) => ref.watch(todoListProvider).length,
);
