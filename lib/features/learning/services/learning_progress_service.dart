import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/learning_progress.dart';

class LearningProgressService {
  final SupabaseClient _client;

  LearningProgressService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<LearningProgress?> getProgress({
    required String learningContentId,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('User is not signed in.');
    }

    final result = await _client
        .from('learning_progress')
        .select(
          'id, user_id, learning_content_id, status, '
          'completed_at, created_at, updated_at',
        )
        .eq('user_id', user.id)
        .eq('learning_content_id', learningContentId)
        .maybeSingle();

    if (result == null) {
      return null;
    }

    return LearningProgress.fromMap(
      result,
    );
  }

  Future<List<LearningProgress>> getCompletedProgress() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('User is not signed in.');
    }

    final result = await _client
        .from('learning_progress')
        .select(
          'id, user_id, learning_content_id, status, '
          'completed_at, created_at, updated_at',
        )
        .eq('user_id', user.id)
        .eq('status', 'completed')
        .order('completed_at', ascending: false);

    return result
        .map(
          (row) => LearningProgress.fromMap(
            row,
          ),
        )
        .toList();
  }

  Future<LearningProgress> completeContent({
    required String learningContentId,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw StateError('User is not signed in.');
    }

    final result = await _client.rpc(
      'complete_learning_content',
      params: {
        'p_learning_content_id': learningContentId,
      },
    );

    return LearningProgress.fromMap(
      Map<String, dynamic>.from(result),
    );
  }
}



