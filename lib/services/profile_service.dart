import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();
      if (response == null) return null;
      return UserProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfile({
    required String userId,
    String? phone,
    String? area,
    String? bloodGroup,
  }) async {
    try {
      await _supabase
          .from('user_profiles')
          .update({
            'phone': phone,
            'area': area,
            'blood_group': bloodGroup,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isProfileComplete(String userId) async {
    final profile = await getProfile(userId);
    return profile?.isComplete ?? false;
  }
}
