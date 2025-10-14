import 'package:flutter/material.dart';

// ProfileEditor - Form widget for editing user profile information
// Accepts controllers and form key from parent to enable validation
class ProfileEditor extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  const ProfileEditor({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        // Connect the Form widget to our GlobalKey
        // This enables validation of all child TextFormFields
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              // Controller connects this field to nameController
              // Use controller.text to get/set the current value
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              // Validator runs when formKey.currentState!.validate() is called
              // Return null if valid, return error message if invalid
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null; // null means validation passed
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null; // Validation passed
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            // StatefulBuilder - Creates local state for this widget only
            // Allows the switch to rebuild when toggled without rebuilding entire form
            StatefulBuilder(
              builder: (context, setState) {
                return SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive updates and alerts'),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    // setState updates the variable and rebuilds only this widget
                    setState(() {
                      onNotificationsChanged(value);
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'This is an example of a full-screen dialog used for complex forms and settings.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
