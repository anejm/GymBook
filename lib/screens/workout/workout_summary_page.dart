import 'package:flutter/material.dart';

import '../../functions/format_time.dart';

import '../../models/workout_details.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final Workout workout;

  const WorkoutSummaryPage({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              'Workout Complete!',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),

            const SizedBox(height: 8),

            Text(
              workout.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(height: 24),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.timer),

                    title:
                        const Text('Duration'),

                    trailing:
                        Text(formatTime(
                      workout.duration,
                    )),
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.fitness_center,
                    ),

                    title:
                        const Text('Exercises'),

                    trailing:
                        Text('${workout.exercises.length}'),
                  ),

                  ListTile(
                    leading:
                        const Icon(Icons.repeat),

                    title:
                        const Text('Total Sets'),

                    trailing:
                        Text('${workout.totalSets}'),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },

                child: const Text(
                  'Back to Home',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}