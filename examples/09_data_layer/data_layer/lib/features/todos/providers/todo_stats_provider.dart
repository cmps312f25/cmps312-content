import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/providers/todo_list_provider.dart';

/// Derived providers for todo statistics.
/// These automatically recalculate when todoListProvider changes.
/// Separate providers allow widgets to subscribe only to what they need.
/// Now works with AsyncValue from StreamNotifier.

final activeTodosCountProvider = Provider<int>((ref) {
  final todosAsync = ref.watch(todoListProvider);
  return todosAsync.maybeWhen(
    data: (todos) => todos.where((todo) => !todo.completed).length,
    orElse: () => 0,
  );
});

final completedTodosCountProvider = Provider<int>((ref) {
  final todosAsync = ref.watch(todoListProvider);
  return todosAsync.maybeWhen(
    data: (todos) => todos.where((todo) => todo.completed).length,
    orElse: () => 0,
  );
});

final totalTodosCountProvider = Provider<int>((ref) {
  final todosAsync = ref.watch(todoListProvider);
  return todosAsync.maybeWhen(data: (todos) => todos.length, orElse: () => 0);
});
