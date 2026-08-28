import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_context.dart';

class UserContextService {
  final SupabaseClient _client;

  UserContextService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<UserContext?> getCurrentContext() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await _client
        .from('user_context')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserContext.fromMap(data);
  }

  Future<UserContext> saveContext({
    String? currentSituation,
    String? biggestNeed,
    int? availableTimeMinutes,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException('User is not signed in.');
    }

    final data = await _client
        .from('user_context')
        .upsert({
          'user_id': user.id,
          'current_situation': currentSituation,
          'biggest_need': biggestNeed,
          'available_time_minutes': availableTimeMinutes,
        })
        .select()
        .single();

    return UserContext.fromMap(data);
  }
}
