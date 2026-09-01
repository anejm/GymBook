import 'package:flutter/material.dart';

import '../../cache/profile_cache.dart';
import '../../cache/workout_cache.dart';
import '../../cache/exercise_cache.dart';
import '../../services/auth_service.dart';
import '../../temp_data/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final cache = ProfileCache.instance;

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

  Future<void> logout() async {
    await AuthService.logout();
    CurrentUser.clear();
    WorkoutCache.instance.clear();
    ExerciseCache.instance.clear();
    ProfileCache.instance.clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = cache.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 45),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              cache.isLoading
                  ? 'Loading...'
                  : profile?.fullName ?? 'Unknown',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          if (cache.error != null)
            Center(
              child: TextButton(
                onPressed: cache.refresh,
                child: const Text('Retry loading profile'),
              ),
            ),

          const SizedBox(height: 32),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Personal Information'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/profile/personal_info',
                  );
                },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/profile/settings'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton(
            onPressed: logout,
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}