import 'package:kalimati/core/providers/database_provider.dart';
import 'package:kalimati/features/auth/repository/auth_repo_local_db.dart';
import 'package:riverpod/riverpod.dart';
import 'package:kalimati/core/entities/user.dart';
import 'package:kalimati/features/auth/repository/auth_repo_contract.dart';

// Auth Repository Provider
final authRepoProvider = FutureProvider<AuthRepo>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return AuthRepoLocalDb(db.userDao);
});

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

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  Future<AuthRepo> get _repo async {
    final asyncRepo = ref.read(authRepoProvider);
    if (asyncRepo.value != null) {
      return asyncRepo.value!;
    }
    // Wait for the repo to be available
    return await ref.read(authRepoProvider.future);
  }

  // Sign in
  Future<void> signIn({required String email, required String password}) async {
    final repo = await _repo;
    state = await repo.signIn(email: email, password: password);
  }

  // Sign out
  void signOut() => state = null;
}
