import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/localization/app_strings.dart';

import '../history/daily_history_service.dart';
import 'growth_insight.dart';

class GrowthInsightService {
  final DailyHistoryService _historyService;

  GrowthInsightService({SupabaseClient? client})
      : _historyService = DailyHistoryService(client: client);

  Future<GrowthInsight> getSevenDayInsight({String languageCode = 'bn'}) async {
    final history = await _historyService.getRecentHistory(days: 7);
    final strings = AppStrings.forLanguage(languageCode);

    var completed = 0;
    var missed = 0;
    var reflections = 0;

    for (final item in history) {
      if (item.commitment.status == 'completed') {
        completed++;
      } else if (item.commitment.status == 'missed') {
        missed++;
      }

      if (item.hasReflection) {
        reflections++;
      }
    }

    final resolvedCommitments = completed + missed;

    final completionRate = resolvedCommitments == 0
        ? 0.0
        : (completed / resolvedCommitments) * 100;

    final reflectionRate = resolvedCommitments == 0
        ? 0.0
        : (reflections / resolvedCommitments) * 100;

    final message = _buildMessage(
      strings: strings,
      total: resolvedCommitments,
      completed: completed,
      missed: missed,
      reflections: reflections,
      completionRate: completionRate,
    );

    return GrowthInsight(
      totalCommitments: resolvedCommitments,
      completedCommitments: completed,
      missedCommitments: missed,
      reflectionCount: reflections,
      completionRate: completionRate,
      reflectionRate: reflectionRate,
      headline: message.$1,
      detail: message.$2,
    );
  }

  (String, String) _buildMessage({
    required AppStrings strings,
    required int total,
    required int completed,
    required int missed,
    required int reflections,
    required double completionRate,
  }) {
    if (total == 0) {
      return (
        strings.growthInsightNoDataHeadline,
        strings.growthInsightNoDataDetail,
      );
    }

    if (total < 3) {
      return (
        strings.growthInsightStartedHeadline,
        strings.growthInsightStartedDetail,
      );
    }

    if (completionRate >= 80 && missed == 0) {
      return (
        strings.growthInsightConsistencyHeadline,
        strings.growthInsightConsistencyDetail,
      );
    }

    if (completionRate >= 60) {
      return (
        strings.growthInsightFoundationHeadline,
        strings.growthInsightFoundationDetail,
      );
    }

    if (missed > completed) {
      return (
        strings.growthInsightSmallerHeadline,
        strings.growthInsightSmallerDetail,
      );
    }

    if (reflections == 0) {
      return (
        strings.growthInsightReflectionHeadline,
        strings.growthInsightReflectionDetail,
      );
    }

    return (
      strings.growthInsightMindfulHeadline,
      strings.growthInsightMindfulDetail,
    );
  }
}
