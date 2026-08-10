import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/circle_model.dart';

class CircleService {
  final supabase = Supabase.instance.client;

  // নতুন সার্কেল তৈরি করা
  Future<Circle> createCircle(String name, String description, String userId) async {
    final inviteCode = _generateInviteCode();

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'invite_code': inviteCode,
      'created_by': userId,
      'members': [userId],
      'leaderboard': {userId: 0},
    };

    final response = await supabase
        .from('circles')
        .insert(data)
        .select()
        .single();

    return Circle.fromJson(response);
  }

  // ইনভাইট কোড দিয়ে সার্কেলে জয়েন করা
  Future<Circle> joinCircle(String inviteCode, String userId) async {
    // সার্কেল খুঁজে বের করা
    final response = await supabase
        .from('circles')
        .select('*')
        .eq('invite_code', inviteCode)
        .single();

    final circle = Circle.fromJson(response);

    // ইউজার ইতিমধ্যে মেম্বার কিনা চেক
    if (circle.members.contains(userId)) {
      throw Exception('আপনি ইতিমধ্যে এই সার্কেলের সদস্য।');
    }

    // নতুন মেম্বার যোগ করা
    final updatedMembers = [...circle.members, userId];
    final updatedLeaderboard = Map<String, int>.from(circle.leaderboard);
    updatedLeaderboard[userId] = 0;

    final updateResponse = await supabase
        .from('circles')
        .update({
          'members': updatedMembers,
          'leaderboard': updatedLeaderboard,
        })
        .eq('id', circle.id)
        .select()
        .single();

    return Circle.fromJson(updateResponse);
  }

  // ইউজারের সব সার্কেল লোড করা
  Future<List<Circle>> getUserCircles(String userId) async {
    final response = await supabase
        .from('circles')
        .select('*')
        .contains('members', [userId]);

    return List<Circle>.from(response.map((e) => Circle.fromJson(e)));
  }

  // সার্কেলের লিডারবোর্ড আপডেট করা (কুইজ শেষে)
  Future<void> updateLeaderboard(String circleId, String userId, int xp) async {
    final response = await supabase
        .from('circles')
        .select('*')
        .eq('id', circleId)
        .single();

    final circle = Circle.fromJson(response);
    final updatedLeaderboard = Map<String, int>.from(circle.leaderboard);
    updatedLeaderboard[userId] = (updatedLeaderboard[userId] ?? 0) + xp;

    await supabase
        .from('circles')
        .update({'leaderboard': updatedLeaderboard})
        .eq('id', circleId);
  }

  // ইনভাইট কোড জেনারেট করা
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
