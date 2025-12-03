import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/features/story_editor/repositories/story_repository_impl.dart';

/// Provider for managing a single section being edited
class SectionNotifier extends AsyncNotifier<Section?> {
  @override
  Future<Section?> build() async {
    return null;
  }

  Future<void> loadSection(int sectionId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.getSection(sectionId);
    });
  }

  Future<Section> createSection({
    required int storyId,
    String? imageUrl,
    String? sectionText,
  }) async {
    final repository = ref.read(storyEditorRepositoryProvider);
    final newSection = await repository.addSection(
      storyId: storyId,
      imageUrl: imageUrl,
      sectionText: sectionText,
    );
    return newSection;
  }

  Future<void> updateSection({
    required int sectionId,
    String? imageUrl,
    String? sectionText,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.updateSection(
        sectionId: sectionId,
        imageUrl: imageUrl,
        sectionText: sectionText,
      );
    });
  }
}

final sectionNotifierProvider =
    AsyncNotifierProvider<SectionNotifier, Section?>(SectionNotifier.new);
