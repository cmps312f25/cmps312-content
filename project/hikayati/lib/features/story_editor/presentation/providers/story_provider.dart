import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/features/story_editor/repositories/story_repository_impl.dart';

/// Provider for managing a single story in the editor
class StoryNotifier extends AsyncNotifier<Story?> {
  @override
  Future<Story?> build() async {
    return null;
  }

  Future<void> createStory({
    required String title,
    required String language,
    required String readingLevel,
    int? categoryId,
    String? coverImageUrl,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.createStory(
        title: title,
        language: language,
        readingLevel: readingLevel,
        categoryId: categoryId,
        coverImageUrl: coverImageUrl,
      );
    });
  }

  Future<void> loadStory(int storyId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.getStoryForEdit(storyId);
    });
  }

  Future<void> updateStory({
    required int storyId,
    String? title,
    String? language,
    String? readingLevel,
    int? categoryId,
    String? coverImageUrl,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.updateStory(
        storyId: storyId,
        title: title,
        language: language,
        readingLevel: readingLevel,
        categoryId: categoryId,
        coverImageUrl: coverImageUrl,
      );
    });
  }

  void resetStory() {
    state = const AsyncValue.data(null);
  }
}

final storyNotifierProvider = AsyncNotifierProvider<StoryNotifier, Story?>(
  StoryNotifier.new,
);
