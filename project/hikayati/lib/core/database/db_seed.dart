import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hikayati/core/database/db_schema.dart';
import 'package:hikayati/core/database/quiz_example.dart';
import 'package:sqflite/sqflite.dart';

/// Database seeding for initial data
///
/// Provides sample data for development and testing.
/// Loads data from JSON files in assets/data directory.
class DatabaseSeed {
  /// Seeds the database with initial data from JSON files
  static Future<void> seedDatabase(Database db) async {
    final batch = db.batch();

    await _seedCategories(batch);
    await _seedUsers(batch);
    await _seedStories(batch);
    await _seedStorySections(batch);

    await batch.commit(noResult: true);
  }

  /// Seeds categories from JSON file
  static Future<void> _seedCategories(Batch batch) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/categories.json',
    );
    final List<dynamic> categories = json.decode(jsonString);

    for (final category in categories) {
      batch.insert(DatabaseSchema.tableCategories, category);
    }
  }

  /// Seeds users from JSON file
  static Future<void> _seedUsers(Batch batch) async {
    final jsonString = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> users = json.decode(jsonString);
    final now = DateTime.now().toIso8601String();

    for (final user in users) {
      final userData = Map<String, dynamic>.from(user);
      userData['created_at'] = now;
      batch.insert(DatabaseSchema.tableUsers, userData);
    }
  }

  /// Seeds stories from JSON file
  static Future<void> _seedStories(Batch batch) async {
    final jsonString = await rootBundle.loadString('assets/data/stories.json');
    final List<dynamic> stories = json.decode(jsonString);
    final now = DateTime.now().toIso8601String();

    for (final story in stories) {
      final storyData = Map<String, dynamic>.from(story);
      storyData['created_at'] = now;

      // Handle quiz example placeholder
      if (storyData['quiz'] == 'quizExample') {
        storyData['quiz'] = quizExample;
      }

      batch.insert(DatabaseSchema.tableStories, storyData);
    }
  }

  /// Seeds story sections from JSON file
  static Future<void> _seedStorySections(Batch batch) async {
    final jsonString = await rootBundle.loadString('assets/data/sections.json');
    final List<dynamic> sections = json.decode(jsonString);
    final now = DateTime.now().toIso8601String();

    for (final section in sections) {
      final sectionData = Map<String, dynamic>.from(section);
      sectionData['created_at'] = now;
      batch.insert(DatabaseSchema.tableSections, sectionData);
    }
  }
}
