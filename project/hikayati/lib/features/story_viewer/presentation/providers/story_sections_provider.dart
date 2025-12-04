import 'package:hikayati/core/repositories/story_repository.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for fetching story details by story ID
final storyProvider = FutureProvider.family<Story, int>((ref, storyId) {
  final repo = ref.watch(storyRepositoryProvider);
  return repo.getStory(storyId);
});

/// Provider for fetching story sections by story ID
final storySectionsProvider = FutureProvider.family<List<Section>, int>((
  ref,
  storyId,
) {
  final repo = ref.watch(storyRepositoryProvider);
  return repo.getSections(storyId);
});
