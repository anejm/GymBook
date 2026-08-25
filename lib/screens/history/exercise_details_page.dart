import 'package:flutter/material.dart';

import '../../models/workout_details.dart';

class ExerciseDetailsPage extends StatelessWidget {
  final CompletedExercise completedExercise;

  const ExerciseDetailsPage({
    super.key,
    required this.completedExercise,
  });

  @override
  Widget build(BuildContext context) {
    final exercise =
        completedExercise.exercise;

    final sets =
        completedExercise.sets;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise Details',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Text(
            exercise.name,
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
          ),

          const SizedBox(height: 8),

          Text(
            exercise.muscleGroup,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 24),

          Card(
            child: Column(
              children: [
                if (sets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No completed sets.',
                    ),
                  ),

                ...sets.asMap().entries.map(
                  (entry) {
                    final index =
                        entry.key;

                    final set =
                        entry.value;

                    return ListTile(
                      title: Text(
                        'Set ${index + 1}',
                      ),

                      trailing: Text(
                        '${set.weight} kg × '
                        '${set.reps}',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Progress',
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(height: 12),

          const Card(
            child: SizedBox(
              height: 200,

              child: Center(
                child: Text(
                  'Exercise progress chart',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}