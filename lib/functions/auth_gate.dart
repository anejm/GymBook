// auth_gate.dart
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../screens/home/home_page.dart';
import '../screens/login/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        return isLoggedIn ? const HomePage() : const LoginPage();
      },
    );
  }
}