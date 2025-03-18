import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/core/config/env_config.dart';

/// @deprecated Use AuthApiService and AuthRepository instead
/// Service class for handling authentication operations through the backend API
/// This class combines service and repository responsibilities and should be
/// refactored to follow the architecture guidelines
@Deprecated('Use AuthApiService and AuthRepository instead')
class AuthService {
  final String _baseUrl = '${EnvConfig.apiBaseUrl}/api/auth';
  final _storage = const FlutterSecureStorage();
  
  /// Check if a user is currently authenticated by verifying if a token exists
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  /// Sign in with email and password using the backend API
  Future<UserModel> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Authentication failed');
    }
    
    final data = jsonDecode(response.body);
    
    // Save the authentication token
    await _storage.write(key: 'auth_token', value: data['token']);
    
    // Create and store user data
    final user = UserModel(
      id: data['user']['id'],
      email: data['user']['email'],
    );
    
    // Store user data in secure storage as JSON
    await _storage.write(
      key: 'user_data',
      value: jsonEncode(user.toJson()),
    );
    
    return user;
  }

  /// Sign out the current user using the backend API
  Future<void> signOut() async {
    final token = await _storage.read(key: 'auth_token');
    
    if (token != null) {
      await http.post(
        Uri.parse('$_baseUrl/signout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
    }
    
    // Clear stored data
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }

  /// Get the current authenticated user data
  Future<UserModel?> getCurrentUser() async {
    final token = await _storage.read(key: 'auth_token');
    
    if (token == null) {
      return null;
    }
    
    // Read user data from secure storage
    final userData = await _storage.read(key: 'user_data');
    if (userData != null) {
      try {
        return UserModel.fromJson(jsonDecode(userData));
      } catch (e) {
        print('Error parsing stored user data: $e');
      }
    }
    
    // If we couldn't get user data from storage, try to get it from the backend
    // This would be a good place for a "me" endpoint in a real app
    return null;
  }
}