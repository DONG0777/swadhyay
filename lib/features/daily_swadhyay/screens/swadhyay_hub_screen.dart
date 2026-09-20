import 'package:flutter/material.dart';

import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_strings.dart';
import '../services/daily_commitment_service.dart';
import '../services/daily_reflection_service.dart';

import '../../learning/screens/learning_screen.dart';
import '../../user_context/screens/user_context_screen.dart';
import 'daily_commitment_screen.dart';
import 'daily_history_screen.dart';
import 'daily_reflection_screen.dart';
import 'growth_insight_screen.dart';

class SwadhyayHubScreen extends StatefulWidget {
  const SwadhyayHubScreen({super.key});

  @override
  State<SwadhyayHubScreen> createState() => _SwadhyayHubScreenState();
}

class _SwadhyayHubScreenState extends State<SwadhyayHubScreen> {

  final DailyCommitmentService _commitmentService =
      DailyCommitmentService();
  final DailyReflectionService _reflectionService =
      DailyReflectionService();

  _NextActionState _nextActionState = _NextActionState.loading;

  @override
  void initState() {
    super.initState();
    _loadNextAction();
  }

  Future<void> _loadNextAction() async {
    try {
      final commitment = await _commitmentService.getTodayCommitment();

      if (!mounted) {
        return;
      }

      if (commitment == null) {
        setState(() {
          _nextActionState = _NextActionState.startCommitment;
        });
        return;
      }

      if (!commitment.isCompleted) {
        setState(() {
          _nextActionState = _NextActionState.continueCommitment;
        });
        return;
      }

      final reflection = await _reflectionService.getTodayReflection();

      if (!mounted) {
        return;
      }

      setState(() {
        _nextActionState = reflection == null
            ? _NextActionState.writeReflection
            : _NextActionState.completed;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _nextActionState = _NextActionState.unavailable;
      });
    }
  }

  void _openNextAction(BuildContext context) {
    switch (_nextActionState) {
      case _NextActionState.startCommitment:
      case _NextActionState.continueCommitment:
        _openDailyCommitment(context);
        break;
      case _NextActionState.writeReflection:
        _openDailyReflection(context);
        break;
      case _NextActionState.completed:
        _openDailyHistory(context);
        break;
      case _NextActionState.loading:
      case _NextActionState.unavailable:
        break;
    }
  }

  Widget _buildNextActionCard(
    BuildContext context,
    AppStrings strings,
  ) {
    if (_nextActionState == _NextActionState.loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
      );
    }

    if (_nextActionState == _NextActionState.unavailable) {
      return const SizedBox.shrink();
    }

    late final String title;
    late final String subtitle;
    late final IconData icon;

    switch (_nextActionState) {
      case _NextActionState.startCommitment:
        title = strings.todaysCommitment;
        subtitle = strings.todaysCommitmentSubtitle;
        icon = Icons.play_circle_outline;
        break;
      case _NextActionState.continueCommitment:
        title = strings.todaysCommitment;
        subtitle = strings.todaysCommitmentSubtitle;
        icon = Icons.arrow_forward_rounded;
        break;
      case _NextActionState.writeReflection:
        title = strings.nightReflection;
        subtitle = strings.nightReflectionSubtitle;
        icon = Icons.edit_note_rounded;
        break;
      case _NextActionState.completed:
        title = strings.myJourney;
        subtitle = strings.myJourneySubtitle;
        icon = Icons.check_circle_outline_rounded;
        break;
      case _NextActionState.loading:
      case _NextActionState.unavailable:
        return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openNextAction(context),
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
              _buildNextActionCard(context, strings),
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
enum _NextActionState {
  loading,
  startCommitment,
  continueCommitment,
  writeReflection,
  completed,
  unavailable,
}
