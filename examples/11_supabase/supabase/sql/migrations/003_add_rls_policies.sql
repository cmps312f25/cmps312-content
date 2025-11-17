-- Migration: Add Row Level Security Policies
-- Description: Enables RLS and creates permissive policies for development
-- Date: 2024-11-17
-- Author: CMPS312 Team
-- NOTE: Update these policies for production based on authentication requirements

-- =============================================================================
-- ENABLE ROW LEVEL SECURITY
-- =============================================================================
-- RLS ensures that users can only access data they're authorized to see
-- After enabling RLS, policies must be created to allow operations

ALTER TABLE owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE pets ENABLE ROW LEVEL SECURITY;
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- DEVELOPMENT POLICIES (PERMISSIVE)
-- =============================================================================
-- ⚠️ WARNING: These policies allow ALL operations for development/testing
-- For production, replace with user-specific policies based on auth.uid()

-- Drop existing policies if they exist (for re-running this migration)
DROP POLICY IF EXISTS "Allow all operations on owners" ON owners;
DROP POLICY IF EXISTS "Allow all operations on pets" ON pets;

-- OWNERS: Allow all operations
CREATE POLICY "Allow all operations on owners" 
ON owners 
FOR ALL 
USING (true) 
WITH CHECK (true);

-- PETS: Allow all operations
CREATE POLICY "Allow all operations on pets" 
ON pets 
FOR ALL 
USING (true) 
WITH CHECK (true);

-- =============================================================================
-- PET_OWNER_VIEW ACCESS
-- =============================================================================
-- Note: Views inherit RLS policies from their underlying tables
-- Since owners and pets have "Allow all operations" policies,
-- the pet_owner_view is automatically accessible.


/*-- TODOS: Allow all operations
CREATE POLICY "Allow all operations on todos" 
ON todos 
FOR ALL 
USING (true) 
WITH CHECK (true); */

-- =============================================================================
-- TODOS RLS POLICIES
-- =============================================================================
-- Allow users to perform all operations on their own todos
DROP POLICY IF EXISTS "Users can manage own todos" ON todos;
CREATE POLICY "Users can manage own todos" 
ON todos 
to authenticated
FOR ALL 
USING (auth.uid() = created_by)
WITH CHECK (auth.uid() = created_by);

-- =============================================================================
-- OWNERS RLS POLICIES
-- Uncomment and adapt these policies to explore RLS with authentication
-- =============================================================================
/*
-- Allow users to view only their own owner record
DROP POLICY IF EXISTS "Users can view own owners" ON owners;
CREATE POLICY "Users can view own owners" 
ON owners 
FOR SELECT 
USING (auth.uid() = user_id);

-- Allow users to insert their own owner record
DROP POLICY IF EXISTS "Users can insert own owners" ON owners;
CREATE POLICY "Users can insert own owners" 
ON owners 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Allow users to update only their own owner record
DROP POLICY IF EXISTS "Users can update own owners" ON owners;
CREATE POLICY "Users can update own owners" 
ON owners 
FOR UPDATE 
USING (auth.uid() = user_id) 
WITH CHECK (auth.uid() = user_id);

-- Allow users to delete only their own owner record
DROP POLICY IF EXISTS "Users can delete own owners" ON owners;
CREATE POLICY "Users can delete own owners" 
ON owners 
FOR DELETE 
USING (auth.uid() = user_id);
*/
-- =============================================================================
-- PETS RLS POLICIES
-- =============================================================================
/*
-- Allow users to view pets belonging to their owners
DROP POLICY IF EXISTS "Users can view own pets" ON pets;
CREATE POLICY "Users can view own pets" 
ON pets 
FOR SELECT 
USING (
  owner_id IN (
    SELECT id FROM owners WHERE user_id = auth.uid()
  )
);

-- Allow users to insert pets for their owners
DROP POLICY IF EXISTS "Users can insert own pets" ON pets;
CREATE POLICY "Users can insert own pets" 
ON pets 
FOR INSERT 
WITH CHECK (
  owner_id IN (
    SELECT id FROM owners WHERE user_id = auth.uid()
  )
);

-- Allow users to update pets belonging to their owners
DROP POLICY IF EXISTS "Users can update own pets" ON pets;
CREATE POLICY "Users can update own pets" 
ON pets 
FOR UPDATE 
USING (
  owner_id IN (
    SELECT id FROM owners WHERE user_id = auth.uid()
  )
) 
WITH CHECK (
  owner_id IN (
    SELECT id FROM owners WHERE user_id = auth.uid()
  )
);

-- Allow users to delete pets belonging to their owners
DROP POLICY IF EXISTS "Users can delete own pets" ON pets;
CREATE POLICY "Users can delete own pets" 
ON pets 
FOR DELETE 
USING (
  owner_id IN (
    SELECT id FROM owners WHERE user_id = auth.uid()
  )
);
*/
-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================
-- Run these to verify RLS and policies are configured correctly:
/*
-- Check if RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('owners', 'pets', 'todos');

-- List all policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
*/