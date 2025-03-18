import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/features/auth/services/auth_api_service.dart';

part 'auth_api_service_provider.g.dart';

@riverpod
AuthApiService authApiService(Ref ref) {
  final service = AuthApiService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}