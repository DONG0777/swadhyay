import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';
import '../models/community_place.dart';
import 'community_routine_screen.dart';
import 'community_sessions_screen.dart';

class CommunityCenterHomeScreen extends StatelessWidget {
  final CommunityPlace place;

  const CommunityCenterHomeScreen({
    required this.place,
    super.key,
  });

  void _openRoutine(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunityRoutineScreen(
          place: place,
        ),
      ),
    );
  }

  void _openSessions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CommunitySessionsScreen(
          placeId: place.id,
        ),
      ),
    );
  }

  Widget _buildActionCard({
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
            title: Text(place.name),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              32,
            ),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(place.address),
                      if (place.description != null) ...[
                        const SizedBox(height: 8),
                        Text(place.description!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context: context,
                icon: Icons.schedule_outlined,
                title: strings.communityRoutineLabel,
                subtitle: strings.communitySubtitle,
                onTap: () => _openRoutine(context),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context: context,
                icon: Icons.event_available_outlined,
                title: strings.communitySessions,
                subtitle: strings.communitySessionsSubtitle,
                onTap: () => _openSessions(context),
              ),
            ],
          ),
        );
      },
    );
  }
}