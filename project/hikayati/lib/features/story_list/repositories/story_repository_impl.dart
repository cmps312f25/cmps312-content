import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/database/database_helper.dart';
import 'package:hikayati/core/providers/database_provider.dart';
import 'package:hikayati/features/story_list/repositories/story_repository_contract.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/category.dart';

class StoryRepositoryImpl implements StoryRepositoryContract {
  final DatabaseHelper _dbHelper;

  StoryRepositoryImpl(this._dbHelper);

  @override
  Future<List<Story>> getStories({
    String? searchQuery,
    int? categoryId,
    String? readingLevel,
    String? language,
  }) async {
    final db = await _dbHelper.database;

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
  Future<Story> getStoryById(int storyId) async {
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
  Future<List<Category>> getAllCategories() async {
    final db = await _dbHelper.database;

    final maps = await db.query('categories', orderBy: 'name ASC');

    return maps.map((json) => Category.fromJson(json)).toList();
  }

  @override
  Future<List<Story>> searchStories(String query) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'stories',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'created_at DESC',
    );

    return maps.map((json) => Story.fromJson(json)).toList();
  }
}

/// Provider for StoryRepository
final storyRepositoryProvider = Provider<StoryRepositoryImpl>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return StoryRepositoryImpl(dbHelper);
});
