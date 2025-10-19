import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/providers/todo_filter_provider.dart';
import 'package:state_management/features/todos/providers/todo_stats_provider.dart';

class TodoToolbar extends ConsumerWidget {
  const TodoToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoFilterProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            ref,
            TodoFilter.all,
            filter,
            ref.watch(totalTodosCountProvider),
          ),
          _buildButton(
            ref,
            TodoFilter.pending,
            filter,
            ref.watch(activeTodosCountProvider),
          ),
          _buildButton(
            ref,
            TodoFilter.completed,
            filter,
            ref.watch(completedTodosCountProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    WidgetRef ref,
    TodoFilter type,
    TodoFilter current,
    int count,
  ) {
    final isActive = type == current;
    return TextButton(
      onPressed: () => ref.read(todoFilterProvider.notifier).setFilter(type),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.purple : Colors.grey.shade700,
        backgroundColor: isActive ? Colors.purple.shade50 : null,
      ),
      child: Text(
        '${type.displayName} ($count)',
        style: TextStyle(fontWeight: isActive ? FontWeight.bold : null),
      ),
    );
  }
}
