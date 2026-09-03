import 'package:flutter/material.dart';
import 'dart:async';

import '../../functions/format_time.dart';
import '../../cache/exercise_cache.dart';

import '../../models/exercise.dart';
import '../../models/workout_details.dart';
import '../../services/workout_service.dart';
import '../../temp_data/user.dart';

import 'workout_summary_page.dart';
//import 'workout_setup_page.dart';
import '../../widgets/exercise_picker_sheet.dart';
import '../../services/workout_draft_service.dart';
import '../../services/workout_notification_service.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final String workoutName;
  final List<Exercise> exercises;
  final DateTime? startedAt;
  final Map<String, List<Map<String, String>>>? initialSets;

  const ActiveWorkoutPage({
    super.key,
    required this.workoutName,
    required this.exercises,
    this.startedAt,
    this.initialSets,
  });

  @override
  State<ActiveWorkoutPage> createState() =>
      _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState
    extends State<ActiveWorkoutPage>  with WidgetsBindingObserver {

  final Map<String, List<TextEditingController>> setControllers = {};
  final Map<String, List<TextEditingController>> weightControllers = {};

  late List<Exercise> exercises;

  Timer? workoutTimer;
  DateTime? workoutStartedAt;
  int seconds = 0;
  int? expandedExerciseIndex;
  final exerciseCache = ExerciseCache.instance;

  String exerciseKey(Exercise exercise) {
    return exercise.id.toString();
  }

  TextEditingController getSetController(
    Exercise exercise,
    int setIndex,
  ) {
    final key = exerciseKey(exercise);

    final controllers = setControllers.putIfAbsent(
      key,
      () => [],
    );

    while (controllers.length <= setIndex) {
      controllers.add(TextEditingController());
    }

    return controllers[setIndex];
  }

  TextEditingController getWeightController(
    Exercise exercise,
    int setIndex,
  ) {
    final key = exerciseKey(exercise);

    final controllers = weightControllers.putIfAbsent(
      key,
      () => [],
    );

    while (controllers.length <= setIndex) {
      controllers.add(TextEditingController());
    }

    return controllers[setIndex];
  }

  void updateWorkoutTime() {
    if (workoutStartedAt == null) return;

    final elapsed = DateTime.now().difference(workoutStartedAt!);

    if (!mounted) return;

    setState(() {
      seconds = elapsed.inSeconds;
    });
  }

  Future<void> removeExercise(int index) async {
    final exercise = exercises[index];
    final key = exerciseKey(exercise);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove exercise?'),
          content: Text(
            'Remove ${exercise.name} from this workout?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final reps = setControllers.remove(key);
    final weights = weightControllers.remove(key);

    for (final controller in reps ?? []) {
      controller.dispose();
    }

    for (final controller in weights ?? []) {
      controller.dispose();
    }

    setState(() {
      exercises.removeAt(index);

      if (expandedExerciseIndex == index) {
        expandedExerciseIndex = null;
      } else if (expandedExerciseIndex != null &&
          expandedExerciseIndex! > index) {
        expandedExerciseIndex =
            expandedExerciseIndex! - 1;
      }
    });
    await saveDraft();
  }

  Future<void> replaceExercise(int index) async {
    final currentExercise = exercises[index];

    final selectedExercise =
        await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ExercisePickerSheet(
          title: 'Replace Exercise',
          exercises: exerciseCache.exercises,
          excludedExercises: exercises,
        );
      },
    );

    if (selectedExercise == null) return;

    if (selectedExercise.id == currentExercise.id) {
      return;
    }

    final currentKey = exerciseKey(currentExercise);

    final hasSets =
        setControllers[currentKey]?.isNotEmpty ?? false;

    if (hasSets) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Replace exercise?'),
            content: Text(
              'Your entered sets for ${currentExercise.name} '
              'will be removed.',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text('Replace'),
              ),
            ],
          );
        },
      );

      if (confirmed != true) return;
    }

    final reps = setControllers.remove(currentKey);
    final weights = weightControllers.remove(currentKey);

    for (final controller in reps ?? []) {
      controller.dispose();
    }

    for (final controller in weights ?? []) {
      controller.dispose();
    }

    setState(() {
      exercises[index] = selectedExercise;
    });
    await saveDraft();
  }

  Future<void> addExercise() async {
    final selectedExercise =
        await showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ExercisePickerSheet(
          title: 'Add Exercise',
          exercises: exerciseCache.exercises,
          excludedExercises: exercises,
        );
      },
    );

    if (selectedExercise == null) return;

    setState(() {
      exercises.add(selectedExercise);
    });
    await saveDraft();
  }

  Future<void> saveDraft() async {
    if (workoutStartedAt == null) return;

    final exerciseData = exercises.map((exercise) {
      final key = exerciseKey(exercise);

      final reps = setControllers[key] ?? [];
      final weights = weightControllers[key] ?? [];

      return {
        'exerciseId': exercise.id,
        'sets': List.generate(
          reps.length,
          (index) => {
            'reps': reps[index].text,
            'weight': index < weights.length
                ? weights[index].text
                : '',
          },
        ),
      };
    }).toList();

    await WorkoutDraftService.saveDraft(
      workoutName: widget.workoutName,
      startedAt: workoutStartedAt!,
      exercises: exerciseData,
    );
  }

  void restoreSets() {
    if (widget.initialSets == null) return;

    for (final exercise in exercises) {
      final key = exerciseKey(exercise);
      final savedSets = widget.initialSets![key];

      if (savedSets == null) continue;

      for (final savedSet in savedSets) {
        final repsController = getSetController(
          exercise,
          setControllers[key]?.length ?? 0,
        );

        final weightController = getWeightController(
          exercise,
          weightControllers[key]?.length ?? 0,
        );

        repsController.text = savedSet['reps'] ?? '';
        weightController.text = savedSet['weight'] ?? '';
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    exercises = List<Exercise>.from(widget.exercises);

    workoutStartedAt =
        widget.startedAt ?? DateTime.now();

    WorkoutNotificationService.start(
      workoutName: widget.workoutName,
      startedAt: workoutStartedAt!,
    );

    restoreSets();

    updateWorkoutTime();

    workoutTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateWorkoutTime(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveDraft();
    });
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      updateWorkoutTime();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        exerciseIndex < exercises.length;
        exerciseIndex++) {

      final exercise = exercises[exerciseIndex];

      final key = exerciseKey(exercise);

      final reps = setControllers[key] ?? [];
      final weights = weightControllers[key] ?? [];

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
        userId: await CurrentUser.id,
        workout: workout,
      );
      await WorkoutNotificationService.stop();
      await WorkoutDraftService.clearDraft();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutSummaryPage(
            workout: workout,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Napaka pri shranjevanju: $e'),
        ),
      );
    }
  }

  // --------------------------------------------------
  // USE SAME WEIGHT
  // --------------------------------------------------

  void useSameWeight(Exercise exercise) async {
    final key = exerciseKey(exercise);
    final weights = weightControllers[key] ?? [];

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
    await saveDraft();
  }

  void showExerciseMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Replace exercise'),
                onTap: () {
                  Navigator.pop(context);
                  replaceExercise(index);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove exercise'),
                onTap: () {
                  Navigator.pop(context);
                  removeExercise(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final discard = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Discard workout?'),
              content: const Text(
                'Are you sure you want to discard this workout? '
                'All entered sets will be lost.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard'),
                ),
              ],
            );
          },
        );

        if (discard == true && mounted) {
          await WorkoutDraftService.clearDraft();
          await WorkoutNotificationService.stop();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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

                    itemCount: exercises.length,

                    itemBuilder: (context, index) {
                      final exercise =
                          exercises[index];

                      final isExpanded =
                          expandedExerciseIndex == index;

                      final key = exerciseKey(exercise);

                      final controllers = setControllers[key] ?? [];

                      final weights = weightControllers[key] ?? [];

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

                                onLongPress: () {
                                  showExerciseMenu(index);
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
                                    onPressed: () async {
                                      setState(() {
                                        getSetController(
                                          exercise,
                                          controllers.length,
                                        );

                                        getWeightController(
                                          exercise,
                                          controllers.length,
                                        );
                                      });

                                      await saveDraft();
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
                                        useSameWeight(exercise);
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

                                              onChanged: (_) {
                                                saveDraft();
                                              },

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

                                              onChanged: (_) {
                                                saveDraft();
                                              },

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
                                              onPressed: () async {
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
                                                await saveDraft();
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
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: isSaving ? null : addExercise,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Exercise'),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSaving ? null : finishWorkout,
                            child: isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Finish Workout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}