import 'dart:convert';
import 'package:http/http.dart' as http;

import 'exercise_service.dart';

class InsightsService {
  static Future<Map<String, dynamic>> getInsights({
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ExerciseService.baseUrl}/users/$userId/insights',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        jsonDecode(response.body)['detail'] ??
            'Failed to load insights',
      );
    }

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getExerciseProgress({
    required String userId,
    required String exerciseId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '${ExerciseService.baseUrl}/users/$userId/insights/exercise/$exerciseId',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        jsonDecode(response.body)['detail'] ??
            'Failed to load exercise progress',
      );
    }

    return jsonDecode(response.body);
  }
}