import 'package:flutter/material.dart';
import 'package:navigation/features/dialogs/models/user_profile.dart';

// Reusable widget for displaying profile information in a SnackBar
// Demonstrates separation of concerns and widget reusability
// Can be used in SnackBars, Dialogs, or any other context where profile info needs to be displayed
// Uses UserProfile data model for cleaner API
class ProfileViewer extends StatelessWidget {
  final UserProfile profile;

  const ProfileViewer({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile saved successfully!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('Name: ${profile.name}'),
        Text('Email: ${profile.email}'),
        Text(
          'Notifications: ${profile.notificationsEnabled ? 'Enabled' : 'Disabled'}',
        ),
      ],
    );
  }
}
