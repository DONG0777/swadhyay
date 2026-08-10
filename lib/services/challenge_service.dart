import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge_model.dart';

class ChallengeService {
  static const String _storageKey = 'challenge_data';
  static const int totalDays = 21;

  Future<List<ChallengeDay>> loadChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => ChallengeDay.fromJson(e)).toList();
    } else {
      // প্রথমবার: সব ডে তৈরি করুন (শুধু দিন ১ আনলকড)
      final days = List.generate(totalDays, (index) {
        final dayNum = index + 1;
        return ChallengeDay(
          day: dayNum,
          title: 'দিন $dayNum',
          description: _getDayDescription(dayNum),
          isCompleted: false,
          isUnlocked: dayNum == 1,
        );
      });
      await saveChallenge(days);
      return days;
    }
  }

  Future<void> saveChallenge(List<ChallengeDay> days) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = days.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  // একটি ডে কমপ্লিট করলে পরের ডে আনলক হয়
  Future<void> completeDay(int dayIndex) async {
    final days = await loadChallenge();
    if (dayIndex < days.length && !days[dayIndex].isCompleted) {
      days[dayIndex].isCompleted = true;
      // পরের ডে আনলক করুন (যদি থাকে)
      if (dayIndex + 1 < days.length) {
        days[dayIndex + 1].isUnlocked = true;
      }
      await saveChallenge(days);
    }
  }

  // প্রতিটি ডে-র আলাদা বর্ণনা
  String _getDayDescription(int day) {
    final descriptions = [
      'শুরু: সংকল্প ও লক্ষ্য নির্ধারণ',
      'শৃঙ্খলা: দৈনিক রুটিন তৈরি',
      'আত্মবিশ্বাস: নিজের উপর আস্থা',
      'জ্ঞান: ভালো বই পড়া',
      'সেবা: সমাজের জন্য কাজ',
      'স্বাস্থ্য: সূর্য নমস্কার',
      'ধ্যান: মানসিক শান্তি',
      'কৃতজ্ঞতা: জীবনের প্রতি কৃতজ্ঞতা',
      'উদারতা: অন্যদের সাহায্য',
      'সাহস: ভয়কে জয় করা',
      'প্রেম: পরিবারের প্রতি যত্ন',
      'সততা: সত্যের পথে চলা',
      'পরিশ্রম: লক্ষ্যের জন্য কাজ',
      'ক্ষমা: ভুলকে মেনে নেওয়া',
      'ধৈর্য: সময়ের অপেক্ষা',
      'আশা: ভালো দিনের প্রতীক্ষা',
      'আত্মনির্ভরতা: নিজের পায়ে দাঁড়ানো',
      'জ্ঞানার্জন: নতুন কিছু শেখা',
      'নেতৃত্ব: অন্যদের পথ দেখানো',
      'ঐক্য: সকলকে সাথে নেওয়া',
      'পূর্ণতা: ২১ দিনের জয়',
    ];
    return descriptions[day - 1] ?? 'এগিয়ে চলো!';
  }

  // প্রগ্রেস ক্যালকুলেশন (শতাংশ)
  Future<double> getProgress() async {
    final days = await loadChallenge();
    final completed = days.where((d) => d.isCompleted).length;
    return completed / totalDays;
  }

  // বর্তমান ডে-র ইনডেক্স খুঁজে বের করা (যে ডে আনলকড কিন্তু কমপ্লিট নয়)
  Future<int> getCurrentDayIndex() async {
    final days = await loadChallenge();
    for (int i = 0; i < days.length; i++) {
      if (days[i].isUnlocked && !days[i].isCompleted) {
        return i;
      }
    }
    return days.length - 1; // সব কমপ্লিট হয়ে গেলে শেষ ডে
  }
}
