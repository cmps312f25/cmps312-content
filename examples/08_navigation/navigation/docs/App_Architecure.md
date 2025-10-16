# Feature-Based Clean Architecture with Responsive Navigation

This project follows a **feature-based Clean Architecture** pattern with **adaptive/responsive UI**, organizing code by features rather than technical layers. This approach improves modularity, maintainability, and scalability across all screen sizes.

## 📁 Project Structure

```
lib/
├── main.dart                      # Application entry point
├── core/                          # Shared/common components
│   ├── models/
│   │   └── nav_item.dart         # Navigation item model (shared)
│   ├── routing/
│   │   └── app_router.dart       # GoRouter configuration with ShellRoute
│   └── widgets/
│       ├── nav_scaffold_responsive.dart  # Responsive coordinator
│       ├── mobile_scaffold.dart  # Mobile layout scaffold
│       ├── tablet_desktop_scaffold.dart  # Tablet/Desktop layout scaffold
│       ├── nav_bottom_bar.dart   # Bottom navigation (mobile)
│       ├── nav_rail.dart         # Navigation rail (tablet/desktop)
│       └── nav_drawer.dart       # Navigation drawer (secondary nav)
│
└── features/                      # Feature modules
    ├── fruits/                    # Fruits feature
    │   ├── models/
    │   │   └── fruit.dart        # Fruit data model
    │   ├── repositories/
    │   │   └── fruit_repository.dart
    │   ├── screens/
    │   │   ├── fruits_list.dart  # List of fruits
    │   │   └── fruit_detail.dart # Fruit details
    │   └── widgets/
    │       └── fruit_list_tile.dart
    │
    ├── dialogs/                   # Overlay components examples
    │   ├── models/
    │   │   └── user_profile.dart
    │   ├── screens/
    │   │   └── dialogs_sheets.dart
    │   └── widgets/
    │       ├── dialog_basic.dart
    │       ├── dialog_fullscreen.dart
    │       ├── dialog_list.dart
    │       ├── bottom_sheet_modal.dart
    │       ├── bottom_sheet_standard.dart
    │       ├── side_sheet_modal.dart
    │       ├── side_sheet_standard.dart
    │       ├── profile_editor.dart
    │       └── profile_viewer.dart
    │
    ├── home/                      # Home feature
    │   └── screens/
    │       └── home_screen.dart
    │
    ├── profile/                   # Profile feature
    │   └── screens/
    │       └── profile_screen.dart
    │
    └── settings/                  # Settings feature
        └── screens/
            └── settings_screen.dart
```

## 🏗️ Architecture Principles

