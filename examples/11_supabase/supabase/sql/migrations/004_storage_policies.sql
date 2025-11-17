-- Storage Policies: Pet Images Bucket
-- Description: Creates RLS policies for the 'pets' storage bucket
-- Date: 2024-11-17
-- 
-- PREREQUISITES:
-- 1. Create 'pets' bucket in Supabase Dashboard (Storage section)
-- 2. Mark bucket as PUBLIC if you want public read access
-- 3. Run this script to set up access policies

-- =============================================================================
-- STORAGE BUCKET POLICIES
-- =============================================================================

-- Drop existing policies if they exist (for re-running this script)
DROP POLICY IF EXISTS "Public read access" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users manage pets images" ON storage.objects;

-- =============================================================================
-- DEVELOPMENT POLICIES (Permissive)
-- =============================================================================
-- Use these for development/testing - allows all authenticated users to manage images

-- Policy 1: Allow anyone to read/view images (public access)
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
USING (bucket_id = 'pets');

-- Policy 2: Allow authenticated users to Upload, Update, Delete images
CREATE POLICY "Authenticated users manage pets images"
ON storage.objects FOR ALL
USING (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
)
WITH CHECK (
  bucket_id = 'pets' 
  AND auth.role() = 'authenticated'
  AND (storage.foldername(name))[1] = 'images'  -- Only allow uploads to 'images/' folder
);

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================
-- Run these to verify policies are configured correctly:

/*
-- List all storage policies
SELECT * FROM pg_policies WHERE tablename = 'objects';

-- Test bucket configuration
SELECT * FROM storage.buckets WHERE name = 'pets';

-- List files in pets bucket (requires files to be uploaded first)
SELECT * FROM storage.objects WHERE bucket_id = 'pets';
*/

-- =============================================================================
-- NOTES
-- =============================================================================
-- 1. The bucket must be created manually in Supabase Dashboard first
-- 2. Mark bucket as PUBLIC for easier development
-- 3. Consider adding file size limits (5-10 MB recommended)
-- 4. Restrict MIME types to images only (jpeg, png, jpg)
-- 5. Implement automatic cleanup of orphaned images (images without pet records)

-- =============================================================================
-- FILE NAMING CONVENTION
-- =============================================================================
-- Format: images/pet_{petId}_{timestamp}.{extension}
-- Example: images/pet_123_1700000000000.jpg
-- 
-- This format allows:
-- - Easy identification of which pet the image belongs to
-- - Unique filenames (timestamp prevents collisions)
-- - Organized folder structure
-- - Simple cleanup when pets are deleted
