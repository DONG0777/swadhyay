import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/community_session.dart';
import '../models/session_participant.dart';

class CommunityService {
  final SupabaseClient _client;

  CommunityService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<CommunitySession>> getUpcomingSessions({
    int limit = 30,
  }) async {
    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than zero.');
    }

    final data = await _client
        .from('community_sessions')
        .select()
        .eq('status', 'planned')
        .gte('starts_at', DateTime.now().toUtc().toIso8601String())
        .order('starts_at', ascending: true)
        .limit(limit);

    return data
        .map(
          (row) => CommunitySession.fromMap(row),
        )
        .toList();
  }

  Future<CommunitySession?> getSession(String sessionId) async {
    final data = await _client
        .from('community_sessions')
        .select()
        .eq('id', sessionId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return CommunitySession.fromMap(data);
  }

  Future<CommunitySession> createSession({
    required String placeId,
    String? routineId,
    required String title,
    String? description,
    required String locationName,
    String? locationDetails,
    required DateTime startsAt,
    required DateTime endsAt,
    int? capacity,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final trimmedTitle = title.trim();
    final trimmedLocationName = locationName.trim();
    final trimmedDescription = _nullableText(description);
    final trimmedLocationDetails = _nullableText(locationDetails);

    if (trimmedTitle.isEmpty) {
      throw ArgumentError('Session title cannot be empty.');
    }

    if (trimmedLocationName.isEmpty) {
      throw ArgumentError('Location cannot be empty.');
    }

    if (!endsAt.isAfter(startsAt)) {
      throw ArgumentError(
        'Session end time must be after start time.',
      );
    }

    if (capacity != null && (capacity < 1 || capacity > 100000)) {
      throw ArgumentError(
        'Capacity must be between 1 and 100000.',
      );
    }

    final result = await _client.rpc(
      'create_community_session',
      params: {
        'p_place_id': placeId,
        'p_routine_id': routineId,
        'p_title': trimmedTitle,
        'p_description': trimmedDescription,
        'p_location_name': trimmedLocationName,
        'p_location_details': trimmedLocationDetails,
        'p_starts_at': startsAt.toUtc().toIso8601String(),
        'p_ends_at': endsAt.toUtc().toIso8601String(),
        'p_capacity': capacity,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError('Invalid session creation response.');
    }

    return CommunitySession.fromMap(result);
  }

  Future<SessionParticipant> joinSession(String sessionId) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final result = await _client.rpc(
      'join_community_session',
      params: {
        'p_session_id': sessionId,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError('Invalid session join response.');
    }

    return SessionParticipant.fromMap(result);
  }

  Future<void> leaveSession(String sessionId) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    await _client
        .from('session_participants')
        .delete()
        .eq('session_id', sessionId)
        .eq('user_id', user.id);
  }

  Future<SessionParticipant?> getMyParticipation(
    String sessionId,
  ) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await _client
        .from('session_participants')
        .select()
        .eq('session_id', sessionId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return SessionParticipant.fromMap(data);
  }

  Future<List<SessionParticipant>> getSessionParticipants(
    String sessionId,
  ) async {
    final data = await _client
        .from('session_participants')
        .select()
        .eq('session_id', sessionId)
        .order('joined_at', ascending: true);

    return data
        .map(
          (row) => SessionParticipant.fromMap(row),
        )
        .toList();
  }

  bool isCurrentUserCreator(CommunitySession session) {
    return _client.auth.currentUser?.id == session.createdBy;
  }
  Future<String> createCheckinToken(String sessionId) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final result = await _client.rpc(
      'create_community_session_checkin_token',
      params: {
        'p_session_id': sessionId,
      },
    );

    if (result == null) {
      throw StateError('Check-in token was not returned.');
    }

    return result as String;
  }

  Future<SessionParticipant> checkInWithToken(String token) async {
    final trimmedToken = token.trim();

    if (trimmedToken.isEmpty) {
      throw ArgumentError('Check-in token cannot be empty.');
    }

    final result = await _client.rpc(
      'check_in_to_community_session',
      params: {
        'p_token': trimmedToken,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError('Invalid check-in response.');
    }

    return SessionParticipant.fromMap(result);
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}






