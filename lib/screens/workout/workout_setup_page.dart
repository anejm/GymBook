import 'package:flutter/material.dart';

//import '../../services/exercise_service.dart';
import '../../models/exercise.dart';
import 'active_workout_page.dart';
//import '../../temp_data/recent_workout_data.dart';
import '../../cache/workout_cache.dart';
import '../../cache/exercise_cache.dart';

//import '../../models/recent_workout.dart';
//import '../../services/workout_service.dart';
//simport '../../temp_data/user.dart';
import '../../functions/format_date.dart';
import '../../models/workout_details.dart';

class WorkoutSetupPage extends StatefulWidget {
  const WorkoutSetupPage({super.key});

  @override
  State<WorkoutSetupPage> createState() =>
      _WorkoutSetupPageState();
}

class _WorkoutSetupPageState extends State<WorkoutSetupPage> {
  final TextEditingController workoutNameController =
      TextEditingController();

  List<Exercise> selectedExercises = [];

  final exerciseCache = ExerciseCache.instance;
  // --------------------------------------------------
  // LOAD EXERCISES
  // --------------------------------------------------

  final cache = WorkoutCache.instance;

  void _onCacheUpdate() => setState((){});

  List<Workout> get recentWorkouts {
  final seenNames = <String>{};
  final deduped = <Workout>[];

  for (final workout in cache.workouts) {
    if (seenNames.add(workout.name)) {
      deduped.add(workout);
    }
  }

  return deduped;
}

  @override
  void initState() {
    super.initState();
    exerciseCache.addListener(_onCacheUpdate);
    cache.addListener(_onCacheUpdate);
  }

  @override
  void dispose() {
    exerciseCache.removeListener(_onCacheUpdate);
    cache.removeListener(_onCacheUpdate);
    super.dispose();
  }

  // --------------------------------------------------
  // DISMISS KEYBOARD
  // --------------------------------------------------

  void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // --------------------------------------------------
  // FORMAT DURATION
  // --------------------------------------------------

