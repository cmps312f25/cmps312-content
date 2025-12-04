import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/category_extension.dart';
import 'package:hikayati/core/widgets/responsive_helper.dart';
import 'package:hikayati/core/providers/categories_provider.dart';

/// Widget for selecting story category
class CategorySelector extends ConsumerWidget {
  final int? selectedCategoryId;
  final ValueChanged<int> onCategorySelected;

  const CategorySelector({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) => Wrap(
        spacing: ref.responsive(ResponsiveSpacing.sm),
        runSpacing: ref.responsive(ResponsiveSpacing.sm),
        children: categories.map((category) {
          final isSelected = selectedCategoryId == category.id;

          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(category.iconData, size: 16),
                const SizedBox(width: 4),
                Text(category.name),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onCategorySelected(category.id);
              }
            },
          );
        }).toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading categories: $error')),
    );
  }
}
