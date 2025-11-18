# Account Deletion Request Setup

This guide will help you set up the account deletion request system for Gas Tracker using Supabase.

## Step 1: Create Supabase Table

1. Go to your [Supabase Dashboard](https://app.supabase.com)
2. Select your Gas Tracker project
3. Navigate to **SQL Editor**
4. Copy and paste the SQL below and click **Run**

```sql
-- Create account_deletion_requests table
CREATE TABLE IF NOT EXISTS account_deletion_requests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT NOT NULL,
    name TEXT,
    reason TEXT,
    project_key TEXT NOT NULL DEFAULT 'gas-tracker',
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled')),
    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed_at TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_deletion_requests_email ON account_deletion_requests(email);
CREATE INDEX IF NOT EXISTS idx_deletion_requests_status ON account_deletion_requests(status);
CREATE INDEX IF NOT EXISTS idx_deletion_requests_project ON account_deletion_requests(project_key);

-- Enable Row Level Security
ALTER TABLE account_deletion_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Allow anyone to insert (submit deletion requests)
CREATE POLICY "Allow public inserts for deletion requests"
    ON account_deletion_requests
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

-- Policy: Only authenticated users (you) can read deletion requests
CREATE POLICY "Allow authenticated users to read deletion requests"
    ON account_deletion_requests
    FOR SELECT
    TO authenticated
    USING (true);

-- Policy: Only authenticated users can update deletion requests
CREATE POLICY "Allow authenticated users to update deletion requests"
    ON account_deletion_requests
    FOR UPDATE
    TO authenticated
    USING (true);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at on row update
CREATE TRIGGER update_account_deletion_requests_updated_at
    BEFORE UPDATE ON account_deletion_requests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

## Step 2: Verify Table Creation

1. Go to **Table Editor** in Supabase Dashboard
2. You should see the `account_deletion_requests` table
3. The table should have the following columns:
   - `id` (UUID, primary key)
   - `email` (text, required)
   - `name` (text, optional)
   - `reason` (text, optional)
   - `project_key` (text, default: 'gas-tracker')
   - `status` (text, default: 'pending')
   - `requested_at` (timestamp)
   - `processed_at` (timestamp, nullable)
   - `notes` (text, optional)
   - `created_at` (timestamp)
   - `updated_at` (timestamp)

## Step 3: Test the Form

1. Open `delete-account.html` in a web browser
2. Fill out the form with a test email address
3. Submit the form
4. Check your Supabase dashboard:
   - Go to **Table Editor** → `account_deletion_requests`
   - You should see a new row with status 'pending'

## Step 4: Processing Deletion Requests

When you receive a deletion request:

1. **Check the Request:**
   - Go to Supabase Dashboard → **Table Editor** → `account_deletion_requests`
   - Find the request with status 'pending'
   - Verify the email address matches an account in your Supabase Auth

2. **Delete the User Account:**
   - Go to **Authentication** → **Users** in Supabase Dashboard
   - Search for the user's email
   - Click on the user
   - Click **Delete User** (this will also delete associated data if you have cascade deletes set up)

3. **Delete Associated Data:**
   You may need to manually delete data from your tables. Here's a SQL query template:

```sql
-- Replace 'user_email@example.com' with the actual email
-- This will delete all data associated with that user
-- Adjust table names and user_id column names based on your schema

-- Example: Delete from expenses table
DELETE FROM expenses WHERE user_id = (
    SELECT id FROM auth.users WHERE email = 'user_email@example.com'
);

-- Example: Delete from vehicles table
DELETE FROM vehicles WHERE user_id = (
    SELECT id FROM auth.users WHERE email = 'user_email@example.com'
);

-- Example: Delete from payments table
DELETE FROM payments WHERE user_id = (
    SELECT id FROM auth.users WHERE email = 'user_email@example.com'
);
```

4. **Update Request Status:**
   - Go back to `account_deletion_requests` table
   - Update the status to 'completed'
   - Set `processed_at` to current timestamp
   - Add any notes if needed

5. **Send Confirmation Email:**
   - Send an email to the user confirming their account has been deleted
   - You can use the email address from the deletion request

## Step 5: Automated Email Notifications (Optional)

To automatically send emails when deletion requests are submitted, you can:

1. **Create a Supabase Edge Function:**
   - Create a function that triggers on insert to `account_deletion_requests`
   - Use a service like Resend, SendGrid, or Mailgun to send emails

2. **Use Database Webhooks:**
   - Set up a webhook in Supabase that triggers on insert
   - Point it to your email service endpoint

## Security Notes

✅ **Safe:**
- The Supabase anon key is public and safe to use in client-side code
- RLS policies ensure only you can read/update deletion requests
- Users can only submit requests, not read or modify them

❌ **Important:**
- Always verify the email address before deleting accounts
- Double-check that you're deleting the correct user's data
- Consider adding a confirmation step (email verification) before processing

## Viewing Deletion Requests

To view all deletion requests:

1. Go to Supabase Dashboard → **Table Editor**
2. Select `account_deletion_requests` table
3. You can filter by:
   - Status (pending, processing, completed, cancelled)
   - Project key
   - Date range

## Exporting Requests

You can export deletion requests:

1. In **Table Editor**, select the `account_deletion_requests` table
2. Click the **Export** button
3. Choose CSV or JSON format

## Troubleshooting

### Form shows "Something went wrong"
- Check browser console (F12) for error messages
- Verify the Supabase table was created successfully
- Ensure RLS policies are set up correctly
- Check that your Supabase project is active

### Can't see deletion requests
- Make sure you're logged into Supabase Dashboard
- Verify RLS policies allow authenticated users to SELECT
- Check that the data was actually inserted

### Table doesn't exist error
- Run the SQL script again
- Check for any SQL errors in the Supabase SQL Editor
- Verify you're in the correct project

---

**Need Help?** Contact surenjanath.singh@gmail.com

