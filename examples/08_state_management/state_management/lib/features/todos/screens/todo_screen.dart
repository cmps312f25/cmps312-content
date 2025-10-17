import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/todos/providers/todo_filter_provider.dart';
import 'package:state_management/features/todos/widgets/add_todo_field.dart';
import 'package:state_management/features/todos/widgets/todo_tile.dart';
import 'package:state_management/features/todos/widgets/todo_toolbar.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          const AddTodoField(),
          const TodoToolbar(),
          const Divider(height: 1),
          Expanded(
            child: todos.isEmpty
                ? Center(
                    child: Text(
                      'No todos',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    itemCount: todos.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (_, index) => TodoTile(todo: todos[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
