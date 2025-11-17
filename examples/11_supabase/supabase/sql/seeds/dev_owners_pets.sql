-- Seed Data: Development Owners and Pets
-- Description: Sample data for development and testing
-- Date: 2024-11-17
-- Environment: Development only

-- =============================================================================
-- WARNING: This will delete all existing data!
-- =============================================================================
-- Only run this in development/test environments
-- DO NOT run in production

-- Clear existing data and reset sequences
TRUNCATE TABLE pets RESTART IDENTITY CASCADE;
TRUNCATE TABLE owners RESTART IDENTITY CASCADE;

-- =============================================================================
-- INSERT SAMPLE OWNERS
-- =============================================================================
INSERT INTO owners (first_name, last_name) VALUES
  ('Fatima', 'Al-Kuwari'),
  ('Mohammed', 'Al-Sulaiti'),
  ('Aisha', 'Al-Mohannadi'),
  ('Ali', 'Al-Ansari'),
  ('Noura', 'Al-Dosari'),
  ('Khaled', 'Al-Marri');

-- =============================================================================
-- INSERT SAMPLE PETS
-- =============================================================================
INSERT INTO pets (name, owner_id) VALUES
  -- Fatima's pets (3 pets)
  ('Max', 1),
  ('Bella', 1),
  ('Luna', 1),
  
  -- Mohammed's pets (2 pets)
  ('Rocky', 2),
  ('Daisy', 2),
  
  -- Aisha's pet (1 pet)
  ('Buddy', 3),
  
  -- Ali's pets (2 pets)
  ('Shadow', 4),
  ('Whiskers', 4),
  
  -- Noura's pets (4 pets)
  ('Tiger', 5),
  ('Simba', 5),
  ('Leo', 5),
  ('Milo', 5);
  
  -- Khaled has no pets yet
  
-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================
-- Verify data was inserted correctly

-- Count owners and their pets
SELECT 
  o.id,
  o.first_name || ' ' || o.last_name as owner_name,
  COUNT(p.id) as pet_count,
  STRING_AGG(p.name, ', ' ORDER BY p.name) as pet_names
FROM owners o
LEFT JOIN pets p ON o.id = p.owner_id
GROUP BY o.id, o.first_name, o.last_name
ORDER BY o.last_name, o.first_name;

-- Total counts
SELECT 
  (SELECT COUNT(*) FROM owners) as total_owners,
  (SELECT COUNT(*) FROM pets) as total_pets,
  (SELECT COUNT(*) FROM owners WHERE id NOT IN (SELECT DISTINCT owner_id FROM pets)) as owners_without_pets;

-- Verify no orphaned pets (should return 0 rows)
SELECT * FROM pets WHERE owner_id NOT IN (SELECT id FROM owners);

-- =============================================================================
-- EXPECTED RESULTS
-- =============================================================================
-- Total owners: 6
-- Total pets: 13
-- Owners without pets: 1 (Khaled)
-- 
-- Distribution:
-- - Fatima Al-Kuwari: 3 pets
-- - Mohammed Al-Sulaiti: 2 pets
-- - Aisha Al-Mohannadi: 1 pet
-- - Ali Al-Ansari: 2 pets
-- - Noura Al-Dosari: 4 pets
-- - Khaled Al-Marri: 0 pets
