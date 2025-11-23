-- Migration: Enable Realtime
-- Description: Enables realtime replication for todos table
-- Date: 2024-11-18

-- =============================================================================
-- ENABLE REALTIME FOR TODOS TABLE
-- =============================================================================
-- This enables the Realtime feature for the todos table.
-- Without this, the RealtimeChannel will not receive events when rows change.

-- Enable realtime publication for todos table
ALTER PUBLICATION supabase_realtime ADD TABLE todos;

-- Verify realtime is enabled (optional - for debugging)
-- You can check this in the Supabase dashboard under Database > Replication
-- or run: SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';
