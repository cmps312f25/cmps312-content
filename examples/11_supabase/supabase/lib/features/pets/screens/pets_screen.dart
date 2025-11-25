import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/pets/models/owner.dart';
import 'package:supabase_app/features/pets/providers/owners_provider.dart';
import 'package:supabase_app/features/pets/providers/pets_provider.dart';
import 'package:supabase_app/features/pets/widgets/add_owner_dialog.dart';
import 'package:supabase_app/features/pets/widgets/add_pet_dialog.dart';
import 'package:supabase_app/features/pets/widgets/pets_summary_dialog.dart';
import 'package:supabase_app/features/pets/widgets/pets_list.dart';

class PetsScreen extends ConsumerStatefulWidget {
  const PetsScreen({super.key});

  @override
  ConsumerState<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends ConsumerState<PetsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ownersAsync = ref.watch(ownersProvider);
    final selectedOwnerId = ref.watch(selectedOwnerIdProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Pet Manager'),
        elevation: 0,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search owners or pets...',
                  leading: const Icon(Icons.search),
                  trailing: _searchQuery.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                        ]
                      : null,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  elevation: const WidgetStatePropertyAll(1),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: colorScheme.primary,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(icon: Icon(Icons.person), text: 'Owners'),
                  Tab(icon: Icon(Icons.pets), text: 'Pets'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize_outlined),
            tooltip: 'Summary',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const PetsSummaryDialog(),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Owners Tab
          ownersAsync.when(
            data: (owners) => _buildOwnersTab(owners),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState('Error loading owners'),
          ),
          // Pets Tab
          selectedOwnerId == null
              ? _buildSelectOwnerPrompt()
              : PetsList(selectedOwnerId: selectedOwnerId),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddOwnerDialog();
          } else {
            if (selectedOwnerId != null) {
              _showAddPetDialog(selectedOwnerId);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select an owner first'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        icon: Icon(_tabController.index == 0 ? Icons.person_add : Icons.add),
        label: Text(_tabController.index == 0 ? 'Add Owner' : 'Add Pet'),
      ),
    );
  }

  Widget _buildOwnersTab(List<Owner> owners) {
    final selectedOwnerId = ref.watch(selectedOwnerIdProvider);
    final filteredOwners = owners.where((owner) {
      if (_searchQuery.isEmpty) return true;
      return owner.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredOwners.isEmpty) {
      return _buildEmptyState(
        icon: Icons.person_off,
        message: _searchQuery.isEmpty
            ? 'No owners yet\nTap + to add your first owner'
            : 'No owners match your search',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredOwners.length,
      itemBuilder: (context, index) {
        final owner = filteredOwners[index];
        final isSelected = selectedOwnerId == owner.id;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: isSelected ? 4 : 1,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: () {
              ref.read(selectedOwnerIdProvider.notifier).selectOwner(owner.id);
              _tabController.animateTo(1); // Switch to pets tab
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    child: Text(
                      owner.firstName[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Owner info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          owner.fullName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        FutureBuilder<int>(
                          future: ref
                              .read(petsProvider.notifier)
                              .getPetCountForOwner(owner.id!),
                          builder: (context, snapshot) {
                            final count = snapshot.data ?? 0;
                            return Text(
                              '$count ${count == 1 ? 'pet' : 'pets'}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                              .withValues(alpha: 0.7)
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Selected indicator
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  const SizedBox(width: 8),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red.shade400,
                    tooltip: 'Delete owner',
                    onPressed: () => _handleDeleteOwner(owner),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectOwnerPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_back,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Select an owner',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Go to Owners tab and tap on an owner\nto view their pets',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            onPressed: () => ref.invalidate(ownersProvider),
          ),
        ],
      ),
    );
  }

  void _showAddOwnerDialog() {
    showDialog(context: context, builder: (context) => const AddOwnerDialog());
  }

  void _showAddPetDialog(int ownerId) {
    showDialog(
      context: context,
      builder: (context) => AddPetDialog(ownerId: ownerId),
    );
  }

  Future<void> _handleDeleteOwner(Owner owner) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48),
        title: const Text('Delete Owner?'),
        content: Text(
          'This will permanently delete ${owner.fullName} and all their pets.\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(ownersProvider.notifier).deleteOwner(owner.id!);

        // Clear selection if deleted owner was selected
        final selectedOwnerId = ref.read(selectedOwnerIdProvider);
        if (selectedOwnerId == owner.id) {
          ref.read(selectedOwnerIdProvider.notifier).selectOwner(null);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${owner.fullName} deleted'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
