# Responsive Navigation Architecture

This document explains the adaptive navigation system that responds to different screen sizes following Material Design 3 guidelines.

## 📐 Screen Size Breakpoints

| Screen Size | Width Range | Navigation | Secondary Nav | Extended |
|-------------|-------------|------------|---------------|----------|
| **Mobile** | < 600dp | Bottom Bar | Drawer (hidden) | N/A |
| **Tablet** | 600-999dp | Rail (collapsed) | Drawer | No |
| **Desktop** | ≥ 1000dp | Rail (extended) | Drawer | Yes |

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────┐
│         app_router.dart (GoRouter)          │
│  - Defines all routes and navigation logic  │
│  - Wraps main screens in ShellRoute         │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│  nav_scaffold_responsive.dart (coordinator) │
│  - Uses LayoutBuilder for screen detection  │
│  - Delegates to appropriate scaffold        │
└─────────────┬───────────────────────────────┘
              │
        ┌─────┴─────┐
        ▼           ▼
   ┌─────────┐  ┌──────────────┐
   │ Mobile  │  │ Tablet/      │
   │ Scaffold│  │ Desktop      │
   │         │  │ Scaffold     │
   └────┬────┘  └───┬──────────┘
        │           │
        ▼           ▼
   ┌─────────┐  ┌──────────────┐
   │ Bottom  │  │ Nav Rail +   │
   │ Nav Bar │  │ Nav Drawer   │
   └─────────┘  └──────────────┘
```

**Components:**
- **ResponsiveNavScaffold** - Coordinator (detects width < 600dp)
- **MobileScaffold** - Mobile layout with BottomNavBar
- **TabletDesktopScaffold** - Tablet/Desktop with Rail + Drawer
- **NavItem** - Shared model for navigation items (DRY)

## 🎯 Key Design Decisions

### 1. **LayoutBuilder over MediaQuery**
```dart
LayoutBuilder(
  builder: (context, constraints) {
    // Uses constraints.maxWidth instead of MediaQuery
    final width = constraints.maxWidth;
  }
)
```
**Why?**
- More accurate for split-screen and responsive layouts
- Measures actual available space, not device screen size
- Better for foldables and future form factors

### 2. **ShellRoute for Persistent Navigation**
```dart
ShellRoute(
  builder: (context, state, child) {
    return ResponsiveNavScaffold(
      child: child, // Preserves child widget between navigation
    );
  },
  routes: [...], // All main app routes
)
```
**Why?**
- Navigation chrome stays visible during route changes
- State preservation (navigation selection persists)
- Smooth transitions without rebuilding navigation

### 3. **Modular Scaffolds**
Separate files for mobile and tablet/desktop layouts.

**Why?** Single responsibility, easier testing, cleaner organization.

### 4. **NavItem Model**
```dart
class NavItem {
  final IconData icon;
  final String label;
  final String? route; // null for primary nav
}
```
**Why?** DRY principle - define once, use everywhere.

## 📂 File Structure

```
lib/core/
├── models/
│   └── nav_item.dart                # Shared navigation model
├── routing/
│   └── app_router.dart              # GoRouter + ShellRoute
└── widgets/
    ├── nav_scaffold_responsive.dart # Coordinator
    ├── mobile_scaffold.dart         # Mobile layout
    ├── tablet_desktop_scaffold.dart # Tablet/Desktop layout
    ├── nav_bottom_bar.dart          # Bottom navigation
    ├── nav_rail.dart                # Navigation rail
    └── nav_drawer.dart              # Drawer
```

## 🔄 Navigation Flow

**Mobile:** Bottom Bar tap → `context.go(route)`  
**Tablet/Desktop:** Rail tap → `context.go(route)` OR Drawer tap → `context.go(route)`

## 🎨 Material 3 Compliance

### Bottom Navigation Bar
- ✅ Fixed at bottom of screen
- ✅ 3-5 destinations (we have 3: Home, Fruits, Dialogs)
- ✅ Icons with labels
- ✅ Active indicator for selected item

### Navigation Rail
- ✅ 72dp width (collapsed) or auto width (extended)
- ✅ Vertical alignment along left edge
- ✅ Selected indicator on active destination
- ✅ Optional leading/trailing widgets

### Navigation Drawer
- ✅ Standard width (280-360dp)
- ✅ Contains secondary destinations
- ✅ Dismissed on destination selection
- ✅ Can be opened via menu icon or swipe

## 🔧 Adding Navigation Items

### Primary (Bottom Bar / Rail)
```dart
// nav_bottom_bar.dart & nav_rail.dart
static const _navItems = [
  NavItem(icon: Icons.home, label: 'Home'),
  NavItem(icon: Icons.apple, label: 'Fruits'),
  NavItem(icon: Icons.chat, label: 'Dialogs'),
  NavItem(icon: Icons.new_icon, label: 'New'), // Add
];

// app_router.dart
static const newItem = '/newItem';
GoRoute(path: AppRoutes.newItem, builder: (_, __) => NewScreen()),
```

### Secondary (Drawer)
```dart
// nav_drawer.dart
NavItem(icon: Icons.new_icon, label: 'New', route: AppRoutes.new),

// app_router.dart (outside ShellRoute)
GoRoute(path: AppRoutes.new, builder: (_, __) => NewScreen()),
```

## 🧪 Testing

```bash
flutter run -d windows  # or chrome
# Resize: < 600dp, 600-999dp, ≥ 1000dp
```

## 🎓 Key Takeaways

1. **Adaptive > Responsive** - Structure changes, not just sizing
2. **LayoutBuilder** - Detects available space (not device size)
3. **ShellRoute** - Preserves navigation state
4. **Modular Scaffolds** - Separate files for maintainability
5. **NavItem Model** - DRY principle eliminates duplication

## 📚 See Also

- [Responsive_Navigation_Visual_Guide.md](./Responsive_Navigation_Visual_Guide.md)
- [Quick_Reference_Responsive_Nav.md](./Quick_Reference_Responsive_Nav.md)
- [App_Architecture.md](./App_Architecure.md)



