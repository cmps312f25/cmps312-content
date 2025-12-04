import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/entities/story.dart';
import 'package:hikayati/core/providers/categories_provider.dart';

extension StoryExtension on Story {
  /// Returns the category name for this story.
  /// Returns null if categoryId is null or if categories haven't loaded yet.
  String? getCategoryName(WidgetRef ref) {
    if (categoryId == null) return null;

    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.whenOrNull(
      data: (categories) {
        try {
          final category = categories.firstWhere((cat) => cat.id == categoryId);
          return category.name;
        } catch (e) {
          // Category not found, return null
          return null;
        }
      },
    );
  }
}
