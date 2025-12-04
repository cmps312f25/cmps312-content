import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/widgets/action_icon_button.dart';

/// Owner action buttons overlay for story card
class StoryCardOwnerActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onEditQuiz;
  final VoidCallback? onDelete;

  const StoryCardOwnerActions({
    super.key,
    this.onEdit,
    this.onEditQuiz,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onEdit != null) ...[
            ActionIconButton(
              icon: Icons.edit_outlined,
              backgroundColor: AppTheme.white.withValues(alpha: 0.95),
              iconColor: AppTheme.primaryPurple,
              onTap: onEdit,
              size: 6,
              iconSize: 18,
            ),
            if (onEditQuiz != null || onDelete != null)
              const SizedBox(width: 6),
          ],
          if (onEditQuiz != null) ...[
            ActionIconButton(
              icon: Icons.quiz_outlined,
              backgroundColor: AppTheme.accentYellow.withValues(alpha: 0.95),
              iconColor: AppTheme.white,
              onTap: onEditQuiz,
              size: 6,
              iconSize: 18,
            ),
            if (onDelete != null) const SizedBox(width: 6),
          ],
          if (onDelete != null)
            ActionIconButton(
              icon: Icons.delete_outlined,
              backgroundColor: Colors.red.withValues(alpha: 0.95),
              iconColor: AppTheme.white,
              onTap: onDelete,
              size: 6,
              iconSize: 18,
            ),
        ],
      ),
    );
  }
}
