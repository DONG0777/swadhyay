import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/community_agenda_item.dart';
import '../models/community_place.dart';
import '../models/community_routine.dart';

class CommunityPracticeService {
  final SupabaseClient _client;

  CommunityPracticeService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

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

    final data = await _client
        .from('community_places')
        .insert({
          'created_by': user.id,
          'name': trimmedName,
          'description': trimmedDescription,
          'address': trimmedAddress,
          'timezone': trimmedTimezone,
        })
        .select()
        .single();

    return CommunityPlace.fromMap(data);
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

    final data = await _client
        .from('community_routines')
        .insert({
          'place_id': placeId,
          'created_by': user.id,
          'weekday': weekday,
          'start_time': startTime,
          'duration_minutes': durationMinutes,
          'title': trimmedTitle,
          'is_active': true,
        })
        .select()
        .single();

    return CommunityRoutine.fromMap(data);
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

    final data = await _client
        .from('community_session_agenda_items')
        .insert({
          'session_id': sessionId,
          'sequence_number': sequenceNumber,
          'activity_type': activityType,
          'title': trimmedTitle,
          'description': _nullableText(description),
          'duration_minutes': durationMinutes,
        })
        .select()
        .single();

    return CommunityAgendaItem.fromMap(data);
  }

  Future<List<CommunityAgendaItem>> createDefaultAgenda(
    String sessionId,
  ) async {
    const defaultItems = [
      {
        'activity_type': 'gathering',
        'title': 'সমবেত হওয়া',
        'description': 'সবাই একত্রিত হয়ে অনুশীলনের জন্য প্রস্তুত হবে।',
        'duration_minutes': 5,
      },
      {
        'activity_type': 'prayer',
        'title': 'প্রার্থনা / শান্তি মুহূর্ত',
        'description': 'মনকে স্থির করে সম্মিলিতভাবে দিনের অনুশীলন শুরু করা।',
        'duration_minutes': 5,
      },
      {
        'activity_type': 'surya_namaskar',
        'title': 'সূর্য নমস্কার',
        'description': 'শরীর, শ্বাস ও শৃঙ্খলার সম্মিলিত অনুশীলন।',
        'duration_minutes': 15,
      },
      {
        'activity_type': 'mindfulness',
        'title': 'মনন',
        'description': 'কিছু সময় নীরবতা, শ্বাস ও আত্ম-পর্যবেক্ষণ।',
        'duration_minutes': 10,
      },
      {
        'activity_type': 'self_study',
        'title': 'স্বাধ্যায়',
        'description': 'একটি মূল্যবোধ বা চিন্তার বিষয় নিয়ে সংক্ষিপ্ত আলোচনা।',
        'duration_minutes': 10,
      },
      {
        'activity_type': 'social_dialogue',
        'title': 'সামাজিক আলোচনা',
        'description': 'স্থানীয় সমাজ ও পারস্পরিক দায়িত্ব নিয়ে কথা বলা।',
        'duration_minutes': 5,
      },
      {
        'activity_type': 'seva',
        'title': 'Seva + সংকল্প',
        'description': 'পরবর্তী দিনের ছোট সামাজিক বা ব্যক্তিগত কাজ নির্ধারণ।',
        'duration_minutes': 5,
      },
      {
        'activity_type': 'closing',
        'title': 'সমাপ্তি',
        'description': 'সংক্ষিপ্ত সমাপ্তি ও পরবর্তী session-এর জন্য প্রস্তুতি।',
        'duration_minutes': 5,
      },
    ];

    final totalMinutes = defaultItems.fold<int>(
      0,
      (total, item) => total + (item['duration_minutes'] as int),
    );

    if (totalMinutes != 60) {
      throw StateError(
        'Default community agenda must total exactly 60 minutes.',
      );
    }

    final existing = await getSessionAgenda(sessionId);

    if (existing.isNotEmpty) {
      return existing;
    }

    final rows = List.generate(
      defaultItems.length,
      (index) {
        final item = defaultItems[index];

        return {
          'session_id': sessionId,
          'sequence_number': index + 1,
          'activity_type': item['activity_type'],
          'title': item['title'],
          'description': item['description'],
          'duration_minutes': item['duration_minutes'],
        };
      },
    );

    final data = await _client
        .from('community_session_agenda_items')
        .insert(rows)
        .select()
        .order('sequence_number', ascending: true);

    return data
        .map((row) => CommunityAgendaItem.fromMap(row))
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

    final data = await _client
        .from('community_session_agenda_items')
        .update({
          'title': trimmedTitle,
          'description': _nullableText(description),
          'activity_type': activityType,
          'duration_minutes': durationMinutes,
        })
        .eq('id', itemId)
        .select()
        .single();

    return CommunityAgendaItem.fromMap(data);
  }

  Future<void> deleteAgendaItem(String itemId) async {
    await _client
        .from('community_session_agenda_items')
        .delete()
        .eq('id', itemId);
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}