  String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    }

    if (duration.inHours > 0) {
      final minutes =
          duration.inMinutes.remainder(60);

      if (minutes == 0) {
        return '${duration.inHours}h';
      }

      return '${duration.inHours}h ${minutes}m';
    }

    return '${duration.inMinutes}m';
  }

  // --------------------------------------------------
  // EXERCISE MENU
  // --------------------------------------------------

  void openExerciseMenu() {
    dismissKeyboard();

    List<Exercise> temporarySelection =
        List.from(selectedExercises);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height:
                  MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Choose Exercises',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium,
                          ),
                        ),
                        Text(
                          '${temporarySelection.length} selected',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // --------------------------------------
                  // EXERCISE LIST
                  // --------------------------------------

                  Expanded(
                    child: cache.isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(),
                          )
                        : cache.error != null
                            ? Center(
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Failed to load exercises',
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          exerciseCache.refresh,
                                      child: const Text(
                                        'Retry',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 16,
                                ),
                                itemCount:
                                    exerciseCache.exercises.length,
                                itemBuilder:
                                    (context, index) {
                                  final exercise =
                                      exerciseCache.exercises[
                                          index];

                                  final isSelected =
                                      temporarySelection
                                          .any(
                                    (selected) =>
                                        selected.id ==
                                        exercise.id,
                                  );

                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        if (isSelected) {
                                          temporarySelection
                                              .removeWhere(
                                            (selected) =>
                                                selected
                                                    .id ==
                                                exercise.id,
                                          );
                                        } else {
                                          temporarySelection
                                              .add(
                                            exercise,
                                          );
                                        }
                                      });
                                    },
                                    child:
                                        AnimatedContainer(
                                      duration:
                                          const Duration(
                                        milliseconds: 150,
                                      ),
                                      margin:
                                          const EdgeInsets
                                              .only(
                                        bottom: 10,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              )
                                                .colorScheme
                                                .primary
                                                .withOpacity(
                                                  0.08,
                                                )
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          14,
                                        ),
                                        border:
                                            Border.all(
                                          color: isSelected
                                              ? Theme.of(
                                                  context,
                                                )
                                                  .colorScheme
                                                  .primary
                                              : Colors.grey
                                                  .shade300,
                                          width:
                                              isSelected
                                                  ? 2
                                                  : 1,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading:
                                            CircleAvatar(
                                          backgroundColor:
                                              isSelected
                                                  ? Theme.of(
                                                      context,
                                                    )
                                                      .colorScheme
                                                      .primary
                                                  : Colors
                                                      .grey
                                                      .shade100,
                                          child: Icon(
                                            Icons
                                                .fitness_center,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors
                                                    .grey
                                                    .shade600,
                                          ),
                                        ),
                                        title: Text(
                                          exercise.name,
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          exercise
                                              .primaryMuscle,
                                        ),
                                        trailing:
                                            AnimatedSwitcher(
                                          duration:
                                              const Duration(
                                            milliseconds:
                                                150,
                                          ),
                                          child: isSelected
                                              ? Icon(
                                                  Icons
                                                      .check_circle,
                                                  key:
                                                      const ValueKey(
                                                    true,
                                                  ),
                                                  color: Theme.of(
                                                    context,
                                                  )
                                                      .colorScheme
                                                      .primary,
                                                )
                                              : Icon(
                                                  Icons
                                                      .circle_outlined,
                                                  key:
                                                      const ValueKey(
                                                    false,
                                                  ),
                                                  color: Colors
                                                      .grey
                                                      .shade400,
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),

                  // --------------------------------------
                  // ADD BUTTON
                  // --------------------------------------

                  SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedExercises =
                                  List.from(
                                temporarySelection,
                              );
                            });

                            Navigator.pop(context);
                          },
                          child: Text(
                            'Add ${temporarySelection.length} Exercises',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------
  // RECENT WORKOUT MENU
  // --------------------------------------------------

  void openRecentWorkoutMenu() {
    dismissKeyboard();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),

                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Workouts',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),

                Expanded(
                  child: cache.error != null && cache.workouts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Failed to load recent workouts'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  cache.refresh();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : recentWorkouts.isEmpty
                          ? const Center(
                              child: Text('No past workouts yet.'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: recentWorkouts.length,
                              itemBuilder: (context, index) {
                                final workout = recentWorkouts[index];

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      child: Icon(Icons.fitness_center),
                                    ),
                                    title: Text(
                                      workout.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${formatDate(workout.date)} • '
                                      '${formatDuration(Duration(seconds: workout.duration))}',
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () {
                                      setState(() {
                                        workoutNameController.text = workout.name;
                                        selectedExercises = workout.exercises
                                            .map((ce) => ce.exercise)
                                            .toList();
                                      });

                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // START WORKOUT
  // --------------------------------------------------

  void startWorkout() {
    final workoutName =
        workoutNameController.text.trim();

    if (workoutName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a workout name.',
          ),
        ),
      );

      return;
    }

    if (selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add at least one exercise.',
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveWorkoutPage(
          workoutName: workoutName,
          exercises:
              List.from(selectedExercises),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Setup'),
      ),
      body: Column(
        children: [
          // ==========================================
          // SCROLLABLE CONTENT
          // ==========================================

          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,

              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,

              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20,
              ),

              // --------------------------------------
              // HEADER
              // --------------------------------------

              header: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Workout',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller:
                        workoutNameController,
                    textInputAction:
                        TextInputAction.done,
                    decoration:
                        const InputDecoration(
                      labelText: 'Workout name',
                      hintText: 'e.g. Push Day',
                      border:
                          OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.edit_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --------------------------------
                  // RECENT WORKOUTS
                  // --------------------------------

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Recent Workouts'),
                      subtitle: Text(
                        cache.isLoading
                            ? 'Loading...'
                            : 'Use a previous workout',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: cache.isLoading ? null : openRecentWorkoutMenu,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --------------------------------
                  // ADD EXERCISES
                  // --------------------------------

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.add_circle_outline,
                      ),
                      title: const Text(
                        'Add Exercises',
                      ),
                      subtitle: Text(
                        selectedExercises.isEmpty
                            ? 'Choose exercises'
                            : '${selectedExercises.length} exercises selected',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap:
                          openExerciseMenu,
                    ),
                  ),

                  if (selectedExercises.isNotEmpty) ...[
                    const SizedBox(height: 20),

                    Text(
                      'Exercises',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),

                    const SizedBox(height: 8),
                  ],
                ],
              ),

              // --------------------------------------
              // EXERCISES
              // --------------------------------------

              itemCount:
                  selectedExercises.length,

              onReorderItem:
                  (oldIndex, newIndex) {
                setState(() {
                  final exercise =
                      selectedExercises
                          .removeAt(oldIndex);

                  selectedExercises.insert(
                    newIndex,
                    exercise,
                  );
                });
              },

              itemBuilder:
                  (context, index) {
                final exercise =
                    selectedExercises[index];

                return Card(
                  key: ValueKey(
                    exercise.id,
                  ),
                  margin:
                      const EdgeInsets.only(
                    bottom: 8,
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
                      exercise.primaryMuscle,
                    ),
                    trailing:
                        ReorderableDragStartListener(
                      index: index,
                      child: const Icon(
                        Icons.drag_handle,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // START WORKOUT
          // ==========================================

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: startWorkout,
                  child: const Text(
                    'Start Workout',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}