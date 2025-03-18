import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/features/auth/models/auth_state.dart' as auth_model;
import 'package:todo_app/features/auth/providers/auth_repository_provider.dart';
import 'package:todo_app/features/auth/providers/auth_state_provider.dart';

part 'current_user_provider.g.dart';

@riverpod
Future<UserModel?> currentUser(Ref ref) async {
  final authState = ref.watch(authProvider);
  
  if (authState.value == auth_model.AuthState.authenticated) {
    return ref.read(authRepositoryProvider).getCurrentUser();
  }
  
  return null;
}