import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration to access environment variables
class EnvConfig {
  /// Returns the Supabase URL from environment variables
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  
  /// Returns the Supabase anonymous key from environment variables
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  /// Returns the backend API base URL from environment variables
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  
  /// Validates that all required environment variables are present
  static bool validateEnvVariables() {
    final variables = [
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
      'API_BASE_URL',
    ];
    
    return variables.every((variable) => 
      dotenv.env[variable]?.isNotEmpty == true);
  }
}