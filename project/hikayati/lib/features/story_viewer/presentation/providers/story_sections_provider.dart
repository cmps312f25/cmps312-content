import 'package:hikayati/features/story_viewer/repositories/story_repository_impl.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for fetching story sections by story ID
final storySectionsProvider = FutureProvider.family<List<Section>, int>((
  ref,
  storyId,
) {
  final repo = ref.watch(readerRepositoryProvider);
  return repo.getSections(storyId);
});
