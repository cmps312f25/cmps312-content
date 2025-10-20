import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/providers/todo_list_provider.dart';

// Simple stateless input field for adding todos
class TodoEditor extends ConsumerWidget {
  const TodoEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const deepPurple = Color(0xFF5E35B1); // Deep Purple 600

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: deepPurple.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: deepPurple.withValues(alpha: 0.1)),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'What needs to be done?',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: Icon(Icons.add, color: deepPurple),
        ),
        onSubmitted: (text) async {
          if (text.trim().isNotEmpty) {
            await ref.read(todoListProvider.notifier).add(text.trim());
          }
        },
      ),
    );
  }
}
