import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final supabase = Supabase.instance.client;

  // নতুন নোটিফিকেশন পাঠান
  Future<void> sendNotification({
    required String title,
    required String body,
    String? receiverId,
    String? circleId,
    String type = 'announcement',
    String? senderId,
  }) async {
    await supabase.from('notifications').insert({
      'title': title,
      'body': body,
      'receiver_id': receiverId,
      'circle_id': circleId,
      'type': type,
      'sender_id': senderId,
      'is_sent': true,
      'sent_at': DateTime.now().toIso8601String(),
    });
  }

  // সার্কেলের সব সদস্যকে নোটিফিকেশন পাঠান
  Future<void> sendToCircle({
    required String circleId,
    required String title,
    required String body,
    String type = 'announcement',
    String? senderId,
  }) async {
    final circle = await supabase
        .from('community_centers')
        .select('members')
        .eq('id', circleId)
        .single();
    
    final members = List<String>.from(circle['members'] ?? []);
    
    for (final memberId in members) {
      await supabase.from('notifications').insert({
        'title': title,
        'body': body,
        'receiver_id': memberId,
        'circle_id': circleId,
        'type': type,
        'sender_id': senderId,
        'is_sent': true,
        'sent_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ইউজারের সব নোটিফিকেশন লোড করুন
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final response = await supabase
        .from('notifications')
        .select('*')
        .eq('receiver_id', userId)
        .order('created_at', ascending: false);
    return response;
  }

  // নোটিফিকেশন রিড মার্ক করুন
  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  // আনরিড কাউন্ট
  Future<int> getUnreadCount(String userId) async {
    final response = await supabase
        .from('notifications')
        .select('id')
        .eq('receiver_id', userId)
        .eq('is_read', false);
    return response.length;
  }
}
