import 'package:flutter/material.dart';

/// Story card cover image widget with placeholder support
class StoryCardImage extends StatelessWidget {
  final String? imageUrl;

  const StoryCardImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl == null) {
      return Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
