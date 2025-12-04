import 'package:flutter/material.dart';
import 'package:hikayati/core/entities/quiz.dart';

class QuestionEditorWidget extends StatefulWidget {
  final Question question;
  final ValueChanged<Question> onChanged;
  final VoidCallback onDelete;

  const QuestionEditorWidget({
    super.key,
    required this.question,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<QuestionEditorWidget> createState() => _QuestionEditorWidgetState();
}

class _QuestionEditorWidgetState extends State<QuestionEditorWidget> {
  late TextEditingController _questionController;
  late List<QuizOption> _options;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _options = widget.question.options.toList();
  }

  void _notifyChanged() {
    widget.onChanged(
      Question(question: _questionController.text, options: _options),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question'),
              onChanged: (value) {
                _notifyChanged();
              },
            ),
            const SizedBox(height: 16),
            ..._options.asMap().entries.map((entry) {
              int index = entry.key;
              QuizOption option = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: option.text),
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _options[index] = QuizOption(
                              text: value,
                              isCorrect: option.isCorrect,
                            );
                          });
                          _notifyChanged();
                        },
                      ),
                    ),
                    Checkbox(
                      value: option.isCorrect,
                      onChanged: (value) {
                        setState(() {
                          _options[index] = QuizOption(
                            text: option.text,
                            isCorrect: value ?? false,
                          );
                        });
                        _notifyChanged();
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _options.add(QuizOption(text: '', isCorrect: false));
                    });
                    _notifyChanged();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Option'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
