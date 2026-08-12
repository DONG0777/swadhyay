import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class CreateCircleScreen extends StatefulWidget {
  const CreateCircleScreen({super.key});

  @override
  State<CreateCircleScreen> createState() => _CreateCircleScreenState();
}

class _CreateCircleScreenState extends State<CreateCircleScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedType = 'family';
  bool _isLoading = false;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    setState(() {
      _isGuest = _auth.userId == 'guest_123';
      if (_isGuest) _selectedType = 'family';
    });
  }

  Future<void> _createCircle() async {
    if (_isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ গেস্ট মোডে সার্কেল তৈরি করা যায় না! লগইন করুন।'), backgroundColor: Colors.orange),
      );
      return;
    }
    // ... (বাকি কোড)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏗️ নতুন সার্কেল তৈরি'),
        backgroundColor: const Color(0xFFFF6B00),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isGuest)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '🔒 গেস্ট মোডে সার্কেল তৈরি করা যায় না। দয়া করে লগইন করুন।',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '🏷️ সার্কেলের নাম *', border: OutlineInputBorder()),
              enabled: !_isGuest,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: '📝 বিবরণ (ঐচ্ছিক)', border: OutlineInputBorder()),
              maxLines: 3,
              enabled: !_isGuest,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: '📌 সার্কেলের ধরন *', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: 'family', child: Text('🏠 পারিবারিক')),
                if (!_isGuest) const DropdownMenuItem(value: 'social', child: Text('🤝 সামাজিক')),
                if (!_isGuest) const DropdownMenuItem(value: 'universal', child: Text('🌍 সার্বিক')),
              ],
              onChanged: _isGuest ? null : (val) => setState(() => _selectedType = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGuest ? null : _createCircle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isGuest ? Colors.grey : const Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isGuest ? '🔒 লগইন করুন' : '✅ সার্কেল তৈরি করুন'),
              ),
            ),
            if (_isGuest)
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('🔑 লগইন পেজে যান'),
              ),
          ],
        ),
      ),
    );
  }
}
