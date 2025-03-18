import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/features/auth/services/auth_api_service.dart';

/// Repository for managing authentication state and data
class AuthRepository {
  final AuthApiService _authService;
  final FlutterSecureStorage _secureStorage;

  AuthRepository({
    required AuthApiService authService,
    FlutterSecureStorage? secureStorage,
  }) : 
    _authService = authService,
    _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Check if a user is currently authenticated
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  /// Get the authentication token
  Future<String?> getAuthToken() async {
    return _secureStorage.read(key: 'auth_token');
  }

  /// Sign in with email and password
  Future<UserModel> signIn(String email, String password) async {
    try {
      final data = await _authService.signIn(email, password);
      
      // Save the authentication token
      await _secureStorage.write(key: 'auth_token', value: data['token']);
      
      // Create user model from response
      final user = UserModel(
        id: data['user']['id'],
        email: data['user']['email'],
      );
      
      // Store user data in secure storage as JSON
      await _secureStorage.write(
        key: 'user_data',
        value: jsonEncode(user.toJson()),
      );
      
      return user;
    } catch (e) {
      // Rethrow the exception with a more user-friendly message
      throw Exception('Authentication failed: ${e.toString()}');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token != null) {
        await _authService.signOut(token);
      }
    } finally {
      // Clear stored data even if API call fails
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'user_data');
    }
  }

  /// Get the current authenticated user data
  Future<UserModel?> getCurrentUser() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      return null;
    }
    
    // Read user data from secure storage
    final userData = await _secureStorage.read(key: 'user_data');
    if (userData != null) {
      try {
        return UserModel.fromJson(jsonDecode(userData));
      } catch (e) {
        // Log the error but don't expose it to the caller
        print('Error parsing stored user data: $e');
      }
    }
    
    return null;
  }
}