import 'package:flutter/material.dart';

import '../../../core/localization/app_strings.dart';

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
  String? _loadedLanguageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final languageCode = Localizations.localeOf(context).languageCode;

    if (_loadedLanguageCode != languageCode) {
      _loadedLanguageCode = languageCode;
      _loadInsight(languageCode);
    }
  }

  Future<void> _loadInsight([String? languageCode]) async {
    final resolvedLanguageCode = languageCode ??
        Localizations.localeOf(context).languageCode;
    try {
      final insight = await _service.getSevenDayInsight(
        languageCode: resolvedLanguageCode,
      );

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
          content: Text(AppStrings.of(context).growthInsightLoadFailed(error)),
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
        title: Text(AppStrings.of(context).sevenDayGrowthInsightTitle),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : insight == null
              ? Center(
                  child: Text(AppStrings.of(context).growthInsightNotFound),
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
                              AppStrings.of(context).totalCommitments,
                              insight.totalCommitments.toString(),
                            ),
                            const SizedBox(width: 8),
                            _metric(
                              context,
                              AppStrings.of(context).completed,
                              insight.completedCommitments.toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _metric(
                              context,
                              AppStrings.of(context).missed,
                              insight.missedCommitments.toString(),
                            ),
                            const SizedBox(width: 8),
                            _metric(
                              context,
                              AppStrings.of(context).reflectionMetric,
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
                            title: Text(AppStrings.of(context).successRate),
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
                            title: Text(AppStrings.of(context).reflectionCoverage),
                            subtitle: Text(AppStrings.of(context).reflectionCoverageDescription),
                            trailing: Text(
                              '${insight.reflectionRate.toStringAsFixed(0)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(AppStrings.of(context).insightPersonalDataDescription),
                      ],
                    ),
                  ),
                ),
    );
  }
}
