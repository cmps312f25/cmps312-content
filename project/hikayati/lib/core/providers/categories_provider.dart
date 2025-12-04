import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/core/repositories/story_repository.dart';
import 'package:hikayati/core/entities/category.dart';

/// Provider for retrieving all categories
final categoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getCategories();
});
