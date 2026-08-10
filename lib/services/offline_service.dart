import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';

class OfflineService {
  static const String _cacheKey = 'cached_questions';
  static const String _lastSyncKey = 'last_sync_time';

  // প্রশ্ন ক্যাশে সেভ করা
  Future<void> cacheQuestions(List<Question> questions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = questions.map((q) => q.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // ক্যাশ থেকে প্রশ্ন লোড করা
  Future<List<Question>> getCachedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_cacheKey);
    if (data == null) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => Question.fromJson(e)).toList();
  }

  // শেষ সিঙ্কের সময়
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final String? time = prefs.getString(_lastSyncKey);
    if (time == null) return null;
    return DateTime.parse(time);
  }

  // ক্যাশে প্রশ্ন আছে কিনা
  Future<bool> hasCachedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cacheKey);
  }

  // ক্যাশ ক্লিয়ার করা
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_lastSyncKey);
  }
}
