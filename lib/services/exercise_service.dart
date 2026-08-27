import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/exercise.dart';

class ExerciseService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  static Future<List<Exercise>> getExercises() async {
    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load exercises: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => Exercise.fromJson(json))
        .toList();
  }
}