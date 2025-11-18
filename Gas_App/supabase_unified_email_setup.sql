-- Unified Email Collection System for Multiple Projects
-- Run this SQL in your Supabase SQL Editor

-- ============================================
-- 1. Projects Table - Define all your mobile projects here
-- ============================================
CREATE TABLE IF NOT EXISTS projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_key TEXT NOT NULL UNIQUE, -- e.g., 'gas-tracker', 'price-analysis'
    project_name TEXT NOT NULL, -- e.g., 'Gas Tracker', 'PriceAnalysis'
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 2. Beta Testers Table - Linked to Projects
-- ============================================
CREATE TABLE IF NOT EXISTS beta_testers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT NOT NULL UNIQUE, -- One email = one project at a time
    name TEXT,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    signup_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    source TEXT DEFAULT 'website',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 3. Release Notifications Table - Linked to Projects
-- ============================================
CREATE TABLE IF NOT EXISTS release_notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT NOT NULL UNIQUE, -- One email = one project at a time
    name TEXT,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    signup_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    source TEXT DEFAULT 'website',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 4. Enable Row Level Security (RLS)
-- ============================================
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE beta_testers ENABLE ROW LEVEL SECURITY;
ALTER TABLE release_notifications ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 5. Drop existing policies (if any) and create new ones
-- ============================================
-- Drop existing policies for projects
DROP POLICY IF EXISTS "Allow authenticated all for projects" ON projects;
DROP POLICY IF EXISTS "Allow public read for projects" ON projects;

-- Drop existing policies for beta_testers
DROP POLICY IF EXISTS "Allow public inserts for beta_testers" ON beta_testers;
DROP POLICY IF EXISTS "Allow public updates for beta_testers" ON beta_testers;
DROP POLICY IF EXISTS "Allow authenticated selects for beta_testers" ON beta_testers;

-- Drop existing policies for release_notifications
DROP POLICY IF EXISTS "Allow public inserts for release_notifications" ON release_notifications;
DROP POLICY IF EXISTS "Allow public updates for release_notifications" ON release_notifications;
DROP POLICY IF EXISTS "Allow authenticated selects for release_notifications" ON release_notifications;

-- ============================================
-- 6. RLS Policies for Projects
-- ============================================
CREATE POLICY "Allow authenticated all for projects"
    ON projects
    FOR ALL
    TO authenticated
    USING (true);

-- Allow public to read projects (needed for RPC functions)
CREATE POLICY "Allow public read for projects"
    ON projects
    FOR SELECT
    TO anon, authenticated
    USING (true);

-- ============================================
-- 7. RLS Policies: Allow public inserts for email tables
-- ============================================
CREATE POLICY "Allow public inserts for beta_testers"
    ON beta_testers
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

CREATE POLICY "Allow public inserts for release_notifications"
    ON release_notifications
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

-- Allow public updates (for switching projects)
CREATE POLICY "Allow public updates for beta_testers"
    ON beta_testers
    FOR UPDATE
    TO anon, authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow public updates for release_notifications"
    ON release_notifications
    FOR UPDATE
    TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- ============================================
-- 8. RLS Policies: Only authenticated users can SELECT
-- ============================================
CREATE POLICY "Allow authenticated selects for beta_testers"
    ON beta_testers
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Allow authenticated selects for release_notifications"
    ON release_notifications
    FOR SELECT
    TO authenticated
    USING (true);

-- ============================================
-- 9. RPC Functions (these handle the upsert logic)
-- ============================================
-- RPC Function: Upsert Beta Tester
CREATE OR REPLACE FUNCTION upsert_beta_tester(
    p_email TEXT,
    p_name TEXT,
    p_project_key TEXT,
    p_source TEXT DEFAULT 'website'
)
RETURNS UUID 
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    v_project_id UUID;
    v_tester_id UUID;
BEGIN
    -- Get project ID
    SELECT id INTO v_project_id 
    FROM projects 
    WHERE project_key = p_project_key;
    
    IF v_project_id IS NULL THEN
        RAISE EXCEPTION 'Project not found: %', p_project_key;
    END IF;
    
    -- Check if email exists
    SELECT id INTO v_tester_id 
    FROM beta_testers 
    WHERE email = p_email;
    
    IF v_tester_id IS NOT NULL THEN
        -- Update existing email to new project
        UPDATE beta_testers 
        SET project_id = v_project_id,
            name = COALESCE(p_name, name),
            updated_at = NOW()
        WHERE id = v_tester_id;
        RETURN v_tester_id;
    ELSE
        -- Insert new email
        INSERT INTO beta_testers (email, name, project_id, source)
        VALUES (p_email, p_name, v_project_id, p_source)
        RETURNING id INTO v_tester_id;
        RETURN v_tester_id;
    END IF;
END;
$$;

-- RPC Function: Upsert Release Notification
CREATE OR REPLACE FUNCTION upsert_release_notification(
    p_email TEXT,
    p_name TEXT,
    p_project_key TEXT,
    p_source TEXT DEFAULT 'website'
)
RETURNS UUID 
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
DECLARE
    v_project_id UUID;
    v_notification_id UUID;
BEGIN
    -- Get project ID
    SELECT id INTO v_project_id 
    FROM projects 
    WHERE project_key = p_project_key;
    
    IF v_project_id IS NULL THEN
        RAISE EXCEPTION 'Project not found: %', p_project_key;
    END IF;
    
    -- Check if email exists
    SELECT id INTO v_notification_id 
    FROM release_notifications 
    WHERE email = p_email;
    
    IF v_notification_id IS NOT NULL THEN
        -- Update existing email to new project
        UPDATE release_notifications 
        SET project_id = v_project_id,
            name = COALESCE(p_name, name),
            updated_at = NOW()
        WHERE id = v_notification_id;
        RETURN v_notification_id;
    ELSE
        -- Insert new email
        INSERT INTO release_notifications (email, name, project_id, source)
        VALUES (p_email, p_name, v_project_id, p_source)
        RETURNING id INTO v_notification_id;
        RETURN v_notification_id;
    END IF;
END;
$$;

-- ============================================
-- 11. Create Indexes for Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_beta_testers_email ON beta_testers(email);
CREATE INDEX IF NOT EXISTS idx_beta_testers_project_id ON beta_testers(project_id);
CREATE INDEX IF NOT EXISTS idx_release_notifications_email ON release_notifications(email);
CREATE INDEX IF NOT EXISTS idx_release_notifications_project_id ON release_notifications(project_id);
CREATE INDEX IF NOT EXISTS idx_projects_project_key ON projects(project_key);

-- ============================================
-- 12. Insert Your Projects (if they don't exist)
-- ============================================
INSERT INTO projects (project_key, project_name, description) VALUES
    ('gas-tracker', 'Gas Tracker', 'Fuel expense tracking app for iOS & Android'),
    ('price-analysis', 'PriceAnalysis', 'PriceSmart product price tracking app')
ON CONFLICT (project_key) DO NOTHING;

-- ============================================
-- 13. Add Comments
-- ============================================
COMMENT ON TABLE projects IS 'Defines all mobile app projects';
COMMENT ON TABLE beta_testers IS 'Beta testers linked to specific projects. One email = one project at a time.';
COMMENT ON TABLE release_notifications IS 'Release notifications linked to specific projects. One email = one project at a time.';

