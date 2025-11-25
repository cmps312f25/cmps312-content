import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show Platform;

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with GitHub OAuth (Mobile only)
  Future<bool> signInWithGitHub() async {
    try {
      return await _client.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'todoapp://login-callback/',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    // Use SignOutScope.global to fully sign out from the provider.
    await _client.auth.signOut(scope: SignOutScope.global);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) async {
    return await _client.auth.updateUser(UserAttributes(data: data));
  }

  // Get user metadata
  Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;

  // Get user full name from metadata
  String? get userFullName => userMetadata?['full_name'] as String?;

  // Get user email
  String? get userEmail => currentUser?.email;
}
