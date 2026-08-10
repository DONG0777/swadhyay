import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/share_service.dart';

class ScoreCardScreen extends StatelessWidget {
  final int score;
  final int total;
  final int streak;
  final int totalXP;

  const ScoreCardScreen({
    super.key,
    required this.score,
    required this.total,
    required this.streak,
    required this.totalXP,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.score),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ShareService.shareScore(
                score: score,
                total: total,
                streak: streak,
                xp: totalXP,
                appTitle: local.appTitle,
              );
            },
            tooltip: local.share,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B00), Color(0xFFFFD700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny, size: 60, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(local.appTitle,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  Text('${local.score}: $score/$total',
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.white, size: 24),
                      const SizedBox(width: 5),
                      Text('$streak ${local.streak}',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(width: 20),
                      const Icon(Icons.star, color: Colors.white, size: 24),
                      const SizedBox(width: 5),
                      Text('$totalXP ${local.xp}',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(DateTime.now().toString().split(' ')[0],
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ShareService.shareScore(
                  score: score,
                  total: total,
                  streak: streak,
                  xp: totalXP,
                  appTitle: local.appTitle,
                );
              },
              icon: const Icon(Icons.share),
              label: Text(local.share),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(local.backHome),
            ),
          ],
        ),
      ),
    );
  }
}
