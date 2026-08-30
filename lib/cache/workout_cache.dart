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

  Future<void> refresh() => load();
}