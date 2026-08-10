import 'package:flutter/material.dart';
import '../services/daily_content_service.dart';
import '../screens/pillar_detail_screen.dart';
import '../generated/l10n/app_localizations.dart';

class DailyPillarsWidget extends StatelessWidget {
  const DailyPillarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final pillars = DailyContentService.getPillars(context); // 🔥 context পাস করা হয়েছে

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '🌸 ${local.challenge}', // দীপ্ত যাত্রা এখানে ব্যবহার করছি
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00)),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: pillars.length,
          itemBuilder: (context, index) {
            final pillar = pillars[index];
            return _PillarCard(pillar: pillar);
          },
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  final Pillar pillar;
  const _PillarCard({required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PillarDetailScreen(pillar: pillar),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                pillar.color,
                pillar.color.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                pillar.icon,
                size: 32,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 12),
              Text(
                pillar.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                pillar.subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
