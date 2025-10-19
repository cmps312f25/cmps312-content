import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/providers/database_provider.dart';
import 'package:uuid/uuid.dart';

/// AsyncNotifier for todos with database persistence.
/// Simple approach: load from database, manage in memory, persist changes.
class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  static const _uuid = Uuid();

  @override
  Future<List<Todo>> build() async {
    final repository = ref.watch(todoRepositoryProvider);
    return await repository.getAllTodos();
  }

  Future<void> add(
    String description, {
    TodoType type = TodoType.personal,
  }) async {
    final repository = ref.read(todoRepositoryProvider);
    final newTodo = Todo(id: _uuid.v4(), description: description, type: type);

    await repository.addTodo(newTodo);

    // Update state optimistically
    state = AsyncValue.data([...state.value ?? [], newTodo]);
  }

  Future<void> toggle(String id) async {
    final repository = ref.read(todoRepositoryProvider);
    final todos = state.value ?? [];
    final todo = todos.firstWhere((t) => t.id == id);

    final updatedTodo = todo.copyWith(completed: !todo.completed);
    await repository.updateTodo(updatedTodo);

    // Update state
    state = AsyncValue.data([
      for (final t in todos)
        if (t.id == id) updatedTodo else t,
    ]);
  }

  Future<void> edit({required String id, required String description}) async {
    final repository = ref.read(todoRepositoryProvider);
    final todos = state.value ?? [];
    final todo = todos.firstWhere((t) => t.id == id);

    final updatedTodo = todo.copyWith(description: description);
    await repository.updateTodo(updatedTodo);

    // Update state
    state = AsyncValue.data([
      for (final t in todos)
        if (t.id == id) updatedTodo else t,
    ]);
  }

  Future<void> remove(String id) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.deleteTodo(id);

    // Update state
    final todos = state.value ?? [];
    state = AsyncValue.data(todos.where((t) => t.id != id).toList());
  }
}

final todoListProvider = AsyncNotifierProvider<TodoListNotifier, List<Todo>>(
  () => TodoListNotifier(),
);
