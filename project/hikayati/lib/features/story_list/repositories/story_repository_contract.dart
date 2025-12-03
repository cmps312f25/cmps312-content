import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/category.dart';

/// Contract for discovering and searching stories
abstract class StoryRepositoryContract {
  /// Get all published stories with optional filters
  Future<List<Story>> getStories({
    String? searchQuery,
    int? categoryId,
    String? readingLevel,
    String? language,
  });

  /// Get a single story by ID
  Future<Story> getStoryById(int storyId);

  /// Get all available categories
  Future<List<Category>> getAllCategories();

  /// Search stories by title or content
  Future<List<Story>> searchStories(String query);
}
