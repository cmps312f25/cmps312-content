import 'package:flutter/material.dart';
import 'package:todo_app/widgets/task_tile.dart';
import 'package:todo_app/models/task.dart';

class TasksList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onUpdateTask;
  final Function(Task) onDeleteTask;

  const TasksList({
    super.key,
    required this.tasks,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          taskTitle: task.name,
          isChecked: task.isDone,
          onCheckChanged: (checkboxState) {
            onUpdateTask(task);
          },
          onLongPress: () {
            onDeleteTask(task);
          },
        );
      },
      itemCount: tasks.length,
    );
  }
}
