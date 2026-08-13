import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/auth_service.dart';
import 'circle_create_screen.dart';

class CircleTypeSelectionScreen extends StatefulWidget {
  const CircleTypeSelectionScreen({super.key});

  @override
  State<CircleTypeSelectionScreen> createState() => _CircleTypeSelectionScreenState();
}

class _CircleTypeSelectionScreenState extends State<CircleTypeSelectionScreen> {
  final AuthService _auth = AuthService();
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _isGuest = _auth.userId == 'guest_123';
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('📌 সার্কেলের ধরন নির্বাচন'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'আপনি কী ধরনের সার্কেল তৈরি করতে চান?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'নিচের যে কোনো একটি নির্বাচন করুন।',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildCircleTypeCard(
              icon: Icons.family_restroom,
              title: '🏠 পারিবারিক',
              description: 'পরিবার ও আত্মীয়দের সাথে চর্চা করুন।',
              type: 'family',
            ),
            const SizedBox(height: 12),
            _buildCircleTypeCard(
              icon: Icons.people,
              title: '🤝 সামাজিক',
              description: 'বন্ধু ও প্রতিবেশীদের সাথে যুক্ত হন।',
              type: 'social',
            ),
            const SizedBox(height: 12),
            _buildCircleTypeCard(
              icon: Icons.public,
              title: '🌍 সার্বিক',
              description: 'সবার জন্য উন্মুক্ত একটি কমিউনিটি।',
              type: 'universal',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleTypeCard({
    required IconData icon,
    required String title,
    required String description,
    required String type,
  }) {
    final local = AppLocalizations.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (_isGuest) {
            _showGuestDialog(context, type);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateCircleScreen(),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: const Color(0xFFFF6B00)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(
                _isGuest ? Icons.lock : Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGuestDialog(BuildContext context, String type) {
    final local = AppLocalizations.of(context);
    String typeName = '';
    String details = '';

    switch (type) {
      case 'family':
        typeName = '🏠 পারিবারিক';
        details = 'পরিবারের সাথে একসাথে শ্লোক পাঠ, সূর্য নমস্কার ও কুইজ করুন।\n\n'
                  '✅ প্রয়োজন: ২ জন সদস্য\n'
                  '✅ GPS প্রয়োজন নেই\n'
                  '✅ শুধু ইনভাইটের মাধ্যমে যোগ দিন';
        break;
      case 'social':
        typeName = '🤝 সামাজিক';
        details = 'বন্ধু ও প্রতিবেশীদের সাথে নিয়মিত চর্চা করুন।\n\n'
                  '✅ প্রয়োজন: ৩ জন সদস্য\n'
                  '✅ GPS ভেরিফিকেশন প্রয়োজন\n'
                  '✅ অ্যাডমিন অনুমোদন প্রয়োজন';
        break;
      case 'universal':
        typeName = '🌍 সার্বিক';
        details = 'সবার জন্য উন্মুক্ত একটি কমিউনিটি।\n\n'
                  '✅ প্রয়োজন: ৫ জন সদস্য\n'
                  '✅ GPS ভেরিফিকেশন আবশ্যক\n'
                  '✅ ২টি সামাজিক সার্কেলের অনুমোদন প্রয়োজন\n'
                  '✅ ৬টি ভোট প্রয়োজন';
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(typeName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📌 এই সার্কেল তৈরি করতে লগইন প্রয়োজন!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 12),
            Text(details),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '🔑 সার্কেল তৈরি করতে দয়া করে লগইন করুন। এটি আপনাকে সম্পূর্ণ অভিজ্ঞতা দেবে।',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(local.backHome),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.login),
            label: const Text('🔑 লগইন করুন'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B00),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
