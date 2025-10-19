import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/app/routing/app_router.dart';
import 'package:navigation/app/widgets/nav_drawer.dart';
import 'package:navigation/features/dialogs/widgets/dialog_basic.dart';
import 'package:navigation/features/dialogs/widgets/dialog_selection_list.dart';
import 'package:navigation/features/dialogs/widgets/bottom_sheet_modal.dart';
import 'package:navigation/features/dialogs/widgets/bottom_sheet_standard.dart';
import 'package:navigation/features/dialogs/widgets/side_sheet_standard.dart';
import 'package:navigation/features/dialogs/widgets/side_sheet_modal.dart';

/// Overlay Components: Dialogs, Bottom Sheets, and Side Sheets
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ WHEN TO USE WHICH COMPONENT?                                            │
/// └─────────────────────────────────────────────────────────────────────────┘
/// 🔴 DIALOGS - Urgent interruptions requiring immediate attention
///    ✓ Use For: Critical alerts, confirmations, important decisions
///    ✗ Avoid: Long content, complex forms, supplementary info
///    📱 Best On: All screen sizes
///    ⚠️  Warning: Disruptive - use sparingly!
///
///    Examples:
///    • "Delete account? This cannot be undone" (confirmation)
///    • "Error: Payment failed. Retry?" (alert)
///    • "Allow camera access?" (permission)
///    • "Unsaved changes. Discard or save?" (decision)
///
/// 🔵 BOTTOM SHEETS - Supplementary content from bottom edge
///    ✓ Use For: Quick actions, share menus, filters, short forms
///    ✗ Avoid: Critical alerts, long scrolling content, desktop layouts
///    📱 Best On: Mobile devices (compact to medium screens)
///    👆 Interaction: Touch-friendly, swipe to dismiss
///
///    Examples:
///    • Social media share options (standard)
///    • Image upload: camera or gallery (modal)
///    • Map location filters (standard)
///    • Quick note creation form (modal)
///    • Product sort options (standard)
///
/// 🟢 SIDE SHEETS - Contextual content from right edge
///    ✓ Use For: Filters, forms, settings, contextual info
///    ✗ Avoid: Mobile layouts, urgent alerts, full-screen content
///    📱 Best On: Tablets and desktops (medium to large screens)
///    🖱️  Interaction: Allows viewing main content while interacting
///
///    Examples:
///    • E-commerce product filters (standard)
///    • Email compose/reply pane (modal)
///    • Calendar event editor (modal)
///    • Dashboard widget settings (standard)
///    • Document properties panel (standard)
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ QUICK DECISION GUIDE                                                     │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │ Urgent + Must Complete → Dialog                                         │
/// │ Mobile + Quick Action → Bottom Sheet                                    │
/// │ Desktop + Contextual → Side Sheet                                       │
/// │ Long Form + Mobile → Consider full-screen page instead                  │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// Material 3 References:
/// - Dialogs: https://m3.material.io/components/dialogs/guidelines
/// - Bottom Sheets: https://m3.material.io/components/bottom-sheets/guidelines
/// - Side Sheets: https://m3.material.io/components/side-sheets/guidelines

class DialogsSheetsScreen extends StatelessWidget {
  const DialogsSheetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & Sheets'),
      ),
      drawer: isMobile ? const NavDrawer() : null,
      // For large screens: show ProductFiltersSheet as endDrawer (side sheet)
      endDrawer: !isMobile
          ? const Drawer(
              width: 320,
              child: ProductFiltersSheet(),
            )
          : null,
      body: Stack(
        children: [
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ─── Dialogs ───
                  Text(
                    'Dialogs',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => const BasicDialog(),
                      );
                      messenger.showSnackBar(
                        SnackBar(content: Text("Delete Confirmed: $confirmed")),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Basic Dialog'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final selectedValue = await showDialog<String>(
                        context: context,
                        builder: (context) => const SelectionListDialog(),
                      );
                      messenger.showSnackBar(SnackBar(
                          content: Text('Selected value: $selectedValue')));
                    },
                    icon: const Icon(Icons.list),
                    label: const Text('Selection List Dialog'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => context.push(AppRoutes.profileDialog),
                    icon: const Icon(Icons.fullscreen),
                    label: const Text('Full-screen Dialog'),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // ─── Bottom Sheets ───
                  Text(
                    'Bottom Sheets',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final result = await _showStandardBottomSheet(context);
                      if (result != null && result != 'Closed') {
                        messenger.showSnackBar(SnackBar(content: Text(result)));
                      }
                    },
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('Standard Bottom Sheet'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final result = await _showModalBottomSheet(context);
                      if (result != null) {
                        messenger.showSnackBar(
                          SnackBar(
                            content:
                                Text('Filters applied: ${result.toString()}'),
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Modal Bottom Sheet'),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // ─── Side Sheets ───
                  Text(
                    'Side Sheets',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final userProfile = await _showStandardSideSheet(context);
                      if (userProfile != null) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                                'Filters applied: ${userProfile.toString()}'),
                            duration: const Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.view_sidebar),
                    label: const Text('Standard Side Sheet'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final result = await _showModalSideSheet(context);
                      if (result != null && result != 'Cancel') {
                        messenger.showSnackBar(SnackBar(content: Text(result)));
                      }
                    },
                    icon: const Icon(Icons.view_sidebar_outlined),
                    label: const Text('Modal Side Sheet'),
                  ),
                ],
              ),
            ),
          ),
          // For mobile screens: add swipe-up draggable bottom sheet
          if (isMobile)
            DraggableScrollableSheet(
              initialChildSize: 0.05, // Start minimized (5% of screen)
              minChildSize: 0.05, // Minimum size
              maxChildSize:
                  0.9, // Maximum size when expanded (increased for better content fit)
              snap: true,
              snapSizes: const [0.05, 0.9],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag handle indicator
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withAlpha(102),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Sheet content - Fixed overflow with proper scrolling
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: const FilterOptionsModalBottomSheet(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Shows standard (non-modal) bottom sheet
  /// Allows interaction with main content, easy to dismiss
  Future<String?> _showStandardBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (context) => const StandardBottomSheet(),
    );
  }

  /// Shows modal bottom sheet - blocks interaction with main content
  /// User must complete action or dismiss before continuing
  /// Returns FilterOptions object with user's selections
  Future<FilterOptions?> _showModalBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<FilterOptions>(
      context: context,
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true, // Allow keyboard to push content up
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const FilterOptionsModalBottomSheet(),
    );
  }

  /// Shows standard (non-modal) side sheet from right edge
  /// Background stays clear - user can still see and interact with main content
  /// Returns SideSheetFilters object with user's selections
  Future<ProductFilters?> _showStandardSideSheet(BuildContext context) async {
    return await showGeneralDialog<ProductFilters>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: const ProductFiltersSheet(),
          ),
        );
      },
    );
  }

  /// Shows modal side sheet - blocks interaction with main content
  /// Dims background to focus user attention on the sheet
  Future<String?> _showModalSideSheet(BuildContext context) async {
    return await showGeneralDialog<String>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withAlpha(128),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: const TaskEditorModalSheet(),
          ),
        );
      },
    );
  }
}
