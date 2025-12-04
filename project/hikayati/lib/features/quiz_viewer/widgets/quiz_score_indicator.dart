import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';

class QuizScoreIndicator extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;

  const QuizScoreIndicator({
    super.key,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: AppTheme.success, size: 20),
          const SizedBox(width: 4),
          Text(
            '$correctAnswers',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.cancel, color: AppTheme.error, size: 20),
          const SizedBox(width: 4),
          Text(
            '$wrongAnswers',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
