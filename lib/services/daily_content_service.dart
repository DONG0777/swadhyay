import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class Pillar {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String content;

  Pillar({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.content,
  });
}

class DailyContentService {
  static List<Pillar> getPillars(BuildContext context) {
    final local = AppLocalizations.of(context);

    return [
      Pillar(
        id: 'stotra',
        title: "একাত্মতা স্তোত্র",
        subtitle: "শুনুন ও অনুভব করুন",
        icon: Icons.music_note,
        color: Colors.deepPurple,
        content: "ওঁ বিশ্বানি দেব সবিতার দুরিতানি পরাসুভ ।\nযৎ ভদ্রং তন্ন আ সুভ ।",
      ),
      Pillar(
        id: 'shloka',
        title: "শ্লোক",
        subtitle: "প্রাচীন জ্ঞান",
        icon: Icons.auto_awesome,
        color: Colors.orange,
        content: "অসতো মা সদ্ গময় ।\nতমসো মা জ্যোতির্গময় ।\nমৃত্যোর্মা অমৃতং গময় ।",
      ),
      Pillar(
        id: 'quote',
        title: "প্রেরণাদায়ী উক্তি",
        subtitle: "স্বামী বিবেকানন্দ",
        icon: Icons.format_quote,
        color: Colors.teal,
        content: "উঠো, জাগো এবং লক্ষ্য না পাওয়া পর্যন্ত থামো না।",
      ),
      Pillar(
        id: 'book',
        title: "বইয়ের স্পটলাইট",
        subtitle: "আজকের পাঠ",
        icon: Icons.book,
        color: Colors.brown,
        content: "আরএসএস: কী ও কেন? - ড. মানবেন্দ্র নাথ রায়",
      ),
      Pillar(
        id: 'surya',
        title: "সূর্য নমস্কার",
        subtitle: "দৈনিক ১২টি সেট",
        icon: Icons.self_improvement,
        color: Colors.redAccent,
        content: "সূর্য নমস্কার - শারীরিক ও মানসিক স্বাস্থ্যের জন্য উপকারী",
      ),
      Pillar(
        id: 'duty',
        title: "নাগরিক কর্তব্য",
        subtitle: "আজকের দায়িত্ব",
        icon: Icons.gavel,
        color: Colors.blue,
        content: "পরিবেশের জন্য গাছ লাগান, অভাবীকে খাদ্য দান করুন",
      ),
    ];
  }
}

