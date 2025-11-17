-- Seed Data: Development Todos
-- Description: Sample todo items for development and testing
-- Date: 2024-11-17
-- Environment: Development only

-- =============================================================================
-- WARNING: This will delete all existing todos!
-- =============================================================================
-- Only run this in development/test environments
-- DO NOT run in production

-- Clear existing data and reset sequence
TRUNCATE TABLE todos RESTART IDENTITY CASCADE;

-- =============================================================================
-- INSERT SAMPLE TODOS
-- =============================================================================
-- NOTE: Replace the user_id with an actual user ID from auth.users table
-- To get your user ID after signing up: SELECT id, email FROM auth.users;

DO $$
DECLARE
  -- Initialize the user ID variable - replace with actual user ID
  created_by UUID := '5356e1b9-87f1-491a-b49f-c5cf8779d77d';
BEGIN

-- Personal todos (mix of completed and active)
INSERT INTO todos (description, completed, type, created_by, created_at) VALUES
  ('Buy groceries', false, 'Personal', created_by, NOW() - INTERVAL '2 hours'),
  ('Call dentist for appointment', false, 'Personal', created_by, NOW() - INTERVAL '5 hours'),
  ('Finish reading "Atomic Habits"', true, 'Personal', created_by, NOW() - INTERVAL '1 day'),
  ('Exercise for 30 minutes', false, 'Personal', created_by, NOW() - INTERVAL '3 hours'),
  ('Water plants', true, 'Personal', created_by, NOW() - INTERVAL '2 days'),
  ('Organize closet', false, 'Personal', created_by, NOW() - INTERVAL '1 hour'),
  ('Pay utility bills', false, 'Personal', created_by, NOW() - INTERVAL '6 hours'),
  ('Schedule car maintenance', true, 'Personal', created_by, NOW() - INTERVAL '3 days');

-- Work todos (mostly active)
INSERT INTO todos (description, completed, type, created_by, created_at) VALUES
  ('Review pull requests', false, 'Work', created_by, NOW() - INTERVAL '1 hour'),
  ('Attend team meeting at 2 PM', true, 'Work', created_by, NOW() - INTERVAL '4 hours'),
  ('Update project documentation', false, 'Work', created_by, NOW() - INTERVAL '2 hours'),
  ('Fix bug #123 in authentication', false, 'Work', created_by, NOW() - INTERVAL '30 minutes'),
  ('Deploy to staging environment', true, 'Work', created_by, NOW() - INTERVAL '1 day'),
  ('Prepare presentation for client', false, 'Work', created_by, NOW() - INTERVAL '5 hours'),
  ('Code review for new feature', false, 'Work', created_by, NOW() - INTERVAL '3 hours'),
  ('Write unit tests for API', true, 'Work', created_by, NOW() - INTERVAL '2 days'),
  ('Update dependencies to latest versions', false, 'Work', created_by, NOW() - INTERVAL '4 hours'),
  ('Optimize database queries', false, 'Work', created_by, NOW() - INTERVAL '6 hours');

-- Family todos (various)
INSERT INTO todos (description, completed, type, created_by, created_at) VALUES
  ('Plan weekend visit to Umrah', false, 'Family', created_by, NOW() - INTERVAL '3 hours'),
  ('Schedule family dinner next weekend', false, 'Family', created_by, NOW() - INTERVAL '2 hours'),
  ('Help kids with homework', true, 'Family', created_by, NOW() - INTERVAL '1 day'),
  ('Book vacation tickets for summer', false, 'Family', created_by, NOW() - INTERVAL '5 hours'),
  ('Buy a gift for mom', false, 'Family', created_by, NOW() - INTERVAL '4 hours'),
  ('Call beloved grandparents', true, 'Family', created_by, NOW() - INTERVAL '2 days'),
  ('Arrange play date for kids', false, 'Family', created_by, NOW() - INTERVAL '1 hour');

END $$;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================
-- Verify data was inserted correctly

-- Summary by type and status
SELECT 
  type,
  COUNT(*) as total,
  SUM(CASE WHEN completed THEN 1 ELSE 0 END) as completed_count,
  SUM(CASE WHEN NOT completed THEN 1 ELSE 0 END) as active_count,
  ROUND(100.0 * SUM(CASE WHEN completed THEN 1 ELSE 0 END) / COUNT(*), 1) as completion_percentage
FROM todos
GROUP BY type
ORDER BY type;

-- Summary by user (created_by)
SELECT 
  created_by,
  COUNT(*) as total_todos,
  SUM(CASE WHEN completed THEN 1 ELSE 0 END) as completed_count,
  SUM(CASE WHEN NOT completed THEN 1 ELSE 0 END) as active_count
FROM todos
GROUP BY created_by
ORDER BY created_by;

-- Total counts
SELECT 
  COUNT(*) as total_todos,
  SUM(CASE WHEN completed THEN 1 ELSE 0 END) as total_completed,
  SUM(CASE WHEN NOT completed THEN 1 ELSE 0 END) as total_active
FROM todos;

-- Most recent todos by type
SELECT 
  type,
  description,
  completed,
  created_at
FROM todos
WHERE created_at > NOW() - INTERVAL '1 day'
ORDER BY type, created_at DESC;

-- Todos created today
SELECT 
  COUNT(*) as todos_today,
  SUM(CASE WHEN completed THEN 1 ELSE 0 END) as completed_today
FROM todos
WHERE created_at::date = CURRENT_DATE;

-- =============================================================================
-- EXPECTED RESULTS
-- =============================================================================
-- Total todos: 25
-- All todos assigned to: 00000000-0000-0000-0000-000000000001
-- 
-- Distribution by type:
-- - Personal: 8 todos (3 completed, 5 active)
-- - Work: 10 todos (3 completed, 7 active)
-- - Family: 7 todos (2 completed, 5 active)
--
-- Overall completion rate: ~32% (8 out of 25)
--
-- NOTE: Update the 'created_by' variable in the DO block above with your 
-- actual user ID from auth.users table before running this seed.
-- To get user ID: SELECT id, email FROM auth.users;
