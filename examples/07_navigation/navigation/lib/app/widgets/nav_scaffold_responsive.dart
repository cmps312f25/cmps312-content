import 'package:flutter/material.dart';
import 'package:navigation/app/widgets/mobile_scaffold.dart';
import 'package:navigation/app/widgets/tablet_desktop_scaffold.dart';

/// Responsive navigation scaffold adapting to screen size
///
/// Mobile (< 600dp): Bottom Navigation Bar
/// Tablet/Desktop (≥ 600dp): Navigation Rail + Drawer
class ResponsiveNavScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const ResponsiveNavScaffold({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return isMobile
            ? MobileScaffold(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                child: child,
              )
            : TabletDesktopScaffold(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                child: child,
              );
      },
    );
  }
}
