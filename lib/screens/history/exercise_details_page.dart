import 'package:flutter/material.dart';

class ExerciseDetailsPage extends StatelessWidget {
  const ExerciseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Details'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Bench Press',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            const Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Set 1'),
                    trailing: Text('60 kg × 10'),
                  ),

                  ListTile(
                    title: Text('Set 2'),
                    trailing: Text('60 kg × 9'),
                  ),

                  ListTile(
                    title: Text('Set 3'),
                    trailing: Text('60 kg × 8'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Progress',
              style: Theme.of(context).textTheme.titleLarge,
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
      ),
    );
  }
}