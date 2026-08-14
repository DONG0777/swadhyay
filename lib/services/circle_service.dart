import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/circle_model.dart';

class CircleService {
  final supabase = Supabase.instance.client;

  // নতুন সার্কেল তৈরি (শুধু community_centers টেবিলে)
  Future<Circle> createCircle(String name, String description, String userId, {String centerType = 'family'}) async {
    final inviteCode = _generateInviteCode();

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'invite_code': inviteCode,
      'created_by': userId,
      'members': [userId],
      'leaderboard': {userId: 0},
      'center_type': centerType,
    };

    print('📝 সার্কেল তৈরি করা হচ্ছে: $data');

    final response = await supabase
        .from('community_centers') // 🔥 সঠিক টেবিল
        .insert(data)
        .select()
        .single();

    print('✅ সার্কেল তৈরি হয়েছে: ${response['id']}');
    return Circle.fromJson(response);
  }

  // ইউজারের সব সার্কেল লোড (community_centers থেকে)
  Future<List<Circle>> getUserCircles(String userId) async {
    print('🔍 ইউজারের সার্কেল খোঁজা হচ্ছে: $userId');
    
    final response = await supabase
        .from('community_centers') // 🔥 সঠিক টেবিল
        .select('*')
        .contains('members', [userId]);

    print('📦 পাওয়া সার্কেল: ${response.length} টি');
    return List<Circle>.from(response.map((e) => Circle.fromJson(e)));
  }

  // ইনভাইট কোড দিয়ে জয়েন
  Future<Circle> joinCircle(String inviteCode, String userId) async {
    final response = await supabase
        .from('community_centers')
        .select('*')
        .eq('invite_code', inviteCode)
        .single();

    final circle = Circle.fromJson(response);

    if (circle.members.contains(userId)) {
      throw Exception('আপনি ইতিমধ্যে এই সার্কেলের সদস্য।');
    }

    final updatedMembers = [...circle.members, userId];
    final updatedLeaderboard = Map<String, int>.from(circle.leaderboard);
    updatedLeaderboard[userId] = 0;

    final updateResponse = await supabase
        .from('community_centers')
        .update({
          'members': updatedMembers,
          'leaderboard': updatedLeaderboard,
        })
        .eq('id', circle.id)
        .select()
        .single();

    return Circle.fromJson(updateResponse);
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[random % chars.length];
    }
    return code;
  }
}
