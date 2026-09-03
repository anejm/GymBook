import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/workout_draft_service.dart';
import '../cache/exercise_cache.dart';

import '../screens/home/home_page.dart';
import '../screens/login/login_page.dart';
import '../screens/workout/active_workout_page.dart';
import '../models/exercise.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool loading = true;
  Widget? page;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final isLoggedIn = await AuthService.isLoggedIn();

    if (!isLoggedIn) {
      if (!mounted) return;

      setState(() {
        page = const LoginPage();
        loading = false;
      });

      return;
    }

    final draft = await WorkoutDraftService.loadDraft();

    // No active workout
    if (draft == null) {
      if (!mounted) return;

      setState(() {
        page = const HomePage();
        loading = false;
      });

      return;
    }

    final exerciseCache = ExerciseCache.instance;

    if (exerciseCache.exercises.isEmpty) {
      await exerciseCache.load();
    }

    final savedExercises =
        draft['exercises'] as List<dynamic>?;

    if (savedExercises == null) {
      await WorkoutDraftService.clearDraft();

      if (!mounted) return;

      setState(() {
        page = const HomePage();
        loading = false;
      });

      return;
    }

    final exercises = <Exercise>[];

    final initialSets =
        <String, List<Map<String, String>>>{};

    for (final savedExercise in savedExercises) {
      final exerciseId =
          savedExercise['exerciseId'].toString();

      final matchingExercises =
          exerciseCache.exercises.where(
        (exercise) =>
            exercise.id.toString() == exerciseId,
      );

      if (matchingExercises.isEmpty) {
        continue;
      }

      final exercise = matchingExercises.first;

      exercises.add(exercise);

      final savedSets =
          savedExercise['sets'] as List<dynamic>?;

      if (savedSets == null) continue;

      initialSets[exerciseId] =
          savedSets.map<Map<String, String>>((set) {
        return {
          'reps': set['reps']?.toString() ?? '',
          'weight': set['weight']?.toString() ?? '',
        };
      }).toList();
    }

    final startedAtString =
        draft['startedAt']?.toString();

    final startedAt = startedAtString != null
        ? DateTime.tryParse(startedAtString)
        : null;

    if (exercises.isEmpty || startedAt == null) {
      await WorkoutDraftService.clearDraft();

      if (!mounted) return;

      setState(() {
        page = const HomePage();
        loading = false;
      });

      return;
    }

    final workoutPage = ActiveWorkoutPage(
      workoutName:
          draft['workoutName']?.toString() ?? 'Workout',
      exercises: exercises,
      startedAt: startedAt,
      initialSets: initialSets,
    );

    if (!mounted) return;

    // Najprej pokažemo HomePage.
    setState(() {
      page = const HomePage();
      loading = false;
    });

    // Nato odpremo active workout nad HomePage.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => workoutPage,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return page ?? const LoginPage();
  }
}