import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/products/models/product.dart';
import 'package:state_management/features/products/repositories/product_repository.dart';

/// FutureProvider for one-time async data loading.
/// Simpler than AsyncNotifierProvider when you don't need custom methods.
/// Can still be refreshed using ref.refresh(productsProvider).
final productsProvider = FutureProvider<List<Product>>(
  (ref) async => await ProductRepository().getProducts(),
);
