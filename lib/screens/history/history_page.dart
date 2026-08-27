import 'package:flutter/material.dart';

import '../../functions/format_time.dart';
import '../../functions/format_date.dart';

import '../../models/workout_details.dart';
import '../../services/workout_service.dart';
import '../../temp_data/user.dart';
import 'workout_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Workout>> workoutsFuture;

  @override
  void initState() {
    super.initState();
    workoutsFuture = WorkoutService.getWorkoutHistory(
      userId: CurrentUser.id,
    );
  }

  Future<void> refresh() async {
    setState(() {
      workoutsFuture = WorkoutService.getWorkoutHistory(
        userId: CurrentUser.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),

      body: FutureBuilder<List<Workout>>(
        future: workoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load history: ${snapshot.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final workouts = snapshot.data ?? [];

          if (workouts.isEmpty) {
            return const Center(child: Text('No workouts yet.'));
          }

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final Workout workout = workouts[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.fitness_center),
                    ),
                    title: Text(workout.name),
                    subtitle: Text(
                      '${formatDate(workout.date)} • '
                      '${formatTime(workout.duration)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutDetailsPage(workout: workout),
                        ),
                      );
                    },
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