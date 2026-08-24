import 'package:flutter/material.dart';
import 'dart:async';
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

  final Map<int, List<TextEditingController>> setControllers = {};

  TextEditingController getSetController(int exerciseIndex, int setIndex) {
    final controllers =
      setControllers.putIfAbsent(
      exerciseIndex,
      () => [],
    );

    while (controllers.length <= setIndex) {
      controllers.add(
        TextEditingController(),
      );
    }

    return controllers[setIndex];
  }

  Timer? workoutTimer;
  int seconds = 0;
  int? expandedExerciseIndex;

  @override
  void initState() {
    super.initState();

    workoutTimer = Timer.periodic(
      const Duration(seconds: 1), (timer) {
        setState(() {
          seconds++;
        });
      },
    );
  }

  @override
  void dispose() {
    workoutTimer?.cancel();

    for (final controllers in setControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }

    super.dispose();
  }

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

      body: GestureDetector(

        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },

        child: Column(
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
                  formatTime(seconds),
                ),
              ),
            ),

            // --------------------------------
            // EXERCISES
            // --------------------------------

            Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                itemCount: widget.exercises.length,

                itemBuilder: (context, index) {
                  final exercise = widget.exercises[index];
                  final isExpanded = expandedExerciseIndex == index;

                  final controllers =
                      setControllers[index] ?? [];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        children: [
                          // -----------------------------
                          // EXERCISE HEADER
                          // -----------------------------

                          InkWell(
                            onTap: () {
                              setState(() {
                                if (expandedExerciseIndex == index) {
                                  expandedExerciseIndex = null;
                                } else {
                                  expandedExerciseIndex = index;
                                }
                              });
                            },

                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        exercise.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),

                                      Text(
                                        exercise.muscleGroup,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                              ],
                            ),
                          ),

                          // --------------------------------
                          // SETS
                          // --------------------------------

                          if (isExpanded) ...[
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    'Set',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    'Reps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            ...controllers.asMap().entries.map(
                              (entry) {
                                final setIndex = entry.key;
                                final controller = entry.value;

                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    bottom: 8,
                                  ),

                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Text(
                                          '${setIndex + 1}',
                                        ),
                                      ),

                                      Expanded(
                                        child: TextField(
                                          controller: controller,

                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,

                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.8),
                                          ),

                                          decoration: InputDecoration(
                                            hintText: 'Reps',

                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 14,
                                            ),

                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),

                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context).colorScheme.primary,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),

                                            isDense: true,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 8,
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            final removed =
                                                controllers
                                                    .removeAt(
                                              setIndex,
                                            );

                                            removed.dispose();
                                          });
                                        },

                                        icon: const Icon(
                                          Icons.remove,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // --------------------------------
                          // ADD SET
                          // --------------------------------

                          const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 42,

                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    getSetController(
                                      index,
                                      controllers.length,
                                    );
                                  });
                                },

                                icon: const Icon(
                                  Icons.add,
                                ),

                                label: const Text(
                                  'Add Set',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ],
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
      )
    );
  }
}