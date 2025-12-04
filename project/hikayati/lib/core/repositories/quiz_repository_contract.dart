import 'package:hikayati/core/entities/quiz.dart';

/// Contract for quiz repository operations
abstract class QuizRepositoryContract {
  /// Retrieves a quiz for a specific story
  /// Returns null if no quiz exists for the given story
  Future<Quiz?> getQuiz(int storyId);

  /// Inserts a new quiz or updates an existing one
  /// If quiz.id is null, creates a new quiz
  /// If quiz.id is not null, updates the existing quiz
  /// Returns the saved quiz with generated IDs
  Future<Quiz> upsert(Quiz quiz);
}
