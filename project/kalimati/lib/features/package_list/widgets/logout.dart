import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kalimati/features/auth/presentation/providers/auth_provider.dart';

class LogoutButton extends ConsumerWidget {
  final Color? iconColor;
  final bool showLabel;

  const LogoutButton({super.key, this.iconColor, this.showLabel = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const brandGreen = Color(0xFF1B5E20);
    const brandBg = Color.fromARGB(255, 243, 255, 243);

    Future<void> showLogoutDialog() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: brandBg,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold, color: brandGreen),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: brandGreen),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        ref.read(authNotifierProvider.notifier).signOut();
        if (context.mounted) context.go('/login');
      }
    }

    return showLabel
        ? ListTile(
            leading: Icon(Icons.logout, color: iconColor ?? Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
            onTap: showLogoutDialog,
          )
        : IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout, color: iconColor ?? Colors.redAccent),
            onPressed: showLogoutDialog,
          );
  }
}
