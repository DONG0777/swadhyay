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
        title: local.pillarStotraTitle,
        subtitle: local.pillarStotraSubtitle,
        icon: Icons.music_note,
        color: Colors.deepPurple,
        content: local.pillarStotraContent,
      ),
      Pillar(
        id: 'shloka',
        title: local.pillarShlokaTitle,
        subtitle: local.pillarShlokaSubtitle,
        icon: Icons.auto_awesome,
        color: Colors.orange,
        content: local.pillarShlokaContent,
      ),
      Pillar(
        id: 'quote',
        title: local.pillarQuoteTitle,
        subtitle: local.pillarQuoteSubtitle,
        icon: Icons.format_quote,
        color: Colors.teal,
        content: local.pillarQuoteContent,
      ),
      Pillar(
        id: 'book',
        title: local.pillarBookTitle,
        subtitle: local.pillarBookSubtitle,
        icon: Icons.book,
        color: Colors.brown,
        content: local.pillarBookContent,
      ),
      Pillar(
        id: 'surya',
        title: local.pillarSuryaTitle,
        subtitle: local.pillarSuryaSubtitle,
        icon: Icons.self_improvement,
        color: Colors.redAccent,
        content: local.pillarSuryaContent,
      ),
      Pillar(
        id: 'duty',
        title: local.pillarDutyTitle,
        subtitle: local.pillarDutySubtitle,
        icon: Icons.gavel,
        color: Colors.blue,
        content: local.pillarDutyContent,
      ),
    ];
  }
}
