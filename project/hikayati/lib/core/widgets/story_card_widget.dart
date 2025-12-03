import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/features/auth/presentation/providers/auth_provider.dart';

/// Card widget for displaying a story with cover image, title, and metadata
class StoryCard extends ConsumerWidget {
  final Story story;
  final String? categoryName;
  final bool hasQuiz;
  final VoidCallback? onTap;
  final VoidCallback? onQuizTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEditQuiz;

  const StoryCard({
    super.key,
    required this.story,
    this.categoryName,
    this.hasQuiz = true,
    this.onTap,
    this.onQuizTap,
    this.onEdit,
    this.onDelete,
    this.onEditQuiz,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser != null && currentUser.id == story.authorId;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                story.coverImageUrl != null
                    ? _buildImageFromPath(story.coverImageUrl!)
                    : _PlaceholderCover(title: story.title),

                // Gradient overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Owner action buttons (Edit/Edit Quiz/Delete)
                if (isOwner)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Edit button
                        if (onEdit != null)
                          Material(
                            color: AppTheme.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: onEdit,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                            ),
                          ),
                        if (onEdit != null && onEditQuiz != null)
                          const SizedBox(width: 6),
                        // Edit Quiz button
                        if (onEditQuiz != null)
                          Material(
                            color: AppTheme.accentYellow.withValues(
                              alpha: 0.95,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: onEditQuiz,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.quiz_outlined,
                                  size: 18,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        if (onEditQuiz != null && onDelete != null)
                          const SizedBox(width: 6),
                        // Delete button
                        if (onDelete != null)
                          Material(
                            color: Colors.red.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: onDelete,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.delete_outlined,
                                  size: 18,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                // Action buttons
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // View button
                      Material(
                        color: AppTheme.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.visibility_outlined,
                              size: 20,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        ),
                      ),
                      // Quiz button (show if quiz exists)
                      if (hasQuiz) ...[
                        const SizedBox(width: 6),
                        Material(
                          color: AppTheme.accentYellow.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: onQuizTap,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.quiz_outlined,
                                size: 20,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  story.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // Metadata row
                Row(
                  children: [
                    _MetadataChip(
                      label: story.readingLevel.value,
                      icon: Icons.school_outlined,
                      color: _getReadingLevelColor(
                        story.readingLevel.value,
                        theme,
                      ),
                    ),
                    if (categoryName != null) ...[
                      const SizedBox(width: 4),
                      Expanded(
                        child: _MetadataChip(
                          label: categoryName!,
                          icon: Icons.category_outlined,
                          color: _getCategoryColor(categoryName!, theme),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getReadingLevelColor(String level, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    switch (level.toUpperCase()) {
      case 'KG1':
        return colorScheme.levelKG1;
      case 'KG2':
        return colorScheme.levelKG2;
      case 'YEAR 1':
        return colorScheme.levelYear1;
      case 'YEAR 2':
        return colorScheme.levelYear2;
      case 'YEAR 3':
        return colorScheme.levelYear3;
      case 'YEAR 4':
        return colorScheme.levelYear4;
      case 'YEAR 5':
        return colorScheme.levelYear5;
      case 'YEAR 6':
        return colorScheme.levelYear6;
      default:
        return AppTheme.grey400;
    }
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    switch (category.toLowerCase()) {
      case 'adventure':
        return colorScheme.categoryAdventure;
      case 'fantasy':
        return colorScheme.categoryFantasy;
      case 'science':
        return colorScheme.categoryScience;
      case 'friendship':
        return colorScheme.categoryFriendship;
      case 'animal':
        return colorScheme.categoryAnimal;
      default:
        return theme.colorScheme.primary;
    }
  }
}

// ==================== Private Helper Widgets ====================

/// Helper function to build image widget from file path, URL, or asset
Widget _buildImageFromPath(String path) {
  if (path.startsWith('http')) {
    return Image.network(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
  if (path.startsWith('assets/')) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  }
  return Image.file(
    File(path),
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
  );
}

/// Placeholder cover image with gradient and first letter
class _PlaceholderCover extends StatelessWidget {
  final String title;

  const _PlaceholderCover({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstLetter = title.isNotEmpty ? title[0].toUpperCase() : '?';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryPurple, AppTheme.secondaryBlue],
        ),
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: theme.textTheme.displayLarge?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w900,
            fontSize: 72,
          ),
        ),
      ),
    );
  }
}

/// Metadata chip for category and reading level
class _MetadataChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _MetadataChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
