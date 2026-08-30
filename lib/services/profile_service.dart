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
}