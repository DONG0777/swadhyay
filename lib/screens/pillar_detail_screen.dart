import 'package:flutter/material.dart';
import '../models/content_model.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/share_service.dart';
import 'surya_namaskar_screen.dart';

class PillarDetailScreen extends StatelessWidget {
  final ContentModel pillar;
  final Color color;
  final IconData icon;

  const PillarDetailScreen({
    super.key,
    required this.pillar,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    if (pillar.contentType == 'surya') {
      return SuryaNamaskarScreen(
        pillar: pillar,
        color: color,
        icon: icon,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pillar.title ?? pillar.contentType),
        backgroundColor: color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ShareService.sharePillar(
                title: pillar.title ?? pillar.contentType,
                subtitle: pillar.contentType,
                content: pillar.content ?? '',
                id: pillar.id ?? 'pillar',
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
                Icon(icon, size: 40, color: color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pillar.title ?? pillar.contentType,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pillar.contentType,
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
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                pillar.content ?? 'কন্টেন্ট নেই',
                style: const TextStyle(fontSize: 18, height: 1.8),
              ),
            ),
            const SizedBox(height: 30),
            if (pillar.explanation != null && pillar.explanation!.isNotEmpty) ...[
              const Text(
                '📖 ব্যাখ্যা / অর্থ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  pillar.explanation!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ShareService.sharePillar(
                      title: pillar.title ?? pillar.contentType,
                      subtitle: pillar.contentType,
                      content: pillar.content ?? '',
                      id: pillar.id ?? 'pillar',
                    );
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(local.share),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                  ),
                ),
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
