import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.fitness_center),
              ),

              title: const Text(
                'Push Workout',
              ),

              subtitle: const Text(
                '18 August 2026 • 58 min',
              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history/details',
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.fitness_center),
              ),

              title: const Text(
                'Pull Workout',
              ),

              subtitle: const Text(
                '16 August 2026 • 52 min',
              ),

              trailing: const Icon(
                Icons.chevron_right,
              ),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history/details',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}