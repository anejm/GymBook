import 'package:flutter/material.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Text(
            'Your Progress',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 20),

          const Card(
            child: ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Workouts'),
              subtitle: Text('12 workouts this month'),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.trending_up),
              title: Text('Volume'),
              subtitle: Text('24,500 kg total volume'),
            ),
          ),

          const Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text('Personal Records'),
              subtitle: Text('5 new PRs'),
            ),
          ),

          const SizedBox(height: 20),

          const Card(
            child: SizedBox(
              height: 250,

              child: Center(
                child: Text(
                  'Progress chart',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}