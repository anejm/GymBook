import 'package:flutter/foundation.dart';

import '../models/workout_details.dart';
import '../services/workout_service.dart';
import '../temp_data/user.dart';

class WorkoutCache extends ChangeNotifier {
  WorkoutCache._();
  static final instance = WorkoutCache._();

  List<Workout> workouts = [];
  bool isLoading = false;
  Object? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userId = await CurrentUser.id;
      workouts = await WorkoutService.getWorkoutHistory(userId: userId);
    } catch (e) {
      error = e;
    }

    isLoading = false;
    notifyListeners();
  }

  CompletedExercise? getLastPerformanceForExercise(
    String exerciseId,
  ) {
    CompletedExercise? latestPerformance;
    DateTime? latestDate;

    for (final workout in workouts) {
      for (final completedExercise in workout.exercises) {
        if (completedExercise.exercise.id.toString() == exerciseId) {
          if (latestDate == null || workout.date.isAfter(latestDate!)) {
            latestDate = workout.date;
            latestPerformance = completedExercise;
          }

          break;
        }
      }
    }

    return latestPerformance;
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await WorkoutService.deleteWorkout(
        workoutId: workoutId,
      );

      workouts.removeWhere((workout) => workout.id == workoutId);

      notifyListeners();
    } catch (e) {
      error = e;
      notifyListeners();
      rethrow;
    }
  }

  void clear() {
    workouts = [];       
    isLoading = false;
    error = null;
    notifyListeners();
  }

  Future<void> refresh() => load();
}