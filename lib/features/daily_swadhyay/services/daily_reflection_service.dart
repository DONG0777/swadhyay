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
    _requireSignedIn();

    final targetDate = DateTime(date.year, date.month, date.day);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (targetDate != todayOnly) {
      throw ArgumentError(
        'Reflection can only be saved for today.',
      );
    }

    final trimmedEgo = _nullableText(egoReflection);
    final trimmedIdealGap = _nullableText(idealGapReflection);
    final trimmedLearning = _nullableText(learningReflection);
    final trimmedObstacle = _nullableText(obstacleReason);

    if (!commitmentCompleted && trimmedObstacle == null) {
      throw ArgumentError(
        'সংকল্প পূরণ না হলে বাধার কারণ লেখা বাধ্যতামূলক।',
      );
    }

    final data = await _client.rpc(
      'save_daily_reflection',
      params: {
        'p_commitment_id': commitmentId,
        'p_ego_reflection': trimmedEgo,
        'p_ideal_gap_reflection': trimmedIdealGap,
        'p_learning_reflection': trimmedLearning,
        'p_obstacle_reason': trimmedObstacle,
      },
    );

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

  void _requireSignedIn() {
    if (_client.auth.currentUser == null) {
      throw const AuthException('User is not signed in.');
    }
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
