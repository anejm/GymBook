import 'dart:convert';
import 'package:http/http.dart' as http;

import 'exercise_service.dart';
import '../models/profile.dart';

class ProfileService {
  static Future<UserProfile> getProfile({required String userId}) async {
    final response = await http.get(
      Uri.parse('${ExerciseService.baseUrl}/users/$userId/profile'),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to load profile');
    }

    return UserProfile.fromJson(jsonDecode(response.body));
  }

  static Future<UserProfile> updateProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required double? weightKg,
    required double? heightCm,
    required DateTime? birthDate,

  }) async {
    final response = await http.put(
      Uri.parse('${ExerciseService.baseUrl}/users/$userId/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'weight_kg': weightKg,
        'height_cm': heightCm,
        'birth_date': birthDate != null
            ? '${birthDate.year.toString().padLeft(4, '0')}-'
                '${birthDate.month.toString().padLeft(2, '0')}-'
                '${birthDate.day.toString().padLeft(2, '0')}'
            : null,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to update profile');
    }

    return UserProfile.fromJson(jsonDecode(response.body));
  }

  static Future<void> updateEmail({
    required String userId,
    required String email,
  }) async {
    final response = await http.put(
      Uri.parse('${ExerciseService.baseUrl}/users/$userId/email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to update email');
    }
  }

    static Future<String> getEmail({required String userId}) async {
    final response = await http.get(
      Uri.parse('${ExerciseService.baseUrl}/users/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['detail'] ?? 'Failed to load email');
    }

    return jsonDecode(response.body)['email'] as String;
  }
}