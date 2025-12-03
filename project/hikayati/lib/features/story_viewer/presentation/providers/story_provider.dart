import 'package:hikayati/features/story_viewer/repositories/story_repository_impl.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for fetching a story by ID
final storyProvider = FutureProvider.family<Story, int>((ref, storyId) {
  final repo = ref.watch(readerRepositoryProvider);
  return repo.getStory(storyId);
});
