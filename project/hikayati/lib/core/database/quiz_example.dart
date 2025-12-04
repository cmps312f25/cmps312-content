import 'dart:convert';
import 'package:hikayati/core/entities/quiz.dart';

const quizExample = r'''
{
  "questions": [
    {
      "question": "Which field focuses on building intelligent systems?",
      "options": [
        { "text": "Computer Science", "is_correct": false },
        { "text": "Computer Engineering", "is_correct": false },
        { "text": "Artificial Intelligence", "is_correct": true },
        { "text": "Electrical Engineering", "is_correct": false }
      ],
      "allow_multiple_answers": false
    },
    {
      "question": "Which activities contribute positively to a healthy daily routine?",
      "options": [
        { "text": "Exercise", "is_correct": true },
        { "text": "Prayer", "is_correct": true },
        { "text": "Overeating", "is_correct": false },
        { "text": "Sleeping late", "is_correct": false }
      ],
      "allow_multiple_answers": true
    }
  ]
}
''';

Quiz getQuizExample() {
  final quizData = jsonDecode(quizExample) as Map<String, dynamic>;
  return Quiz.fromJson(quizData);
}
