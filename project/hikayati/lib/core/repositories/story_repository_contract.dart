import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/core/entities/category.dart';

/// Unified contract for all story-related operations
abstract class StoryRepositoryContract {
  // ===== Story Creation & Editing =====

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

  /// Delete a story and all its sections
  Future<void> deleteStory(int storyId);

  // ===== Story Discovery & Listing =====

  /// Get all published stories with optional filters
  Future<List<Story>> getStories({
    String? searchQuery,
    int? categoryId,
    String? readingLevel,
    String? language,
  });

  /// Search stories by title or content
  Future<List<Story>> searchStories(String query);

  // ===== Story Retrieval =====

  /// Get a story by ID
  Future<Story> getStory(int storyId);

  /// Get a single story by ID (alias for consistency)
  Future<Story> getStoryById(int storyId);

  // ===== Section Management =====

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

  /// Get all sections for a story in order
  Future<List<Section>> getSections(int storyId);

  // ===== Quiz Management =====

  /// Get quiz for a story
  Future<Quiz?> getQuiz(int storyId);

  // ===== Category Management =====

  /// Get all available categories
  Future<List<Category>> getCategories();
}
