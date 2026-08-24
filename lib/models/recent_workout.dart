import 'exercise.dart';

class RecentWorkout {
  final String name;
  final Duration timeAgo;
  final Duration averageDuration;
  final List<Exercise> exercises;

  const RecentWorkout({
    required this.name,
    required this.timeAgo,
    required this.averageDuration,
    required this.exercises,
  });
}