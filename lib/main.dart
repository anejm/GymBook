import 'package:flutter/material.dart';

import 'screens/login/login_page.dart';
import 'screens/home/home_page.dart';
import 'screens/login/login_form_page.dart';
import 'screens/login/register_page.dart';
import 'functions/auth_gate.dart';

import 'screens/workout/workout_setup_page.dart';
//import 'screens/workout/active_workout_page.dart';
//import 'screens/workout/workout_summary_page.dart';
import 'package:flutter/services.dart';

import 'screens/history/history_page.dart';
//import 'screens/history/workout_details_page.dart';
//import 'screens/history/exercise_details_page.dart';

import 'screens/insights/insights_page.dart';
import 'screens/calendar/calendar_page.dart';
import 'screens/profile/profile_page.dart';

import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const FitnessApp());
  });
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'GymBook',

      theme: AppTheme.lightTheme,
      home: const AuthGate(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/login/form': (context) => const LoginFormPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),

        '/workout/setup': (context) => const WorkoutSetupPage(),
        //'/workout/active': (context) => const ActiveWorkoutPage(),
        //'/workout/summary': (context) => const WorkoutSummaryPage(),

        '/history': (context) => const HistoryPage(),
        //'/history/details': (context) => const WorkoutDetailsPage(),
        //'/history/exercise': (context) => const ExerciseDetailsPage(),

        '/insights': (context) => const InsightsPage(),

        '/calendar': (context) => const CalendarPage(),

        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}