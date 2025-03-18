import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/core/services/supabase_service.dart';

/// Service class for handling authentication operations
class AuthService {
  /// Check if a user is currently authenticated
  Future<bool> isAuthenticated() async {
    return SupabaseService.isAuthenticated;
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    final response = await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.session == null) {
      throw Exception('Authentication failed');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }

  /// Get the current authenticated user as a UserModel
  UserModel? getCurrentUser() {
    final supabaseUser = SupabaseService.currentUser;
    if (supabaseUser != null) {
      return UserModel.fromSupabaseUser(supabaseUser);
    }
    return null;
  }
}