import 'package:flutter/material.dart';

import '../../functions/format_time.dart';
import '../../functions/format_date.dart';

import '../../models/workout_details.dart';
import 'exercise_details_page.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailsPage({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Text(
            workout.name,
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
          ),

          const SizedBox(height: 8),

          Text(
            formatDate(workout.date),
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 8),

          Text(
            '${formatTime(workout.duration)} • '
            '${workout.exercises.length} exercises • '
            '${workout.totalSets} sets',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 24),

          ...workout.exercises.map(
            (completedExercise) {
              return Card(
                child: ListTile(
                  title: Text(
                    completedExercise
                        .exercise
                        .name,
                  ),

                  subtitle: Text(
                    '${completedExercise.sets.length} sets',
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExerciseDetailsPage(
                          completedExercise:
                              completedExercise,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}