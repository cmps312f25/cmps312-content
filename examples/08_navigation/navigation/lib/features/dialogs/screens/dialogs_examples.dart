import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/routing/app_router.dart';
import 'package:navigation/core/widgets/nav_drawer.dart';
import 'package:navigation/features/dialogs/widgets/basic_dialog.dart';
import 'package:navigation/features/dialogs/widgets/list_dialog.dart';
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

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & Sheets'),
      ),
      drawer: const NavDrawer(),
      body: Center(
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
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const BasicDialog(),
                ),
                icon: const Icon(Icons.info_outline),
                label: const Text('Basic Dialog'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const ListDialog(),
                ),
                icon: const Icon(Icons.list),
                label: const Text('List Dialog'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => context.push(AppRoutes.fullscreenDialog),
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
                onPressed: () => _showStandardBottomSheet(context),
                icon: const Icon(Icons.arrow_upward),
                label: const Text('Standard Bottom Sheet'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showModalBottomSheet(context),
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
                onPressed: () => _showStandardSideSheet(context),
                icon: const Icon(Icons.view_sidebar),
                label: const Text('Standard Side Sheet'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showModalSideSheet(context),
                icon: const Icon(Icons.view_sidebar_outlined),
                label: const Text('Modal Side Sheet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows standard (non-modal) bottom sheet
  /// Allows interaction with main content, easy to dismiss
  void _showStandardBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) => const StandardBottomSheet(),
    );
  }

  /// Shows modal bottom sheet - blocks interaction with main content
  /// User must complete action or dismiss before continuing
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      showDragHandle: true, // Material 3 drag handle
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const ModalBottomSheetContent(),
    );
  }

  /// Shows standard (non-modal) side sheet from right edge
  /// Background stays clear - user can still see and interact with main content
  void _showStandardSideSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent, // No darkening effect
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
            child: const StandardSideSheet(),
          ),
        );
      },
    );
  }

  /// Shows modal side sheet - blocks interaction with main content
  /// Dims background to focus user attention on the sheet
  void _showModalSideSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor:
          Colors.black.withAlpha(128), // Semi-transparent dark overlay
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
            child: const ModalSideSheet(),
          ),
        );
      },
    );
  }
}
