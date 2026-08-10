import 'package:flutter/material.dart';
import '../services/daily_content_service.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/share_service.dart';

class PillarDetailScreen extends StatelessWidget {
  final Pillar pillar;

  const PillarDetailScreen({super.key, required this.pillar});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(pillar.title),
        backgroundColor: pillar.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ShareService.sharePillar(
                title: pillar.title,
                subtitle: pillar.subtitle,
                content: pillar.content,
                id: pillar.id,
              );
            },
            tooltip: local.share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(pillar.icon, size: 40, color: pillar.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pillar.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pillar.subtitle,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 40, thickness: 2),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: pillar.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: pillar.color.withOpacity(0.3)),
              ),
              child: Text(
                pillar.content,
                style: const TextStyle(fontSize: 18, height: 1.8),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // শেয়ার বাটন
                ElevatedButton.icon(
                  onPressed: () {
                    ShareService.sharePillar(
                      title: pillar.title,
                      subtitle: pillar.subtitle,
                      content: pillar.content,
                      id: pillar.id,
                    );
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(local.share),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                  ),
                ),
                // হোম বাটন
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(local.backHome),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
