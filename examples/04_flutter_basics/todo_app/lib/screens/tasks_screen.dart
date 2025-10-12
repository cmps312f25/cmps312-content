import 'package:flutter/material.dart';
import 'package:todo_app/widgets/tasks_header.dart';
import 'package:todo_app/widgets/tasks_container.dart';
import 'package:todo_app/widgets/add_task_fab.dart';
import 'package:todo_app/widgets/task_modal_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_data.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _taskData = TaskData();

  int get taskCount => _taskData.taskCount;

  void addTask(String newTaskTitle) {
    setState(() {
      _taskData.addTask(newTaskTitle);
    });
  }

  void updateTask(Task task) {
    setState(() {
      _taskData.updateTask(task);
    });
  }

  void deleteTask(Task task) {
    setState(() {
      _taskData.deleteTask(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: AddTaskFab(
        onPressed: () => _showAddTaskModal(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TasksHeader(taskCount: taskCount),
          TasksContainer(
            tasks: _taskData.tasks,
            onTaskUpdated: updateTask,
            onTaskDeleted: deleteTask,
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    TaskModalHelper.showAddTaskModal(context, addTask);
  }
}
