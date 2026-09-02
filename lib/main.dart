import 'package:flutter/material.dart';

import 'screens/login/login_page.dart';
import 'screens/home/home_page.dart';
import 'screens/login/login_form_page.dart';
import 'screens/login/register_page.dart';
import 'screens/profile/settings.dart';
import 'functions/auth_gate.dart';

import 'screens/workout/workout_setup_page.dart';
//import 'screens/workout/active_workout_page.dart';
//import 'screens/workout/workout_summary_page.dart';
import 'package:flutter/services.dart';

import 'screens/history/history_page.dart';
//import 'screens/history/workout_details_page.dart';
//import 'screens/history/exercise_details_page.dart';
import 'cache/settings_cache.dart';

import 'screens/insights/insights_page.dart';
import 'screens/calendar/calendar_page.dart';
import 'screens/profile/profile_page.dart';
import 'screens/profile/personal_info.dart';

import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SettingsCache.instance.load();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const FitnessApp());
}

class FitnessApp extends StatefulWidget {
  const FitnessApp({super.key});

  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  final cache = SettingsCache.instance;

  void _onUpdate() => setState(() {});

  @override
  void initState() {
    super.initState();
    cache.addListener(_onUpdate);
  }

  @override
  void dispose() {
    cache.removeListener(_onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'GymBook',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: SettingsCache.instance.darkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(SettingsCache.instance.textScale),
        ),
        child: child!,
      ),
      home: const AuthGate(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/login/form': (context) => const LoginFormPage(),
        '/register': (context) => const RegisterPage(),

        '/home': (context) => const HomePage(),

        '/workout/setup': (context) => const WorkoutSetupPage(),

        '/calendar': (context) => const CalendarPage(),

        '/profile/personal_info': (context) => PersonalInfoPage(),
        '/profile/settings': (context) => SettingsPage(),
      },
    );
  }
}