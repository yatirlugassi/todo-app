import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/core/models/user_model.dart';
import 'package:todo_app/core/config/env_config.dart';

/// Service class for handling authentication operations through the backend API
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
    
    // Return user data
    return UserModel(
      id: data['user']['id'],
      email: data['user']['email'],
    );
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
    
    // Clear the stored token
    await _storage.delete(key: 'auth_token');
  }

  /// Get the current authenticated user data
  Future<UserModel?> getCurrentUser() async {
    final token = await _storage.read(key: 'auth_token');
    
    if (token == null) {
      return null;
    }
    
    // In a real app, you would typically have an endpoint to get user data
    // For now, we'll return a minimal user model based on the stored ID
    return UserModel(
      id: 'current-user', // In a real app, extract this from JWT or make an API call
      email: 'user@example.com', // In a real app, this would come from the backend
    );
  }
}