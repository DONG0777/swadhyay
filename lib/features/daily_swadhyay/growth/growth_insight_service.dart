import 'package:supabase_flutter/supabase_flutter.dart';

import '../history/daily_history_service.dart';
import 'growth_insight.dart';

class GrowthInsightService {
  final DailyHistoryService _historyService;

  GrowthInsightService({SupabaseClient? client})
      : _historyService = DailyHistoryService(client: client);

  Future<GrowthInsight> getSevenDayInsight() async {
    final history = await _historyService.getRecentHistory(days: 7);

    var completed = 0;
    var missed = 0;
    var reflections = 0;

    for (final item in history) {
      if (item.commitment.status == 'completed') {
        completed++;
      } else if (item.commitment.status == 'missed') {
        missed++;
      }

      if (item.hasReflection) {
        reflections++;
      }
    }

    final resolvedCommitments = completed + missed;

    final completionRate = resolvedCommitments == 0
        ? 0.0
        : (completed / resolvedCommitments) * 100;

    final reflectionRate = resolvedCommitments == 0
        ? 0.0
        : (reflections / resolvedCommitments) * 100;

    final message = _buildMessage(
      total: resolvedCommitments,
      completed: completed,
      missed: missed,
      reflections: reflections,
      completionRate: completionRate,
    );

    return GrowthInsight(
      totalCommitments: resolvedCommitments,
      completedCommitments: completed,
      missedCommitments: missed,
      reflectionCount: reflections,
      completionRate: completionRate,
      reflectionRate: reflectionRate,
      headline: message.$1,
      detail: message.$2,
    );
  }

  (String, String) _buildMessage({
    required int total,
    required int completed,
    required int missed,
    required int reflections,
    required double completionRate,
  }) {
    if (total == 0) {
      return (
        'এখনও যথেষ্ট data নেই',
        'কয়েকটি দৈনিক সংকল্প সম্পন্ন বা অসম্পন্ন হিসেবে নথিভুক্ত হলে তোমার নিজের যাত্রা থেকে insight তৈরি হবে।',
      );
    }

    if (total < 3) {
      return (
        'যাত্রা শুরু হয়েছে',
        'এখনও pattern বলার মতো যথেষ্ট data নেই। আরও কয়েকটি দিনের সংকল্প ও আত্ম-বিশ্লেষণ তৈরি হতে দাও।',
      );
    }

    if (completionRate >= 80 && missed == 0) {
      return (
        'তোমার ধারাবাহিকতা ভালো',
        'সংকল্পগুলো বাস্তবে করার ক্ষেত্রে তুমি এখন ভালো momentum তৈরি করছ। এবার সংকল্পের মান আরও নির্দিষ্ট করা যায়।',
      );
    }

    if (completionRate >= 60) {
      return (
        'ভিত্তি তৈরি হচ্ছে',
        'তোমার কিছু সংকল্প সফল হচ্ছে। যেগুলো হয়নি, সেগুলোর কারণ দেখলে পরের কয়েক দিনে উন্নতির স্পষ্ট পথ পাওয়া যাবে।',
      );
    }

    if (missed > completed) {
      return (
        'সংকল্পকে আরও ছোট করো',
        'এই ৭ দিনে অসম্পন্ন সংকল্প বেশি। বড় লক্ষ্য না নিয়ে আরও ছোট এবং নির্দিষ্ট কাজ দিয়ে শুরু করা উপকারী হতে পারে।',
      );
    }

    if (reflections == 0) {
      return (
        'কাজের সঙ্গে আত্ম-বিশ্লেষণও দরকার',
        'শুধু সংকল্প নয়—দিন শেষে কয়েক মিনিট নিজের অভিজ্ঞতা লিখলে pattern বোঝা সহজ হবে।',
      );
    }

    return (
      'ধীরে, কিন্তু সচেতনভাবে এগোও',
      'সংকল্প, কাজ এবং আত্ম-বিশ্লেষণ—এই তিনটিকে নিয়মিত রাখাই এখন সবচেয়ে গুরুত্বপূর্ণ।',
    );
  }
}
