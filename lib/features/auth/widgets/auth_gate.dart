import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final session = snapshot.data?.session;

        if (session == null) {
          return const LoginScreen();
        }

        return const Scaffold(
          body: Center(
            child: Text('Authenticated'),
          ),
        );
      },
    );
  }
}
