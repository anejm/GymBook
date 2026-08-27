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
}