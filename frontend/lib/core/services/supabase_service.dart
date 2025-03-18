import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/core/config/env_config.dart';

/// Service for interacting with Supabase
class SupabaseService {
  /// Initializes Supabase client with environment variables
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      debug: false, // Set to true for development
    );
  }
  
  /// Returns the Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Returns the current authenticated user or null if not authenticated
  static User? get currentUser => client.auth.currentUser;
  
  /// Returns the current user session or null if not authenticated
  static Session? get currentSession => client.auth.currentSession;
  
  /// Returns whether a user is currently authenticated
  static bool get isAuthenticated => currentUser != null;
}