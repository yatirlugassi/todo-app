import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/features/auth/repositories/auth_repository.dart';
import 'package:todo_app/features/auth/providers/auth_api_service_provider.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    authService: ref.watch(authApiServiceProvider),
  );
}