import 'package:flutter/material.dart';

class TaskEditor extends StatelessWidget {
  final Function(String) onAddTask;

  const TaskEditor({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    // Controller used to retrieve text input from the TextField
    final textController = TextEditingController();

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0, color: Colors.lightBlueAccent),
            ),
            TextField(
              controller: textController,
              autofocus: true,
              textAlign: TextAlign.center,
              onSubmitted: (value) => _handleAddTask(context, textController),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              onPressed: () => _handleAddTask(context, textController),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void _handleAddTask(BuildContext context, TextEditingController textController) {
    final taskTitle = textController.text.trim();
    if (taskTitle.isNotEmpty) {
      onAddTask(taskTitle);
      Navigator.pop(context);
    }
  }
}
