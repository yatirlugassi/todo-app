import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/features/auth/models/auth_state.dart' as auth_model;
import 'package:todo_app/features/auth/providers/auth_repository_provider.dart';

part 'auth_state_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AsyncValue<auth_model.AuthState> build() {
    return const AsyncValue.data(auth_model.AuthState.initial);
  }

  Future<void> initialize() async {
    state = const AsyncValue.loading();
    try {
      final isAuthenticated = await ref.read(authRepositoryProvider).isAuthenticated();
      state = AsyncValue.data(
        isAuthenticated ? auth_model.AuthState.authenticated : auth_model.AuthState.unauthenticated,
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signIn(email, password);
      state = const AsyncValue.data(auth_model.AuthState.authenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncValue.data(auth_model.AuthState.unauthenticated);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}