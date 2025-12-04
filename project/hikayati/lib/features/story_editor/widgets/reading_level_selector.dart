import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/widgets/responsive_helper.dart';

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
        final color = theme.colorScheme.secondary;

        return FilterChip(
          label: Text(level),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onLevelSelected(level);
            }
          },
          backgroundColor: color.withValues(alpha: 0.1),
          selectedColor: color.withValues(alpha: 0.3),
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
}
