import 'quiz_question.dart';

class Quiz {
  final int? id;
  final int storyId;
  final List<Question> questions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Quiz({
    this.id,
    required this.storyId,
    required this.questions,
    this.createdAt,
    this.updatedAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questionsList = json['questions'] as List<dynamic>? ?? [];

    return Quiz(
      id: json['id'] as int?,
      storyId: json['story_id'] as int,
      questions: questionsList
          .map(
            (question) => Question.fromJson(question as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'story_id': storyId,
      'questions': questions.map((q) => q.toJson()).toList(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
