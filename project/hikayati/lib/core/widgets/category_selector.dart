import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import '../utils/responsive_helper.dart';

/// Widget for selecting story category
class CategorySelector extends ConsumerWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  // TODO: remove hardcoded category listing and make it dynamic by fetching from database
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Adventure', 'icon': Icons.explore},
    {'name': 'Fantasy', 'icon': Icons.auto_awesome},
    {'name': 'Science', 'icon': Icons.science},
    {'name': 'Friendship', 'icon': Icons.favorite},
    {'name': 'Animal', 'icon': Icons.pets},
    {'name': 'Mystery', 'icon': Icons.search},
    {'name': 'History', 'icon': Icons.history_edu},
    {'name': 'Nature', 'icon': Icons.park},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: ref.responsive(ResponsiveSpacing.sm),
      runSpacing: ref.responsive(ResponsiveSpacing.sm),
      children: categories.map((category) {
        final name = category['name'] as String;
        final icon = category['icon'] as IconData;
        final isSelected = selectedCategory == name;
        final color = _getCategoryColor(name, theme);

        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(name),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onCategorySelected(name);
            }
          },
          backgroundColor: color.withOpacity(0.1),
          selectedColor: color.withOpacity(0.3),
          checkmarkColor: color,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? color : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected ? color : AppTheme.grey300,
            width: isSelected ? 2 : 1,
          ),
        );
      }).toList(),
    );
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    switch (category.toLowerCase()) {
      case 'adventure':
        return colorScheme.categoryAdventure;
      case 'fantasy':
        return colorScheme.categoryFantasy;
      case 'science':
        return colorScheme.categoryScience;
      case 'friendship':
        return colorScheme.categoryFriendship;
      case 'animal':
        return colorScheme.categoryAnimal;
      default:
        return theme.colorScheme.primary;
    }
  }
}
