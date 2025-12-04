import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';

class QuizTopBar extends StatelessWidget {
  final bool hasUnsavedChanges;
  final VoidCallback onBack;
  final VoidCallback onSave;

  const QuizTopBar({
    super.key,
    required this.hasUnsavedChanges,
    required this.onBack,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Back button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.grey200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              onPressed: onBack,
              color: AppTheme.grey900,
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz Editor',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.grey900,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                if (hasUnsavedChanges)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentYellow.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Unsaved changes',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.grey900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Save button
          Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentYellow, AppTheme.accentYellowLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton.icon(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.check, color: AppTheme.grey900),
              label: Text(
                'Save',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.grey900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
