import 'package:flutter/material.dart';

import '../../models/exercise.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final String workoutName;
  final List<Exercise> exercises;

  const ActiveWorkoutPage({
    super.key,
    required this.workoutName,
    required this.exercises,
  });

  @override
  State<ActiveWorkoutPage> createState() =>
      _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState
    extends State<ActiveWorkoutPage> {

  int seconds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workoutName,
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/workout/summary',
              );
            },

            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // --------------------------------
          // TIMER
          // --------------------------------

          Card(
            margin: const EdgeInsets.all(16),

            child: ListTile(
              leading: const Icon(
                Icons.timer_outlined,
              ),

              title: const Text(
                'Workout Time',
              ),

              subtitle: Text(
                '$seconds seconds',
              ),
            ),
          ),

          // --------------------------------
          // EXERCISES
          // --------------------------------

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              itemCount: widget.exercises.length,

              itemBuilder: (context, index) {
                final exercise =
                    widget.exercises[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),

                    title: Text(
                      exercise.name,
                    ),

                    subtitle: Text(
                      exercise.muscleGroup,
                    ),

                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                  ),
                );
              },
            ),
          ),

          // --------------------------------
          // FINISH
          // --------------------------------

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/workout/summary',
                  );
                },

                child: const Text(
                  'Finish Workout',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}