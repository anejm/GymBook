import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          const CircleAvatar(
            radius: 45,

            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'Your Name',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),
          ),

          const SizedBox(height: 32),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Personal Information'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              trailing: const Icon(Icons.chevron_right),

              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/calendar',
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },

            child: const Text(
              'Logout',
            ),
          ),
        ],
      ),
    );
  }
}