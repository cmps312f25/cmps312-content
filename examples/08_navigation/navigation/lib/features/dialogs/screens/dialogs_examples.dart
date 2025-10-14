import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/routing/app_router.dart';
import 'package:navigation/core/widgets/nav_drawer.dart';
import 'package:navigation/features/dialogs/widgets/basic_dialog.dart';
import 'package:navigation/features/dialogs/widgets/list_dialog.dart';
import 'package:navigation/features/dialogs/widgets/modal_bottom_sheet.dart';
import 'package:navigation/features/dialogs/widgets/scrollable_bottom_sheet.dart';
import 'package:navigation/features/dialogs/widgets/standard_bottom_sheet.dart';

// Material 3 Dialog and Bottom Sheet Examples
// Dialogs interrupt users with urgent information, details, or actions.
// They appear in front of app content to provide critical information or ask for a decision.
//
// Key Design Guidelines:
// 1. Use dialogs sparingly - they interrupt the user experience
// 2. Keep content focused and concise
// 3. Provide clear actions (typically 1-2 buttons)
// 4. Use appropriate dialog type for the use case:
//    - Basic Dialog: Simple decisions or information (e.g., confirmations, alerts)
//    - Full-screen Dialog: Complex tasks requiring more space (e.g., forms, multi-step processes)
//
// Bottom Sheets are surfaces containing supplementary content, anchored to the bottom of the screen.
// Use bottom sheets for:
// - Secondary actions or content that doesn't need full screen attention
// - Providing options or filtering content
// - Displaying additional information without leaving current context
//
// References:
// - Dialogs: https://m3.material.io/components/dialogs/guidelines
// - Bottom Sheets: https://m3.material.io/components/bottom-sheets/guidelines

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material 3 Dialogs & Bottom Sheets'),
      ),
      drawer: const NavDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dialogs Section
              Text(
                'Dialogs',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const BasicDialog(),
                ),
                icon: const Icon(Icons.info_outline),
                label: const Text('Basic Dialog'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const ListDialog(),
                ),
                icon: const Icon(Icons.list),
                label: const Text('List Dialog'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.fullscreenDialog),
                icon: const Icon(Icons.fullscreen),
                label: const Text('Full-screen Dialog'),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Bottom Sheets Section
              Text(
                'Bottom Sheets',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showStandardBottomSheet(context),
                icon: const Icon(Icons.arrow_upward),
                label: const Text('Standard Bottom Sheet'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showModalBottomSheet(context),
                icon: const Icon(Icons.filter_list),
                label: const Text('Modal Bottom Sheet'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showScrollableBottomSheet(context),
                icon: const Icon(Icons.menu_book),
                label: const Text('Scrollable Bottom Sheet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Standard Bottom Sheet - Non-modal, doesn't block interaction with main content
  // Use case: Quick actions, supplementary content that users can dismiss easily
  void _showStandardBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => const StandardBottomSheet(),
    );
  }

  // Modal Bottom Sheet - Blocks interaction with main content
  // Use case: User must make a choice or complete an action before continuing
  // Common uses: Filters, sort options, sharing options
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Enable dragging to dismiss
      isDismissible: true,
      // Show drag handle for better UX
      showDragHandle: true,
      // Rounded corners for Material 3 design
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const ModalBottomSheetContent(),
    );
  }

  // Scrollable Bottom Sheet - For larger content that requires scrolling
  // Use case: Lists, detailed information, terms and conditions
  // Takes up more screen space, usually with max height constraint
  void _showScrollableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows sheet to take up more screen space
      isDismissible: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      // Constrain to 90% of screen height
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => const ScrollableBottomSheetContent(),
    );
  }
}
