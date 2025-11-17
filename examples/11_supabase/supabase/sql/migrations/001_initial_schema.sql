-- Migration: Initial Schema
-- Description: Creates owners, pets, and todos tables
-- Date: 2024-11-17

-- =============================================================================
-- OWNERS TABLE
-- =============================================================================
-- Stores pet owners information
CREATE TABLE IF NOT EXISTS owners (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- PETS TABLE
-- =============================================================================
-- Stores pets belonging to owners
CREATE TABLE IF NOT EXISTS pets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  -- Foreign key to owners table with cascade delete
  owner_id INTEGER NOT NULL REFERENCES owners(id) ON DELETE CASCADE,
  image_path VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- TODOS TABLE
-- =============================================================================
-- Stores user todo items
CREATE TABLE IF NOT EXISTS todos (
  id SERIAL PRIMARY KEY,
  description TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  type VARCHAR(50) NOT NULL CHECK (type IN ('Personal', 'Work', 'Family')),
  -- UUID of the user who created this todo (references auth.users)
  created_by UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  -- Timestamp when todo was created
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =============================================================================
-- VIEWS
-- =============================================================================
-- This simplifies queries of pets with owner information in the application layer
CREATE OR REPLACE VIEW pet_owner_view AS
SELECT 
  p.id as pet_id,
  p.name as pet_name,
  p.image_path as pet_image_path,
  p.created_at as pet_created_at,
  o.id as owner_id,
  o.first_name as owner_first_name,
  o.last_name as owner_last_name,
  o.created_at as owner_created_at
FROM pets p
INNER JOIN owners o ON p.owner_id = o.id;