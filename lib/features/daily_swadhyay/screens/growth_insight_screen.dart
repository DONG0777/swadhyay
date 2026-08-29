import 'package:flutter/material.dart';

import '../growth/growth_insight.dart';
import '../growth/growth_insight_service.dart';

class GrowthInsightScreen extends StatefulWidget {
  const GrowthInsightScreen({super.key});

  @override
  State<GrowthInsightScreen> createState() =>
      _GrowthInsightScreenState();
}

class _GrowthInsightScreenState extends State<GrowthInsightScreen> {
  final GrowthInsightService _service = GrowthInsightService();

  GrowthInsight? _insight;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInsight();
  }

  Future<void> _loadInsight() async {
    try {
      final insight = await _service.getSevenDayInsight();

      if (!mounted) {
        return;
      }

      setState(() {
        _insight = insight;
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
          content: Text('Growth Insight লোড করা যায়নি: $error'),
        ),
      );
    }
  }

  Widget _metric(
    BuildContext context,
    String label,
    String value,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insight = _insight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('৭ দিনের Growth Insight'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : insight == null
              ? const Center(
                  child: Text('Insight পাওয়া যায়নি।'),
                )
              : RefreshIndicator(
                  onRefresh: _loadInsight,
                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          insight.headline,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          insight.detail,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _metric(
                              context,
                              'মোট সংকল্প',
                              insight.totalCommitments.toString(),
                            ),
                            const SizedBox(width: 8),
                            _metric(
                              context,
                              'সম্পন্ন',
                              insight.completedCommitments.toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _metric(
                              context,
                              'অসম্পন্ন',
                              insight.missedCommitments.toString(),
                            ),
                            const SizedBox(width: 8),
                            _metric(
                              context,
                              'Reflection',
                              insight.reflectionCount.toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.insights_outlined,
                            ),
                            title: const Text('সফলতার হার'),
                            trailing: Text(
                              '${insight.completionRate.toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.self_improvement_outlined,
                            ),
                            title: const Text(
                              'Reflection coverage',
                            ),
                            subtitle: const Text(
                              'যে দিন সংকল্প ছিল, তার মধ্যে কত দিনে আত্ম-বিশ্লেষণ হয়েছে',
                            ),
                            trailing: Text(
                              '${insight.reflectionRate.toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'এই insight তোমার নিজের data থেকে তৈরি।',
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
