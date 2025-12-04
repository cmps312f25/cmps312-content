import 'package:hikayati/core/database/db_schema.dart';
import 'package:hikayati/core/database/db_seed.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton helper class for managing the local SQLite database
///
/// This class implements best practices for SQLite database management:
/// - Singleton pattern to ensure single database connection
/// - Lazy initialization
/// - Proper transaction handling
/// - Connection lifecycle management
/// - Error handling and logging
class DatabaseHelper {
  DatabaseHelper._();

  /// Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._();

  /// Database instance (cached)
  Database? _database;

  /// Database configuration
  static const String databaseName = 'hikayati.db';
  static const int databaseVersion = 1;

  /// Gets the database instance with lazy initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  /// Initializes the database with proper configuration
  Future<Database> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, databaseName);

    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
      singleInstance: true,
    );
  }

  /// Creates the database schema and seeds initial data
  Future<void> _onCreateDatabase(Database db, int version) async {
    await DatabaseSchema.createTables(db);
    await DatabaseSeed.seedDatabase(db);
  }

  /// Handles database schema upgrades
  Future<void> _onUpgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    await DatabaseSchema.upgradeSchema(db, oldVersion, newVersion);
  }

  /// Closes the database connection
  ///
  /// Note: Only close the database when your app is shutting down,
  /// not between operations
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Deletes the database file
  ///
  /// WARNING: This permanently removes all data. Use with caution.
  /// Primarily intended for testing or complete app data reset.
  Future<void> deleteDatabase() async {
    await close();

    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, databaseName);
      await databaseFactory.deleteDatabase(path);
    } catch (e) {
      throw Exception('Failed to delete database: $e');
    }
  }

  /// Resets the database by deleting and recreating it with fresh data
  ///
  /// This is useful for testing or resetting the app to initial state
  Future<void> reset() async {
    await deleteDatabase();
    // Trigger re-initialization on next access
    _database = null;
  }

  /// Gets the database path (useful for debugging)
  Future<String> getDatabasePath() async {
    final databasesPath = await getDatabasesPath();
    return join(databasesPath, databaseName);
  }

  /// Checks if the database exists
  Future<bool> exists() async {
    final path = await getDatabasePath();
    return await databaseFactory.databaseExists(path);
  }
}
