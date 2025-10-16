import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Standard Bottom Sheet - Non-modal, doesn't block interaction with main content
// Use case: Quick actions, supplementary content that users can dismiss easily
//
// Key characteristics:
// - Non-modal: users can still interact with content behind the sheet
// - Persistent until explicitly dismissed
// - Suitable for quick actions that don't require full attention
// - Less intrusive than modal bottom sheets
class StandardBottomSheet extends StatelessWidget {
  const StandardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop('Closed'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This is a standard bottom sheet. You can still interact with the content behind it.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () => context.pop('Share action selected'),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () => context.pop('Download action selected'),
          ),
        ],
      ),
    );
  }
}
