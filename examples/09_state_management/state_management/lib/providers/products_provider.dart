import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/models/product.dart';
import 'package:state_management/providers/selected_category_provider.dart';
import 'package:state_management/repositories/product_repository.dart';

// Fetches all products from JSON file (simulates API call with 2s delay)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  return ProductRepository.getProducts();
});

// Filters products by selected category (null = show all products)
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final productsAsync = ref.watch(productsProvider);

  return productsAsync.whenData(
    (products) => selectedCategory != null
        ? products.where((p) => p.category == selectedCategory).toList()
        : products,
  );
});
