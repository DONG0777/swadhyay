import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';

import '../../learning/screens/learning_screen.dart';
import '../../user_context/screens/user_context_screen.dart';
import 'daily_commitment_screen.dart';
import 'daily_history_screen.dart';
import 'daily_reflection_screen.dart';
import 'growth_insight_screen.dart';

class SwadhyayHubScreen extends StatelessWidget {
  const SwadhyayHubScreen({super.key});

  void _openLearning(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const LearningScreen(),
      ),
    );
  }

  void _openUserContext(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const UserContextScreen(),
      ),
    );
  }

  void _openDailyCommitment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DailyCommitmentScreen(),
      ),
    );
  }

  void _openDailyReflection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DailyReflectionScreen(),
      ),
    );
  }

  void _openGrowthInsight(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const GrowthInsightScreen(),
      ),
    );
  }

  void _openDailyHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DailyHistoryScreen(),
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
            title: Text(strings.swadhyayHubTitle),
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
                  child: Text(
                    strings.swadhyayHubSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context: context,
                icon: Icons.menu_book_outlined,
                title: strings.learning,
                subtitle: strings.learningSubtitle,
                onTap: () => _openLearning(context),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context: context,
                icon: Icons.explore_outlined,
                title: strings.startMySwadhyay,
                subtitle: strings.startMySwadhyaySubtitle,
                onTap: () => _openUserContext(context),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context: context,
                icon: Icons.flag_outlined,
                title: strings.todaysCommitment,
                subtitle: strings.todaysCommitmentSubtitle,
                onTap: () => _openDailyCommitment(context),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context: context,
                icon: Icons.self_improvement_outlined,
                title: strings.nightReflection,
                subtitle: strings.nightReflectionSubtitle,
                onTap: () => _openDailyReflection(context),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context: context,
                icon: Icons.auto_graph_outlined,
                title: strings.swadhyayProgress,
                subtitle: strings.growthInsightSubtitle,
                onTap: () => _openGrowthInsight(context),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context: context,
                icon: Icons.insights_outlined,
                title: strings.myJourney,
                subtitle: strings.myJourneySubtitle,
                onTap: () => _openDailyHistory(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
