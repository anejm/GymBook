import 'mock_exercises.dart';
import '../models/recent_workout.dart';

final List<RecentWorkout> recentWorkouts = [
  RecentWorkout(
    name: 'Push Day',
    timeAgo: const Duration(days: 1),
    averageDuration: const Duration(
      hours: 1,
      minutes: 10,
    ),
    exercises: [
      availableExercises[0], // Bench Press
      availableExercises[1], // Incline Dumbbell Press
      availableExercises[2], // Dumbbell Fly
      availableExercises[6], // Shoulder Press
      availableExercises[7], // Lateral Raise
      availableExercises[9], // Tricep Pushdown
    ],
  ),

  RecentWorkout(
    name: 'Pull Day',
    timeAgo: const Duration(days: 3),
    averageDuration: const Duration(
      minutes: 58,
    ),
    exercises: [
      availableExercises[3], // Lat Pulldown
      availableExercises[4], // Barbell Row
      availableExercises[5], // Seated Cable Row
      availableExercises[8], // Barbell Curl
    ],
  ),

  RecentWorkout(
    name: 'Leg Day',
    timeAgo: const Duration(days: 5),
    averageDuration: const Duration(
      hours: 1,
      minutes: 5,
    ),
    exercises: [
      availableExercises[10], // Squat
      availableExercises[11], // Leg Press
      availableExercises[12], // RDL
      availableExercises[13], // Leg Curl
      availableExercises[14], // Calf Raise
      availableExercises[15], // Hip Thrust
    ],
  ),
];