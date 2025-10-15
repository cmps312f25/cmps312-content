import 'package:flutter/material.dart';

// Modal Bottom Sheet - Blocks interaction with main content
// Use case: User must make a choice or complete an action before continuing
//
// Key characteristics:
// - Modal: prevents interaction with content behind the sheet
// - Requires explicit dismissal (tap outside, drag down, or action button)
// - Common uses: filters, sort options, sharing options, settings
// - Better for focused tasks that require user decision
//
// Material 3 features:
// - Drag handle for improved usability
// - Rounded top corners
// - Proper elevation and theming
class ModalBottomSheetContent extends StatelessWidget {
  const ModalBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Select filters to refine your results',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          // Filter options as chips - Material 3 component
          // FilterChips allow single or multiple selection
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: true,
                onSelected: (selected) {},
              ),
              FilterChip(
                label: const Text('Recent'),
                selected: false,
                onSelected: (selected) {},
              ),
              FilterChip(
                label: const Text('Favorites'),
                selected: false,
                onSelected: (selected) {},
              ),
              FilterChip(
                label: const Text('Archived'),
                selected: false,
                onSelected: (selected) {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action buttons - always provide clear actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filters applied')),
                  );
                },
                child: const Text('Apply'),
              ),
            ],
          ),
          // Add bottom padding for safe area (handles notches, home indicators)
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
