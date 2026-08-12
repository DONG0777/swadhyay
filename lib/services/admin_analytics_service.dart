import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAnalyticsService {
  final supabase = Supabase.instance.client;

  // মোট ইউজার
  Future<int> getTotalUsers() async {
    final response = await supabase.from('user_profiles').select('id');
    return response.length;
  }

  // গত ৭ দিনে সক্রিয় ইউজার
  Future<int> getActiveUsersLast7Days() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    final response = await supabase
        .from('center_attendances')
        .select('user_id')
        .gte('check_in_date', sevenDaysAgo);
    final userIds = response.map((e) => e['user_id']).toSet();
    return userIds.length;
  }

  // মোট সার্কেল
  Future<int> getTotalCircles() async {
    final response = await supabase.from('community_centers').select('id');
    return response.length;
  }

  // সাপ্তাহিক উপস্থিতির ডেটা (গ্রাফের জন্য)
  Future<List<Map<String, dynamic>>> getWeeklyAttendance() async {
    final sevenDays = List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      return date.toIso8601String().split('T')[0];
    });

    List<Map<String, dynamic>> result = [];
    for (final day in sevenDays) {
      final count = await supabase
          .from('center_attendances')
          .select('id')
          .eq('check_in_date', day);
      result.add({'date': day, 'count': count.length});
    }
    return result;
  }
}
