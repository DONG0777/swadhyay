import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/community_agenda_item.dart';
import '../models/community_place.dart';
import '../models/community_routine.dart';
import '../models/nearby_community_place.dart';
import '../models/my_community_place.dart';

class CommunityPracticeService {
  final SupabaseClient _client;

  CommunityPracticeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<void> joinCommunity(String placeId) async {
    if (placeId.trim().isEmpty) {
      throw ArgumentError('Community place ID cannot be empty.');
    }

    final result = await _client.rpc(
      'join_community_place',
      params: {
        'p_place_id': placeId,
      },
    );

    if (result == null ||
        result is! Map<String, dynamic>) {
      throw StateError(
        'Invalid community join response.',
      );
    }
  }

  Future<void> leaveCommunity(String placeId) async {
    if (placeId.trim().isEmpty) {
      throw ArgumentError('Community place ID cannot be empty.');
    }

    final result = await _client.rpc(
      'leave_community_place',
      params: {
        'p_place_id': placeId,
      },
    );

    if (result == null ||
        result is! Map<String, dynamic>) {
      throw StateError(
        'Invalid community leave response.',
      );
    }
  }

  Future<List<MyCommunityPlace>> getMyCommunities({
    int limit = 50,
  }) async {
    if (limit <= 0 || limit > 100) {
      throw ArgumentError(
        'Limit must be between 1 and 100.',
      );
    }

    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException(
        'User is not signed in.',
      );
    }

    final memberships = await _client
        .from('community_memberships')
        .select('place_id, joined_at')
        .eq('user_id', user.id)
        .eq('status', 'active')
        .order('joined_at', ascending: false)
        .limit(limit);

    final result = <MyCommunityPlace>[];

    for (final row in memberships) {
      final placeId = row['place_id'] as String;

      final placeRow = await _client
          .from('community_places')
          .select()
          .eq('id', placeId)
          .maybeSingle();

      if (placeRow == null) {
        continue;
      }

      result.add(
        MyCommunityPlace(
          place: CommunityPlace.fromMap(
            Map<String, dynamic>.from(placeRow),
          ),
          joinedAt: DateTime.parse(
            row['joined_at'] as String,
          ),
        ),
      );
    }

