import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/core/entities/quiz.dart';

/// Contract for reading stories
abstract class StoryRepositoryContract {
  /// Get a story by ID for reading
  Future<Story> getStory(int storyId);

  /// Get all pages for a story in order
  Future<List<Section>> getSections(int storyId);

  /// Get quiz for a story
  Future<Quiz?> getQuiz(int storyId);

  /// Generate audio for page text
  Future<String> generateAudioForPage({
    required String sectionId,
    required String text,
    String? language,
  });
}
