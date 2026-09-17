import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';

import '../../admin/screens/admin_dashboard_screen.dart';
import '../../admin/services/admin_service.dart';
import '../../auth/services/auth_service.dart';
import '../../community/screens/community_home_screen.dart';
import '../../daily_swadhyay/screens/swadhyay_hub_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/services/profile_service.dart';
import '../../surya_namaskar/screens/surya_namaskar_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  Future<void> _signOut() {
    return _authService.signOut();
  }

  Future<void> _changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    final controller = AppLanguageController.instance;

    if (controller.languageCode == languageCode) {
      return;
    }

    final previousLanguage = controller.languageCode;

    controller.setLanguage(languageCode);

    try {
      await _profileService.updateLanguageCode(languageCode);
    } catch (_) {
      controller.setLanguage(previousLanguage);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Language could not be saved.'),
          ),
        );
      }
    }
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






  void _openCommunity(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CommunityHomeScreen(),
      ),
    );
  }



  void _openSwadhyayHub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SwadhyayHubScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final languageController = AppLanguageController.instance;
    final user = _authService.currentUser;
    final email = user?.email ?? strings.userFallback;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swadhyay'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: languageController.languageCode,
              items: const [
                DropdownMenuItem(
                  value: 'bn',
                  child: Text('বাংলা'),
                ),
                DropdownMenuItem(
                  value: 'hi',
                  child: Text('हिन्दी'),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                _changeLanguage(context, value);
              },
            ),
          ),
          IconButton(
            onPressed: () => _openProfile(context),
            tooltip: strings.myProfile,
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
                tooltip: strings.adminDashboard,
                icon: const Icon(
                  Icons.admin_panel_settings_outlined,
                ),
              );
            },
          ),
          IconButton(
            onPressed: _signOut,
            tooltip: strings.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.welcome,
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wb_sunny_outlined,
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.suryaNamaskar,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(strings.suryaNamaskarSubtitle),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),




                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openSwadhyayHub(context),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_stories_outlined,
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.swadhyayHubTitle,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(strings.swadhyayHubSubtitle),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),                Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openCommunity(context),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            size: 36,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.community,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(strings.communitySubtitle),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