    return result;
  }
  Future<List<NearbyCommunityPlace>> getNearbyCommunityPlaces({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000,
    int limit = 30,
  }) async {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError(
        'Latitude must be between -90 and 90.',
      );
    }

    if (longitude < -180 || longitude > 180) {
      throw ArgumentError(
        'Longitude must be between -180 and 180.',
      );
    }

    if (radiusMeters <= 0 || radiusMeters > 50000) {
      throw ArgumentError(
        'Radius must be between 1 and 50000 meters.',
      );
    }

    if (limit <= 0 || limit > 100) {
      throw ArgumentError(
        'Limit must be between 1 and 100.',
      );
    }

    final result = await _client.rpc(
      'find_nearby_community_places',
      params: {
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_radius_meters': radiusMeters,
        'p_limit': limit,
      },
    );

    if (result is! List) {
      throw StateError(
        'Invalid nearby community response.',
      );
    }

    return result
        .map(
          (row) => NearbyCommunityPlace.fromMap(
            Map<String, dynamic>.from(row as Map),
          ),
        )
        .toList();
  }
  Future<List<CommunityPlace>> getCommunityPlaces({
    int limit = 50,
  }) async {
    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than zero.');
    }

    final data = await _client
        .from('community_places')
        .select()
        .order('name', ascending: true)
        .limit(limit);

    return data
        .map((row) => CommunityPlace.fromMap(row))
        .toList();
  }

  Future<CommunityPlace> createCommunityPlace({
    required String name,
    String? description,
    required String address,
    String timezone = 'Asia/Kolkata',
    double? latitude,
    double? longitude,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final trimmedName = name.trim();
    final trimmedAddress = address.trim();
    final trimmedDescription = _nullableText(description);
    final trimmedTimezone = timezone.trim();

    if (trimmedName.isEmpty) {
      throw ArgumentError('Place name cannot be empty.');
    }

    if (trimmedAddress.isEmpty) {
      throw ArgumentError('Address cannot be empty.');
    }

    if (trimmedTimezone.isEmpty) {
      throw ArgumentError('Timezone cannot be empty.');
    }

    final hasLatitude = latitude != null;
    final hasLongitude = longitude != null;

    if (hasLatitude != hasLongitude) {
      throw ArgumentError(
        'Latitude and longitude must be provided together.',
      );
    }

    if (latitude != null &&
        (latitude < -90 || latitude > 90)) {
      throw ArgumentError(
        'Latitude must be between -90 and 90.',
      );
    }

    if (longitude != null &&
        (longitude < -180 || longitude > 180)) {
      throw ArgumentError(
        'Longitude must be between -180 and 180.',
      );
    }

    final result = await _client.rpc(
      'create_community_place',
      params: {
        'p_name': trimmedName,
        'p_description': trimmedDescription,
        'p_address': trimmedAddress,
        'p_timezone': trimmedTimezone,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError(
        'Invalid community place creation response.',
      );
    }

    final place = CommunityPlace.fromMap(result);

    if (latitude != null && longitude != null) {
      try {
        final result = await _client.rpc(
          'set_community_place_location',
          params: {
            'p_place_id': place.id,
            'p_latitude': latitude,
            'p_longitude': longitude,
          },
        );

        if (result == null ||
            result is! Map<String, dynamic>) {
          throw StateError(
            'Invalid location save response.',
          );
        }

        return CommunityPlace.fromMap(result);
      } catch (error) {
        throw StateError(
          'Community place was created, but its location '
          'could not be saved: $error',
        );
      }
    }

    return place;
  }
  Future<List<CommunityRoutine>> getRoutines(
    String placeId, {
    bool activeOnly = false,
  }) async {
    var query = _client
        .from('community_routines')
        .select()
        .eq('place_id', placeId);

    if (activeOnly) {
      query = query.eq('is_active', true);
    }

    final data = await query
        .order('weekday', ascending: true)
        .order('start_time', ascending: true);

    return data
        .map((row) => CommunityRoutine.fromMap(row))
        .toList();
  }

  Future<CommunityRoutine> createRoutine({
    required String placeId,
    required int weekday,
    required String startTime,
    required String title,
    int durationMinutes = 60,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    if (weekday < 1 || weekday > 7) {
      throw ArgumentError('Weekday must be between 1 and 7.');
    }

    if (durationMinutes < 30 || durationMinutes > 120) {
      throw ArgumentError(
        'Duration must be between 30 and 120 minutes.',
      );
    }

    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ArgumentError('Routine title cannot be empty.');
    }

    final result = await _client.rpc(
      'create_community_routine',
      params: {
        'p_place_id': placeId,
        'p_weekday': weekday,
        'p_start_time': startTime,
        'p_title': trimmedTitle,
        'p_duration_minutes': durationMinutes,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError(
        'Invalid community routine creation response.',
      );
    }

    return CommunityRoutine.fromMap(result);
  }

  Future<List<CommunityAgendaItem>> getSessionAgenda(
    String sessionId,
  ) async {
    final data = await _client
        .from('community_session_agenda_items')
        .select()
        .eq('session_id', sessionId)
        .order('sequence_number', ascending: true);

    return data
        .map((row) => CommunityAgendaItem.fromMap(row))
        .toList();
  }

  Future<CommunityAgendaItem> addAgendaItem({
    required String sessionId,
    required int sequenceNumber,
    required String activityType,
    required String title,
    String? description,
    required int durationMinutes,
  }) async {
    if (sequenceNumber < 1) {
      throw ArgumentError('Sequence number must be at least 1.');
    }

    if (durationMinutes < 1 || durationMinutes > 60) {
      throw ArgumentError(
        'Agenda duration must be between 1 and 60 minutes.',
      );
    }

    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ArgumentError('Agenda title cannot be empty.');
    }

    final result = await _client.rpc(
      'add_community_session_agenda_item',
      params: {
        'p_session_id': sessionId,
        'p_sequence_number': sequenceNumber,
        'p_activity_type': activityType,
        'p_title': trimmedTitle,
        'p_description': _nullableText(description),
        'p_duration_minutes': durationMinutes,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError(
        'Invalid community agenda item creation response.',
      );
    }

    return CommunityAgendaItem.fromMap(result);
  }

  Future<List<CommunityAgendaItem>> createDefaultAgenda(
    String sessionId,
  ) async {
    final result = await _client.rpc(
      'create_default_community_session_agenda',
      params: {
        'p_session_id': sessionId,
      },
    );

    if (result == null || result is! List) {
      throw StateError(
        'Invalid default community agenda response.',
      );
    }

    return result
        .map(
          (row) => CommunityAgendaItem.fromMap(
            Map<String, dynamic>.from(row as Map),
          ),
        )
        .toList();
  }
  Future<CommunityAgendaItem> updateAgendaItem({
    required String itemId,
    required String title,
    String? description,
    required String activityType,
    required int durationMinutes,
  }) async {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ArgumentError('Agenda title cannot be empty.');
    }

    if (durationMinutes < 1 || durationMinutes > 60) {
      throw ArgumentError(
        'Agenda duration must be between 1 and 60 minutes.',
      );
    }

    final result = await _client.rpc(
      'update_community_session_agenda_item',
      params: {
        'p_item_id': itemId,
        'p_title': trimmedTitle,
        'p_description': _nullableText(description),
        'p_activity_type': activityType,
        'p_duration_minutes': durationMinutes,
      },
    );

    if (result == null || result is! Map<String, dynamic>) {
      throw StateError(
        'Invalid community agenda item update response.',
      );
    }

    return CommunityAgendaItem.fromMap(result);
  }

  Future<void> deleteAgendaItem(String itemId) async {
    await _client.rpc(
      'delete_community_session_agenda_item',
      params: {
        'p_item_id': itemId,
      },
    );
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}

