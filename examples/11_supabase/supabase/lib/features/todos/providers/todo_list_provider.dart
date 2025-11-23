import 'package:supabase_app/features/todos/providers/todo_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/todos/models/todo.dart';
import 'package:supabase_app/features/auth/providers/auth_provider.dart';

/// Notifier for todo mutations (add, edit, toggle, delete).
/// Does NOT manually refresh - relies on Supabase realtime streams for automatic updates.
/// Performance benefit: Avoids unnecessary refetches, streams handle updates automatically.
class TodoListNotifier extends Notifier<void> {
  @override
  void build() {
    // No initial state - this is a mutation-only provider
  }

  Future<void> add(
    String description, {
    TodoType type = TodoType.personal,
  }) async {
    final repository = ref.read(todoRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);

    // Get the current user's ID
    final userId = authRepository.currentUser?.id;

    // Create new todo with the current user's ID
    final newTodo = Todo(
      description: description,
      type: type,
      createdBy: userId,
    );

    await repository.addTodo(newTodo);
    // No manual refresh needed - realtime stream will auto-update
  }

  Future<void> toggle(int id) async {
    final repository = ref.read(todoRepositoryProvider);

    // Fetch only the specific todo from database
    final todo = await repository.getTodoById(id);
    if (todo == null) return;

    final updatedTodo = todo.copyWith(completed: !todo.completed);
    await repository.updateTodo(updatedTodo);
    // No manual refresh needed - realtime stream will auto-update
  }

  Future<void> edit({required int id, required String description}) async {
    final repository = ref.read(todoRepositoryProvider);

    // Fetch only the specific todo from database
    final todo = await repository.getTodoById(id);
    if (todo == null) return;

    final updatedTodo = todo.copyWith(description: description);
    await repository.updateTodo(updatedTodo);
    // No manual refresh needed - realtime stream will auto-update
  }

  Future<void> delete(int id) async {
    final repository = ref.read(todoRepositoryProvider);
    await repository.deleteTodo(id);
    // No manual refresh needed - realtime stream will auto-update
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, void>(
  () => TodoListNotifier(),
);
