import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/pets/providers/pets_provider.dart';
import 'package:supabase_app/features/pets/widgets/owners_list.dart';
import 'package:supabase_app/features/pets/widgets/pets_list.dart';
import 'package:supabase_app/features/pets/widgets/add_owner_dialog.dart';
import 'package:supabase_app/features/pets/widgets/pets_summary_dialog.dart';

class PetsScreen extends ConsumerWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOwnerId = ref.watch(selectedOwnerIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets Manager'),
        backgroundColor: const Color(0xFF00897B), // Teal 600
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize),
            tooltip: 'Pets Summary',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const PetsSummaryDialog(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Owner',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddOwnerDialog(),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Owners list (left side)
          const Expanded(flex: 1, child: OwnersList()),

          // Pets list (right side)
          Expanded(flex: 2, child: PetsList(selectedOwnerId: selectedOwnerId)),
        ],
      ),
    );
  }
}
