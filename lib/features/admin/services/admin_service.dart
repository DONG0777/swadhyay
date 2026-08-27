import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final SupabaseClient _client;

  AdminService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<bool> isAdmin() async {
    final result = await _client.rpc('is_admin');
    return result == true;
  }
}
