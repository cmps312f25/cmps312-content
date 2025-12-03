import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import '../utils/responsive_helper.dart';

/// Widget for displaying a multiple choice quiz question
class QuizQuestionCard extends ConsumerWidget {
  final String question;
  final List<String> options;
  final int? selectedOption;
  final int? correctOption;
  final bool showCorrectAnswer;
  final ValueChanged<int>? onOptionSelected;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.options,
    this.selectedOption,
    this.correctOption,
    this.showCorrectAnswer = false,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(ref.responsive(ResponsiveSpacing.md)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Text(
              question,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: ref.responsive(ResponsiveSpacing.md)),

            // Options
            ...List.generate(options.length, (index) {
              final isSelected = selectedOption == index;
              final isCorrect = correctOption == index;
              final showAsCorrect = showCorrectAnswer && isCorrect;
              final showAsWrong = showCorrectAnswer && isSelected && !isCorrect;

              Color? backgroundColor;
              Color? borderColor;

              if (showAsCorrect) {
                backgroundColor = theme.colorScheme.success.withValues(
                  alpha: 0.1,
                );
                borderColor = theme.colorScheme.success;
              } else if (showAsWrong) {
                backgroundColor = theme.colorScheme.error.withValues(
                  alpha: 0.1,
                );
                borderColor = theme.colorScheme.error;
              } else if (isSelected) {
                backgroundColor = theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                );
                borderColor = theme.colorScheme.primary;
              }

              return Padding(
                padding: EdgeInsets.only(
                  bottom: ref.responsive(ResponsiveSpacing.sm),
                ),
                child: InkWell(
                  onTap: onOptionSelected != null && !showCorrectAnswer
                      ? () => onOptionSelected!(index)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(
                      ref.responsive(ResponsiveSpacing.md),
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? AppTheme.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor ?? AppTheme.grey300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Option letter
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: showAsCorrect
                                ? theme.colorScheme.success
                                : showAsWrong
                                ? theme.colorScheme.error
                                : isSelected
                                ? theme.colorScheme.primary
                                : AppTheme.grey300,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: ref.responsive(ResponsiveSpacing.sm)),

                        // Option text
                        Expanded(
                          child: Text(
                            options[index],
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),

                        // Check/Cross icon
                        if (showAsCorrect)
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.success,
                          )
                        else if (showAsWrong)
                          Icon(Icons.cancel, color: theme.colorScheme.error),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
