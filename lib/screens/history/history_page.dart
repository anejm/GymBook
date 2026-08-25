import 'package:flutter/material.dart';

import '../../functions/format_time.dart';
import '../../functions/format_date.dart';

import '../../temp_data/workout_history.dart';
import '../../models/workout_details.dart';
import 'workout_details_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final workouts = WorkoutHistory.workouts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),

      body: workouts.isEmpty
          ? const Center(
              child: Text(
                'No workouts yet.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: workouts.length,

              itemBuilder: (context, index) {
                final Workout workout =
                    workouts[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.fitness_center,
                      ),
                    ),

                    title: Text(
                      workout.name,
                    ),

                    subtitle: Text(
                      '${formatDate(workout.date)} • '
                      '${formatTime(workout.duration)}',
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailsPage(
                            workout: workout,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}