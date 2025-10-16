import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Basic Dialog with List - Used for simple selections from a list
// Useful when users need to choose one option from multiple choices
// Example: Selecting ringtones, notification sounds, themes, etc.
class ListDialog extends StatelessWidget {
  final List<(IconData icon, String label)> options;
  final String title;

  const ListDialog({
    super.key,
    this.title = 'Select Ringtone',
    this.options = const [
      (Icons.music_note, 'Default Ringtone'),
      (Icons.album, 'Classical'),
      (Icons.audiotrack, 'Jazz'),
      (Icons.radio, 'Electronic'),
      (Icons.piano, 'Piano Melody'),
      (Icons.queue_music, 'Nature Sounds'),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return ListTile(
              leading: Icon(option.$1),
              title: Text(option.$2),
              onTap: () => context.pop(option.$2),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop('Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
