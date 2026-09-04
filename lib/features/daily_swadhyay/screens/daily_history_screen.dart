import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';

import '../history/daily_history.dart';
import '../history/daily_history_service.dart';

class DailyHistoryScreen extends StatefulWidget {
  const DailyHistoryScreen({super.key});

  @override
  State<DailyHistoryScreen> createState() => _DailyHistoryScreenState();
}

class _DailyHistoryScreenState extends State<DailyHistoryScreen> {
  final DailyHistoryService _service = DailyHistoryService();

  List<DailyHistoryItem> _history = [];
  DailyHistorySummary? _summary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final results = await Future.wait([
        _service.getRecentHistory(days: 30),
        _service.getRecentSummary(days: 30),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _history = results[0] as List<DailyHistoryItem>;
        _summary = results[1] as DailyHistorySummary;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.of(context).dailyHistoryLoadFailed(error)),
        ),
      );
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final months = AppStrings.of(context).monthNames;

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _summaryCard(
    BuildContext context,
    String title,
    String value,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusIcon(String status) {
    if (status == 'completed') {
      return const Icon(Icons.check_circle_outline);
    }

    if (status == 'missed') {
      return const Icon(Icons.event_busy_outlined);
    }

    return const Icon(Icons.schedule_outlined);
  }

  String _statusText(BuildContext context, String status) {
    switch (status) {
      case 'completed':
        return AppStrings.of(context).completed;
      case 'missed':
        return AppStrings.of(context).missed;
      default:
        return AppStrings.of(context).dailyCommitmentInProgress;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).myJourney),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadHistory,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.of(context).myLast30Days,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.of(context).journeyDescription,
                    ),
                    const SizedBox(height: 20),
                    if (summary != null) ...[
                      Row(
                        children: [
                          _summaryCard(
                            context,
                            AppStrings.of(context).totalCommitments,
                            summary.totalCommitments.toString(),
                          ),
                          const SizedBox(width: 8),
                          _summaryCard(
                            context,
                            AppStrings.of(context).completed,
                            summary.completedCommitments.toString(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _summaryCard(
                            context,
                            AppStrings.of(context).missed,
                            summary.missedCommitments.toString(),
                          ),
                          const SizedBox(width: 8),
                          _summaryCard(
                            context,
                            AppStrings.of(context).reflections,
                            summary.totalReflections.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.insights_outlined),
                          title: Text(AppStrings.of(context).successRate),
                          trailing: Text(
                            '${summary.completionRate.toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Text(
                      AppStrings.of(context).dayByDayJourney,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    if (_history.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'এখনও কোনো দৈনিক সংকল্পের ইতিহাস তৈরি হয়নি।',
                          ),
                        ),
                      )
                    else
                      ..._history.map(
                        (item) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2),
                                  child: _statusIcon(
                                    item.commitment.status,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(context, item.commitment.commitmentDate),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.commitment.commitmentText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _statusText(
                                          context,
                                          item.commitment.status,
                                        ),
                                      ),
                                      if (item.hasReflection) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          AppStrings.of(context).reflectionAvailable,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
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


