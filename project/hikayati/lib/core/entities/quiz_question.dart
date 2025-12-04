import 'quiz_option.dart';

class Question {
  final int? id;
  final int quizId;
  final String text;
  final List<Option> options;
  final bool isMultiSelect;

  Question({
    this.id,
    required this.quizId,
    required this.text,
    required this.options,
    this.isMultiSelect = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final optionsList = json['options'] as List;
    return Question(
      id: json['id'] as int?,
      quizId: json['quiz_id'] as int,
      text: json['text'] as String,
      options: optionsList
          .map((option) => Option.fromJson(option as Map<String, dynamic>))
          .toList(),
      isMultiSelect: json['is_multi_select'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'quiz_id': quizId,
      'text': text,
      'options': options.map((o) => o.toJson()).toList(),
      'is_multi_select': isMultiSelect,
    };
  }
}
