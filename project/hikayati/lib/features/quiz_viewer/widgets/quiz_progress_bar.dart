import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';

class QuizProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress;

  const QuizProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Question $currentQuestion of $totalQuestions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppTheme.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.accentYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
