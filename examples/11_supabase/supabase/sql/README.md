# SQL Queries Documentation

This directory contains all SQL queries used in the Supabase Flutter app.

## Directory Structure

### 📁 migrations/
Sequential database schema changes. Run in order to set up or update the database.

- `001_initial_schema.sql` - Creates tables (owners, pets, todos)
- `002_add_indexes.sql` - Performance indexes
- `003_add_rls_policies.sql` - Row Level Security policies

### 📁 seeds/
Test data for development and testing environments.

- `dev_owners.sql` - Sample owners and pets
- `dev_todos.sql` - Sample todo items

### 📁 queries/
Reusable SQL queries organized by feature.

- `pets/` - Pet and owner related queries
- `todos/` - Todo related queries

## Usage

### Initial Setup
Run migrations in sequence in Supabase SQL Editor:

1. Copy and run `sql/migrations/001_initial_schema.sql`
2. Copy and run `sql/migrations/002_add_indexes.sql`
3. Copy and run `sql/migrations/003_add_rls_policies.sql`

### Load Test Data
```sql
-- Copy and run in Supabase SQL Editor
-- sql/seeds/dev_owners.sql
-- sql/seeds/dev_todos.sql
```

### Reference Queries
Copy and adapt queries from `sql/queries/` for use in your Dart repositories.

## Naming Conventions

- **Migration files**: `{number}_{description}.sql` (e.g., `001_initial_schema.sql`)
- **Seed files**: `{env}_{entity}.sql` (e.g., `dev_owners.sql`)
- **Query files**: `{action}_{entity}.sql` (e.g., `select_active_todos.sql`)

## Best Practices

1. ✅ Always test migrations in development first
2. ✅ Keep migrations idempotent (use `IF NOT EXISTS`, `IF EXISTS`)
3. ✅ Document complex queries with comments
4. ✅ Version control all SQL files
5. ✅ Never commit production credentials or data
6. ✅ Run migrations in sequence (001, 002, 003...)
7. ✅ Use DROP POLICY IF EXISTS before CREATE POLICY to avoid conflicts

## Integration with Dart/Flutter

The queries in this directory serve as:
- **Documentation**: Reference for what SQL is actually executed
- **Testing**: Use in integration tests
- **Optimization**: Tune queries before implementing in Dart
- **Collaboration**: Share SQL knowledge across team

## Migration to Supabase CLI (Future)

When ready to use Supabase CLI migrations:

```bash
# Initialize migrations
supabase init

# Create new migration
supabase migration new migration_name

# Apply migrations
supabase db push
```

Move files from `sql/migrations/` to `supabase/migrations/` directory.
