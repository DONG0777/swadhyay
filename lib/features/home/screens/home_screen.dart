import 'package:flutter/material.dart';

import '../../admin/screens/admin_dashboard_screen.dart';
import '../../admin/services/admin_service.dart';
import '../../auth/services/auth_service.dart';
import '../../profile/screens/profile_screen.dart';
import '../../surya_namaskar/screens/surya_namaskar_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _authService = AuthService();

  Future<void> _signOut() {
    return _authService.signOut();
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  void _openSuryaNamaskar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SuryaNamaskarScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final email = user?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swadhyay'),
        actions: [
          IconButton(
            onPressed: () => _openProfile(context),
            tooltip: 'My Profile',
            icon: const Icon(Icons.person_outline),
          ),
          FutureBuilder<bool>(
            future: AdminService().isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.data != true) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AdminDashboardScreen(),
                    ),
                  );
                },
                tooltip: 'Admin Dashboard',
                icon: const Icon(Icons.admin_panel_settings_outlined),
              );
            },
          ),
          IconButton(
            onPressed: _signOut,
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openSuryaNamaskar(context),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wb_sunny_outlined,
                          size: 36,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'সূর্য নমস্কার',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '১২ ধাপে সূর্য নমস্কার শিখুন',
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Your Swadhyay journey starts here.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
