import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/products/models/category.dart';
import 'package:data_layer/features/products/repositories/product_repository.dart';

/// FutureProvider fetches data once and caches the result.
final categoriesProvider = FutureProvider<List<Category>>(
  (ref) async => await ProductRepository().getCategories(),
);
