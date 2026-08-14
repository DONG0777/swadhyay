import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/circle_model.dart';

class CircleService {
  final supabase = Supabase.instance.client;

  // ইউজারের পারিবারিক সার্কেল কাউন্ট চেক
  Future<int> getFamilyCircleCount(String userId) async {
    final response = await supabase
        .from('community_centers')
        .select('id')
        .eq('created_by', userId)
        .eq('center_type', 'family');
    return response.length;
  }

  // নতুন সার্কেল তৈরি (পারিবারিক লিমিট সহ)
  Future<Circle> createCircle(String name, String description, String userId, {String centerType = 'family'}) async {
    if (centerType == 'family') {
      final count = await getFamilyCircleCount(userId);
      if (count >= 1) {
        throw Exception('আপনি ইতিমধ্যে একটি পারিবারিক সার্কেল তৈরি করেছেন!');
      }
    }

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

    final response = await supabase
        .from('community_centers')
        .insert(data)
        .select()
        .single();

    return Circle.fromJson(response);
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

  // ইউজারের সব সার্কেল লোড
  Future<List<Circle>> getUserCircles(String userId) async {
    final response = await supabase
        .from('community_centers')
        .select('*')
        .contains('members', [userId]);

    return List<Circle>.from(response.map((e) => Circle.fromJson(e)));
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
