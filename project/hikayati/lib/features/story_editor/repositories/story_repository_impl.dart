import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/database/database_helper.dart';
import 'package:hikayati/core/providers/database_provider.dart';
import 'package:hikayati/features/auth/presentation/providers/auth_provider.dart';
import 'package:hikayati/features/story_editor/repositories/story_repository_contract.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/core/entities/quiz.dart';

class StoryRepositoryImpl implements StoryRepositoryContract {
  final DatabaseHelper _dbHelper;
  final Ref _ref;

  StoryRepositoryImpl(this._dbHelper, this._ref);

  Future<int> _getCurrentUserId() async {
    final user = _ref.read(currentUserProvider);
    if (user == null || user.id == null) {
      throw Exception('User not authenticated');
    }
    return user.id!;
  }

  @override
  Future<Story> createStory({
    required String title,
    required String language,
    required String readingLevel,
    int? categoryId,
    String? coverImageUrl,
  }) async {
    final db = await _dbHelper.database;
    final userId = await _getCurrentUserId();

    // TODO: Remove the default quiz
    final storyData = {
      'author_id': userId,
      'title': title,
      'language': language,
      'reading_level': readingLevel,
      'created_at': DateTime.now().toIso8601String(),
      if (categoryId != null) 'category_id': categoryId,
      if (coverImageUrl != null) 'cover_image_url': coverImageUrl,
    };

    final id = await db.insert('stories', storyData);

    // Query the newly created story to return it with the auto-generated ID
    final maps = await db.query('stories', where: 'id = ?', whereArgs: [id]);
    return Story.fromJson(maps.first);
  }

  @override
  Future<Story> updateStory({
    required int storyId,
    String? title,
    String? language,
    String? readingLevel,
    int? categoryId,
    String? coverImageUrl,
    Quiz? quiz,
  }) async {
    final db = await _dbHelper.database;

    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (title != null) updateData['title'] = title;
    if (language != null) updateData['language'] = language;
    if (readingLevel != null) updateData['reading_level'] = readingLevel;
    if (categoryId != null) updateData['category_id'] = categoryId;
    if (coverImageUrl != null) updateData['cover_image_url'] = coverImageUrl;
    if (quiz != null) {
      // Use the quiz's toJson method to properly serialize all fields including
      // allowMultipleAnswers for each question
      final quizJson = quiz.toJson();
      // Store as a list with the metadata and questions
      updateData['quiz'] = jsonEncode([quizJson]);
    }

    await db.update(
      'stories',
      updateData,
      where: 'id = ?',
      whereArgs: [storyId],
    );

    final maps = await db.query(
      'stories',
      where: 'id = ?',
      whereArgs: [storyId],
    );

    return Story.fromJson(maps.first);
  }

  @override
  Future<Story> getStoryForEdit(int storyId) async {
    final db = await _dbHelper.database;

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
  Future<Section> addSection({
    required int storyId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  }) async {
    final db = await _dbHelper.database;

    final sectionData = {
      'story_id': storyId,
      'created_at': DateTime.now().toIso8601String(),
      if (imageUrl != null) 'image_url': imageUrl,
      if (sectionText != null) 'section_text': sectionText,
      if (audioUrl != null) 'audio_url': audioUrl,
    };

    final id = await db.insert('sections', sectionData);

    // Query the newly created section to return it with the auto-generated ID
    final maps = await db.query('sections', where: 'id = ?', whereArgs: [id]);
    return Section.fromJson(maps.first);
  }

  @override
  Future<Section> updateSection({
    required int sectionId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  }) async {
    final db = await _dbHelper.database;

    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (imageUrl != null) updateData['image_url'] = imageUrl;
    if (sectionText != null) updateData['section_text'] = sectionText;
    if (audioUrl != null) updateData['audio_url'] = audioUrl;

    await db.update(
      'sections',
      updateData,
      where: 'id = ?',
      whereArgs: [sectionId],
    );

    final maps = await db.query(
      'sections',
      where: 'id = ?',
      whereArgs: [sectionId],
    );

    return Section.fromJson(maps.first);
  }

  @override
  Future<void> deleteSection(int sectionId) async {
    final db = await _dbHelper.database;

    await db.delete('sections', where: 'id = ?', whereArgs: [sectionId]);
  }

  @override
  Future<Section> getSection(int sectionId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'sections',
      where: 'id = ?',
      whereArgs: [sectionId],
    );

    if (maps.isEmpty) {
      throw Exception('Section not found');
    }

    return Section.fromJson(maps.first);
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
}

/// Provider for StoryEditorRepository
final storyEditorRepositoryProvider = Provider<StoryRepositoryImpl>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return StoryRepositoryImpl(dbHelper, ref);
});
