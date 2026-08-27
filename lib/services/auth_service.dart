import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'exercise_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    double? weightKg,
  }) async {
    final response = await http.post(
      Uri.parse('${ExerciseService.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate.toIso8601String().split('T')[0],
        'weight_kg': weightKg,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Registration failed');
    }

    final data = jsonDecode(response.body);
    await _saveSession(data['user_id'], data['token']);
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ExerciseService.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Login failed');
    }

    final data = jsonDecode(response.body);
    await _saveSession(data['user_id'], data['token']);
  }

  static Future<void> _saveSession(String userId, String token) async {
    await _storage.write(key: 'user_id', value: userId);
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getUserId() => _storage.read(key: 'user_id');

  static Future<bool> isLoggedIn() async {
    final userId = await _storage.read(key: 'user_id');
    return userId != null;
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}