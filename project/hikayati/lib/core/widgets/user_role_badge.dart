import 'package:flutter/material.dart';
import 'package:hikayati/core/theme/app_theme.dart';

/// Badge widget to display user role (Learner or Educator)
class UserRoleBadge extends StatelessWidget {
  final String role; // 'learner' or 'educator'
  final bool compact;

  const UserRoleBadge({super.key, required this.role, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEducator = role.toLowerCase() == 'educator';
    final color = isEducator
        ? theme.colorScheme.educatorColor
        : theme.colorScheme.learnerColor;
    final icon = isEducator ? Icons.school : Icons.person;
    final label = isEducator ? 'Educator' : 'Learner';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 14 : 16, color: color),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
