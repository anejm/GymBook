import 'package:flutter/material.dart';

class WorkoutSummaryPage extends StatelessWidget {
  const WorkoutSummaryPage({super.key});

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

            const SizedBox(height: 24),

            const Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.timer),
                    title: Text('Duration'),
                    trailing: Text('58 min'),
                  ),

                  ListTile(
                    leading: Icon(Icons.fitness_center),
                    title: Text('Exercises'),
                    trailing: Text('6'),
                  ),

                  ListTile(
                    leading: Icon(Icons.repeat),
                    title: Text('Total Sets'),
                    trailing: Text('18'),
                  ),
                ],
              ),
            ),

            const Spacer(),

            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}