import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GYMBOOK',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 12),

              Text(
                'Track your progress',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/home',
                  );
                },
                child: const Text('Continue'),
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {
                  // Login boš dodal kasneje.
                },
                child: const Text('Login'),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  // Google login boš dodal kasneje.
                },
                child: const Text('Continue with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}