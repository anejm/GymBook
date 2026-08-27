import 'exercise.dart';

class WorkoutSet {
  final double weight;
  final int reps;

  WorkoutSet({
    required this.weight,
    required this.reps,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      weight: (json['weight_kg'] as num).toDouble(),
      reps: json['reps'],
    );
  }
}

class CompletedExercise {
  final Exercise exercise;
  final List<WorkoutSet> sets;

  CompletedExercise({
    required this.exercise,
    required this.sets,
  });

  factory CompletedExercise.fromJson(Map<String, dynamic> json) {
    return CompletedExercise(
      exercise: Exercise(
        id: json['exercise_id'],
        name: json['exercise_name'],
        primaryMuscle: json['primary_muscle'] ?? '',
      ),
      sets: (json['sets'] as List)
          .map((s) => WorkoutSet.fromJson(s))
          .toList(),
    );
  }
}

class Workout {
  final String id;
  final String name;
  final DateTime date;
  final int duration;
  final List<CompletedExercise> exercises;

  Workout({
    this.id = '',
    required this.name,
    required this.date,
    required this.duration,
    required this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['started_at']),
      duration: json['duration_seconds'] ?? 0,
      exercises: (json['exercises'] as List)
          .map((e) => CompletedExercise.fromJson(e))
          .toList(),
    );
  }

  int get totalSets {
    return exercises.fold(
      0,
      (total, exercise) => total + exercise.sets.length,
    );
  }
}