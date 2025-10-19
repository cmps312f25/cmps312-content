# 📁 State Management

## Overview
This project demonstrates Flutter state management using Riverpod with a clean, feature-based architecture.

## 🎯 Feature Structure
Clean, layered architecture for each feature:

```
lib/features/<feature_name>/
├── 📊 models/          # Data classes
├── 💾 repositories/    # Data access (API/JSON/DB)
├── 🔄 providers/       # Riverpod state management
├── 📱 screens/         # Full-page UI
└── 🧩 widgets/         # Reusable components
```

---

## 📦 Project Structure

```
lib/
├── main.dart
│
├── app/
│   ├── home_screen.dart      # Main navigation
│   └── router.dart           # GoRouter config
│
└── features/
    │
    ├── ⚙️  app_config/         # Provider demo
    │   ├── providers/
    │   │   ├── api_config_provider.dart
    │   │   ├── max_items_per_page_provider.dart
    │   │   └── theme_mode_provider.dart
    │   └── screens/
    │       └── app_config_screen.dart
    │
    ├── 🧮 counter/             # NotifierProvider demo
    │   ├── providers/
    │   │   └── counter_provider.dart
    │   └── screens/
    │       └── counter_screen.dart
    │
    ├── ☁️  weather/            # FutureProvider + NotifierProvider
    │   ├── models/
    │   │   └── weather_model.dart
    │   ├── providers/
    │   │   ├── selected_city_provider.dart
    │   │   └── weather_provider.dart
    │   └── screens/
    │       └── weather_screen.dart
    │
    ├── 📰 news/                # StreamProvider demo
    │   ├── models/
    │   │   └── news_model.dart
    │   ├── providers/
    │   │   └── news_provider.dart
    │   └── screens/
    │       └── news_screen.dart
    │
    ├── 🍎 fruits/              # FutureProvider + navigation
    │   ├── models/
    │   │   └── fruit_model.dart
    │   ├── repositories/
    │   │   └── fruit_repository.dart
    │   ├── providers/
    │   │   └── fruits_provider.dart
    │   ├── screens/
    │   │   ├── fruits_screen.dart
    │   │   └── fruit_detail_screen.dart
    │   └── widgets/
    │       └── fruit_tile.dart
    │
    ├── 🛍️  products/           # Computed providers + filtering
    │   ├── models/
    │   │   ├── category.dart
    │   │   └── product.dart
    │   ├── repositories/
    │   │   └── product_repository.dart
    │   ├── providers/
    │   │   ├── categories_provider.dart
    │   │   ├── filtered_products_provider.dart
    │   │   ├── products_provider.dart
    │   │   └── selected_category_provider.dart
    │   ├── screens/
    │   │   └── products_screen.dart
    │   └── widgets/
    │       └── product_tile.dart
    │
    └── ✅ todos/               # Complex CRUD operations
        ├── models/
        │   └── todo.dart
        ├── repositories/
        │   └── todo_repository.dart
        ├── providers/
        │   ├── filtered_todos_provider.dart
        │   ├── todo_filter_provider.dart
        │   ├── todo_list_provider.dart
        │   └── todo_stats_provider.dart
        ├── screens/
        │   └── todo_screen.dart
        └── widgets/
            ├── add_todo_field.dart
            ├── todo_tile.dart
            └── todo_toolbar.dart
```

---

## 🔄 Riverpod Provider Types

| Type | Use Case | Example |
|------|----------|---------|
| **Provider** | Immutable config | API settings, constants |
| **NotifierProvider** | Mutable state | Counter, selected filter |
| **FutureProvider** | One-time async | API calls, data loading |
| **StreamProvider** | Continuous updates | Real-time news feed |

### Feature Provider Map

| Feature | Provider Type | Purpose |
|---------|--------------|---------|
| **app_config** | Provider | Immutable configuration |
| **counter** | NotifierProvider | Simple state mutations |
| **weather** | FutureProvider | Async weather data |
| **news** | StreamProvider | Live news updates |
| **fruits** | FutureProvider | Fruit list loading |
| **products** | FutureProvider | Product list loading |
| **todos** | NotifierProvider | Todo CRUD operations |

### Key Patterns

**Computed Providers**: Combine multiple providers
- `filtered_products_provider` - Filters products by category
- `filtered_todos_provider` - Filters todos by status
- `todo_stats_provider` - Derives counts from todo list

**Provider Composition**: Building on simpler providers
- Weather feature: `selected_city_provider` + `weather_provider`
- Products feature: `selected_category_provider` + `filtered_products_provider`
- Todos feature: `todo_filter_provider` + `filtered_todos_provider`
