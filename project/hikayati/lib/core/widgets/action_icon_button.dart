import 'package:flutter/material.dart';

/// Circular icon button with background for action buttons
class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
    this.size = 8,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(size),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}
