import 'package:flutter/material.dart';

class DailyContentScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const DailyContentScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              '$title - কন্টেন্ট শীঘ্রই আসছে',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // XP যোগ করার ফাংশন এখানে পরে যোগ করা হবে
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('+৫ XP পেলেন!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: const Text('Complete & Earn XP'),
            ),
          ],
        ),
      ),
    );
  }
}
