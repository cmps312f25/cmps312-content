import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/entities/story_extension.dart';
import 'package:hikayati/core/widgets/metadata_chip.dart';
import 'package:hikayati/features/auth/presentation/providers/auth_provider.dart';
import 'package:hikayati/features/story_list/presentation/widgets/story_card_image.dart';
import 'package:hikayati/features/story_list/presentation/widgets/story_card_actions.dart';
import 'package:hikayati/features/story_list/presentation/widgets/story_card_owner_actions.dart';

/// Card widget for displaying a story with cover image, title, and metadata
class StoryCard extends ConsumerWidget {
  final Story story;
  final bool hasQuiz;
  final VoidCallback? onTap;
  final VoidCallback? onQuizTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEditQuiz;

  const StoryCard({
    super.key,
    required this.story,
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
    final categoryName = story.getCategoryName(ref);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  StoryCardImage(imageUrl: story.coverImageUrl),
                  _buildGradientOverlay(),
                  if (isOwner)
                    StoryCardOwnerActions(
                      onEdit: onEdit,
                      onEditQuiz: onEditQuiz,
                      onDelete: onDelete,
                    ),
                  StoryCardActions(
                    onView: onTap,
                    onQuiz: onQuizTap,
                    hasQuiz: hasQuiz,
                  ),
                ],
              ),
            ),
            _buildContent(theme, categoryName),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.black.withValues(alpha: 0.4), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, String? categoryName) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            story.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              MetadataChip(
                label: story.readingLevel.value,
                icon: Icons.school_outlined,
                color: theme.colorScheme.secondary,
              ),
              if (categoryName != null) ...[
                const SizedBox(width: 4),
                Expanded(
                  child: MetadataChip(
                    label: categoryName,
                    icon: Icons.category_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
