import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/features/story_editor/repositories/story_repository_impl.dart';

/// Provider for managing sections of a story
class SectionsNotifier extends AsyncNotifier<List<Section>> {
  @override
  Future<List<Section>> build() async {
    return [];
  }

  Future<void> loadSections(int storyId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(storyEditorRepositoryProvider);
      return await repository.getSections(storyId);
    });
  }

  Future<Section> addSection({
    required int storyId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  }) async {
    final repository = ref.read(storyEditorRepositoryProvider);
    final newSection = await repository.addSection(
      storyId: storyId,
      imageUrl: imageUrl,
      sectionText: sectionText,
      audioUrl: audioUrl,
    );

    // Reload sections after adding
    await loadSections(storyId);

    return newSection;
  }

  Future<void> updateSection({
    required int storyId,
    required int sectionId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  }) async {
    final repository = ref.read(storyEditorRepositoryProvider);
    await repository.updateSection(
      sectionId: sectionId,
      imageUrl: imageUrl,
      sectionText: sectionText,
      audioUrl: audioUrl,
    );

    // Reload sections after updating
    await loadSections(storyId);
  }

  Future<void> deleteSection(int sectionId, int storyId) async {
    final repository = ref.read(storyEditorRepositoryProvider);
    await repository.deleteSection(sectionId);

    // Reload sections after deleting
    await loadSections(storyId);
  }

  void clearSections() {
    state = const AsyncValue.data([]);
  }
}

final sectionsNotifierProvider =
    AsyncNotifierProvider<SectionsNotifier, List<Section>>(
      SectionsNotifier.new,
    );
