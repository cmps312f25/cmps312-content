import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/products/providers/categories_provider.dart';
import 'package:data_layer/features/products/providers/selected_category_provider.dart';
import 'package:data_layer/features/products/providers/filtered_products_provider.dart';
import 'package:data_layer/features/products/widgets/product_tile.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: const Color(0xFF00897B), // Teal 600
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _CategoryFilter(),
          const Divider(height: 1),
          Expanded(child: _ProductList()),
        ],
      ),
    );
  }
}

// Category dropdown filter widget
class _CategoryFilter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) => Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownMenu<String>(
          width: MediaQuery.of(context).size.width - 32,
          initialSelection: selectedCategory,
          hintText: 'Filter by Category',
          leadingIcon: const Icon(Icons.category),
          dropdownMenuEntries: [
            const DropdownMenuEntry(
              value: 'All',
              label: 'All Categories',
              leadingIcon: Icon(Icons.apps),
            ),
            ...categories.map(
              (category) => DropdownMenuEntry(
                value: category.name,
                label: category.name,
                leadingIcon: const Icon(Icons.label),
              ),
            ),
          ],
          onSelected: (value) => ref
              .read(selectedCategoryProvider.notifier)
              .setCategory(value ?? 'All'),
        ),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, _) => _ErrorBanner(message: 'Failed to load categories'),
    );
  }
}

// Product list widget
class _ProductList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return _EmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ProductTile(product: products[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _ErrorState(message: err.toString()),
    );
  }
}

// Empty state when no products match filter
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// Error state widget
class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// Error banner for category loading
class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
