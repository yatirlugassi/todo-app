import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/core/config/env_config.dart';

/// Service class for handling authentication API operations
class AuthApiService {
  final String _baseUrl;
  final http.Client _httpClient;

  AuthApiService({
    String? baseUrl,
    http.Client? httpClient,
  }) : 
    _baseUrl = baseUrl ?? '${EnvConfig.apiBaseUrl}/api/auth',
    _httpClient = httpClient ?? http.Client();

  /// Sign in with email and password
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    final data = jsonDecode(response.body);
    
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Authentication failed');
    }
    
    return data;
  }

  /// Sign out the current user
  Future<void> signOut(String token) async {
    await _httpClient.post(
      Uri.parse('$_baseUrl/signout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }
  
  /// Cleanup resources
  void dispose() {
    _httpClient.close();
  }
}