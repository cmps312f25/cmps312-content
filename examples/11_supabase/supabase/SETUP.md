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

Run the following SQL in your Supabase SQL Editor (Dashboard > SQL Editor):

```sql
-- Create owners table
CREATE TABLE owners (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

-- Create pets table
CREATE TABLE pets (
  id BIGSERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  owner_id BIGINT NOT NULL REFERENCES owners(id) ON DELETE CASCADE
);

-- Create todos table
CREATE TABLE todos (
  id TEXT PRIMARY KEY,
  description TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  type TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create a view for pets with owner names (optional, for convenience)
CREATE OR REPLACE VIEW pet_owner_view AS
SELECT 
  p.id as pet_id,
  p.name as pet_name,
  o.id as owner_id,
  o.name as owner_name
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

## Running the App

### Option 1: Using Command Line Arguments

```powershell
flutter run -d windows --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Replace:
- `https://your-project.supabase.co` with your Supabase project URL
- `your-anon-key` with your Supabase anon/public key
- `-d windows` with your target device (chrome, macos, linux, etc.)

### Option 2: Using Environment File (Recommended)

1. Create a file named `.env` in the project root (already in `.gitignore`)

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

2. Create a launch configuration in `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Supabase)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=SUPABASE_URL=${env:SUPABASE_URL}",
        "--dart-define=SUPABASE_ANON_KEY=${env:SUPABASE_ANON_KEY}"
      ]
    }
  ]
}
```

3. Run using VS Code's Run & Debug panel (F5)

### Option 3: Hard-code for Development (Not Recommended)

Modify `lib/main.dart` to use hard-coded values:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key',
  );

  runApp(const App());
}
```

**⚠️ Warning:** Never commit credentials to version control!

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

## Additional Resources

- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Flutter Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
