import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/features/story_editor/repositories/story_repository_impl.dart';

/// Provider for managing quiz of a story
class QuizNotifier extends AsyncNotifier<Quiz?> {
  @override
  Future<Quiz?> build() async {
    return null;
  }

  Future<void> loadQuiz(int storyId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.getQuiz(storyId);
    });
  }

  Future<void> updateQuiz(int storyId, Quiz quiz) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      await repository.updateStory(storyId: storyId, quiz: quiz);
      return quiz;
    });
  }

  Future<void> clearQuiz() async {
    state = const AsyncValue.data(null);
  }
}

final quizNotifierProvider = AsyncNotifierProvider<QuizNotifier, Quiz?>(
  QuizNotifier.new,
);
