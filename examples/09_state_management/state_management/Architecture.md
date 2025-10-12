# State Management - Feature-Based Architecture

## Overview
This project demonstrates Flutter state management using Riverpod with a clean, feature-based architecture.

## Architecture Structure

```
lib/
├── core/                      # Core/shared code
│   ├── router.dart           # App routing configuration
│   └── home_screen.dart      # Main navigation screen
│
├── features/                  # Feature modules
│   ├── counter/              # Counter feature
│   │   ├── counter_provider.dart
│   │   ├── counter_screen.dart
│   │   └── click_counter.dart
│   │
│   ├── weather/              # Weather feature
│   │   ├── weather_model.dart
│   │   ├── weather_provider.dart
│   │   └── weather_screen.dart
│   │
│   ├── news/                 # News feature
│   │   ├── news_model.dart
│   │   ├── news_provider.dart
│   │   └── news_screen.dart
│   │
│   ├── todos/                # Todo list feature
│   │   ├── models/
│   │   │   └── todo.dart
│   │   ├── providers/
│   │   │   ├── todo_list_provider.dart
│   │   │   └── todo_filter_provider.dart
│   │   ├── repositories/
│   │   │   └── todo_repository.dart
│   │   ├── widgets/
│   │   │   ├── add_todo_field.dart
│   │   │   ├── todo_tile.dart
│   │   │   └── todo_toolbar.dart
│   │   └── todo_screen.dart
│   │
│   ├── products/             # Products feature
│   │   ├── models/
│   │   │   ├── product.dart
│   │   │   └── category.dart
│   │   ├── providers/
│   │   │   ├── products_provider.dart
│   │   │   ├── categories_provider.dart
│   │   │   └── selected_category_provider.dart
│   │   ├── repositories/
│   │   │   └── product_repository.dart
│   │   ├── widgets/
│   │   │   └── product_tile.dart
│   │   └── products_screen.dart
│   │
│   ├── fruits/               # Fruits feature
│   │   ├── fruit_model.dart
│   │   ├── fruits_provider.dart
│   │   ├── fruit_repository.dart
│   │   ├── widgets/
│   │   │   └── fruit_tile.dart
│   │   ├── fruits_screen.dart
│   │   └── fruit_detail_screen.dart
│   │
│   └── app_config/           # App configuration feature
│       ├── app_config_provider.dart
│       └── app_config_screen.dart
│
└── main.dart                 # App entry point

```

## Principles

### 1. **Feature-Based Organization**
- Each feature is self-contained in its own folder
- Related files (models, providers, screens, widgets) are grouped together
- Easy to find and modify feature-specific code

### 2. **Clear Separation of Concerns**
- **Models**: Data structures
- **Providers**: State management logic
- **Repositories**: Data access layer
- **Screens**: UI screens/pages
- **Widgets**: Reusable UI components
- **Core**: Shared/global code (routing, main navigation)

### 3. **Scalability**
- Adding new features is straightforward: create a new folder under `features/`
- Removing features is clean: delete the folder
- Features can be developed independently

### 4. **Maintainability**
- Code is organized by domain/feature, not by technical type
- Each feature can be understood and modified without affecting others
- Clear file naming conventions

## Provider Patterns Used

### Counter Feature
- **Pattern**: NotifierProvider
- **Purpose**: Simple state management with methods

### Weather Feature
- **Pattern**: FutureProvider + NotifierProvider
- **Purpose**: Async API calls with state selection

### News Feature
- **Pattern**: StreamProvider
- **Purpose**: Continuous data updates

### Todos Feature
- **Pattern**: NotifierProvider + Derived Providers
- **Purpose**: Complex state with filtering and computed values

### Products Feature
- **Pattern**: AsyncNotifierProvider
- **Purpose**: Async initialization with methods

### Fruits Feature
- **Pattern**: FutureProvider
- **Purpose**: Simple async data loading

### App Config Feature
- **Pattern**: Provider
- **Purpose**: Read-only configuration values