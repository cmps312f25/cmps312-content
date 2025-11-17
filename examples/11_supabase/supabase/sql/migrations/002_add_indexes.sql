-- Migration: Add Performance Indexes
-- Description: Creates indexes for common queries to improve performance
-- Date: 2024-11-17

-- =============================================================================
-- PETS TABLE INDEXES
-- =============================================================================

-- Index for pets by owner (frequent join/filter operation)
-- Used when: Loading pets for a specific owner
CREATE INDEX IF NOT EXISTS idx_pets_owner_id 
ON pets(owner_id);

-- =============================================================================
-- TODOS TABLE INDEXES
-- =============================================================================

-- Index for filtering by completion status
-- Used when: Filtering active vs completed todos
CREATE INDEX IF NOT EXISTS idx_todos_completed 
ON todos(completed);

-- Index for filtering by type
-- Used when: Showing Personal/Work/Family todos
CREATE INDEX IF NOT EXISTS idx_todos_type 
ON todos(type);

-- Composite index for common todo queries (status + type)
-- Used when: Filtering by both completion and type simultaneously
CREATE INDEX IF NOT EXISTS idx_todos_status_type 
ON todos(completed, type);

-- Index for filtering by user (created_by)
-- Used when: Loading todos for a specific authenticated user
CREATE INDEX IF NOT EXISTS idx_todos_created_by 
ON todos(created_by);

-- Composite index for user + status filtering
-- Used when: Filtering user's todos by completion status
CREATE INDEX IF NOT EXISTS idx_todos_user_status 
ON todos(created_by, completed);


-- =============================================================================
-- PERFORMANCE NOTES
-- =============================================================================
-- 1. Indexes speed up SELECT queries but slow down INSERT/UPDATE/DELETE
-- 2. Drop unused indexes to improve write performance