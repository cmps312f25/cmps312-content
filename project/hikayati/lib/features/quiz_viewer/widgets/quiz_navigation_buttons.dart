import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';

class QuizNavigationButtons extends StatelessWidget {
  final bool hasSelectedAnswer;
  final bool isLastQuestion;
  final bool isQuestionSubmitted;
  final bool canGoBack;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const QuizNavigationButtons({
    super.key,
    required this.hasSelectedAnswer,
    required this.isLastQuestion,
    required this.isQuestionSubmitted,
    required this.canGoBack,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (canGoBack) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.white,
                  side: const BorderSide(
                    color: AppTheme.primaryPurple,
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: hasSelectedAnswer ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentYellow,
                disabledBackgroundColor: AppTheme.grey400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _getButtonLabel(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonLabel() {
    if (!isQuestionSubmitted) {
      return 'Check Answer';
    }
    if (isLastQuestion) {
      return 'Finish';
    }
    return 'Next';
  }
}
