import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

/// Filter options selected by the user
class FilterOptions {
  final String category;
  final String sortBy;
  final bool showAll;
  final bool showRecent;
  final bool showFavorites;
  final bool showArchived;

  const FilterOptions({
    this.category = '',
    this.sortBy = 'Name',
    this.showAll = true,
    this.showRecent = false,
    this.showFavorites = false,
    this.showArchived = false,
  });

  @override
  String toString() {
    final filters = <String>[];
    if (showAll) filters.add('All');
    if (showRecent) filters.add('Recent');
    if (showFavorites) filters.add('Favorites');
    if (showArchived) filters.add('Archived');

    final parts = <String>[];
    if (category.isNotEmpty) parts.add('Category: $category');
    parts.add('Sort: $sortBy');
    if (filters.isNotEmpty) parts.add('Filters: ${filters.join(', ')}');

    return parts.join(' | ');
  }
}

class FilterOptionsModalBottomSheet extends StatelessWidget {
  const FilterOptionsModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for form fields
    final categoryController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // ValueNotifiers to track checkbox states (stateless approach)
    final showAllNotifier = ValueNotifier<bool>(true);
    final showRecentNotifier = ValueNotifier<bool>(false);
    final showFavoritesNotifier = ValueNotifier<bool>(false);
    final showArchivedNotifier = ValueNotifier<bool>(false);
    final sortByNotifier = ValueNotifier<String>('Name');

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
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

              // Category text field
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter category name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),

              // Sort by dropdown
              ValueListenableBuilder<String>(
                valueListenable: sortByNotifier,
                builder: (context, sortBy, _) {
                  return DropdownButtonFormField<String>(
                    initialValue: sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.sort),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Name', child: Text('Name')),
                      DropdownMenuItem(value: 'Date', child: Text('Date')),
                      DropdownMenuItem(value: 'Size', child: Text('Size')),
                      DropdownMenuItem(value: 'Type', child: Text('Type')),
                    ],
                    onChanged: (value) {
                      if (value != null) sortByNotifier.value = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Filter chips with ValueNotifier
              Text(
                'Show Items',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: showAllNotifier,
                    builder: (context, selected, _) {
                      return FilterChip(
                        label: const Text('All'),
                        selected: selected,
                        onSelected: (value) => showAllNotifier.value = value,
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: showRecentNotifier,
                    builder: (context, selected, _) {
                      return FilterChip(
                        label: const Text('Recent'),
                        selected: selected,
                        onSelected: (value) => showRecentNotifier.value = value,
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: showFavoritesNotifier,
                    builder: (context, selected, _) {
                      return FilterChip(
                        label: const Text('Favorites'),
                        selected: selected,
                        onSelected: (value) =>
                            showFavoritesNotifier.value = value,
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: showArchivedNotifier,
                    builder: (context, selected, _) {
                      return FilterChip(
                        label: const Text('Archived'),
                        selected: selected,
                        onSelected: (value) =>
                            showArchivedNotifier.value = value,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final filters = FilterOptions(
                          category: categoryController.text.trim(),
                          sortBy: sortByNotifier.value,
                          showAll: showAllNotifier.value,
                          showRecent: showRecentNotifier.value,
                          showFavorites: showFavoritesNotifier.value,
                          showArchived: showArchivedNotifier.value,
                        );

                        context.pop(filters);
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
