class Option {
  final int? id;
  final int questionId;
  final String text;
  final bool isCorrect;

  Option({
    this.id,
    required this.questionId,
    required this.text,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as int?,
      questionId: json['question_id'] as int,
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'question_id': questionId,
      'text': text,
      'is_correct': isCorrect,
    };
  }
}
