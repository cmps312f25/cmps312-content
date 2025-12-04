import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/features/auth/presentation/providers/auth_provider.dart';
import 'package:hikayati/core/repositories/story_repository_contract.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/section.dart';
import 'package:hikayati/core/entities/category.dart';
import 'package:hikayati/core/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class StoryRepository implements StoryRepositoryContract {
  final Future<Database> _database;
  final Ref _ref;

  StoryRepository(this._database, this._ref);

  Future<int> _getCurrentUserId() async {
    final user = _ref.read(currentUserProvider);
    if (user == null || user.id == null) {
      throw Exception('User not authenticated');
    }
    return user.id!;
  }

  // ===== Story CRUD =====
  @override
  Future<Story> createStory(Story story) async {
    final db = await _database;
    final userId = await _getCurrentUserId();

    final storyData = {
      'author_id': userId,
      'title': story.title,
      'language': story.language,
      'reading_level': story.readingLevel.value,
      'created_at': DateTime.now().toIso8601String(),
      if (story.categoryId != null) 'category_id': story.categoryId,
      if (story.coverImageUrl != null) 'cover_image_url': story.coverImageUrl,
    };

    final id = await db.insert('stories', storyData);

    // Query the newly created story to return it with the auto-generated ID
    final maps = await db.query('stories', where: 'id = ?', whereArgs: [id]);
    return Story.fromJson(maps.first);
  }

  @override
  Future<Story> updateStory(Story story) async {
    final db = await _database;

    if (story.id == null) {
      throw Exception('Story ID is required for update');
    }

    final updateData = <String, dynamic>{
      'title': story.title,
      'language': story.language,
      'reading_level': story.readingLevel.value,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (story.categoryId != null) updateData['category_id'] = story.categoryId;
    if (story.coverImageUrl != null) {
      updateData['cover_image_url'] = story.coverImageUrl;
    }

    await db.update(
      'stories',
      updateData,
      where: 'id = ?',
      whereArgs: [story.id],
    );

    final maps = await db.query(
      'stories',
      where: 'id = ?',
      whereArgs: [story.id],
    );

    return Story.fromJson(maps.first);
  }

  @override
  Future<void> deleteStory(int storyId) async {
    final db = await _database;

    // Delete all sections associated with the story
    await db.delete('sections', where: 'story_id = ?', whereArgs: [storyId]);

    // Delete the story itself
    await db.delete('stories', where: 'id = ?', whereArgs: [storyId]);
  }

  // ===== Story Listing & Searching =====

  @override
  Future<List<Story>> getStories({
    String? searchQuery,
    int? categoryId,
    String? readingLevel,
    String? language,
  }) async {
    final db = await _database;

    final conditions = <String>[];
    final args = <dynamic>[];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      conditions.add('title LIKE ?');
      args.add('%$searchQuery%');
    }

    if (categoryId != null) {
      conditions.add('category_id = ?');
      args.add(categoryId);
    }

    if (readingLevel != null) {
      conditions.add('reading_level = ?');
      args.add(readingLevel);
    }

    if (language != null) {
      conditions.add('language = ?');
      args.add(language);
    }

    final maps = await db.query(
      'stories',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'created_at DESC',
    );

    return maps.map((json) => Story.fromJson(json)).toList();
  }

  @override
  Future<List<Story>> searchStories(String query) async {
    final db = await _database;

    final maps = await db.query(
      'stories',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'created_at DESC',
    );

    return maps.map((json) => Story.fromJson(json)).toList();
  }

  // ===== Story Retrieval =====

  @override
  Future<Story> getStory(int storyId) async {
    final db = await _database;

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
  Future<Story> getStoryById(int storyId) async {
    // Delegate to getStory for consistency
    return getStory(storyId);
  }

  // ===== Section Management =====

  @override
  Future<Section> addSection({
    required int storyId,
    String? imageUrl,
    String? sectionText,
    String? audioUrl,
  }) async {
    final db = await _database;

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
    final db = await _database;

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
    final db = await _database;

    await db.delete('sections', where: 'id = ?', whereArgs: [sectionId]);
  }

  @override
  Future<Section> getSection(int sectionId) async {
    final db = await _database;

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
    final db = await _database;

    final maps = await db.query(
      'sections',
      where: 'story_id = ?',
      whereArgs: [storyId],
      orderBy: 'id ASC',
    );

    return maps.map((json) => Section.fromJson(json)).toList();
  }

  // ===== Category Management =====

  @override
  Future<List<Category>> getCategories() async {
    final db = await _database;
    final categoriesJson = await db.query('categories', orderBy: 'name ASC');
    return categoriesJson.map((json) => Category.fromJson(json)).toList();
  }
}

/// Provider for StoryRepository
final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  final db = ref.watch(databaseProvider.future);
  return StoryRepository(db, ref);
});
