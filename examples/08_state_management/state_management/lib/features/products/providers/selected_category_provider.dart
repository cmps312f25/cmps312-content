import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/products/providers/products_provider.dart';

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setCategory(String category) {
    state = category;
  }
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
      () => SelectedCategoryNotifier(),
    );

// Filtered products based on selected category
final filteredProductsProvider = Provider((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return products.when(
    data: (productList) {
      if (selectedCategory == 'All') {
        return AsyncValue.data(productList);
      }
      return AsyncValue.data(
        productList.where((p) => p.category == selectedCategory).toList(),
      );
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
