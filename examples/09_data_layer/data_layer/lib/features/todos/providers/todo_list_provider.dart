import 'package:data_layer/features/todos/providers/todo_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/providers/filtered_todos_provider.dart';
import 'package:uuid/uuid.dart';

/// Notifier for todo mutations (add, edit, toggle, delete).
/// Does NOT cache todos in memory - delegates display to FilteredTodosNotifier.
/// Performance benefit: Avoids loading all todos when dealing with large datasets.
class TodoListNotifier extends Notifier<void> {
  static const _uuid = Uuid();

  @override
  void build() {
    // No initial state - this is a mutation-only provider
  }

  Future<void> add(
    String description, {
    TodoType type = TodoType.personal,
  }) async {
    final repository = await ref.read(todoRepositoryProvider.future);
    final newTodo = Todo(id: _uuid.v4(), description: description, type: type);

    await repository.addTodo(newTodo);

    // Trigger refresh of filtered todos
    ref.read(filteredTodosProvider.notifier).refresh();
  }

  Future<void> toggle(String id) async {
    final repository = await ref.read(todoRepositoryProvider.future);

    // Fetch only the specific todo from database
    final todo = await repository.getTodoById(id);
    if (todo == null) return;

    final updatedTodo = todo.copyWith(completed: !todo.completed);
    await repository.updateTodo(updatedTodo);

    // Trigger refresh of filtered todos
    ref.read(filteredTodosProvider.notifier).refresh();
  }

  Future<void> edit({required String id, required String description}) async {
    final repository = await ref.read(todoRepositoryProvider.future);

    // Fetch only the specific todo from database
    final todo = await repository.getTodoById(id);
    if (todo == null) return;

    final updatedTodo = todo.copyWith(description: description);
    await repository.updateTodo(updatedTodo);

    // Trigger refresh of filtered todos
    ref.read(filteredTodosProvider.notifier).refresh();
  }

  Future<void> delete(String id) async {
    final repository = await ref.read(todoRepositoryProvider.future);
    await repository.deleteTodo(id);

    // Trigger refresh of filtered todos
    ref.read(filteredTodosProvider.notifier).refresh();
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, void>(
  () => TodoListNotifier(),
);
