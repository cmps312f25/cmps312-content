import 'package:flutter/material.dart';
import 'package:todo_app/screens/task_editor.dart';

class TaskModalHelper {
  static void showAddTaskModal(
    BuildContext context,
    Function(String) onTaskAdded,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TaskEditor(onAddTask: onTaskAdded),
        ),
      ),
    );
  }
}