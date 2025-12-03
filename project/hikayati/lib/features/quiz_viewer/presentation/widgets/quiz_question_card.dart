import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/entities/quiz.dart';
import 'package:hikayati/features/quiz_viewer/presentation/widgets/quiz_option_tile.dart';

class QuizQuestionCard extends StatelessWidget {
  final Question question;
  final bool isSubmitted;
  final bool Function(int) isOptionSelected;
  final Function(int) onSelectOption;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.isSubmitted,
    required this.isOptionSelected,
    required this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.grey900,
            ),
          ),
          if (question.allowMultipleAnswers) ...[
            const SizedBox(height: 12),
            _buildMultipleAnswersBadge(theme),
          ],
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return QuizOptionTile(
                  optionText: question.options[index].text,
                  isSelected: isOptionSelected(index),
                  isSubmitted: isSubmitted,
                  isCorrectOption: question.options[index].isCorrect,
                  allowMultipleAnswers: question.allowMultipleAnswers,
                  onTap: () => onSelectOption(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleAnswersBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentPink.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentPink),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_box, size: 16, color: AppTheme.accentPink),
          const SizedBox(width: 6),
          Text(
            'Select all that apply',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTheme.accentPink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
