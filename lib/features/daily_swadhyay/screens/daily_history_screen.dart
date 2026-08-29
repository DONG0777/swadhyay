import 'package:flutter/material.dart';

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
          content: Text('ইতিহাস লোড করা যায়নি: $error'),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ];

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

  String _statusText(String status) {
    switch (status) {
      case 'completed':
        return 'সম্পন্ন';
      case 'missed':
        return 'অসম্পন্ন';
      default:
        return 'চলমান';
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার যাত্রা'),
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
                      'আমার গত ৩০ দিন',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'নিজের যাত্রাকে দেখুন—তুলনা করার জন্য নয়, বুঝে ওঠার জন্য।',
                    ),
                    const SizedBox(height: 20),
                    if (summary != null) ...[
                      Row(
                        children: [
                          _summaryCard(
                            context,
                            'মোট সংকল্প',
                            summary.totalCommitments.toString(),
                          ),
                          const SizedBox(width: 8),
                          _summaryCard(
                            context,
                            'সম্পন্ন',
                            summary.completedCommitments.toString(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _summaryCard(
                            context,
                            'অসম্পন্ন',
                            summary.missedCommitments.toString(),
                          ),
                          const SizedBox(width: 8),
                          _summaryCard(
                            context,
                            'Reflection',
                            summary.totalReflections.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.insights_outlined),
                          title: const Text('সফলতার হার'),
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
                      'দিনভিত্তিক যাত্রা',
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
                                        _formatDate(
                                          item.commitment.commitmentDate,
                                        ),
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
                                          item.commitment.status,
                                        ),
                                      ),
                                      if (item.hasReflection) ...[
                                        const SizedBox(height: 4),
                                        const Text(
                                          'আত্ম-বিশ্লেষণ আছে',
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
