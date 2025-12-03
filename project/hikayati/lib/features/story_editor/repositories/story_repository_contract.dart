import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/section.dart';

/// Contract for creating and editing stories
abstract class StoryRepositoryContract {
  /// Create a new story
  Future<Story> createStory({
    required String title,
    required String language,
    required String readingLevel,
    int? categoryId,
    String? coverImageUrl,
  });

  /// Update an existing story
  Future<Story> updateStory({
    required int storyId,
    String? title,
    String? language,
    String? readingLevel,
    int? categoryId,
    String? coverImageUrl,
    Quiz? quiz,
  });

  /// Get a story by ID for editing
  Future<Story> getStoryForEdit(int storyId);

  /// Add a section to a story
  Future<Section> addSection({
    required int storyId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  });

  /// Update an existing section
  Future<Section> updateSection({
    required int sectionId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  });

  /// Delete a section
  Future<void> deleteSection(int sectionId);

  /// Get a single section by ID
  Future<Section> getSection(int sectionId);

  /// Get all sections for a story
  Future<List<Section>> getSections(int storyId);

  /// Get quiz for a story
  Future<Quiz?> getQuiz(int storyId);
}
