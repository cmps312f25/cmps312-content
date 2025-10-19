import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/app/routing/app_router.dart';
import 'package:navigation/app/widgets/nav_drawer.dart';
import 'package:navigation/features/fruits/models/fruit.dart';
import 'package:navigation/features/fruits/repositories/fruit_repository.dart';
import 'package:navigation/features/fruits/widgets/fruit_list_tile.dart';

/// Fruits list screen with search and sort functionality
class FruitsScreen extends StatefulWidget {
  const FruitsScreen({super.key});

  @override
  State<FruitsScreen> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  String _searchQuery = '';
  bool _sortAscending = true;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  /// Filters and sorts fruits based on current state
  List<Fruit> _getFilteredFruits() {
    var fruits = FruitRepository.getFruits();

    // Filter by search query (case-insensitive)
    if (_searchQuery.trim().isNotEmpty) {
      fruits = fruits
          .where((fruit) =>
              fruit.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort alphabetically
    fruits.sort((a, b) =>
        _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));

    return fruits;
  }

  /// Builds search TextField for AppBar
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search fruits...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }

  /// Builds AppBar actions (search/close, sort icons)
  List<Widget> _buildActions() {
    return [
      // Toggle between search and close icons
      if (_searchQuery.isEmpty)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _searchQuery = ' '; // Trigger search mode
              _searchController.text = '';
            });
          },
        )
      else
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _searchQuery = '';
              _searchController.clear();
            });
          },
        ),
      // Sort toggle
      IconButton(
        icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
        onPressed: () => setState(() => _sortAscending = !_sortAscending),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fruits = _getFilteredFruits();
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: _searchQuery.isNotEmpty
            ? _buildSearchField()
            : const Text('Fruits'),
        backgroundColor: Colors.orange,
        actions: _buildActions(),
      ),
      drawer: isSmallScreen ? const NavDrawer() : null,
      // Ternary: show empty state or list (simpler than if-else in Column)
      body: fruits.isEmpty
          ? const Center(child: Text('No fruits found'))
          : ListView.builder(
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return FruitListTile(
                  fruit: fruit,
                  // Pass fruit object via extra (type-safe alternative to path params)
                  onTap: () => context.push(
                    AppRoutes.fruitDetails,
                    extra: fruit,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adding a fruit is not implemented yet'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
