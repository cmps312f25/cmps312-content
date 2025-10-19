import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/models/todo.dart';
import 'package:state_management/features/todos/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';

/// Notifier for complex state with CRUD operations.
/// State is immutable - we create new lists rather than modifying existing ones.
class TodoListNotifier extends Notifier<List<Todo>> {
  static const _uuid = Uuid();

  @override
  List<Todo> build() => TodoRepository.getTodos();

  void add(String description) {
    // Spread operator creates new list (immutability)
    state = [...state, Todo(id: _uuid.v4(), description: description)];
  }

  void toggle(String id) {
    // Map through list, creating new Todo objects (immutability)
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(id: todo.id, completed: todo.completed, description: description)
        else
          todo,
    ];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  () => TodoListNotifier(),
);
