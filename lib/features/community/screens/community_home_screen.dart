import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';
import 'community_places_screen.dart';
import 'community_sessions_screen.dart';
import 'my_community_screen.dart';

class CommunityHomeScreen extends StatelessWidget {
  const CommunityHomeScreen({super.key});

  void _openMyCommunity(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const MyCommunityScreen(),
      ),
    );
  }

  void _openCommunityPlaces(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CommunityPlacesScreen(),
      ),
    );
  }

  void _openCommunitySessions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CommunitySessionsScreen(),
      ),
    );
  }

  Widget _buildCommunityCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageController.instance,
      builder: (context, _) {
        final strings = AppStrings.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(strings.community),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              32,
            ),
            children: [
              _buildCommunityCard(
                context: context,
                icon: Icons.groups_outlined,
                title: strings.myCommunities,
                subtitle: strings.myCommunitiesSubtitle,
                onTap: () => _openMyCommunity(context),
              ),
              const SizedBox(height: 16),
              _buildCommunityCard(
                context: context,
                icon: Icons.explore_outlined,
                title: strings.discoverCommunities,
                subtitle: strings.discoverCommunitiesSubtitle,
                onTap: () => _openCommunityPlaces(context),
              ),
              const SizedBox(height: 16),
              _buildCommunityCard(
                context: context,
                icon: Icons.event_outlined,
                title: strings.communitySessions,
                subtitle: strings.communitySessionsSubtitle,
                onTap: () => _openCommunitySessions(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
