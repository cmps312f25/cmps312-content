import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/providers/todo_list_provider.dart';

// Simple stateless input field for adding todos
class AddTodoField extends ConsumerWidget {
  const AddTodoField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        border: Border(bottom: BorderSide(color: Colors.purple.shade100)),
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
          suffixIcon: Icon(Icons.add, color: Colors.purple.shade400),
        ),
        onSubmitted: (text) {
          if (text.trim().isNotEmpty) {
            ref.read(todoListProvider.notifier).add(text.trim());
          }
        },
      ),
    );
  }
}
