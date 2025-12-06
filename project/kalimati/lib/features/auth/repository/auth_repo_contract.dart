import 'package:kalimati/core/entities/user.dart';

abstract class AuthRepo {
  Stream<List<User>> getUsers();

  Future<User?> getUserById(String id);

  // Sign in with email and password
  Future<User> signIn({required String email, required String password});
}
