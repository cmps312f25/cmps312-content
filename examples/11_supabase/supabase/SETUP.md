# Supabase Flutter App Setup Guide

This Flutter application demonstrates data persistence using Supabase instead of local SQLite/Floor database.

## Prerequisites

- Flutter SDK (3.9.2 or higher)
- A Supabase account and project ([supabase.com](https://supabase.com))

## Supabase Setup

### 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Fill in project details and wait for setup to complete
4. Note your project URL and anon (public) key from Project Settings > API

### 2. Create Database Tables

You have two options for setting up the database:

#### Option A: Using Migration Files (Recommended)

Run the migration files in sequence from the `sql/migrations/` directory in your Supabase SQL Editor:

1. **Initial Schema** - Creates all tables and views
   ```sql
   -- Copy and run: sql/migrations/001_initial_schema.sql
   ```

2. **Add Indexes** - Improves query performance
   ```sql
   -- Copy and run: sql/migrations/002_add_indexes.sql
   ```

3. **Add RLS Policies** - Enables Row Level Security
   ```sql
   -- Copy and run: sql/migrations/003_add_rls_policies.sql
   ```

4. **Load Test Data** (Optional, for development)
   ```sql
   -- Copy and run: sql/seeds/dev_owners.sql
   -- Copy and run: sql/seeds/dev_todos.sql
   ```

> 💡 **Pro Tip**: The migration files in `sql/` directory are version-controlled, well-documented, and include additional features like indexes and detailed comments.

#### Option B: Quick Setup (All-in-One)

If you prefer a single script, run the following SQL in your Supabase SQL Editor (Dashboard > SQL Editor):

```sql
-- Create owners table
CREATE TABLE if not exists owners (
  -- auto-generates the ID via SERIAL
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL
);

-- Create pets table
CREATE TABLE if not exists pets (
  -- auto-generates the ID via SERIAL
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  owner_id INTEGER NOT NULL REFERENCES owners(id) ON DELETE CASCADE
);

-- Create todos table
CREATE TABLE if not exists todos (
  -- auto-generates the ID via SERIAL
  id SERIAL PRIMARY KEY,
  description TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  type VARCHAR(50) NOT NULL,
  created_by UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create a view for pets with owner names (optional, for convenience)
CREATE OR REPLACE VIEW pet_owner_view AS
SELECT 
  p.id as pet_id,
  p.name as pet_name,
  o.id as owner_id,
  o.first_name as owner_first_name,
  o.last_name as owner_last_name
FROM pets p
JOIN owners o ON p.owner_id = o.id;

-- Enable Row Level Security (RLS) - for production
ALTER TABLE owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE pets ENABLE ROW LEVEL SECURITY;
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- Create policies to allow all operations (for development)
-- NOTE: For production, create more restrictive policies based on auth
CREATE POLICY "Allow all operations on owners" ON owners FOR ALL USING (true);
CREATE POLICY "Allow all operations on pets" ON pets FOR ALL USING (true);
CREATE POLICY "Allow all operations on todos" ON todos FOR ALL USING (true);
```

> ⚠️ **Note**: This quick setup is suitable for getting started quickly. For production or team environments, use Option A (migration files) for better version control and documentation.

## Running the App

### Option 1: Using Configuration File (Recommended for Development)

This approach stores your credentials in a Dart configuration file, making it easy to run without command-line arguments.

1. Create a file `lib/config/supabase_config.dart`:

```dart
/// Supabase configuration
/// ⚠️ WARNING: This file contains sensitive credentials.
/// - Add this file to .gitignore before committing
/// - Never commit this file to version control
/// - For production, use environment variables or secure storage
class SupabaseConfig {
  static const String url = 'https://your-project.supabase.co';
  static const String anonKey = 'your-anon-key';
}
```

2. Add the config file to `.gitignore`:

```gitignore
# Supabase credentials
lib/config/supabase_config.dart
```

3. Update `lib/main.dart` to use the config:

```dart
import 'package:supabase_app/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  runApp(const App());
}
```

4. Create a template file `lib/config/supabase_config.template.dart` to commit to version control:

```dart
/// Supabase configuration template
/// Copy this file to supabase_config.dart and fill in your credentials
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL_HERE';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
}
```

5. Simply run: `flutter run -d chrome` (or any device)

**Pros:**
- ✅ No command-line arguments needed
- ✅ Easy to switch between projects
- ✅ Works with all IDEs and command line
- ✅ Fast iteration during development

**Cons:**
- ⚠️ Must ensure file is in .gitignore
- ⚠️ Not suitable for production builds

---

### Option 2: Using dart-define-from-file (Recommended for Teams)

Flutter 3.7+ supports loading dart-define values from a JSON file.

1. Create `dart_defines.json` in project root:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key"
}
```

2. Add to `.gitignore`:

```gitignore
dart_defines.json
```

3. Create a template `dart_defines.template.json`:

```json
{
  "SUPABASE_URL": "YOUR_SUPABASE_URL_HERE",
  "SUPABASE_ANON_KEY": "YOUR_SUPABASE_ANON_KEY_HERE"
}
```

4. Update `lib/main.dart`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw StateError('Missing SUPABASE_URL or SUPABASE_ANON_KEY');
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const App());
}
```

5. Run with: `flutter run -d chrome --dart-define-from-file=dart_defines.json`

6. (Optional) Add to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Supabase)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "toolArgs": ["--dart-define-from-file=dart_defines.json"]
    }
  ]
}
```

**Pros:**
- ✅ Secure (file not committed)
- ✅ Team-friendly (template shows required keys)
- ✅ Supports multiple environments (dev, staging, prod)
- ✅ Works with CI/CD

---

### Option 3: Using Command Line Arguments

For quick testing or CI/CD pipelines:

```powershell
flutter run -d chrome `
  --dart-define=SUPABASE_URL=https://your-project.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Replace:
- `https://your-project.supabase.co` with your Supabase project URL
- `your-anon-key` with your Supabase anon/public key
- `-d chrome` with your target device (windows, macos, linux, etc.)

