import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/features/auth/repositories/auth_repository.dart';
import 'package:hikayati/core/providers/database_provider.dart';
import 'package:hikayati/core/entities/user.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return AuthRepository(dbHelper);
});

// Auth State Notifier
class AuthNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  // Sign up
  Future<void> signUp(User user) async {
    state = await _repo.signUp(user);
  }

  // Sign in
  Future<void> signIn({required String email, required String password}) async {
    state = await _repo.signIn(email: email, password: password);
  }

  // Sign out
  void signOut() => state = null;
}

// Auth Notifier Provider
final authNotifierProvider = NotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

// Current User Provider
final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(authNotifierProvider),
);

// Is Authenticated Provider
final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authNotifierProvider) != null,
);
