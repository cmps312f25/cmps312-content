import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/todos/providers/status_filter_provider.dart';
import 'package:supabase_app/features/todos/providers/todo_stats_provider.dart';

class TodoToolbar extends ConsumerWidget {
  const TodoToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatusFilter = ref.watch(statusFilterProvider);
    final todosCount = ref.watch(todosCountProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(
            ref,
            TodoStatus.pending,
            selectedStatusFilter,
            todosCount,
          ),
          _buildButton(
            ref,
            TodoStatus.completed,
            selectedStatusFilter,
            todosCount,
          ),
          _buildButton(ref, TodoStatus.all, selectedStatusFilter, todosCount),
        ],
      ),
    );
  }

  Widget _buildButton(
    WidgetRef ref,
    TodoStatus statusFilter,
    TodoStatus selectedStatusFilter,
    int count,
  ) {
    final isActive = statusFilter == selectedStatusFilter;
    return TextButton(
      onPressed: () =>
          ref.read(statusFilterProvider.notifier).setFilter(statusFilter),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.purple : Colors.grey.shade700,
        backgroundColor: isActive ? Colors.purple.shade50 : null,
      ),
      child: Text(
        isActive
            ? '${statusFilter.displayName} ($count)'
            : statusFilter.displayName,
        style: TextStyle(fontWeight: isActive ? FontWeight.bold : null),
      ),
    );
  }
}
