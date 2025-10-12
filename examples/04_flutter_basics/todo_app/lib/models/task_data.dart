import 'package:todo_app/models/task.dart';
import 'dart:collection';

class TaskData {
  final _tasks = [
    Task(name: 'Study important flutter widgets'),
    Task(name: 'Extend lecture examples'),
    Task(name: 'Go to Gym'),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
  }

  void updateTask(Task task) {
    task.toggleDone();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
  }
}
