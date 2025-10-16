import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Standard Side Sheet Filter Result
class ProductFilters {
  final String category;
  final RangeValues priceRange;
  final bool inStockOnly;

  const ProductFilters({
    required this.category,
    required this.priceRange,
    required this.inStockOnly,
  });

  @override
  String toString() {
    return 'Category: $category | '
        'Price: \$${priceRange.start.round()}-\$${priceRange.end.round()} | '
        'In Stock: ${inStockOnly ? 'Yes' : 'No'}';
  }
}

/// Standard Side Sheet - Non-modal supplementary surface
/// Use for: Filters, contextual actions, supplemental info
/// M3 Reference: https://m3.material.io/components/side-sheets
class StandardSideSheet extends StatefulWidget {
  const StandardSideSheet({super.key});

  @override
  State<StandardSideSheet> createState() => _StandardSideSheetState();
}

class _StandardSideSheetState extends State<StandardSideSheet> {
  String _selectedCategory = 'All';
  RangeValues _priceRange = const RangeValues(0, 100);
  bool _inStockOnly = false;

  final _categories = ['All', 'Electronics', 'Clothing', 'Home', 'Books'];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 320, // M3 standard side sheet width
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Category'),
                    const SizedBox(height: 8),
                    _buildCategoryChips(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Price Range'),
                    const SizedBox(height: 8),
                    _buildPriceRangeSlider(),
                    const SizedBox(height: 24),
                    _buildInStockFilter(),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Header with title and close button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Filters',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }

  /// FilterChips for category selection
  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category;
        return FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = category;
            });
          },
        );
      }).toList(),
    );
  }

  /// RangeSlider for price filtering
  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 500,
          divisions: 50,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.round()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '\$${_priceRange.end.round()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Checkbox for in-stock filter
  Widget _buildInStockFilter() {
    return CheckboxListTile(
      title: const Text('In Stock Only'),
      value: _inStockOnly,
      onChanged: (value) {
        setState(() {
          _inStockOnly = value ?? false;
        });
      },
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  /// Action buttons with reset and apply
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _resetFilters,
              child: const Text('Reset'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () => _setActiveFilters(context),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }

  /// Reset all filters to defaults
  void _resetFilters() {
    setState(() {
      _selectedCategory = 'All';
      _priceRange = const RangeValues(0, 100);
      _inStockOnly = false;
    });
  }

  /// Apply filters and close sheet with filter object
  void _setActiveFilters(BuildContext context) {
    final filters = ProductFilters(
      category: _selectedCategory,
      priceRange: _priceRange,
      inStockOnly: _inStockOnly,
    );
    context.pop(filters);
  }
}
