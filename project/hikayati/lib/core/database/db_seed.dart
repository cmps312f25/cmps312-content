import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hikayati/core/database/db_schema.dart';
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
    await _seedQuizzes(db);

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

  /// Seeds quizzes from JSON file
  static Future<void> _seedQuizzes(Database db) async {
    final jsonString = await rootBundle.loadString('assets/data/quizzes.json');
    final List<dynamic> quizzes = json.decode(jsonString);
    final now = DateTime.now().toIso8601String();

    for (final quiz in quizzes) {
      final quizData = Map<String, dynamic>.from(quiz);
      quizData['created_at'] = now;

      // Insert quiz and get its ID
      final quizId = await db.insert(DatabaseSchema.tableQuizzes, {
        'story_id': quizData['story_id'],
        'created_at': now,
      });

      // Insert questions
      final questions = quizData['questions'] as List<dynamic>;
      for (final question in questions) {
        final questionData = Map<String, dynamic>.from(question);

        // Insert question and get its ID
        final questionId = await db.insert(DatabaseSchema.tableQuestions, {
          'quiz_id': quizId,
          'text': questionData['text'],
          'is_multi_select': questionData['is_multi_select'] == true ? 1 : 0,
        });

        // Insert options
        final options = questionData['options'] as List<dynamic>;
        for (final option in options) {
          final optionData = Map<String, dynamic>.from(option);
          await db.insert(DatabaseSchema.tableOptions, {
            'question_id': questionId,
            'text': optionData['text'],
            'is_correct': optionData['is_correct'] == true ? 1 : 0,
          });
        }
      }
    }
  }
}
