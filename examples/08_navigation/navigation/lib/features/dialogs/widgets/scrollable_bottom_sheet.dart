import 'package:flutter/material.dart';

// Scrollable Bottom Sheet - For larger content that requires scrolling
// Use case: Lists, detailed information, terms and conditions, search results
//
// Key characteristics:
// - Takes up significant screen space (up to 90% of screen height)
// - Scrollable content area with fixed header and footer
// - DraggableScrollableSheet allows users to resize the sheet
// - Ideal for content that doesn't fit in standard bottom sheet
//
// Design considerations:
// - Keep header and action bar fixed (non-scrollable)
// - Only content area should scroll
// - Provide clear visual separation between sections
// - Always include action buttons for user completion
class ScrollableBottomSheetContent extends StatelessWidget {
  const ScrollableBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9, // Start at 90% of max height
      minChildSize: 0.5, // Minimum 50% when dragged down
      maxChildSize: 0.9, // Maximum 90% of screen
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Header (non-scrollable) - Always visible at top
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable content area
          // Use the scrollController from DraggableScrollableSheet
          Expanded(
            child: ListView.builder(
              controller: scrollController, // Important: enables drag-to-scroll
              padding: const EdgeInsets.all(16),
              itemCount: 20,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('Description for item ${index + 1}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),

          // Bottom action bar (non-scrollable) - Always visible at bottom
          // Provides clear call-to-action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Action completed')),
                        );
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
