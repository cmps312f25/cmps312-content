import 'package:hikayati/core/database/quiz_example.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Database Helper for managing local SQLite database
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hikayati.db');
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Create all tables when database is first created
  Future<void> _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
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

    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        icon TEXT NOT NULL
      )
    ''');

    // Create stories table
    await db.execute('''
      CREATE TABLE stories (
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
        FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // Create sections table
    await db.execute('''
      CREATE TABLE sections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        story_id INTEGER NOT NULL,
        image_url TEXT,
        section_text TEXT,
        audio_url TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        FOREIGN KEY (story_id) REFERENCES stories (id) ON DELETE CASCADE
      )
    ''');

    // Seed the database with initial data
    await _seedDatabase(db);

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_stories_author ON stories (author_id)');
    await db.execute(
      'CREATE INDEX idx_stories_category ON stories (category_id)',
    );
    await db.execute('CREATE INDEX idx_sections_story ON sections (story_id)');
  }

  /// Seeds the database with initial data
  Future<void> _seedDatabase(Database db) async {
    final batch = db.batch();

    // Seed Categories
    batch.insert('categories', {
      'id': 1,
      'name': 'Adventure',
      'icon': 'explore',
    });
    batch.insert('categories', {
      'id': 2,
      'name': 'Fantasy',
      'icon': 'auto_awesome',
    });
    batch.insert('categories', {'id': 3, 'name': 'Science', 'icon': 'science'});
    batch.insert('categories', {
      'id': 4,
      'name': 'Friendship',
      'icon': 'favorite',
    });
    batch.insert('categories', {'id': 5, 'name': 'Animal', 'icon': 'pets'});
    batch.insert('categories', {'id': 6, 'name': 'Mystery', 'icon': 'search'});
    batch.insert('categories', {
      'id': 7,
      'name': 'History',
      'icon': 'history_edu',
    });
    batch.insert('categories', {'id': 8, 'name': 'Nature', 'icon': 'park'});

    // Seed Users (IDs will be auto-generated: 1, 2, 3, 4, 5)
    batch.insert('users', {
      'first_name': 'Ahmed',
      'last_name': 'Ali',
      'email': 'author1@hikayati.com',
      'password': 'pass123',
      'role': 'Author',
      'created_at': DateTime.now().toIso8601String(),
    });
    batch.insert('users', {
      'first_name': 'Fatima',
      'last_name': 'Hassan',
      'email': 'author2@hikayati.com',
      'password': 'pass123',
      'role': 'Author',
      'created_at': DateTime.now().toIso8601String(),
    });
    batch.insert('users', {
      'first_name': 'Mohammed',
      'last_name': 'Ahmed',
      'email': 'author3@hikayati.com',
      'password': 'pass123',
      'role': 'Author',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Seed Stories (author_id=2 which is creator@hikayati.com)
    batch.insert('stories', {
      'title': 'The Whispering Woods',
      'language': 'English',
      'cover_image_url':
          'https://raw.githubusercontent.com/cmps312f25/cmps312-content/refs/heads/main/project/hikayati-images/story1.png',
      'reading_level': 'KG2',
      'category_id': 1, // Adventure
      'author_id': 2,
      'created_at': DateTime.now().toIso8601String(),
    });
    batch.insert('stories', {
      'title': 'Galaxy Explorers',
      'language': 'English',
      'cover_image_url':
          'https://raw.githubusercontent.com/cmps312f25/cmps312-content/refs/heads/main/project/hikayati-images/story2.png',
      'reading_level': 'G1',
      'category_id': 3, // Science
      'author_id': 2,
      'created_at': DateTime.now().toIso8601String(),
    });

    batch.insert('stories', {
      'title': 'The Missing Star',
      'language': 'Arabic',
      'reading_level': 'G2',
      'category_id': 6, // Mystery
      'author_id': 2,
      'cover_image_url':
          'https://raw.githubusercontent.com/cmps312f25/cmps312-content/refs/heads/main/project/hikayati-images/story3.png',
      'quiz': quizExample,          
      'created_at': DateTime.now().toIso8601String(),
    });

    // Seed story sections
    batch.insert('sections', {
      'story_id': 1,
      'image_url':
          'https://raw.githubusercontent.com/cmps312f25/cmps312-content/refs/heads/main/project/hikayati-images/story1.png',
      'section_text':
          'In the heart of the Whispering Woods, a secret was kept.',
      'created_at': DateTime.now().toIso8601String(),
    });
    batch.insert('sections', {
      'story_id': 1,
      'section_text': 'A young fox named Finn decided to uncover it.',
      'created_at': DateTime.now().toIso8601String(),
    });
    batch.insert('sections', {
      'story_id': 2,
      'image_url':
          'https://raw.githubusercontent.com/cmps312f25/cmps312-content/refs/heads/main/project/hikayati-images/story2.png',
      'section_text': 'Leo and his robot friend Sparky blasted off into space.',
      'created_at': DateTime.now().toIso8601String(),
    });
    batch.insert('sections', {
      'story_id': 4,
      'image_url':
          'https://raw.githubusercontent.com/cmps312f25/cmps312-content/refs/heads/main/project/hikayati-images/story4.png',
      'section_text': 'كان هناك نجم مفقود في سماء الليل.',
      'created_at': DateTime.now().toIso8601String(),
    });

    await batch.commit(noResult: true);
  }

  /// Handle database upgrades
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here when schema changes
  }

  /// Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Delete the database (useful for testing or reset)
  Future<void> deleteDB() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'hikayati.db');
      await deleteDatabase(path);
    } catch (e) {
      print('Error deleting the database: $e');
    } finally {
      _database = null;
    }
  }
}
