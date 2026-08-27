import 'package:flutter/material.dart';
import 'dart:async';

import '../../functions/format_time.dart';

import '../../models/exercise.dart';
import '../../models/workout_details.dart';
import '../../services/workout_service.dart';
import '../../temp_data/user.dart';

import 'workout_summary_page.dart';

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

  // Reps controllers
  final Map<int, List<TextEditingController>> setControllers = {};

  // Weight controllers
  final Map<int, List<TextEditingController>> weightControllers = {};

  Timer? workoutTimer;
  int seconds = 0;
  int? expandedExerciseIndex;

  TextEditingController getSetController(
    int exerciseIndex,
    int setIndex,
  ) {
    final controllers = setControllers.putIfAbsent(
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

  TextEditingController getWeightController(
    int exerciseIndex,
    int setIndex,
  ) {
    final controllers = weightControllers.putIfAbsent(
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

  @override
  void initState() {
    super.initState();

    workoutTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
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

    for (final controllers in weightControllers.values) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }

    super.dispose();
  }

  // --------------------------------------------------
  // CREATE WORKOUT
  // --------------------------------------------------

  Workout createWorkout() {
    final completedExercises = <CompletedExercise>[];

    for (int exerciseIndex = 0;
        exerciseIndex < widget.exercises.length;
        exerciseIndex++) {

      final exercise = widget.exercises[exerciseIndex];

      final reps = setControllers[exerciseIndex] ?? [];
      final weights = weightControllers[exerciseIndex] ?? [];

      final sets = <WorkoutSet>[];

      for (int setIndex = 0;
          setIndex < reps.length;
          setIndex++) {

        final repsText = reps[setIndex].text.trim();
        final weightText = weights[setIndex].text.trim();

        // Ignore completely empty sets
        if (repsText.isEmpty && weightText.isEmpty) {
          continue;
        }

        final repsValue = int.tryParse(repsText);
        final weightValue = double.tryParse(weightText);

        if (repsValue == null) {
          continue;
        }

        sets.add(
          WorkoutSet(
            weight: weightValue ?? 0,
            reps: repsValue,
          ),
        );
      }

      completedExercises.add(
        CompletedExercise(
          exercise: exercise,
          sets: sets,
        ),
      );
    }

    return Workout(
      name: widget.workoutName,
      date: DateTime.now(),
      duration: seconds,
      exercises: completedExercises,
    );
  }

  // --------------------------------------------------
  // FINISH WORKOUT
  // --------------------------------------------------

  bool isSaving = false;

  Future<void> finishWorkout() async {

    if (isSaving) return;

    final workout = createWorkout();

    setState(() {
      isSaving = true;
    });

    try {
      await WorkoutService.saveWorkout(
        userId: CurrentUser.id,
        workout: workout,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutSummaryPage(workout: workout),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Napaka pri shranjevanju: $e')),
      );
    }
  }

  // --------------------------------------------------
  // USE SAME WEIGHT
  // --------------------------------------------------

  void useSameWeight(int exerciseIndex) {
    final weights =
        weightControllers[exerciseIndex] ?? [];

    if (weights.isEmpty) {
      return;
    }

    final firstWeight = weights.first.text;

    if (firstWeight.isEmpty) {
      return;
    }

    setState(() {
      for (final controller in weights) {
        controller.text = firstWeight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workoutName,
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: finishWorkout,
                      icon: const Icon(Icons.check),
                    ),
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
                  final exercise =
                      widget.exercises[index];

                  final isExpanded =
                      expandedExerciseIndex == index;

                  final controllers =
                      setControllers[index] ?? [];

                  final weights =
                      weightControllers[index] ?? [];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        children: [

                          // --------------------------------
                          // EXERCISE HEADER
                          // --------------------------------

                          InkWell(
                            onTap: () {
                              setState(() {
                                if (expandedExerciseIndex ==
                                    index) {
                                  expandedExerciseIndex = null;
                                } else {
                                  expandedExerciseIndex =
                                      index;
                                }
                              });
                            },

                            child: Row(
                              children: [

                                CircleAvatar(
                                  child: Text(
                                    '${index + 1}',
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        exercise.name,
                                        style:
                                            Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                      ),

                                      Text(
                                        exercise.primaryMuscle,
                                        style:
                                            Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  isExpanded
                                      ? Icons
                                          .keyboard_arrow_up
                                      : Icons
                                          .keyboard_arrow_down,
                                ),
                              ],
                            ),
                          ),

                          // --------------------------------
                          // SETS
                          // --------------------------------

                          if (isExpanded) ...[
                            const SizedBox(height: 10),

                            // ADD SET
                            SizedBox(
                              width: double.infinity,
                              height: 30,

                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    getSetController(
                                      index,
                                      controllers.length,
                                    );

                                    getWeightController(
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
                                  style:
                                      TextStyle(fontSize: 14),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // SAME WEIGHT
                            if (weights.isNotEmpty)
                              Align(
                                alignment:
                                    Alignment.centerRight,

                                child: TextButton(
                                  onPressed: () {
                                    useSameWeight(index);
                                  },

                                  child: const Text(
                                    'Use same weight',
                                  ),
                                ),
                              ),

                            // HEADER
                            Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    'Set',
                                    style:
                                        Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    'Weight',
                                    style:
                                        Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    'Reps',
                                    style:
                                        Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                  ),
                                ),

                                const SizedBox(
                                  width: 48,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // SETS
                            ...controllers
                                .asMap()
                                .entries
                                .map(
                              (entry) {
                                final setIndex =
                                    entry.key;

                                final controller =
                                    entry.value;

                                final weightController =
                                    weights[setIndex];

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

                                      // WEIGHT
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              weightController,

                                          keyboardType:
                                              const TextInputType
                                                  .numberWithOptions(
                                            decimal: true,
                                          ),

                                          textInputAction:
                                              TextInputAction.next,

                                          decoration:
                                              InputDecoration(
                                            hintText: 'kg',

                                            hintStyle: TextStyle(
                                              color: Colors.grey.withOpacity(0.4)
                                            ),

                                            isDense: true,

                                            enabledBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(
                                                color: Colors
                                                    .grey
                                                    .shade300,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                10,
                                              ),
                                            ),

                                            focusedBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(
                                                color: Theme.of(
                                                        context)
                                                    .colorScheme
                                                    .primary,

                                                width: 2,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 8,
                                      ),

                                      // REPS
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              controller,

                                          keyboardType:
                                              TextInputType
                                                  .number,

                                          textInputAction:
                                              TextInputAction
                                                  .done,

                                          decoration:
                                              InputDecoration(
                                            hintText: 'Reps',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.withOpacity(0.4)
                                            ),

                                            isDense: true,

                                            enabledBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(
                                                color: Colors
                                                    .grey
                                                    .shade300,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                10,
                                              ),
                                            ),

                                            focusedBorder:
                                                OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(
                                                color: Theme.of(
                                                        context)
                                                    .colorScheme
                                                    .primary,

                                                width: 2,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 4,
                                      ),

                                      // REMOVE
                                      SizedBox(
                                        width: 44,

                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              final removed =
                                                  controllers
                                                      .removeAt(
                                                setIndex,
                                              );

                                              removed.dispose();

                                              final removedWeight =
                                                  weights
                                                      .removeAt(
                                                setIndex,
                                              );

                                              removedWeight
                                                  .dispose();
                                            });
                                          },

                                          icon: const Icon(
                                            Icons.remove,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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

                child: SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: isSaving ? null : finishWorkout,
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Finish Workout'),
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