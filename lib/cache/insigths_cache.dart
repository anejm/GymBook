import 'package:flutter/foundation.dart';

import '../models/insights.dart';
import '../services/insights_service.dart';
import '../temp_data/user.dart';

class InsightsCache extends ChangeNotifier {
  InsightsCache._();

  static final instance = InsightsCache._();

  bool isLoading = false;
  String? error;

  int workoutsCount = 0;
  double totalVolume = 0;
  double averageVolume = 0;

  List<VolumeData> volumeHistory = [];
  List<InsightExercise> exercises = [];
  List<PersonalRecord> personalRecords = [];

  InsightExercise? selectedExercise;
  List<ExerciseProgress> exerciseProgress = [];

  bool exerciseProgressLoading = false;

  bool get hasData =>
      volumeHistory.isNotEmpty ||
      exercises.isNotEmpty ||
      personalRecords.isNotEmpty ||
      workoutsCount > 0;

  Future<void> load({bool forceRefresh = false}) async {
    if (!forceRefresh && hasData) {
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userId = await CurrentUser.id;

      final data = await InsightsService.getInsights(
        userId: userId,
      );

      workoutsCount = data['workouts_count'] ?? 0;

      totalVolume =
          (data['total_volume'] ?? 0).toDouble();

      averageVolume =
          (data['average_volume'] ?? 0).toDouble();

      volumeHistory = (data['volume_history'] as List)
          .map(
            (item) => VolumeData(
              date: DateTime.parse(item['date']),
              volume: (item['volume'] ?? 0).toDouble(),
              workoutName: item['name'] ?? '',
            ),
          )
          .toList();

      exercises = (data['exercises'] as List)
          .map(
            (item) => InsightExercise(
              id: item['id'].toString(),
              name: item['name'],
              primaryMuscle: item['primary_muscle'],
            ),
          )
          .toList();

      personalRecords =
          (data['personal_records'] as List)
              .map(
                (item) => PersonalRecord(
                  exerciseName: item['exercise_name'],
                  maxWeight:
                      (item['max_weight'] ?? 0).toDouble(),
                ),
              )
              .toList();

      if (selectedExercise == null &&
          exercises.isNotEmpty) {
        selectedExercise = exercises.first;
      }

      isLoading = false;
    } catch (e) {
      error = 'Failed to load insights';
      isLoading = false;
    }

    notifyListeners();

    if (selectedExercise != null) {
      await loadExerciseProgress(
        selectedExercise!.id,
        forceRefresh: forceRefresh,
      );
    }
  }

  Future<void> loadExerciseProgress(
    String exerciseId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        selectedExercise?.id == exerciseId &&
        exerciseProgress.isNotEmpty) {
      return;
    }

    exerciseProgressLoading = true;
    notifyListeners();

    try {
      final userId = await CurrentUser.id;

      final data =
          await InsightsService.getExerciseProgress(
        userId: userId,
        exerciseId: exerciseId,
      );

      exerciseProgress = (data as List)
          .map(
            (item) => ExerciseProgress(
              date: DateTime.parse(item['date']),
              maxWeight:
                  (item['max_weight'] ?? 0).toDouble(),
            ),
          )
          .toList();
    } catch (_) {
      exerciseProgress = [];
    }

    exerciseProgressLoading = false;
    notifyListeners();
  }

  Future<void> selectExercise(
    InsightExercise exercise,
  ) async {
    selectedExercise = exercise;
    exerciseProgress = [];

    notifyListeners();

    await loadExerciseProgress(exercise.id);
  }

  Future<void> refresh() async {
    await load(forceRefresh: true);
  }

  void clear() {
    isLoading = false;
    error = null;

    workoutsCount = 0;
    totalVolume = 0;
    averageVolume = 0;

    volumeHistory = [];
    exercises = [];
    personalRecords = [];

    selectedExercise = null;
    exerciseProgress = [];
    exerciseProgressLoading = false;

    notifyListeners();
  }
}