import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/theme/app_theme.dart';
import '../utils/responsive_helper.dart';

/// Widget for displaying an image in the library with selection state
class ImageLibraryItem extends ConsumerWidget {
  final String imageId;
  final String imageUrl;
  final bool isGenerated;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ImageLibraryItem({
    super.key,
    required this.imageId,
    required this.imageUrl,
    this.isGenerated = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final borderRadius = ref.responsive(ResponsiveBorderRadius.sm);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.grey200,
                    child: Icon(
                      Icons.broken_image,
                      color: AppTheme.grey400,
                      size: 32,
                    ),
                  );
                },
              ),

              // AI badge for generated images
              if (isGenerated)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 10,
                          color: AppTheme.white,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'AI',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Selection overlay
              if (isSelected)
                Container(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
