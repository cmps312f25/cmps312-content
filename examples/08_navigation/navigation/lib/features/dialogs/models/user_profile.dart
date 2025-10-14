// Data model for profile form - encapsulates form data
// Benefits:
// - Type-safe data structure
// - Single source of truth for profile data
// - Easy to pass between widgets and functions
// - Can be extended with methods (validation, serialization, etc.)
class UserProfile {
  final String name;
  final String email;
  final bool notificationsEnabled;

  UserProfile({
    required this.name,
    required this.email,
    required this.notificationsEnabled,
  });
}
