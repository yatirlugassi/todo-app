import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/features/auth/services/auth_service.dart';

// Generate the providers
part 'auth_provider.g.dart';

// Auth state enum to track authentication state
enum AuthState {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

// Auth service provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService();
}

// Auth state provider
@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<AuthState> build() {
    return const AsyncValue.data(AuthState.initial);
  }

  Future<void> initialize() async {
    state = const AsyncValue.loading();
    try {
      final isAuthenticated = await ref.read(authServiceProvider).isAuthenticated();
      state = AsyncValue.data(
        isAuthenticated ? AuthState.authenticated : AuthState.unauthenticated,
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signIn(email, password);
      state = const AsyncValue.data(AuthState.authenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signOut();
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Current user provider
@riverpod
Future<UserModel?> currentUser(CurrentUserRef ref) async {
  final authState = ref.watch(authProvider);
  
  if (authState.value == AuthState.authenticated) {
    return ref.read(authServiceProvider).getCurrentUser();
  }
  
  return null;
}