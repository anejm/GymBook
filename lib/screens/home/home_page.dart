import 'package:flutter/material.dart';

import '../history/history_page.dart';
import '../insights/insights_page.dart';
import '../profile/profile_page.dart';
import '../../services/workout_service.dart';
import '../../temp_data/user.dart';
import '../../functions/format_time.dart';
import '../../functions/format_date.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  void goToTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(onGoToHistory: () => goToTab(1)),
      const HistoryPage(),
      const InsightsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: goToTab,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            activeIcon: Icon(Icons.insights),
            label: 'Insights',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onGoToHistory;

  const HomeContent({
    super.key,
    required this.onGoToHistory,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<Map<String, dynamic>?> recentWorkoutFuture;

  @override
  void initState() {
    super.initState();
    recentWorkoutFuture = WorkoutService.getRecentWorkout(
      userId: CurrentUser.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GymBook'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 8),

              Text(
                'Ready for your next workout?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/workout/setup',
                  );
                },

                icon: const Icon(Icons.add),

                label: const Text(
                  'New Workout',
                ),
              ),

              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/calendar',
                  );
                },

                icon: const Icon(Icons.calendar_month),

                label: const Text(
                  'Calendar',
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Recent Workout',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              FutureBuilder<Map<String, dynamic>?>(
                future: recentWorkoutFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.error_outline),
                        ),
                        title: const Text('Failed to load'),
                        subtitle: Text('${snapshot.error}'),
                        onTap: widget.onGoToHistory,
                      ),
                    );
                  }

                  final recent = snapshot.data;

                  if (recent == null) {
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.fitness_center),
                        ),
                        title: const Text(
                          'No workouts yet',
                        ),
                        subtitle: const Text(
                          'Your recent workouts will appear here.',
                        ),
                        onTap: widget.onGoToHistory,
                      ),
                    );
                  }

                  final date = DateTime.parse(recent['started_at']);
                  final duration = recent['duration_seconds'] as int;

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.fitness_center),
                      ),
                      title: Text(recent['name']),
                      subtitle: Text(
                        '${formatDate(date)} • ${formatTime(duration)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: widget.onGoToHistory,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}