---
**⚠️ Warning:** Never commit credentials directly in code!

## Features

### Todos Feature
- Create, update, delete todos
- Filter by status (All, Active, Completed)
- Filter by type (Personal, Work, Family)
- Search by description
- Real-time updates via Supabase

### Pets Feature
- Manage pet owners
- Manage pets per owner
- View pets with their owners
- Cascading delete (deleting owner removes their pets)

## Project Structure

```
lib/
├── app/
│   ├── main_scaffold.dart       # App shell with bottom navigation
│   ├── router.dart               # GoRouter configuration
│   └── providers/
│       └── database_provider.dart # Supabase client provider
├── features/
│   ├── pets/
│   │   ├── daos/                 # Data access objects (Supabase queries)
│   │   ├── models/               # Data models with JSON serialization
│   │   ├── providers/            # Riverpod providers
│   │   ├── repositories/         # Business logic layer
│   │   ├── screens/              # UI screens
│   │   └── widgets/              # Reusable widgets
│   └── todos/
│       └── (same structure)
└── main.dart                     # App entry point
```

## Key Differences from Floor/SQLite

1. **Cloud Database**: Data is stored in Supabase cloud instead of local SQLite
2. **Real-time Updates**: Supabase supports real-time subscriptions (see `TodoDao.observeTodos()`)
3. **No Code Generation**: No need for `build_runner` or `@dao`/`@entity` annotations
4. **JSON Serialization**: Models use `fromJson`/`toJson` instead of Floor's type converters
5. **SQL Views**: Database views (like `pet_owner_view`) are created in Supabase dashboard
6. **Authentication Ready**: Easy to add Supabase Auth when needed

## Troubleshooting

### "Supabase not configured" Error
Ensure you're passing `SUPABASE_URL` and `SUPABASE_ANON_KEY` via `--dart-define` flags.

### Connection Errors
- Check your internet connection
- Verify your Supabase project URL and anon key
- Ensure your Supabase project is active (not paused)

### Table Not Found Errors
Run the SQL setup script in your Supabase SQL Editor to create all required tables and views.

### RLS Policy Errors
If you see permission errors, check that RLS policies are properly configured in Supabase.
