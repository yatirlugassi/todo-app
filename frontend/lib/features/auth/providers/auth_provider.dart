import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/features/auth/repositories/auth_repository.dart';
import 'package:todo_app/features/auth/services/auth_api_service.dart';

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

// AuthApiService provider using standard Provider instead of riverpod annotation
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final service = AuthApiService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

// AuthRepository provider using standard Provider instead of riverpod annotation
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.watch(authApiServiceProvider),
  );
});

// Auth state provider
@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<AuthState> build() {
    return const AsyncValue.data(AuthState.initial);
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> initialize() async {
    state = const AsyncValue.loading();
    try {
      final isAuthenticated = await _repository.isAuthenticated();
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
      await _repository.signIn(email, password);
      state = const AsyncValue.data(AuthState.authenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signOut();
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Current user provider
@riverpod
Future<UserModel?> currentUser(Ref ref) async {
  final authState = ref.watch(authProvider);
  
  if (authState.value == AuthState.authenticated) {
    return ref.read(authRepositoryProvider).getCurrentUser();
  }
  
  return null;
}