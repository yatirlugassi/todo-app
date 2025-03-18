-- Create tasks table if it doesn't exist
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  is_completed BOOLEAN DEFAULT FALSE,
  priority TEXT CHECK (priority IN ('low', 'medium', 'high')),
  due_date TIMESTAMP WITH TIME ZONE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Create policy for users to see only their tasks
CREATE POLICY "Users can view their own tasks" 
  ON tasks
  FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy for users to insert their own tasks
CREATE POLICY "Users can insert their own tasks" 
  ON tasks
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy for users to update their own tasks
CREATE POLICY "Users can update their own tasks" 
  ON tasks
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Create policy for users to delete their own tasks
CREATE POLICY "Users can delete their own tasks" 
  ON tasks
  FOR DELETE
  USING (auth.uid() = user_id);