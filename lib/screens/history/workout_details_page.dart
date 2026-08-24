import 'package:flutter/material.dart';

class WorkoutDetailsPage extends StatelessWidget {
  const WorkoutDetailsPage({super.key});

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
            'Push Workout',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 8),

          Text(
            '18 August 2026',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          Card(
            child: ListTile(
              title: const Text('Bench Press'),
              subtitle: const Text('3 sets'),
              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history/exercise',
                );
              },
            ),
          ),

          const Card(
            child: ListTile(
              title: Text('Incline Dumbbell Press'),
              subtitle: Text('3 sets'),
            ),
          ),

          const Card(
            child: ListTile(
              title: Text('Dips'),
              subtitle: Text('3 sets'),
            ),
          ),
        ],
      ),
    );
  }
}