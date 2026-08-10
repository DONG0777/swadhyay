import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _shareScoreCard(BuildContext context) async {
    final text =
        '☀️ *Swadhyay Quiz Scorecard*\n📊 Score: $score/$total\n🔥 Streak: $streak days\n⭐ Total XP: $totalXP\n📅 Date: ${DateTime.now().toString().split(' ')[0]}';
    final encoded = Uri.encodeComponent(text);
    final url = Uri.parse('https://wa.me/?text=$encoded');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scorecard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
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
                  const Text('SWADHYAY',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  Text('Score: $score/$total',
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
                      Text('$streak day streak',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(width: 20),
                      const Icon(Icons.star, color: Colors.white, size: 24),
                      const SizedBox(width: 5),
                      Text('$totalXP XP',
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
              onPressed: () => _shareScoreCard(context),
              icon: const Icon(Icons.share),
              label: const Text('Share to WhatsApp'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
