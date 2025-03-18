import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

dotenv.config();

// Get Supabase credentials from environment variables
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

// Ensure credentials are available
if (!supabaseUrl || !supabaseKey) {
  throw new Error('Supabase credentials are not properly set in environment variables.');
}

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseKey);

export default supabase;