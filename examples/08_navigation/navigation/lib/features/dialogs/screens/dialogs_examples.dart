import 'package:flutter/material.dart';
import 'package:navigation/features/dialogs/widgets/basic_dialog.dart';
import 'package:navigation/features/dialogs/widgets/fullscreen_dialog.dart';
import 'package:navigation/features/dialogs/widgets/list_dialog.dart';

// Material 3 Dialog Examples
// Dialogs interrupt users with urgent information, details, or actions.
// They appear in front of app content to provide critical information or ask for a decision.
//
// Key Design Guidelines:
// 1. Use dialogs sparingly - they interrupt the user experience
// 2. Keep content focused and concise
// 3. Provide clear actions (typically 1-2 buttons)
// 4. Use appropriate dialog type for the use case:
//    - Basic Dialog: Simple decisions or information (e.g., confirmations, alerts)
//    - Full-screen Dialog: Complex tasks requiring more space (e.g., forms, multi-step processes)
//
// Reference: https://m3.material.io/components/dialogs/guidelines

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Dialogs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const BasicDialog(),
              ),
              icon: const Icon(Icons.info_outline),
              label: const Text('Basic Dialog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const ListDialog(),
              ),
              icon: const Icon(Icons.list),
              label: const Text('List Dialog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (context) => const FullScreenDialog(),
                ),
              ),
              icon: const Icon(Icons.fullscreen),
              label: const Text('Full-screen Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
