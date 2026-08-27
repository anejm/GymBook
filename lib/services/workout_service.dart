import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/workout_details.dart';
import 'exercise_service.dart';

class WorkoutService {
  static Future<void> saveWorkout({
    required String userId,
    required Workout workout,
  }) async {
    final body = {
      'user_id': userId,
      'name': workout.name,
      'started_at': workout.date
          .subtract(Duration(seconds: workout.duration))
          .toIso8601String(),
      'duration_seconds': workout.duration,
      'exercises': [
        for (int i = 0; i < workout.exercises.length; i++)
          {
            'exercise_id': workout.exercises[i].exercise.id,
            'exercise_order': i,
            'sets': [
              for (int j = 0; j < workout.exercises[i].sets.length; j++)
                {
                  'set_number': j + 1,
                  'weight_kg': workout.exercises[i].sets[j].weight,
                  'reps': workout.exercises[i].sets[j].reps,
                },
            ],
          },
      ],
    };

    final response = await http.post(
      Uri.parse('${ExerciseService.baseUrl}/workouts/complete'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to save workout: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<List<Workout>> getWorkoutHistory({
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse('${ExerciseService.baseUrl}/users/$userId/workouts'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load workout history: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data.map((json) => Workout.fromJson(json)).toList();
  }
  static Future<Map<String, dynamic>?> getRecentWorkout({
    required String userId,
  }) async {
    final response = await http.get(
      Uri.parse('${ExerciseService.baseUrl}/users/$userId/recent-workout'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load recent workout: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded == null) {
      return null; // ni še nobenega treninga
    }

    return decoded as Map<String, dynamic>;
  }
}