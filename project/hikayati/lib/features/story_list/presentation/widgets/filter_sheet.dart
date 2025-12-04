import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/reading_level.dart';
import 'package:hikayati/core/providers/categories_provider.dart';

class FilterSheet extends ConsumerStatefulWidget {
  final Set<ReadingLevel> initialLevels;
  final Set<int> initialCategoryIds;
  final Function(Set<ReadingLevel> levels, Set<int> categoryIds) onApply;
  final VoidCallback onReset;

  const FilterSheet({
    super.key,
    required this.initialLevels,
    required this.initialCategoryIds,
    required this.onApply,
    required this.onReset,
  });

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late Set<ReadingLevel> _selectedLevels;
  late Set<int> _selectedCategoryIds;

  @override
  void initState() {
    super.initState();
    _selectedLevels = {...widget.initialLevels};
    _selectedCategoryIds = {...widget.initialCategoryIds};
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Stories', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),

            // Reading Level
            Text('Reading Level', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReadingLevel.values.map((level) {
                return FilterChip(
                  label: Text(level.value),
                  selected: _selectedLevels.contains(level),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedLevels.add(level);
                      } else {
                        _selectedLevels.remove(level);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Categories
            Text('Category', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            categoriesAsync.when(
              data: (categories) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final id = category.id;
                  return FilterChip(
                    label: Text(category.name),
                    selected: _selectedCategoryIds.contains(id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategoryIds.add(id);
                        } else {
                          _selectedCategoryIds.remove(id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading categories'),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  onPressed: () {
                    widget.onApply(_selectedLevels, _selectedCategoryIds);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
