import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location_service.dart';
import '../services/auth_service.dart';
import '../generated/l10n/app_localizations.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;
  bool _isCheckedInToday = false;
  String _statusMessage = 'চেক-ইন করতে নিচের বাটনে ক্লিক করুন।';
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _checkTodayStatus();
  }

  Future<void> _checkTodayStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _auth.userId;
    final lastDate = prefs.getString('${userId}_checkin_date');
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (lastDate == today) {
      setState(() {
        _isCheckedInToday = true;
        _statusMessage = '✅ আজকে আপনি ইতিমধ্যে চেক-ইন করেছেন!';
      });
    }
  }

  Future<void> _performCheckin() async {
    setState(() => _isLoading = true);

    try {
      // 🔥 স্ট্যাটিক মেথড ব্যবহার করুন
      final position = await LocationService.getCurrentLocation();
      _latitude = position.latitude;
      _longitude = position.longitude;

      final prefs = await SharedPreferences.getInstance();
      final userId = _auth.userId;
      final today = DateTime.now().toIso8601String().split('T')[0];

      final lastDate = prefs.getString('${userId}_checkin_date');
      if (lastDate == today) {
        setState(() {
          _isCheckedInToday = true;
          _statusMessage = '✅ আপনি আজকে ইতিমধ্যে চেক-ইন করেছেন!';
          _isLoading = false;
        });
        return;
      }

      await prefs.setString('${userId}_checkin_date', today);
      await prefs.setDouble('${userId}_checkin_lat', position.latitude);
      await prefs.setDouble('${userId}_checkin_lon', position.longitude);

      setState(() {
        _isCheckedInToday = true;
        _statusMessage = '🎉 চেক-ইন সফল! +৫ এক্সপি পেয়েছেন!';
        _isLoading = false;
      });

      Navigator.pop(context, {'xp': 5});
    } catch (e) {
      setState(() {
        _statusMessage = '❌ লোকেশন পেতে সমস্যা: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('📍 ${local.checkin}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80, color: Color(0xFFFF6B00)),
            const SizedBox(height: 20),
            const Text(
              'দৈনিক চেক-ইন',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'আপনার বর্তমান অবস্থান থেকে চেক-ইন করুন\nএবং +৫ এক্সপি অর্জন করুন।',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _isCheckedInToday ? Icons.check_circle : Icons.pending,
                        color: _isCheckedInToday ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _statusMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: _isCheckedInToday ? Colors.green : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_latitude != null && _longitude != null) ...[
                    const Divider(),
                    Text(
                      '📍 ${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isLoading || _isCheckedInToday) ? null : _performCheckin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isCheckedInToday ? '✅ ইতিমধ্যে চেক-ইন করেছেন' : '📍 চেক-ইন করুন',
                        style: const TextStyle(fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 20),
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
