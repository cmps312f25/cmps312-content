import 'package:hikayati/core/repositories/quiz_repository.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for fetching quiz by story ID
final quizProvider = FutureProvider.family<Quiz?, int>((ref, storyId) {
  final repo = ref.watch(quizRepositoryProvider);
  return repo.getQuiz(storyId);
});
