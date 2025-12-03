import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/database/database_helper.dart';
import 'package:hikayati/core/providers/database_provider.dart';
import 'package:hikayati/features/story_viewer/repositories/story_repository_contract.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'dart:convert';

class StoryRepositoryImpl implements StoryRepositoryContract {
  final DatabaseHelper _dbHelper;

  StoryRepositoryImpl(this._dbHelper);

  @override
  Future<Story> getStory(int storyId) async {
    final db = await _dbHelper.database;

    // No user check needed for reading a story
    final maps = await db.query(
      'stories',
      where: 'id = ?',
      whereArgs: [storyId],
    );

    if (maps.isEmpty) {
      throw Exception('Story not found');
    }

    return Story.fromJson(maps.first);
  }

  @override
  Future<List<Section>> getSections(int storyId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'sections',
      where: 'story_id = ?',
      whereArgs: [storyId],
      orderBy: 'id ASC',
    );

    return maps.map((json) => Section.fromJson(json)).toList();
  }

  @override
  Future<Quiz?> getQuiz(int storyId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'stories',
      columns: ['quiz'],
      where: 'id = ?',
      whereArgs: [storyId],
    );

    if (maps.isEmpty || maps.first['quiz'] == null) {
      return null;
    }

    final quizData = jsonDecode(maps.first['quiz'] as String);

    // Handle both formats: direct list or wrapped in 'questions' key
    if (quizData is List) {
      return Quiz.fromJson(quizData);
    } else if (quizData is Map && quizData.containsKey('questions')) {
      return Quiz.fromJson(quizData['questions'] as List);
    }

    return null;
  }

  @override
  Future<String> generateAudioForPage({
    required String sectionId,
    required String text,
    String? language,
  }) async {
    // In production, this would call a text-to-speech service
    // For now, return a placeholder URL
    return 'https://placeholder.com/audio/$sectionId.mp3';
  }
}

/// Provider for ReaderRepository
final readerRepositoryProvider = Provider<StoryRepositoryImpl>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return StoryRepositoryImpl(dbHelper);
});
