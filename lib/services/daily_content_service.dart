import 'package:flutter/material.dart';

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
  static List<Pillar> getPillars() {
    return [
      Pillar(
        id: 'stotra',
        title: 'একাত্মতা স্তোত্র',
        subtitle: 'শুনুন ও অনুভব করুন',
        icon: Icons.music_note,
        color: Colors.deepPurple,
        content: 'ওঁ বিশ্বানি দেব সবিতার দুরিতানি পরাসুভ ।\nযৎ ভদ্রং তন্ন আ সুভ ।\n\n(ঋগ্বেদ ৫.৮২.৫)\n\nঅর্থ: হে সূর্য! আমাদের সকল পাপ দূর করো এবং যা মঙ্গলকর, তা আমাদের দান করো।',
      ),
      Pillar(
        id: 'shloka',
        title: 'শ্লোক',
        subtitle: 'প্রাচীন জ্ঞান',
        icon: Icons.auto_awesome,
        color: Colors.orange,
        content: 'অসতো মা সদ্ গময় ।\nতমসো মা জ্যোতির্গময় ।\nমৃত্যোর্মা অমৃতং গময় ।\n\n(বৃহদারণ্যক উপনিষদ ১.৩.২৮)\n\nঅর্থ: আমাকে অসত্য থেকে সত্যে নিয়ে চলো। অন্ধকার থেকে আলোতে নিয়ে চলো। মৃত্যু থেকে অমৃতত্বে নিয়ে চলো।',
      ),
      Pillar(
        id: 'quote',
        title: 'প্রেরণাদায়ী উক্তি',
        subtitle: 'স্বামী বিবেকানন্দ',
        icon: Icons.format_quote,
        color: Colors.teal,
        content: '"উঠো, জাগো এবং লক্ষ্য না পাওয়া পর্যন্ত থামো না।"\n\n- স্বামী বিবেকানন্দ\n\nআপনার মধ্যে অপরিমেয় শক্তি আছে। বিশ্বাস করুন, নিজের উপর আস্থা রাখুন।',
      ),
      Pillar(
        id: 'book',
        title: 'বইয়ের স্পটলাইট',
        subtitle: 'আজকের পাঠ',
        icon: Icons.book,
        color: Colors.brown,
        content: '📖 **আরএসএস: কী ও কেন?**\n\nলেখক: ড. মানবেন্দ্র নাথ রায়\n\nসংক্ষিপ্ত বিবরণ: এই বইটি রাষ্ট্রীয় স্বয়ংsevক সংঘের (আরএসএস) আদর্শ, কর্মপদ্ধতি ও ভারতীয় সংস্কৃতিতে এর অবদান সম্পর্কে আলোচনা করে। স্বায়ংসেবকের জীবনদর্শন ও সংগঠনের লক্ষ্য বুঝতে এটি অপরিহার্য পাঠ্য।',
      ),
      Pillar(
        id: 'surya',
        title: 'সূর্য নমস্কার',
        subtitle: 'দৈনিক ১২টি সেট',
        icon: Icons.self_improvement,
        color: Colors.redAccent,
        content: '🧘 **সূর্য নমস্কার**\n\nদৈনিক ১২টি সেট করুন।\nপ্রতিটি সেটে ১২টি আসন থাকে।\n\nসূর্য নমস্কার শারীরিক ও মানসিক স্বাস্থ্যের জন্য অত্যন্ত উপকারী। এটি সকালে খালি পেটে করার পরামর্শ দেওয়া হয়।',
      ),
      Pillar(
        id: 'duty',
        title: 'নাগরিক কর্তব্য',
        subtitle: 'আজকের দায়িত্ব',
        icon: Icons.gavel,
        color: Colors.blue,
        content: '🇮🇳 **আজকের কর্তব্য:**\n\n১. পরিবেশের জন্য একটি গাছ লাগান।\n২. কোনো অভাবী ব্যক্তিকে খাদ্য দান করুন।\n৩. নিজের এলাকা পরিষ্কার রাখুন।\n\n"সেবা পরমো ধর্ম" - এই বাণী স্মরণ রাখুন।',
      ),
    ];
  }
}
