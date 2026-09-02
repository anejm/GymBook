import 'package:flutter/material.dart';

import '../../functions/format_time.dart';
import '../../functions/format_date.dart';

import '../../cache/workout_cache.dart';
import '../../models/workout_details.dart';
//import '../../services/workout_service.dart';
//import '../../temp_data/user.dart';
import 'workout_details_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cache = WorkoutCache.instance;
  void _onUpdate() => setState(() {});

  Future<void> _deleteWorkout(Workout workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete workout?'),
          content: Text(
            'Are you sure you want to delete "${workout.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await cache.deleteWorkout(workout.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout deleted'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete workout'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    cache.addListener(_onUpdate);
  }

  @override
  void dispose() {
    cache.removeListener(_onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),

      body: Builder(
        builder: (context) {
          if (cache.isLoading && cache.workouts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cache.error != null && cache.workouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load history: ${cache.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: cache.refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final workouts = cache.workouts;

          if (workouts.isEmpty) {
            return const Center(child: Text('No workouts yet.'));
          }

          return RefreshIndicator(
            onRefresh: cache.refresh,
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
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteWorkout(workout);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete workout'),
                        ),
                      ],
                    ),
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