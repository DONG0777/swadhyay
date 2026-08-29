import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/daily_reflection.dart';

class DailyReflectionService {
  final SupabaseClient _client;

  DailyReflectionService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<DailyReflection?> getReflectionForDate(DateTime date) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final dateOnly = _dateOnly(date);

    final data = await _client
        .from('daily_reflections')
        .select()
        .eq('user_id', user.id)
        .eq('reflection_date', dateOnly)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return DailyReflection.fromMap(data);
  }

  Future<DailyReflection?> getTodayReflection() {
    return getReflectionForDate(DateTime.now());
  }

  Future<DailyReflection> saveReflectionForDate({
    required DateTime date,
    required String commitmentId,
    required bool commitmentCompleted,
    String? egoReflection,
    String? idealGapReflection,
    String? learningReflection,
    String? obstacleReason,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final trimmedObstacle = _nullableText(obstacleReason);

    if (!commitmentCompleted && trimmedObstacle == null) {
      throw ArgumentError(
        'সংকল্প পূরণ না হলে বাধার কারণ লেখা বাধ্যতামূলক।',
      );
    }

    final data = await _client
        .from('daily_reflections')
        .upsert(
          {
            'user_id': user.id,
            'commitment_id': commitmentId,
            'reflection_date': _dateOnly(date),
            'ego_reflection': _nullableText(egoReflection),
            'ideal_gap_reflection': _nullableText(idealGapReflection),
            'learning_reflection': _nullableText(learningReflection),
            'obstacle_reason':
                commitmentCompleted ? null : trimmedObstacle,
          },
          onConflict: 'user_id,reflection_date',
        )
        .select()
        .single();

    return DailyReflection.fromMap(data);
  }

  Future<DailyReflection> saveTodayReflection({
    required String commitmentId,
    required bool commitmentCompleted,
    String? egoReflection,
    String? idealGapReflection,
    String? learningReflection,
    String? obstacleReason,
  }) {
    return saveReflectionForDate(
      date: DateTime.now(),
      commitmentId: commitmentId,
      commitmentCompleted: commitmentCompleted,
      egoReflection: egoReflection,
      idealGapReflection: idealGapReflection,
      learningReflection: learningReflection,
      obstacleReason: obstacleReason,
    );
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
