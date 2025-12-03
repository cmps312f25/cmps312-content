import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hikayati/features/story_list/repositories/story_repository_impl.dart';
import 'package:hikayati/core/entities/category.dart';

/// Provider for categories - simple fetch
final categoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) {
  final repository = ref.watch(storyRepositoryProvider);
  return repository.getAllCategories();
});
