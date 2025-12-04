import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';

class QuizOptionTile extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrectOption;
  final bool allowMultipleAnswers;
  final VoidCallback? onTap;

  const QuizOptionTile({
    super.key,
    required this.optionText,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrectOption,
    required this.allowMultipleAnswers,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors();

    return InkWell(
      onTap: !isSubmitted ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                optionText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppTheme.grey900,
                ),
              ),
            ),
            if (colors.icon != null) ...[
              const SizedBox(width: 12),
              Icon(colors.icon, color: colors.iconColor, size: 24),
            ],
          ],
        ),
      ),
    );
  }

  _OptionColors _getColors() {
    if (isSubmitted) {
      if (isCorrectOption) {
        return _OptionColors(
          backgroundColor: AppTheme.successLight.withOpacity(0.2),
          borderColor: AppTheme.success,
          icon: Icons.check_circle,
          iconColor: AppTheme.success,
        );
      } else if (isSelected && !isCorrectOption) {
        return _OptionColors(
          backgroundColor: AppTheme.errorLight.withOpacity(0.2),
          borderColor: AppTheme.error,
          icon: Icons.cancel,
          iconColor: AppTheme.error,
        );
      } else {
        return _OptionColors(
          backgroundColor: AppTheme.grey100,
          borderColor: AppTheme.grey300,
        );
      }
    } else {
      if (isSelected) {
        return _OptionColors(
          backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
          borderColor: AppTheme.primaryPurple,
          icon: allowMultipleAnswers ? Icons.check_box : null,
          iconColor: allowMultipleAnswers ? AppTheme.primaryPurple : null,
        );
      } else {
        return _OptionColors(
          backgroundColor: AppTheme.white,
          borderColor: AppTheme.grey300,
          icon: allowMultipleAnswers ? Icons.check_box_outline_blank : null,
          iconColor: allowMultipleAnswers ? AppTheme.grey400 : null,
        );
      }
    }
  }
}

class _OptionColors {
  final Color backgroundColor;
  final Color borderColor;
  final IconData? icon;
  final Color? iconColor;

  _OptionColors({
    required this.backgroundColor,
    required this.borderColor,
    this.icon,
    this.iconColor,
  });
}