### Feature-Based Organization
Each feature is self-contained with its own:
- **models/** - Domain or data models (e.g., User, Product, Fruit)
- **repositories/** - Data access layer and business logic
- **screens/** - UI entry points (pages/routes)
- **widgets/** - Feature-specific reusable UI components

### Core Module
Shared components used across multiple features:
- **models/** - Shared data models (e.g., NavItem for navigation consistency)
- **routing/** - Navigation and routing configuration with GoRouter
- **widgets/** - Common UI components (scaffolds, navigation bars, drawers)

### Benefits

✅ **Modularity** - Features are independent and can be developed in isolation  
✅ **Scalability** - Easy to add new features without affecting existing ones  
✅ **Maintainability** - Related code is grouped together  
✅ **Testability** - Features can be tested independently  
✅ **Responsive Design** - Adaptive navigation for all screen sizes  
✅ **Team Collaboration** - Multiple developers can work on different features simultaneously  
✅ **Code Reusability** - Clear separation of shared vs feature-specific code


## 🎯 Current Features

- **fruits** - Browse and view fruit details with repository pattern
- **dialogs** - Material 3 overlay components (dialogs, bottom sheets, side sheets)
- **home** - Application home screen
- **profile** - User profile screen (drawer navigation)
- **settings** - Application settings (drawer navigation)

## 🔗 Responsive Navigation Architecture

The app uses **ResponsiveNavScaffold** which automatically adapts navigation based on screen width:

#### Mobile Layout (< 600dp)
- **Bottom Navigation Bar** - Primary navigation (Home, Fruits, Dialogs)
- **Drawer** - Secondary navigation (Profile, Settings)
- Accessed via hamburger menu in AppBar

#### Tablet Layout (≥ 600)
- **Navigation Rail** (collapsed) - Primary navigation on left edge
- **Drawer** - Secondary navigation accessible via rail's hamburger menu
- Drawer overlays content when opened

### Architecture Components

**1. ResponsiveNavScaffold** (`nav_scaffold_responsive.dart`)
- Coordinator widget using LayoutBuilder
- Detects screen width and delegates to appropriate scaffold
- Single responsibility: responsive decision-making only

**2. MobileScaffold** (`mobile_scaffold.dart`)
- Handles mobile layout (< 600dp)
- Integrates BottomNavBar for primary navigation
- Clean, focused implementation for small screens

**3. TabletDesktopScaffold** (`tablet_desktop_scaffold.dart`)
- Handles tablet/desktop layout (≥ 600dp)
- Integrates NavRail (primary) and NavDrawer (secondary)
- Supports extended mode for large screens (≥ 1000dp)

**4. NavItem Model** (`core/models/nav_item.dart`)
- Shared data model for all navigation items
- Eliminates code duplication across navigation widgets
- Properties: `icon`, `label`, `route` (nullable for primary nav)

**5. ShellRoute (GoRouter)**
- Wraps main app screens with persistent navigation
- Preserves navigation state across route changes
- Integrates ResponsiveNavScaffold for adaptive UI

**6. Navigation Widgets**
- **NavBottomBar** - Material 3 bottom navigation for mobile
- **NavRail** - Vertical navigation rail for tablet/desktop with hamburger menu
- **NavDrawer** - Standard overlay drawer for secondary navigation

### Route Structure

```dart
ShellRoute (with ResponsiveNavScaffold)
├── / (Home)
├── /fruits (Fruits List)
└── /dialogs (Dialogs & Sheets)

Standalone Routes (no shell)
├── /profile (Profile)
├── /settings (Settings)
├── /fruitDetails (Fruit Detail)
└── /fullscreenDialog (Fullscreen Dialog Example)
```

### Key Design Decisions

✅ **Adaptive Pattern** - UI structure changes based on screen width, not device type  
✅ **ShellRoute** - Persistent navigation for primary routes  
✅ **Modular Scaffolds** - Separate files for mobile and tablet/desktop layouts  
✅ **Shared NavItem Model** - DRY principle with single navigation item definition  
✅ **Single Responsibility** - Each widget/file has one clear purpose

## 📱 Responsive Behavior

The navigation automatically adapts when:
- User resizes window (desktop/web)
- Device is rotated (mobile/tablet)
- App runs on different form factors (phone/tablet/desktop)
- Split-screen or multi-window mode is used

This ensures a consistent, optimal user experience across all platforms and screen sizes.

## 🎨 Dialogs & Sheets
The app demonstrates overlay components:
- **Dialogs** - Basic, List, and Fullscreen dialogs
- **Bottom Sheets** - Modal and Standard bottom sheets
- **Side Sheets** - Modal and Standard side sheets

## 💡 Best Practices Implemented

✅ **DRY (Don't Repeat Yourself) Principle** - NavItem eliminates code duplication  
✅ **Single Responsibility** - Each file/class has one purpose  
✅ **Composition Over Inheritance** - Widgets composed from smaller parts  
✅ **Open/Closed Principle** - Easy to extend, no need to modify existing code  
✅ **Dependency Inversion** - Features depend on routing, not direct imports  
✅ **Material 3 Compliance** - Follows official design guidelines  
✅ **Clean Architecture** - Clear separation of concerns and features