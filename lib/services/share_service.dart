import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  static Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      final encoded = Uri.encodeComponent(text);
      final url = Uri.parse('https://wa.me/?text=$encoded');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        return;
      }
      // Fallback: কপি টু ক্লিপবোর্ড (Web-এর জন্য)
      await _copyToClipboard(text);
    } catch (e) {
      print('❌ Share error: $e');
      await _copyToClipboard(text);
    }
  }

  static Future<void> _copyToClipboard(String text) async {
    // Web-এ কপি করার জন্য (পরবর্তীতে ক্লিপবোর্ড API ব্যবহার করা যেতে পারে)
    print('📋 কপি করুন: $text');
  }

  static Future<void> shareChallengeProgress({
    required int completed,
    required int total,
    required int streak,
    required int xp,
    String? language,
  }) async {
    final message = '''
🌱 *দীপ্ত যাত্রা - আমার অগ্রগতি* 🌱

✅ সম্পন্ন: $completed/$total দিন
🔥 স্ট্রিক: $streak দিন
⭐ এক্সপি: $xp
📅 ভাষা: ${language ?? 'বাংলা'}

"প্রতিদিন একটু করে এগিয়ে যাও – সাফল্য অবশ্যম্ভাবী!" 🌟

#Swadhyay #DiptoJatra #আত্মশিক্ষা #স্বাধ্যায়
''';
    await shareText(text: message);
  }

  static Future<void> shareQuote({
    required String title,
    required String content,
    String? category,
  }) async {
    final message = '''
📜 *$title*

"$content"

${category != null ? '📂 বিভাগ: $category\n' : ''}
শেয়ার করুন এবং অন্যদেরও অনুপ্রাণিত করুন! 🌟

#Swadhyay #স্বাধ্যায় #শ্লোক #প্রেরণা
''';
    await shareText(text: message);
  }

  static Future<void> shareScore({
    required int score,
    required int total,
    required int streak,
    required int xp,
    required String appTitle,
  }) async {
    final message = '''
☀️ *$appTitle - কুইজ স্কোরকার্ড* ☀️

📊 স্কোর: $score/$total
🔥 স্ট্রিক: $streak দিন
⭐ এক্সপি: $xp
📅 তারিখ: ${DateTime.now().toString().split(' ')[0]}

"জ্ঞানই শক্তি – শিখতে থাকুন, বাড়তে থাকুন!" 📚

#Swadhyay #Quiz #Knowledge #স্বাধ্যায়
''';
    await shareText(text: message);
  }

  static Future<void> sharePillar({
    required String title,
    required String subtitle,
    required String content,
    required String id,
  }) async {
    final message = '''
📖 *$title* - $subtitle

$content

🌅 স্বাধ্যায় – দৈনিক আত্মশিক্ষা ও সাংস্কৃতিক সচেতনতা

#Swadhyay #Pillar #${id.toUpperCase()} #স্বাধ্যায়
''';
    await shareText(text: message);
  }
}
