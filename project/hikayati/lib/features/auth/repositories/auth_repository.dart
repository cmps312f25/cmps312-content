import 'package:hikayati/core/database/database_helper.dart';
import 'package:hikayati/core/entities/user.dart';
import 'package:hikayati/features/auth/repositories/auth_repository_contract.dart';

class AuthRepository implements AuthRepositoryContract {
  final DatabaseHelper _dbHelper;

  AuthRepository(this._dbHelper);

  @override
  // Sign up with email and password
  Future<User> signUp(User user) async {
    final db = await _dbHelper.database;

    // Check if email already exists
    final existingUsers = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [user.email],
    );

    if (existingUsers.isNotEmpty) {
      throw Exception('Email already exists');
    }

    final userId = await db.insert('users', user.toJson());

    // Query the newly created user
    final maps = await db.query('users', where: 'id = ?', whereArgs: [userId]);

    return User.fromJson(maps.first);
  }

  @override
  // Sign in with email and password
  Future<User> signIn({required String email, required String password}) async {
    final db = await _dbHelper.database;

    // Search for the user with matching email and password
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) {
      throw Exception('Invalid email or password');
    }

    return User.fromJson(maps.first);
  }
}
