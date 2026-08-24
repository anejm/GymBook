import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              child: SizedBox(
                height: 350,

                child: Center(
                  child: Text(
                    'Calendar goes here',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Card(
              child: ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Today'),
                subtitle: Text(
                  'No workout scheduled',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}