import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/widgets/responsive_helper.dart';

/// Widget for selecting story language
class LanguageSelector extends ConsumerWidget {
  final String? selectedLanguage;
  final ValueChanged<String> onLanguageSelected;

  const LanguageSelector({
    super.key,
    this.selectedLanguage,
    required this.onLanguageSelected,
  });

  static const List<String> languages = [
    'English',
    'Arabic',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: ref.responsive(ResponsiveSpacing.sm),
      runSpacing: ref.responsive(ResponsiveSpacing.sm),
      children: languages.map((language) {
        final isSelected = selectedLanguage == language;

        return FilterChip(
          label: Text(language),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onLanguageSelected(language);
            }
          },
          backgroundColor: theme.brightness == Brightness.light
              ? AppTheme.grey100
              : AppTheme.grey800,
          selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: theme.colorScheme.primary,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        );
      }).toList(),
    );
  }
}
