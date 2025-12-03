import 'package:hikayati/features/story_viewer/repositories/story_repository_impl.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for fetching story quiz by story ID
final storyQuizProvider = FutureProvider.family<Quiz?, int>((ref, storyId) {
  final repo = ref.watch(readerRepositoryProvider);
  return repo.getQuiz(storyId);
});
