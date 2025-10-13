# Feature-Based Clean Architecture

This project follows a **feature-based Clean Architecture** pattern, organizing code by features rather than technical layers. This approach improves modularity, maintainability, and scalability.

## 📁 Project Structure

```
lib/
├── main.dart                      # Application entry point
├── core/                          # Shared/common components
│   ├── routing/
│   │   └── app_router.dart       # GoRouter configuration
│   └── widgets/
│       ├── nav_bottom_bar.dart   # Bottom navigation bar
│       └── nav_drawer.dart       # Navigation drawer
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
    ├── dialogs/                   # Dialog examples feature
    │   ├── screens/
    │   │   └── dialogs_examples.dart
    │   └── widgets/
    │       ├── basic_dialog.dart
    │       ├── fullscreen_dialog.dart
    │       └── list_dialog.dart
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
- **routing/** - Navigation and routing configuration
- **widgets/** - Common UI components (navigation bars, drawers)

### Benefits

✅ **Modularity** - Features are independent and can be developed in isolation
✅ **Scalability** - Easy to add new features without affecting existing ones
✅ **Maintainability** - Related code is grouped together
✅ **Testability** - Features can be tested independently
✅ **Team Collaboration** - Multiple developers can work on different features simultaneously
✅ **Code Reusability** - Clear separation of shared vs feature-specific code


## 🎯 Current Features

- **fruits** - Browse and view fruit details with repository pattern
- **dialogs** - Material 3 dialog examples (basic, list, full-screen)
- **home** - Application home screen
- **profile** - User profile screen
- **settings** - Application settings

## 🔗 Navigation Architecture

- **ShellRoute** - Provides persistent bottom navigation for Home, Fruits, and Dialogs
- **Individual Routes** - Profile and Settings accessible via drawer