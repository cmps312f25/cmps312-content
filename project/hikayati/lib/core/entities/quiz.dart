class QuizOption {
  final String text;
  final bool isCorrect;

  QuizOption({required this.text, required this.isCorrect});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'is_correct': isCorrect};
  }
}

class Question {
  final String question;
  final List<QuizOption> options;
  final bool allowMultipleAnswers;

  Question({
    required this.question,
    required this.options,
    this.allowMultipleAnswers = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final optionsList = json['options'] as List;
    return Question(
      question: json['question'] as String,
      options: optionsList
          .map((option) => QuizOption.fromJson(option as Map<String, dynamic>))
          .toList(),
      allowMultipleAnswers: json['allow_multiple_answers'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options.map((o) => o.toJson()).toList(),
      'allow_multiple_answers': allowMultipleAnswers,
    };
  }
}

class Quiz {
  final List<Question> questions;

  Quiz({required this.questions});

  factory Quiz.fromJson(List<dynamic> json) {
    // Handle both old format (list) and new format (map with metadata)
    if (json.isEmpty) {
      return Quiz(questions: []);
    }

    // If it's a map with metadata
    if (json.first is Map && (json.first as Map).containsKey('metadata')) {
      final questionsList = json.first['questions'] as List;
      return Quiz(
        questions: questionsList
            .map(
              (question) => Question.fromJson(question as Map<String, dynamic>),
            )
            .toList(),
      );
    }

    // Old format - just a list of questions
    return Quiz(
      questions: json
          .map(
            (question) => Question.fromJson(question as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'questions': questions.map((q) => q.toJson()).toList()};
  }
}
