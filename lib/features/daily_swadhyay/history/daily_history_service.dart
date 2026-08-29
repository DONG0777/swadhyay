import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/daily_commitment.dart';
import '../models/daily_reflection.dart';
import 'daily_history.dart';

class DailyHistoryService {
  final SupabaseClient _client;

  DailyHistoryService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<DailyHistoryItem>> getRecentHistory({
    int days = 30,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return [];
    }

    if (days <= 0) {
      throw ArgumentError('Days must be greater than zero.');
    }

    final today = _dateOnly(DateTime.now());
    final startDate = _dateOnly(
      DateTime.now().subtract(Duration(days: days - 1)),
    );

    final commitmentRows = await _client
        .from('daily_commitments')
        .select()
        .eq('user_id', user.id)
        .gte('commitment_date', startDate)
        .lte('commitment_date', today)
        .order('commitment_date', ascending: false);

    final reflectionRows = await _client
        .from('daily_reflections')
        .select()
        .eq('user_id', user.id)
        .gte('reflection_date', startDate)
        .lte('reflection_date', today)
        .order('reflection_date', ascending: false);

    final reflections = <String, DailyReflection>{};

    for (final row in reflectionRows) {
      final reflection = DailyReflection.fromMap(row);
      reflections[reflection.commitmentId] = reflection;
    }

    final items = <DailyHistoryItem>[];

    for (final row in commitmentRows) {
      final commitment = DailyCommitment.fromMap(row);

      items.add(
        DailyHistoryItem(
          commitment: commitment,
          reflection: reflections[commitment.id],
        ),
      );
    }

    return items;
  }

  Future<DailyHistorySummary> getRecentSummary({
    int days = 30,
  }) async {
    final history = await getRecentHistory(days: days);

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

    return DailyHistorySummary(
      totalCommitments: history.length,
      completedCommitments: completed,
      missedCommitments: missed,
      totalReflections: reflections,
    );
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
