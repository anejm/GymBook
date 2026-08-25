import 'package:flutter/material.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final String workoutName;
  final int duration;
  final int exerciseCount;
  final int totalSets;

  const WorkoutSummaryPage({
    super.key,
    required this.workoutName,
    required this.duration,
    required this.exerciseCount,
    required this.totalSets,
  });

  String formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes <= 0) {
      return '$seconds s';
    } 
    if (hours <= 0) {
      return '$minutes m : ${seconds.toString().padLeft(2, '0')} s';
    }

    return '$hours h : ${minutes.toString().padLeft(2, '0')} m : ${seconds.toString().padLeft(2, '0')} s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Workout Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            Text(
              workoutName,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 24),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text('Duration'),
                    trailing: Text(formatTime(duration)),
                  ),

                  ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: const Text('Exercises'),
                    trailing: Text('$exerciseCount'),
                  ),

                  ListTile(
                    leading: const Icon(Icons.repeat),
                    title: const Text('Total Sets'),
                    trailing: Text('$totalSets'),
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