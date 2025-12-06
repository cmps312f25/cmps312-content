import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:kalimati/core/entities/user.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(AppDatabase database) async {
    try {
      final packagesCount = await database.learningPackageDao
          .getPackages()
          .first;

      if (packagesCount.isNotEmpty) {
        await _seedUsers(database);
        return;
      }

      await _seedUsers(database);
      await _seedPackages(database);
      debugPrint('✅ Database seeding completed');
    } catch (e) {
      debugPrint('❌ Error seeding database: $e');
      rethrow;
    }
  }

  static Future<void> _seedPackages(AppDatabase database) async {
    final jsonString = await rootBundle.loadString('assets/data/packages.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    for (final pkg in jsonData) {
      debugPrint('📦 Package: ${pkg['title']}');
      for (final word in pkg['words'] ?? []) {
        debugPrint('  🧠 Word: ${word['text']}');
        for (final res in word['resources'] ?? []) {
          debugPrint('    🔗 Resource URL: ${res['url']}');
        }
      }
    }
    final categories = jsonData
        .map((json) => LearningPackage.fromJson(json))
        .toList();
    await database.learningPackageDao.insertPackages(categories);
  }

  static Future<void> _seedUsers(AppDatabase database) async {
    final jsonString = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final users = jsonData.map((json) => User.fromJson(json)).toList();
    await database.userDao.clearUsers();
    await database.userDao.insertUsers(users);
  }

  static Future<void> resetDatabase() async {
    try {
      // Use sqflite's getDatabasesPath to match Floor's database location
      final dbDir = await sqflite.getDatabasesPath();
      final dbPath = p.join(dbDir, 'kalimati.db');
      final dbFile = File(dbPath);

      debugPrint('🔍 Looking for database at: $dbPath');

      if (await dbFile.exists()) {
        await dbFile.delete();
        debugPrint('🧹 Database deleted successfully');
      } else {
        debugPrint('ℹ️ No existing database found at: $dbPath');
      }

      // Clean up SQLite auxiliary files
      final auxiliaryFiles = ['$dbPath-journal', '$dbPath-shm', '$dbPath-wal'];

      for (final filePath in auxiliaryFiles) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          debugPrint('🧹 Deleted auxiliary file: ${p.basename(filePath)}');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error resetting database: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
