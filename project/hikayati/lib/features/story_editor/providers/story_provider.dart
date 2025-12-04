import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/repositories/story_repository.dart';

/// Provider for managing a single story in the editor
class StoryNotifier extends AsyncNotifier<Story?> {
  @override
  Future<Story?> build() async {
    return null;
  }

  Future<void> createStory(Story story) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyRepositoryProvider);
      return await repository.createStory(story);
    });
  }

  Future<void> loadStory(int storyId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyRepositoryProvider);
      return await repository.getStory(storyId);
    });
  }

  Future<void> updateStory(Story story) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyRepositoryProvider);
      return await repository.updateStory(story);
    });
  }

  void resetStory() {
    state = const AsyncValue.data(null);
  }
}

final storyNotifierProvider = AsyncNotifierProvider<StoryNotifier, Story?>(
  StoryNotifier.new,
);
