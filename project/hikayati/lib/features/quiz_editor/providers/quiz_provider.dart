import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/repositories/quiz_repository.dart';

/// Provider for managing quiz of a story
class QuizNotifier extends AsyncNotifier<Quiz?> {
  @override
  Future<Quiz?> build() async {
    return null;
  }

  Future<void> loadQuiz(int storyId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(quizRepositoryProvider);
      return await repository.getQuiz(storyId);
    });
  }

  Future<void> updateQuiz(int storyId, Quiz quiz) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final quizRepository = ref.read(quizRepositoryProvider);
      // Ensure the quiz has the correct storyId
      final quizToSave = Quiz(
        id: quiz.id,
        storyId: storyId,
        questions: quiz.questions
      );
      // Return the saved quiz with generated IDs
      return await quizRepository.upsert(quizToSave);
    });
  }

  Future<void> clearQuiz() async {
    state = const AsyncValue.data(null);
  }
}

final quizNotifierProvider = AsyncNotifierProvider<QuizNotifier, Quiz?>(
  QuizNotifier.new,
);
