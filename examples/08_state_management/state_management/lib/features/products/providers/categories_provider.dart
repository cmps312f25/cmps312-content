import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/products/models/category.dart';
import 'package:state_management/features/products/repositories/product_repository.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ProductRepository();
  return await repository.getCategories();
});
