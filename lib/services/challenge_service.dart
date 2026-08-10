import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/challenge_model.dart';
import '../generated/l10n/app_localizations.dart';

class ChallengeService {
  static const String _storageKey = 'challenge_data';
  static const int totalDays = 21;

  // ভাষা অনুযায়ী বর্ণনা লোড করার ফাংশন
  List<String> _getAllDescriptions(BuildContext context) {
    final local = AppLocalizations.of(context);
    return List.generate(totalDays, (index) {
      return local.challengeDay(index + 1);
    });
  }

  Future<List<ChallengeDay>> loadChallenge(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);

    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => ChallengeDay.fromJson(e)).toList();
    } else {
      // প্রথমবার: সব ডে তৈরি করুন (শুধু দিন ১ আনলকড)
      final descriptions = _getAllDescriptions(context);
      final days = List.generate(totalDays, (index) {
        final dayNum = index + 1;
        return ChallengeDay(
          day: dayNum,
          title: 'Day $dayNum',
          description: descriptions[index],
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

  Future<void> completeDay(BuildContext context, int dayIndex) async {
    final days = await loadChallenge(context);
    if (dayIndex < days.length && !days[dayIndex].isCompleted) {
      days[dayIndex].isCompleted = true;
      if (dayIndex + 1 < days.length) {
        days[dayIndex + 1].isUnlocked = true;
      }
      await saveChallenge(days);
    }
  }

  Future<double> getProgress(BuildContext context) async {
    final days = await loadChallenge(context);
    final completed = days.where((d) => d.isCompleted).length;
    return completed / totalDays;
  }

  Future<int> getCurrentDayIndex(BuildContext context) async {
    final days = await loadChallenge(context);
    for (int i = 0; i < days.length; i++) {
      if (days[i].isUnlocked && !days[i].isCompleted) {
        return i;
      }
    }
    return days.length - 1;
  }
}
