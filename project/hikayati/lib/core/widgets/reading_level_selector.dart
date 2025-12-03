import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import '../utils/responsive_helper.dart';

/// Widget for selecting reading level
class ReadingLevelSelector extends ConsumerWidget {
  final String? selectedLevel;
  final ValueChanged<String> onLevelSelected;

  const ReadingLevelSelector({
    super.key,
    this.selectedLevel,
    required this.onLevelSelected,
  });

  static const List<String> levels = [
    'KG1',
    'KG2',
    'Year 1',
    'Year 2',
    'Year 3',
    'Year 4',
    'Year 5',
    'Year 6',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: ref.responsive(ResponsiveSpacing.sm),
      runSpacing: ref.responsive(ResponsiveSpacing.sm),
      children: levels.map((level) {
        final isSelected = selectedLevel == level;
        final color = _getLevelColor(level, theme);

        return FilterChip(
          label: Text(level),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onLevelSelected(level);
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

  Color _getLevelColor(String level, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    switch (level) {
      case 'KG1':
        return colorScheme.levelKG1;
      case 'KG2':
        return colorScheme.levelKG2;
      case 'Year 1':
        return colorScheme.levelYear1;
      case 'Year 2':
        return colorScheme.levelYear2;
      case 'Year 3':
        return colorScheme.levelYear3;
      case 'Year 4':
        return colorScheme.levelYear4;
      case 'Year 5':
        return colorScheme.levelYear5;
      case 'Year 6':
        return colorScheme.levelYear6;
      default:
        return AppTheme.grey400;
    }
  }
}
