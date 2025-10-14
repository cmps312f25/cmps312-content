import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/features/dialogs/models/user_profile.dart';
import 'package:navigation/features/dialogs/widgets/profile_viewer.dart';
import 'package:navigation/features/dialogs/widgets/profile_editor.dart';

// Full-screen Dialog - Used for complex tasks requiring more space
// Characteristics:
// - Takes up entire screen (mobile) or large area (tablet/desktop)
// - Has app bar with close/back button and save/confirm action
// - Suitable for forms, settings, or multi-step processes
// - Can contain scrollable content
class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // GlobalKey<FormState> - Unique identifier for the Form widget
    // Allows us to access form methods like validate() and save()
    // Think of it as a "remote control" for the form
    final formKey = GlobalKey<FormState>();

    // TextEditingController - Manages the text content of TextField/TextFormField
    // Purpose: Read user input and programmatically set/clear text
    // Each text field needs its own controller
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    // Boolean variable to track notification preference
    // StatefulBuilder in ProfileEditor will handle UI updates when this changes
    bool notificationsEnabled = true;

    return Scaffold(
      // Full-screen dialogs use an AppBar with close and save actions
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('User Profile'),
        actions: [
          TextButton(
            onPressed: () => _handleSave(
              context,
              formKey,
              nameController,
              emailController,
              notificationsEnabled,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
      body: ProfileEditor(
        formKey: formKey,
        nameController: nameController,
        emailController: emailController,
        notificationsEnabled: notificationsEnabled,
        onNotificationsChanged: (value) {
          notificationsEnabled = value;
        },
      ),
    );
  }

  // Extracted save handler for better code organization
  // Validates form, extracts data, and displays success message
  void _handleSave(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController emailController,
    bool notificationsEnabled,
  ) {
    // Validate all TextFormFields in the form
    // Returns true if all validators pass, false otherwise
    if (formKey.currentState!.validate()) {
      // All fields are valid - extract data into model
      // Using a data model makes the code cleaner and more maintainable
      final formData = UserProfile(
        name: nameController.text,
        email: emailController.text,
        notificationsEnabled: notificationsEnabled,
      );

      // In a real app, you would save formData to database or send to API
      // Example: await profileRepository.save(formData);

      context.pop();

      // Display saved data in a SnackBar for user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ProfileViewer(
            profile: formData,
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    // If validation fails, error messages appear automatically
  }
}
