import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/repositories/story_repository.dart';
import 'package:hikayati/core/entities/story.dart';

/// Manages the list of stories with async loading states
class StoriesNotifier extends AsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    return _fetchStories();
  }

  StoryRepository get _repository => ref.read(storyRepositoryProvider);

  Future<List<Story>> _fetchStories({
    String? searchQuery,
    int? categoryId,
    List<int>? categoryIds,
    String? readingLevel,
    List<String>? readingLevels,
    String? language,
  }) async {
    // If multi-select filters provided, fetch broadly then filter client-side
    final bool useClientFiltering =
        (categoryIds != null && categoryIds.isNotEmpty) ||
        (readingLevels != null && readingLevels.isNotEmpty);

    final stories = await _repository.getStories(
      searchQuery: searchQuery,
      categoryId: useClientFiltering ? null : categoryId,
      readingLevel: useClientFiltering ? null : readingLevel,
      language: language,
    );

    if (!useClientFiltering) return stories;

    // Apply client-side filtering for multi-select
    return stories.where((story) {
      final matchesLevel = readingLevels == null || readingLevels.isEmpty
          ? true
          : readingLevels.contains(story.readingLevel.value);
      final matchesCategory = categoryIds == null || categoryIds.isEmpty
          ? true
          : (story.categoryId != null &&
                categoryIds.contains(story.categoryId));
      return matchesLevel && matchesCategory;
    }).toList();
  }

  /// Refresh stories - fetches all stories
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStories());
  }

  /// Search stories by query
  Future<void> search(String query) async {
    if (query.isEmpty) {
      await refresh();
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.searchStories(query));
  }

  /// Filter stories by various criteria
  Future<void> filter({
    String? searchQuery,
    int? categoryId,
    List<int>? categoryIds,
    String? readingLevel,
    List<String>? readingLevels,
    String? language,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchStories(
        searchQuery: searchQuery,
        categoryId: categoryId,
        categoryIds: categoryIds,
        readingLevel: readingLevel,
        readingLevels: readingLevels,
        language: language,
      ),
    );
  }
}

/// Provider for stories
final storiesNotifierProvider =
    AsyncNotifierProvider.autoDispose<StoriesNotifier, List<Story>>(
      StoriesNotifier.new,
    );
