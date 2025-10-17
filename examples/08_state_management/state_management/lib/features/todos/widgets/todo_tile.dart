import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/models/todo.dart';
import 'package:state_management/features/todos/providers/todo_list_provider.dart';

// Displays a todo item with checkbox - simple and stateless
class TodoTile extends ConsumerWidget {
  const TodoTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Checkbox(
        value: todo.completed,
        onChanged: (_) => ref.read(todoListProvider.notifier).toggle(todo.id),
      ),
      title: Text(
        todo.description,
        style: TextStyle(
          decoration: todo.completed
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: todo.completed ? Colors.grey : Colors.black,
          fontSize: 16,
        ),
      ),
      onTap: () => ref.read(todoListProvider.notifier).toggle(todo.id),
    );
  }
}
