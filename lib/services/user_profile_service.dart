import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileService {
  final supabase = Supabase.instance.client;

  // প্রোফাইল লোড করুন (ইউজার আইডি অনুযায়ী)
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await supabase
          .from('user_profiles')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      print('❌ Error loading profile: $e');
      return null;
    }
  }

  // সার্কেলের সব সদস্যের প্রোফাইল লোড করুন (অ্যাডমিনের জন্য)
  Future<List<Map<String, dynamic>>> getCircleMembersProfiles(List<String> memberIds) async {
    if (memberIds.isEmpty) return [];
    try {
      final response = await supabase
          .from('user_profiles')
          .select('*')
          .inFilter('user_id', memberIds);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error loading circle members: $e');
      return [];
    }
  }
}
