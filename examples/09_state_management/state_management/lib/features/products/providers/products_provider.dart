import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/products/models/product.dart';
import 'package:state_management/features/products/repositories/product_repository.dart';

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final repository = ProductRepository();
    return await repository.getProducts();
  }
}

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  () => ProductsNotifier(),
);
