import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/database/database_helper.dart';
import 'package:hikayati/core/database/db_schema.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/entities/quiz_question.dart';
import 'package:hikayati/core/entities/quiz_option.dart';
import 'package:hikayati/core/repositories/quiz_repository_contract.dart';
import 'package:sqflite/sqflite.dart';

/// Repository for managing quiz data
class QuizRepository implements QuizRepositoryContract {
  Future<Database> get _database => DatabaseHelper.instance.database;

  @override
  /// Retrieves a quiz for a story
  Future<Quiz?> getQuiz(int storyId) async {
    final db = await _database;

    // Get quiz for the story
    final quizMaps = await db.query(
      DatabaseSchema.tableQuizzes,
      where: 'story_id = ?',
      whereArgs: [storyId],
    );

    if (quizMaps.isEmpty) {
      return null;
    }

    final quizMap = quizMaps.first;
    final quizId = quizMap['id'] as int;

    // Get questions for this quiz
    final questionMaps = await db.query(
      DatabaseSchema.tableQuestions,
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );

    final questions = <Question>[];
    for (final questionMap in questionMaps) {
      final questionId = questionMap['id'] as int;

      // Get options for this question
      final optionMaps = await db.query(
        DatabaseSchema.tableOptions,
        where: 'question_id = ?',
        whereArgs: [questionId],
      );

      final options = optionMaps.map((optionMap) {
        return Option(
          id: optionMap['id'] as int?,
          questionId: questionId,
          text: optionMap['text'] as String,
          isCorrect: (optionMap['is_correct'] as int) == 1,
        );
      }).toList();

      questions.add(
        Question(
          id: questionId,
          quizId: quizId,
          text: questionMap['text'] as String,
          options: options,
          isMultiSelect: (questionMap['is_multi_select'] as int) == 1,
        ),
      );
    }

    return Quiz(
      id: quizId,
      storyId: storyId,
      questions: questions,
      createdAt: quizMap['created_at'] != null
          ? DateTime.parse(quizMap['created_at'] as String)
          : null,
      updatedAt: quizMap['updated_at'] != null
          ? DateTime.parse(quizMap['updated_at'] as String)
          : null,
    );
  }

  @override
  /// Inserts or updates a quiz
  Future<Quiz> upsert(Quiz quiz) async {
    final db = await _database;
    final now = DateTime.now().toIso8601String();

    int quizId;

    if (quiz.id != null) {
      // Update existing quiz
      await db.update(
        DatabaseSchema.tableQuizzes,
        {'story_id': quiz.storyId, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [quiz.id],
      );
      quizId = quiz.id!;

      // Delete existing questions and options (cascade)
      await db.delete(
        DatabaseSchema.tableQuestions,
        where: 'quiz_id = ?',
        whereArgs: [quizId],
      );
    } else {
      // Insert new quiz
      quizId = await db.insert(DatabaseSchema.tableQuizzes, {
        'story_id': quiz.storyId,
        'created_at': now,
      });
    }

    // Insert questions and options
    for (final question in quiz.questions) {
      final questionId = await db.insert(DatabaseSchema.tableQuestions, {
        'quiz_id': quizId,
        'text': question.text,
        'is_multi_select': question.isMultiSelect ? 1 : 0,
      });

      // Insert options
      for (final option in question.options) {
        await db.insert(DatabaseSchema.tableOptions, {
          'question_id': questionId,
          'text': option.text,
          'is_correct': option.isCorrect ? 1 : 0,
        });
      }
    }

    // Return the saved quiz by querying it back
    return (await getQuiz(quiz.storyId))!;
  }
}

/// Provider for QuizRepository
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository();
});
