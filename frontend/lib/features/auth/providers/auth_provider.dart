import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/core/services/supabase_service.dart';

// Auth state enum to track authentication state
enum AuthState {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

// Auth state notifier class
class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  AuthNotifier() : super(const AsyncValue.data(AuthState.initial)) {
    _initialize();
  }

  // Initialize by checking current auth status
  Future<void> _initialize() async {
    state = const AsyncValue.loading();
    try {
      final isAuthenticated = SupabaseService.isAuthenticated;
      state = AsyncValue.data(
        isAuthenticated ? AuthState.authenticated : AuthState.unauthenticated,
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.session == null) {
        throw Exception('Authentication failed');
      }
      
      state = const AsyncValue.data(AuthState.authenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await SupabaseService.client.auth.signOut();
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>(
  (ref) => AuthNotifier(),
);

// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  
  if (authState.value == AuthState.authenticated) {
    final supabaseUser = SupabaseService.currentUser;
    if (supabaseUser != null) {
      return UserModel.fromSupabaseUser(supabaseUser);
    }
  }
  
  return null;
});