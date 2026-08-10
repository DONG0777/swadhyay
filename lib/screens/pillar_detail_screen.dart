import 'package:flutter/material.dart';
import '../services/daily_content_service.dart';

class PillarDetailScreen extends StatelessWidget {
  final Pillar pillar;

  const PillarDetailScreen({super.key, required this.pillar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pillar.title),
        backgroundColor: pillar.color,
        foregroundColor: Colors.white,
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
            // একটি ছোট অ্যাকশন বাটন (শেয়ার বা মার্ক ডান)
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('"${pillar.title}" শেয়ার করার ব্যবস্থা শীঘ্রই আসছে!')),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('শেয়ার করুন'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pillar.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
