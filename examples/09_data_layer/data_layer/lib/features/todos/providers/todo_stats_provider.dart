import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/providers/filtered_todos_provider.dart';

/// Derived provider for todo count.
/// Automatically recalculates when filteredTodosProvider changes.
final todosCountProvider = Provider<int>((ref) {
  final todosAsync = ref.watch(filteredTodosProvider);
  // Use maybeWhen to handle only the AsyncValue states you care about
  // Cleaner code when you don't need to differentiate between loading/error
  return todosAsync.maybeWhen(data: (todos) => todos.length, orElse: () => 0);
});
