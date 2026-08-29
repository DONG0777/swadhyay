import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/daily_commitment.dart';

class DailyCommitmentService {
  final SupabaseClient _client;

  DailyCommitmentService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<DailyCommitment?> getCommitmentForDate(DateTime date) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final dateOnly = _dateOnly(date);

    final data = await _client
        .from('daily_commitments')
        .select()
        .eq('user_id', user.id)
        .eq('commitment_date', dateOnly)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return DailyCommitment.fromMap(data);
  }

  Future<DailyCommitment?> getTodayCommitment() {
    return getCommitmentForDate(DateTime.now());
  }

  Future<DailyCommitment> createCommitmentForDate({
    required DateTime date,
    required String commitmentText,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final trimmedText = commitmentText.trim();

    if (trimmedText.isEmpty) {
      throw ArgumentError('Commitment cannot be empty.');
    }

    if (trimmedText.length > 500) {
      throw ArgumentError(
        'Commitment cannot be longer than 500 characters.',
      );
    }

    final dateOnly = _dateOnly(date);

    final data = await _client
        .from('daily_commitments')
        .insert({
          'user_id': user.id,
          'commitment_date': dateOnly,
          'commitment_text': trimmedText,
        })
        .select()
        .single();

    return DailyCommitment.fromMap(data);
  }

  Future<DailyCommitment> createTodayCommitment({
    required String commitmentText,
  }) {
    return createCommitmentForDate(
      date: DateTime.now(),
      commitmentText: commitmentText,
    );
  }

  Future<DailyCommitment> updateCommitmentForDate({
    required DateTime date,
    required String commitmentText,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final trimmedText = commitmentText.trim();

    if (trimmedText.isEmpty) {
      throw ArgumentError('Commitment cannot be empty.');
    }

    if (trimmedText.length > 500) {
      throw ArgumentError(
        'Commitment cannot be longer than 500 characters.',
      );
    }

    final dateOnly = _dateOnly(date);

    final data = await _client
        .from('daily_commitments')
        .update({
          'commitment_text': trimmedText,
        })
        .eq('user_id', user.id)
        .eq('commitment_date', dateOnly)
        .eq('status', 'pending')
        .select()
        .single();

    return DailyCommitment.fromMap(data);
  }

  Future<DailyCommitment> completeCommitmentForDate(
    DateTime date,
  ) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final dateOnly = _dateOnly(date);

    final data = await _client
        .from('daily_commitments')
        .update({
          'status': 'completed',
          'completed_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', user.id)
        .eq('commitment_date', dateOnly)
        .eq('status', 'pending')
        .select()
        .single();

    return DailyCommitment.fromMap(data);
  }

  Future<DailyCommitment> completeTodayCommitment() {
    return completeCommitmentForDate(DateTime.now());
  }

  Future<DailyCommitment> markCommitmentMissedForDate(
    DateTime date,
  ) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final dateOnly = _dateOnly(date);

    final data = await _client
        .from('daily_commitments')
        .update({
          'status': 'missed',
        })
        .eq('user_id', user.id)
        .eq('commitment_date', dateOnly)
        .eq('status', 'pending')
        .select()
        .single();

    return DailyCommitment.fromMap(data);
  }

  Future<DailyCommitment> markTodayCommitmentMissed() {
    return markCommitmentMissedForDate(DateTime.now());
  }

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
