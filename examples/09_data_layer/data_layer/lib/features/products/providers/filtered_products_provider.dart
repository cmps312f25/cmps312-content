import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/products/providers/products_provider.dart';
import 'package:data_layer/features/products/providers/selected_category_provider.dart';

/// Computed provider that combines products and category filter.
/// Automatically rebuilds when either dependency changes (reactive).
final filteredProductsProvider = Provider((ref) {
  // ref.watch() creates a dependency - rebuilds when these change
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  // .when() handles all AsyncValue states (loading, error, data)
  return products.when(
    data: (productList) {
      // Filter logic: 'All' returns everything, else filter by category
      final filtered = selectedCategory == 'All'
          ? productList
          : productList.where((p) => p.category == selectedCategory).toList();

      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
