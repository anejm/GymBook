import 'package:flutter/material.dart';

import '../../../models/exercise.dart';

class ExercisePickerSheet extends StatefulWidget {
  final List<Exercise> exercises;
  final List<Exercise> excludedExercises;
  final String title;

  const ExercisePickerSheet({
    super.key,
    required this.exercises,
    this.excludedExercises = const [],
    required this.title,
  });

  @override
  State<ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState
    extends State<ExercisePickerSheet> {

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final excludedIds = widget.excludedExercises
        .map((exercise) => exercise.id)
        .toSet();

    final filteredExercises = widget.exercises.where((exercise) {
      final matchesSearch = exercise.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final isExcluded = excludedIds.contains(exercise.id);

      return matchesSearch && !isExcluded;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
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
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search exercises',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredExercises.isEmpty
                ? const Center(
                    child: Text('No exercises found'),
                  )
                : ListView.builder(
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise =
                          filteredExercises[index];

                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.fitness_center),
                        ),
                        title: Text(exercise.name),
                        subtitle: Text(
                          exercise.primaryMuscle,
                        ),
                        onTap: () {
                          Navigator.pop(
                            context,
                            exercise,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}