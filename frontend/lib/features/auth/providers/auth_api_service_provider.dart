import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/features/auth/services/auth_api_service.dart';

part 'auth_api_service_provider.g.dart';

@riverpod
AuthApiService authApiService(AuthApiServiceRef ref) {
  final service = AuthApiService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}