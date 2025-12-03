import 'package:hikayati/core/entities/user.dart';

abstract class AuthRepositoryContract {
  // Sign up with email and password
  Future<User> signUp(User user);

  // Sign in with email and password
  Future<User> signIn({required String email, required String password});
}
