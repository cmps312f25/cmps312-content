# 📁 Feature-Based Architecture - Quick Visual Reference

## 🎯 Standard Feature Structure

```
lib/features/<feature_name>/
│
├── 📊 models/          ← Data classes (Product, Todo, Weather, etc.)
│   └── *.dart
│
├── 💾 repositories/    ← Data access layer (API, JSON, local storage)
│   └── *.dart
│
├── 🔄 providers/       ← Riverpod providers (state + business logic)
│   └── *.dart
│
├── 📱 screens/         ← Page-level UI (routes)
│   └── *.dart
│
└── 🧩 widgets/         ← Reusable UI components
    └── *.dart
```

---

## 📦 All Features Overview

```
lib/
├── main.dart                          # 🚀 App entry point
├── app/
│   └── router.dart                    # 🗺️  Go Router (8 routes)
├── core/
│   └── home_screen.dart               # 🏠 Main navigation
│
└── features/
    │
    ├── 🧮 counter/                    # NotifierProvider demo
    │   ├── providers/
    │   │   └── counter_provider.dart
    │   └── screens/
    │       └── counter_screen.dart
    │
    ├── ☁️  weather/                    # FutureProvider + API
    │   ├── models/
    │   │   └── weather_model.dart
    │   ├── providers/
    │   │   └── weather_provider.dart
    │   └── screens/
    │       └── weather_screen.dart
    │
    ├── 📰 news/                        # StreamProvider + auto-refresh
    │   ├── models/
    │   │   └── news_model.dart
    │   ├── providers/
    │   │   └── news_provider.dart
    │   └── screens/
    │       └── news_screen.dart
    │
    ├── 🍎 fruits/                      # FutureProvider + navigation
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
    ├── 🛍️  products/                   # AsyncNotifierProvider + filtering
    │   ├── models/
    │   │   ├── product.dart
    │   │   └── category.dart
    │   ├── repositories/
    │   │   └── product_repository.dart
    │   ├── providers/
    │   │   ├── products_provider.dart
    │   │   ├── categories_provider.dart
    │   │   └── selected_category_provider.dart
    │   ├── screens/
    │   │   └── products_screen.dart
    │   └── widgets/
    │       └── product_tile.dart
    │
    ├── ✅ todos/                       # Complex state + CRUD
    │   ├── models/
    │   │   └── todo.dart
    │   ├── repositories/
    │   │   └── todo_repository.dart
    │   ├── providers/
    │   │   ├── todo_list_provider.dart
    │   │   └── todo_filter_provider.dart
    │   ├── screens/
    │   │   └── todo_screen.dart
    │   └── widgets/
    │       ├── add_todo_field.dart
    │       ├── todo_tile.dart
    │       └── todo_toolbar.dart
    │
    └── ⚙️  app_config/                 # Simple Provider demo
        ├── providers/
        │   └── app_config_provider.dart
        └── screens/
            └── app_config_screen.dart
```

## 🔄 Provider Types Summary

```
┌─────────────────────────────────────────────────┐
│ PROVIDER TYPE           │ USED IN              │
├─────────────────────────────────────────────────┤
│ Provider<T>             │ app_config           │
│ NotifierProvider        │ counter, todos       │
│ FutureProvider          │ weather, fruits      │
│ StreamProvider          │ news                 │
│ AsyncNotifierProvider   │ products             │
└─────────────────────────────────────────────────┘
```
