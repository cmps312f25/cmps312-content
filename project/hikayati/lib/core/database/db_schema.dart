import 'package:sqflite/sqflite.dart';

/// Database schema management
///
/// Handles all database table creation, indexing, and schema migrations.
class DatabaseSchema {
  /// Table names as constants for type safety
  static const String tableUsers = 'users';
  static const String tableCategories = 'categories';
  static const String tableStories = 'stories';
  static const String tableSections = 'sections';

  /// Creates all database tables
  static Future<void> createTables(Database db) async {
    await _createUsersTable(db);
    await _createCategoriesTable(db);
    await _createStoriesTable(db);
    await _createSectionsTable(db);
    await _createIndexes(db);
  }

  /// Creates the users table
  static Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'Author',
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }

  /// Creates the categories table
  static Future<void> _createCategoriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        icon TEXT NOT NULL
      )
    ''');
  }

  /// Creates the stories table
  static Future<void> _createStoriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableStories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        language TEXT NOT NULL,
        cover_image_url TEXT,
        reading_level TEXT NOT NULL,
        category_id INTEGER,
        author_id INTEGER NOT NULL,
        quiz TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (author_id) REFERENCES $tableUsers (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES $tableCategories (id) ON DELETE SET NULL
      )
    ''');
  }

  /// Creates the sections table
  static Future<void> _createSectionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableSections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        story_id INTEGER NOT NULL,
        image_url TEXT,
        section_text TEXT,
        audio_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (story_id) REFERENCES $tableStories (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Creates indexes for optimized query performance
  ///
  /// Indexes are created on foreign keys and frequently queried columns
  static Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stories_author ON $tableStories (author_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_stories_category ON $tableStories (category_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sections_story ON $tableSections (story_id)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_users_email ON $tableUsers (email)',
    );
  }

  /// Handles database schema upgrades
  ///
  /// This method is called when the database version increases.
  /// Implement migration logic for each version increment.
  static Future<void> upgradeSchema(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Apply migrations incrementally
    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _applyMigration(db, version);
    }
  }

  /// Applies migration for a specific version
  static Future<void> _applyMigration(Database db, int toVersion) async {
    switch (toVersion) {
      case 2:
        // Example: Add profile_image column to users table
        // await db.execute(
        //   'ALTER TABLE $tableUsers ADD COLUMN profile_image TEXT',
        // );
        break;
      case 3:
        // Example: Add new table or modify existing schema
        break;
      default:
        throw Exception('Unknown database version: $toVersion');
    }
  }
}
