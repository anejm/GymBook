import 'package:flutter/foundation.dart';

import '../models/exercise.dart';
import '../services/exercise_service.dart';

class ExerciseCache extends ChangeNotifier {
  ExerciseCache._();
  static final instance = ExerciseCache._();

  List<Exercise> exercises = [];
  bool isLoading = false;
  Object? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      exercises = await ExerciseService.getExercises();
    } catch (e) {
      error = e;
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    exercises = [];     
    isLoading = false;
    error = null;
    notifyListeners();
  }

  Future<void> refresh() => load();
}