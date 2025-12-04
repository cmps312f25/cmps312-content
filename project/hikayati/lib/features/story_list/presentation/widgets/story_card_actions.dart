import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/widgets/action_icon_button.dart';

/// Action buttons overlay for story card
class StoryCardActions extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onQuiz;
  final bool hasQuiz;

  const StoryCardActions({
    super.key,
    this.onView,
    this.onQuiz,
    this.hasQuiz = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionIconButton(
            icon: Icons.visibility_outlined,
            backgroundColor: AppTheme.white.withValues(alpha: 0.95),
            iconColor: AppTheme.primaryPurple,
            onTap: onView,
          ),
          if (hasQuiz) ...[
            const SizedBox(width: 6),
            ActionIconButton(
              icon: Icons.quiz_outlined,
              backgroundColor: AppTheme.accentYellow.withValues(alpha: 0.95),
              iconColor: AppTheme.white,
              onTap: onQuiz,
            ),
          ],
        ],
      ),
    );
  }
}
