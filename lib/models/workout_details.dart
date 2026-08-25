import 'exercise.dart';

class WorkoutSet {
  final double weight;
  final int reps;

  WorkoutSet({
    required this.weight,
    required this.reps,
  });
}

class CompletedExercise {
  final Exercise exercise;
  final List<WorkoutSet> sets;

  CompletedExercise({
    required this.exercise,
    required this.sets,
  });
}

class Workout {
  final String name;
  final DateTime date;
  final int duration;
  final List<CompletedExercise> exercises;

  Workout({
    required this.name,
    required this.date,
    required this.duration,
    required this.exercises,
  });

  int get totalSets {
    return exercises.fold(
      0,
      (total, exercise) => total + exercise.sets.length,
    );
  }
}