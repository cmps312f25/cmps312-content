import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/products/models/category.dart';
import 'package:state_management/features/products/repositories/product_repository.dart';

/// FutureProvider fetches data once and caches the result.
final categoriesProvider = FutureProvider<List<Category>>(
  (ref) async => await ProductRepository().getCategories(),
);
