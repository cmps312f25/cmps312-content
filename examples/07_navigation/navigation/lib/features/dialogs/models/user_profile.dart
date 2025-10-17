/// User profile data model
/// Immutable class representing user profile form data
///
/// Benefits of using data models:
/// - Type-safe data structure
/// - Single source of truth for profile data
/// - Easy to pass between widgets and functions
/// - Can be extended with methods (toJson, fromJson, validation, etc.)
class UserProfile {
  final String name;
  final String email;
  final bool notificationsEnabled;

  const UserProfile({
    required this.name,
    required this.email,
    required this.notificationsEnabled,
  });

  /// Creates a copy with modified fields
  /// Useful for updating immutable data
  UserProfile copyWith({
    String? name,
    String? email,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
